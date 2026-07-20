resource "aws_db_instance" "mysql" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_name                 = var.db_name
  username             = var.username
  password             = var.password
  parameter_group_name = "default.mysql8.0"
  db_subnet_group_name = var.subnet_group
  skip_final_snapshot  = true
  publicly_accessible  = false
}
