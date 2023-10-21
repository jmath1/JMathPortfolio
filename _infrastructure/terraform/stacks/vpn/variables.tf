variable "env" {
  type = string
}

variable "name" {
  type    = string
  default = "jmath"
}

variable "region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidr" {
  type = string
}

variable "private_subnet_cidr" {
  type = string
}
