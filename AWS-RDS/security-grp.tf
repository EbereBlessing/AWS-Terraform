# Security Group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds_postgres_sg"
  description = "Allow inbound access to RDS PostgreSQL"

  # Allow inbound access to PostgreSQL (default port 5432)
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with a more restrictive CIDR for production
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}