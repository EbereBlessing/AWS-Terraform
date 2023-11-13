
# EC2 instance in Public Subnet
resource "aws_instance" "Bastion" {
  ami             = var.os # Replace with the desired AMI ID
  allocation_id = aws_eip.NAT_eip.id
  instance_type = var.instance   # Replace with the desired instance type
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  subnet_id     = aws_subnet.public_subnet1.id
  associate_public_ip_address = true
  key_name      = aws_key_pair.key-pair.key_name # Replace with your SSH key pair
  tags = {
    Name = "Bastion"
    description = "Jump server to the private instance "
  }
}
resource "aws_launch_configuration" "ec2" {
  name                        = "${var.tag}-instances"
  image_id            = var.os  # Replace with the desired AMI ID
  instance_type = var.instance     # Replace with the desired instance type
  security_groups             = [aws_security_group.ec2_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.session-manager.id
  key_name                    = aws_key_pair.key-pair.key_name
  associate_public_ip_address = false
  user_data = <<-EOL
  #!/bin/bash -xe
  sudo yum update -y
  sudo yum -y install docker
  sudo service docker start
  sudo usermod -a -G docker ec2-user
  sudo chmod 666 /var/run/docker.sock
  docker pull nginx
  docker tag nginx my-nginx
  docker run --rm --name nginx-server -d -p 80:80 -t my-nginx
  EOL
  depends_on = [aws_nat_gateway.nat]
}