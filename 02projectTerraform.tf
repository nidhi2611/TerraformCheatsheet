
# 1. Create VPC
# 2. Create Internet Gateway
# 3. Create Custom Route Table
# 4. Create Subnet 
# 5. Associate Subnet with Route Table
# 6. Create Security Group to allow port 22,80,443
# 7. Create a network interface with a IP in the subnet that was created in step 4
# 8. Assign an ElasticIP to the network interface created in step 7 
# 9. Create an Ubuntu Server and install/enable apache2

resource "aws_vpc" "myVPC" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "VPC1"
  }
}

resource "aws_internet_gateway" "gateway1" {
  vpc_id = aws_vpc.myVPC.id
  tags = {
    Name = "gateway1"
  }
}

resource "aws_route_table" "myVPCRouteTable" {
  vpc_id = aws_vpc.myVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway1.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.gateway1.id
  }

  tags = {
    Name = "myVPCRoutes"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.myVPC.id 
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-west-2a"
  tags = {
    Name = "subnet1"
  }
}

resource "aws_route_table_association" "subnet1RouteTable" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.myVPCRouteTable.id
}

resource "aws_security_group" "allow_web" {
  name        = "webServer"
  description = "Allow inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.myVPC.id 

  ingress {
    description = "SSH"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    description = "HTTP"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    description = "HTTPS"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    Name = "webServerSecurityGroup"
  }

}

resource "aws_network_interface" "networkInterface" {
  subnet_id       = aws_subnet.subnet1.id
  private_ips     = ["10.0.0.50"]
  security_groups = [aws_security_group.allow_web.id]
  
}

resource "aws_eip" "ip" {
  vpc                    = "true"
  network_interface         = aws_network_interface.networkInterface.id
  associate_with_private_ip = "10.0.0.50"
  depends_on = [aws_internet_gateway.gateway1]
}

resource "aws_instance" "web-server-instance" {
  ami = "ami-01e82af4e524a0aa3"
  instance_type = "t2.micro"
  availability_zone = "us-west-2a"

  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.networkInterface.id
  }

  user_data = <<-EOF
        #!/bin/bash
        sudo apt update -y
        sudo apt install apache2 -y
        sudo systemctl start apache2
        sudo bash -c 'echo yor very first web server > /var/www/html/index.html'
        EOF
  tags = {
    Name = "web-server-instance"
  }
}
