resource "aws_key_pair" "_" {
  key_name   = "lite_instance"
  public_key = file("~/.ssh/id_rsa.pub")
}


resource "aws_route53_record" "www" {
  zone_id = local.hosted_zone_id
  name    = "jonathanmath.com"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.django_app.public_ip]
}

resource "aws_security_group" "lite" {
  name        = "lite-security-group"
  description = "Allow 443 and SSH traffic"
  vpc_id      = local.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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


resource "aws_s3_bucket" "example_bucket" {
  bucket = "your_bucket_name"
}

resource "aws_s3_bucket_object" "example_object" {
  bucket = aws_s3_bucket.example_bucket.id
  key    = "example_file.txt"
  source = "path/to/local/file.txt"  # Path to the file you want to upload

  # If you want to set content type, cache control, etc., you can specify them here
  # content_type = "text/plain"
  # cache_control = "max-age=86400"
}


resource "aws_instance" "django_app" {
  ami           = "ami-0b0ea68c435eb488d"
  instance_type = "t2.micro"

  key_name = aws_key_pair._.key_name
  security_groups             = [aws_security_group.lite.id]
  associate_public_ip_address = true
  subnet_id                   = local.public_subnet_id
  vpc_security_group_ids      = [local.vpc_default_security_group_id, aws_security_group.lite.id]

  lifecycle {
    ignore_changes = ["security_groups"]
  }
  user_data = <<-EOF
                #!/bin/bash
                # Update and install necessary packages
                apt-get update
                apt-get install -y apt-transport-https ca-certificates curl software-properties-common awscli
                
                apt-get update
                apt-get install -y docker-ce

                # Install Docker Compose
                curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
                chmod +x /usr/local/bin/docker-compose

                # Download the .env file from S3
                aws s3 cp s3://your-s3-bucket/path/to/your/.env /path/to/your/local/.env

                # Run Docker Compose (assuming docker-compose.yml is already in place)
                cd /path/to/your/docker-compose-directory
                docker-compose up -d
              EOF
}
