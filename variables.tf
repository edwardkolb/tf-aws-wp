variable "region" {
  description = "Please Enter AWS Region to deploy Server"
  type        = string
  default     = "eu-central-1"
}

variable "instance_type" {
  description = "Enter Instance Type"
  type        = string
  default     = "t2.micro"
}

variable "allow_ports" {
  description = "List of Ports to open for server"
  type        = list
  default     = ["80", "22", "8080"]
}

variable "cidr" {
    type = list
    default = ["0.0.0.0/0"]
}

variable "key_name" {
  type = string
  default = "aws_key"
}

