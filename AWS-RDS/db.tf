# RDS PostgreSQL Primary Instance
resource "aws_db_instance" "postgres_instance" {
  allocated_storage    = var.allocated_storage
  # db_name              = "default"
  identifier           = "primarydb"
  storage_type         = "gp3"
  max_allocated_storage = var.max_allocated_storage
  engine               = "postgres"
  engine_version       = "16.3" # Specify the required PostgreSQL version
  instance_class       = var.db_instance_class
  username             = var.db_user
  password             = var.db_password
  skip_final_snapshot  = true

  # Link the RDS instance to the security group
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  # Set to 'true' if this is a production environment to enable automatic backups
  backup_retention_period = 7

  # Optionally, make it publicly accessible if needed (avoid for production)
  publicly_accessible = true

  # Deletion protection (disable for non-production environments)
  deletion_protection = false
}

# RDS PostgreSQL Read Replica
resource "aws_db_instance" "postgres_read_replica" {
  engine               = aws_db_instance.postgres_instance.engine
  instance_class       = var.read_replica_instance_class
  publicly_accessible  = true
  identifier           = "replica"
  replicate_source_db  = aws_db_instance.postgres_instance.identifier
  skip_final_snapshot  = true
  allocated_storage     = var.read_storage
  max_allocated_storage = var.max_read_storage

  # Link the read replica to the security group
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}
