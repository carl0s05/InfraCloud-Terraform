variable "my_access_key" {
        description = "Access key to AWS console"
        default = "no_access_key_value_found"
}
variable "my_secret_key" {
        description = "Secret key to AWS console"
        default = "no_secret_key_value_found"
}


variable "EC2_01" {
        description = "Name of the instance to be created"
        default = "test"
}

variable "ami_id" {
        description = "The AMI to use"
        default = "ami-**********"
}
variable "instance_type" {
        default = "t2.micro"
}

variable "generated_key_ec2_test" {
        default = "key_tf_test"
}
variable "subnet_id" {
        description = "The VPC subnet the instance(s) will be created in"
        default = "subnet-**********"
}

variable "VPC_id" {
        description = "VPC infraestructura de pruebas"
        default = "vpc-*********"
}

variable "number_of_instances" {
        description = "number of instances to be created"
        default = 1
}


