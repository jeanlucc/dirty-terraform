terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

resource "aws_instance" "example" {
  ami           = "ami-022e8cc8f0d3c52fd"
  instance_type = "t2.micro"
  key_name      = "deployer-key"
  security_groups = [aws_security_group.allow_http_ssh.name]

  connection {
    type        = "ssh"
    host        = self.public_dns
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    timeout     = "5m"
  }

#  provisioner "file" {
#    source      = "./install.sh"
#    destination = "/tmp/install.sh"
#  }
#
#  provisioner "remote-exec" {
#    inline = [
#      "chmod +x /tmp/install.sh",
#      "/tmp/install.sh",
#    ]
#  }

  provisioner "remote-exec" {
    script = "install.sh"
  }

  tags = {
    Name = "ExampleInstance"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC0Qa5F98D6r5rGH0qXbRu2RktcpkbWNPZK9WOVt6KRtwFy9fybOma+get+ftrV9xjb5h9f6K4xHKuG4qBhIj/IkAW/4mtyAsaohXOzFrwW/7BwQbm9cDfhc8rJp58c1P/RmgGTgDKb79xDzKoU9q3CbdMEtefKaovJ/8V2kfVZYanR8gQNTnvX4e8uHb+Sx2iWrP85JCuHR10qqUjzC6XgENohY3G/+x5fg1SoEeT487UoFMkSROrJJ6+YYfX6Uqgnz5rsfrU9d285P+446AtWMZF8sR+O2uHWM4E4Kqkk58uMB5QAycAAVnV/HYB/Axudaa8D268VC/hFadcINGCr /Users/Jean_Luc/.ssh/id_rsa"
}

resource "aws_security_group" "allow_http_ssh" {
  name        = "ec2"
  description = "allow ssh and http"

  ingress {
    description = "HTTP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
