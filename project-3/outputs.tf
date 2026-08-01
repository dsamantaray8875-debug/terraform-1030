output "database_endpoint" {
  value = module.mysql.db_endpoint
}

output "database_port" {
  value = module.mysql.db_port
}

output "database_security_group" {
  value = module.mysql.db_security_group
}

output "read_replica_endpoint" {
  value = module.mysql.read_replica_endpoint
}