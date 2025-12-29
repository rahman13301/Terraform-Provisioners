terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.27.0"
    }
  }
}

provider "aws" {
    region = "us-east-1"
}
variable "cidr" {
    default = "10.0.0.0/16"
}
resource "aws_key_pair" "my-key1" {
    key_name   = "my-key1"
    public_key = file("/root/.ssh/id_rsa.pub")
}
resource "aws_vpc" "myvpc" {
    cidr_block = var.cidr
    }
resource "aws_subnet" "mysubnet" {
    vpc_id            = aws_vpc.myvpc.id
    cidr_block        = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
}
resource "aws_internet_gateway" "myigw" {
    vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "myroute" {
    vpc_id = aws_vpc.myvpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myigw.id
    }
}

resource "aws_route_table_association" "rta1" {
    subnet_id      = aws_subnet.mysubnet.id
    route_table_id = aws_route_table.myroute.id
}

resource "aws_security_group" "mysg" {
    name        = "allow_ssh_http"
    description = "Allow SSH and HTTP inbound traffic"
    vpc_id      = aws_vpc.myvpc.id

    ingress {
        description = "SSH from anywhere"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "HTTP from anywhere"
        from_port   = 80
        to_port     = 80
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

resource "aws_instance" "myec2" {
    ami                    = "ami-0ecb62995f68bb549" # ubuntu 24.04 in us-east-1
    instance_type          = "t2.micro"
    subnet_id              = aws_subnet.mysubnet.id
    vpc_security_group_ids = [aws_security_group.mysg.id]
    key_name               = aws_key_pair.my-key1.id

    
# File Provisioner to copy app.py to EC2 instance
    provisioner "file" {
        source      = "/mnt/c/Users/Terraform/Terraform provisioners/app.py"
        destination = "/home/ubuntu/app.py"
    }
    connection {
        type        = "ssh"
        user        = "ubuntu"
        private_key = file("/root/.ssh/id_rsa")
        host        = self.public_ip
    }
# Remote-exec Provisioner to run commands on EC2 instance   
    provisioner "remote-exec" {
        inline = [
            "echo 'Hello, This is mostly use terraform task'",
            "sudo apt update -y",
            "sudo apt install python3-pip python3-flask -y",
            "nohup python3 /home/ubuntu/app.py &"
        ]
    }
}
