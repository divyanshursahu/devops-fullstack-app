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
  access_key = "ASIAVRULR5SO645LY3XS"
  secret_key = "6sFW/NGBSoX0vtsSWFsx5IDI+65AmlizPR7Fmld1"
  token = "FwoGZXIvYXdzEBsaDCcK3DBHVal+ljcPFSLVAa+xFoyoW1vt1fcV/5dYWER8LJajgDmnM73pOZ4VssVtvFpeOVQ4pYexu2jYPy+HL3pxR/14+U65IjoNmvg781VTNqwxevjpnoiLi520vKqcWW/w6KNIkNW5pi3n/wK2k39yUXO/NMa/LBXzMU1dnS8zB2SSpsLjmZuBbOh+rp9xde/AlVs5vHYBdmfOiVKhraDAILZpawRPAvx4rNAhlp/rM68HnolRNCMnYzNEYFC4BUdi/Z/ya+AW/8+hWi89HOIymEeomDguulMpfna+czZZ9m5Lryjh0NqpBjItZPXLrf8UYebOipBVuk20hIdewYsMgHKq5UIq6NG4OttmbbpKw/OpPKw6I4oT"

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
