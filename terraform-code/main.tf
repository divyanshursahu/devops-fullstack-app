terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.22.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
  
}

# data "aws_ami" "ubuntu" {
    
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-22.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"] # Canonical
# }

resource "aws_key_pair" "tf-key-pair" {
key_name = "tf-key-pair.pem"
public_key = tls_private_key.rsa.public_key_openssh
}
resource "tls_private_key" "rsa" {
algorithm = "RSA"
rsa_bits  = 4096
}
resource "local_file" "tf-key" {
content  = tls_private_key.rsa.private_key_pem
filename = "tf-key-pair.pem"
}

resource "aws_instance" "web" {
    
    ami           = "ami-0fc5d935ebf8bc3bc"
    instance_type = "t2.medium"
    key_name = "tf-key-pair.pem"

    tags = {
      Name = "verito-vm"
    }

}

output "pub-ip" {
  value = aws_instance.web.public_ip
}
