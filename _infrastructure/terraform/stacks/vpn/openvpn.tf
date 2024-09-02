resource "aws_key_pair" "_" {
  key_name   = "openvpn_kp"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "vpn" {
  name        = "vpn-security-group"
  description = "Allow SSH and OpenVPN traffic"
  vpc_id      = local.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "_" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.nano"

  key_name                    = aws_key_pair._.key_name
  security_groups             = [aws_security_group.vpn.id]
  user_data                   = file("./provider-user-data.sh")
  associate_public_ip_address = true
  subnet_id                   = local.public_subnet_id
  vpc_security_group_ids      = [local.vpc_default_security_group_id, aws_security_group.vpn.id]
  tags = {
    Name = "OpenVPN Service"
  }
  lifecycle {
    ignore_changes = ["security_groups"]
  }

}
