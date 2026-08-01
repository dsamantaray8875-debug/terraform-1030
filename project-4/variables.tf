variable "region" {

  type = string

}

variable "vpc_id" {

  type = string

}

variable "private_subnets" {

  type = list(string)

}

variable "ami" {

  type = string

}

variable "instance_type" {

  type = string

}