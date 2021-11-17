resource "aws_db_instance" "example-stg-rds" {
  allocated_storage      = 100
  identifier             = "example-stg-rds"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = local.rds_instance_type
  name                   = "ExampleStgDB"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.example-stg-rds-subnets.name
  vpc_security_group_ids = [aws_security_group.example-stg-sg-rds.id]
  multi_az               = false
  # uncomment to set up backups  
  backup_window           = "17:00-17:30"
  backup_retention_period = 5
  maintenance_window      = "Sun:18:00-Sun:18:30"
  skip_final_snapshot     = true
}

/* Uncomment to create Read Replica
resource "aws_db_instance" "example-stg-rds-read-replica" {
  allocated_storage      = 100
  identifier             = "example-stg-rds-read-replica"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = local.rds_instance_type
  name                   = "ExampleStgDB"
  username               = var.db_username
  password               = var.db_password
  vpc_security_group_ids = [aws_security_group.example-stg-sg-rds.id]
  # uncomment to set up backups  
  # backup_window           = "17:00-17:30"
  # backup_retention_period = 5
  replicate_source_db = aws_db_instance.example-stg-rds.id
  maintenance_window  = "Sun:18:00-Sun:18:30"
  skip_final_snapshot = true
}
*/

resource "aws_db_subnet_group" "example-stg-rds-subnets" {
  name       = "example-stg-rds-subnets"
  subnet_ids = module.vpc.database_subnets
}
