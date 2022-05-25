variable "awsprops" {
    default = {
    region = "ap-southeast-1"
    vpc = "vpc-0cbb8dafee602b4bc"
    ami = "ami-0bd6906508e74f692"
    itype = "t2.micro"
    publicip = true
    keyname = "myseckey" // this key need to generate manually or use auto generate aws_key_pair named aws-ssh-key
    secgroupname = "IAC-Sec-Group-1"
  }
}

provider "aws" {
  region = lookup(var.awsprops, "region")
}

resource "aws_key_pair" "ssh-key" {
  key_name   = "aws-ssh-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC6xjqIhu0XG2E4e7sfyaV7Yj5Q+3ex+TNSaXayH4zrMF+15WMw/45R9AE/Y+cwH9PEJwv2oCQF1tXgslNmhEMhOc7ScJTB0RY9HN97tvja20hcPqJi43FiGLGZj6VfNsu2f0rTtf3h28xucREUBy+pgaC34SiHbBtun9HGAAInfVhFgD8xm7TgyjfdOB5Ve1d7KAG2vq5KC/LFKkdAF8rfSd/Qa0Urdy/IxN138KWx7SiGGKMZyhjSxtmxgn42COoiihY0xgueft9XhAOKh6zlTstMOJ7khJ4bcqFV3ZzT80h5DbrfN5t33Ew+uxb5UpDsTsrVfiH/oa9rnafirlV/MUpqRf+KwG/0SVmTiLaCJz3Eqo8fWSGI1eMYr+2+JQKD4/xm3LtngEM2+N1jXBnAdecXesblKcgPLhgRS12D3+ZoMHLBSRrfeOVDJhNLUM56lYxfn6GiOrVbHKDCrQuh/zLYf5kErIXeaxOkfK0hHJaA3gsavoPKGp5/WW/EMpQuwkzuy5HIY1eSmgqfKg6dIpX5pXQQRw2RxEe6btpROwMvs3MnMEftHOeU+uBHYAE0uZF0Zzoa4v3V0rnEEBVElMiDVRZGwKCXN+GC//hLwQieGg89nK43BNRzA5Q318TInqg1/EwITqv2bSubA6wsgdTtlAP1oW9Mgx9TZ/0Y2Q== root@devopsrnd.ibcs-primax.com"
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
    Managed = "IAC"
  }

  depends_on = [ aws_security_group.project-iac-sg1 ]
}


output "ec2instance" {
  value = aws_instance.project-iac.public_ip
}