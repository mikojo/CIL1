resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "mikojovpc"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "mikojo_subnet"
  }
}

resource "aws_network_interface" "mikojo" {
  subnet_id   = aws_subnet.my_subnet.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "mikojo_instance" {
  ami           = "ami-0182f373e66f89c85" # us-east-1a
  instance_type = "t2.micro"
  
  # Key pair name for SSH access (without the .pem extension)
  key_name = "papkojo"

  network_interface {
    network_interface_id = aws_network_interface.mikojo.id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
}
