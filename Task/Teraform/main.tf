variable "awsprops" {
    default = {
    region = "ap-southeast-1"
    vpc = "vpc-0cbb8dafee602b4bc"
    ami = "ami-0bd6906508e74f692"
    itype = "t2.micro"
    publicip = true
    keyname = "myseckey" // this key need to generate manually or use auto generate aws_key_pair named aws-ssh-key
    secgroupname = "IAC-Sec-Group-1"
    iam_user_key = "AKIxxxxxNXB2BYDxxxxx"
    ima_secret_key = "xxxxxCia2vjbq4zGxxxxxbOhnacm2QIMgcBxxxxx"
  }
}

provider "aws" {
  region = lookup(var.awsprops, "region")
  access_key = lookup(var.awsprops, "iam_user_key")
  secret_key = lookup(var.awsprops, "ima_secret_key")
}

resource "aws_key_pair" "ssh-key" {
  key_name   = "aws-ssh-key"
  public_key = "ssh-rsa ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41== root@$hostname"
}


resource "aws_security_group" "project-iac-sg1" {
  name = lookup(var.awsprops, "secgroupname")
  description = lookup(var.awsprops, "secgroupname")
  vpc_id = lookup(var.awsprops, "vpc")

  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_instance" "project-iac" {
  ami = lookup(var.awsprops, "ami")
  instance_type = lookup(var.awsprops, "itype")
  associate_public_ip_address = lookup(var.awsprops, "publicip")
  key_name = lookup(var.awsprops, "keyname")


  vpc_security_group_ids = [
    aws_security_group.project-iac-sg1.id
  ]
  root_block_device {
    delete_on_termination = true
    volume_size = "8"
    volume_type = "gp2"
  }
  tags = {
    Name ="Hydrus Development VM"
    Environment = "DEV"
  }

  depends_on = [ aws_security_group.project-iac-sg1 ]
}

output "ec2instance" {
  value = aws_instance.project-iac.public_ip
}
