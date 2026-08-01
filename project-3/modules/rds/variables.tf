variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "app_sg" {
  type = string
}