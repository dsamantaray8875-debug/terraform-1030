resource "aws_db_instance" "mysql_replica" {

  identifier = "production-mysql-replica"

  replicate_source_db = aws_db_instance.mysql.identifier

  instance_class = "db.t3.micro"

  publicly_accessible = false

  storage_encrypted = true

  skip_final_snapshot = true

  depends_on = [
    aws_db_instance.mysql
  ]

  tags = {
    Name = "MySQL Read Replica"
  }
}





resource "aws_security_group" "rds_sg" {

  name = "rds-security-group"

  description = "Allow MySQL"

  vpc_id = var.vpc_id

  ingress {

    from_port = 3306

    to_port = 3306

    protocol = "tcp"

    security_groups = [var.app_sg]

  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

}

resource "aws_db_subnet_group" "db_subnet" {

  name = "prod-db-subnet"

  subnet_ids = var.private_subnets

  tags = {

    Name = "Production DB"

  }

}

resource "aws_db_instance" "mysql" {

  identifier = "production-mysql"

  engine = "mysql"

  engine_version = "8.0"

  instance_class = "db.t3.micro"

  allocated_storage = 20

  storage_type = "gp3"

  storage_encrypted = true

  username = var.db_username

  password = var.db_password

  backup_retention_period = 7

  skip_final_snapshot = true

  publicly_accessible = false

  db_subnet_group_name = aws_db_subnet_group.db_subnet.name

  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]

}