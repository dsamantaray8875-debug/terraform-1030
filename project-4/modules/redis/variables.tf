variable "vpc_id" {

  type = string

}

variable "private_subnets" {

  type = list(string)

}

variable "app_sg" {

  type = string

}