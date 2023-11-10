# Creating Security Group for ALB
## Traffic from the internet to the application load_balancer
resource "aws_security_group" "elb_sg" {
  name = "elb_sg"
  vpc_id      = aws_vpc.vpc.id
  description = "Load_balancer Security group"
# Inbound Rules
  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Ideal scenario the alb should also receive traffic fro HTTPS(443). Uncomment if SSL is configured 
  # HTTPS access from anywhere
  #ingress {
  #  from_port   = 443
  #  to_port     = 443
  #  protocol    = "tcp"
  #  cidr_blocks = ["0.0.0.0/0"]
 # }
# Outbound Rules
  # Internet access to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
## Creating Security Group
## routing ALB traffic to the ec2 instance and also enabling ssh connectivity to the ec2(public)
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_security_group"
  description = "Allows inbound access from the ALB only"
  vpc_id      =  aws_vpc.vpc.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.elb_sg.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}