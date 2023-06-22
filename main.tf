terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.0.1"
    }
  }
}

# Configure the AWS Provider-----pruebas
provider "aws" {
  region     = "us-east-2"
  access_key = "${var.my_access_key}"
  secret_key = "${var.my_secret_key}"
}

/*output "access_key_is" {
  value = var.my_access_key
}
output "secret_key_is" {
  value = var.my_secret_key
}*/

/********* GRUPOS DE SEGURIDAD *********/

resource "aws_security_group" "SG_EC2_TEST" {
  name        = "SG-EC2-TEST"
  description = "SG Instancias"
  vpc_id      = "${var.VPC_id}"
  ingress = []
  egress = []
  tags = {
    Name = "SG-EC2-TEST"
  }
}

resource "aws_security_group_rule" "sg2" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
  security_group_id = aws_security_group.SG_EC2_TEST.id
}
resource "aws_security_group_rule" "sg3" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"//-1 = All | TCP | UPD 
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
  security_group_id = aws_security_group.SG_EC2_TEST.id
}




 /********* EC2-PRUEBAS*********/
resource "aws_network_interface" "NET_TEST_01" {
	subnet_id = "${var.subnet_id}"
  security_groups    = [aws_security_group.SG_EC2_TEST.id]
  //subnet_id   = aws_subnet.SUBNET_PUBLICA_1.id
  //private_ips = ["0.0.0.0"]
  tags = {
    Name = "NET_TEST_01"
  }
}

resource "aws_instance" "EC2_01" {
	ami = "${var.ami_id}"
	instance_type = "${var.instance_type}"
	key_name = "${var.generated_key_ec2_test}"
	count = "${var.number_of_instances}"

  root_block_device {
    volume_type = "gp2"//standard, gp2, gp3, io1, io2, sc1, or st1
    volume_size = 10
    delete_on_termination = false
    encrypted   = true
    //kms_key_id = (ARN) of the KMS Key
  }

/*
  ebs_block_device {
    device_name = "/dev/sdb"
    delete_on_termination = false
    volume_type = "gp2"
    volume_size = 400
    //delete_on_terminatikey_name = aws_key_pair.generated_key.key_nameon = true
    encrypted   = true
  }
  */


  network_interface {
    network_interface_id = aws_network_interface.NET_TEST_01.id
    device_index         = 0
  }

  tags = {
    Name = "Instancia de prueba"
    Env = "dev"
    Name = "EC2-test-terraform"
    SO = "RHEL Linux 9"
    Area = "Unity"
    Ecosistema = "Bancoppel"
  }
}

resource "tls_private_key" "pri_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#Generación local de key acceso a EC2 
resource "aws_key_pair" "generated_key_ec2_test" {
	key_name = "${var.generated_key_ec2_test}"
  public_key = tls_private_key.pri_key.public_key_openssh
}

resource "local_file" "cloud_pem" { 
  filename = "${path.module}/${var.generated_key_ec2_test}.pem"
  #filename = "${path.module}/key_tf_test.pem"
  content = tls_private_key.pri_key.private_key_pem
  }


