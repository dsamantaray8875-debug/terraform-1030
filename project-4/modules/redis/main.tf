resource "aws_elasticache_replication_group" "redis" {

  replication_group_id = "production-redis"

  description = "Production Redis Cluster"

  engine = "redis"

  engine_version = "7.1"

  node_type = "cache.t3.micro"

  num_cache_clusters = 2

  automatic_failover_enabled = true

  multi_az_enabled = true

  subnet_group_name = aws_elasticache_subnet_group.redis_subnet_group.name

  security_group_ids = [
    aws_security_group.redis_sg.id
  ]

  port = 6379

  at_rest_encryption_enabled = true

  transit_encryption_enabled = true

  tags = {
    Name = "Production Redis"
  }
}




resource "aws_elasticache_subnet_group" "redis_subnet_group" {

  name       = "redis-subnet-group"

  subnet_ids = var.private_subnets

  description = "Subnet Group for Redis"

}





resource "aws_security_group" "redis_sg" {

  name        = "redis-security-group"
  description = "Allow Redis Traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [var.app_sg]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Redis-SG"
  }
}