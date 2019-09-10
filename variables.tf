variable "aws_region" {
  description = "Region for the VPC"
  default     = "us-east-1"
}

variable "availability_zone" {
  description = "Ec2 availability zone"
  default     = "us-east-1a"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet"
  default     = "10.0.2.0/24"
}

variable "ami" {
  description = "Amazon Linux AMI"
  default     = "ami-4fffc834"
}

variable "key_path" {
  description = "SSH Public Key path"
  default     = "~/.ssh/id_rsa.pub"
}

variable "identity" {
  type    = "string"
  default = "example"
}

variable "default_tags" {
  type = "map"
  default = {
    "owner" : "email",
  }
}
