output "db_endpoint" {
  value = aws_db_instance.mysql.endpoint
}

output "db_port" {
  value = aws_db_instance.mysql.port
}

output "db_name" {
  value = aws_db_instance.mysql.db_name
}

output "db_security_group" {
  value = aws_security_group.rds_sg.id
}

output "read_replica_endpoint" {
  value = aws_db_instance.mysql_replica.endpoint
}