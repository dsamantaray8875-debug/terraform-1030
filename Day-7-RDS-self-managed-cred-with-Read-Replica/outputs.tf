output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.name.id
}

output "subnet_1_id" {
  description = "Subnet 1 ID"
  value       = aws_subnet.subnet-1.id
}

output "rds_endpoint" {
  description = "RDS database endpoint"
  value       = aws_db_instance.name.endpoint
}

output "rds_identifier" {
  description = "RDS instance identifier"
  value       = aws_db_instance.name.identifier
}