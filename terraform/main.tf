provider "aws" {
  region = "eu-west-3"
}

/* resource "aws_vpc" "myapp_vpc" {
    cidr_block = var.vpc_cidr_blocks
    tags = {
        Name: "${var.env_prefix}-vpc"
    }
  
} */

/* resource "aws_subnet" "myapp-subnet-1" {
    vpc_id = aws_vpc.myapp_vpc.id
    cidr_block = var.subnet_cidr_blocks
    availability_zone = var.avail_zone
    tags = {
        Name: "${var.env_prefix}-subnet-1"
    }

} */

/* resource "aws_route_table" "myapp-route-table" {
    vpc_id = aws_vpc.myapp_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myapp-igw.id

    }
    tags = {
      Name: "${var.env_prefix}-rtb"
    }
} */

/* resource "aws_internet_gateway" "myapp-igw" {
    vpc_id = aws_vpc.myapp_vpc.id

    tags = {
      Name: "${var.env_prefix}-igw"
    } 
} */

/* resource "aws_route_table_association" "a-rtb-subnet" {
    subnet_id = aws_subnet.myapp-subnet-1.id
    route_table_id = aws_route_table.myapp-route-table.id
  
} */

/* resource "aws_default_route_table" "main-rtb" {
    default_route_table_id = aws_vpc.myapp_vpc.default_route_table_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myapp-igw.id

    }
    tags = {
      Name: "${var.env_prefix}-rtb"
    }
} */

/* resource "aws_security_group" "myapp-sg" {
    name = "myapp-sg"
    vpc_id = aws_vpc.myapp_vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
        prefix_list_ids = [  ]
    }

    tags = {
        Name: "${var.env_prefix}-sg"
    }
  
} */

data "aws_security_group" "my_sg" {
    tags = {
      Name: "SG1"
    }
}

/* data "aws_ami" "latest-amazon-linux-image" {
    most_recent = true
    owners = [ "amazon" ]
    filter {
      name = "name"
      values = [ "amz*" ]
    }
    filter {
        name = "virtualization-type"
        values = [ "hvm" ]
    }
  
} */

data "aws_subnet" "my_subnet" {
    availability_zone = var.avail_zone
    id = "subnet-0120f4c4f4c6ced93"
}

resource "aws_instance" "myapp-server" {
    ami = "ami-00983e8a26e4c9bd9"
    instance_type = var.instance_type
    key_name = "SSH-Key1"
    subnet_id = data.aws_subnet.my_subnet.id
    vpc_security_group_ids = [ data.aws_security_group.my_sg.id ]
    availability_zone = var.avail_zone
    associate_public_ip_address = true

    tags = {
        Name: "${var.env_prefix}-server"
    }

    root_block_device {
    volume_size = 8
    volume_type = "gp2"  # General Purpose (SSD) volume type
  }

    user_data = <<EOF
                    #!/bin/bash
                    sudo apt update
                    sudo apt upgrade
                    
                EOF

    /* provisioner "local-exec" {

    } */
}