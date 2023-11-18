## GENERATING SSH KEY FOR THE BASTION HOST
## Generate PEM (and OpenSSH) formatted private key.
resource "tls_private_key" "ec2-bastion-key-pair" {
  algorithm = "RSA"
  rsa_bits = 4096
}

## Create the file for Public Key
resource "local_file" "public-key" {
  depends_on = [ tls_private_key.ec2-bastion-key-pair ]
  content = tls_private_key.ec2-bastion-key-pair.public_key_openssh
  filename = var.public-key-path
}

## Create the sensitive file for Private Key
resource "local_sensitive_file" "private-key" {
  depends_on = [ tls_private_key.ec2-bastion-key-pair ]
  content = tls_private_key.ec2-bastion-key-pair.private_key_pem
  filename = var.private-key-path
  file_permission = "0600"
}

## AWS SSH Key Pair
resource "aws_key_pair" "key-pair" {
  depends_on = [ local_file.public-key ]
<<<<<<< HEAD
  key_name = var.private-key-path
=======
  key_name = var.key-nam
>>>>>>> origin/main
  public_key = tls_private_key.ec2-bastion-key-pair.public_key_openssh
}
