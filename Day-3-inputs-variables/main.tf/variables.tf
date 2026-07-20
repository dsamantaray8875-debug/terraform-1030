variable "ami_id" {
 description = "The AMI ID to use for the instance"
  type        = string
  default     = "" 
}
variable "instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
  default     = ""
}
variable "tags" {
  description = "The tags for the EC2 instance"
    type        = string
  default     = ""
}
variable "region"{
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-west-2"
}