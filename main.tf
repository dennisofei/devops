# Create the VPC

resource "aws_vpc" "Prod-rock-vpc" {
  cidr_block       = var.cidr-for-vpc
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "Prod-rock-vpc"
  }
}


#create security group
resource "aws_security_group""Test-sec-group"{
  name="security group using terraform"
  description="security group using terraform"
  vpc_id=aws_vpc.Prod-rock-vpc.id




ingress{
  description="HTTP"
  from_port=80
  to_port=80
  protocol="tcp"
  cidr_blocks=["0.0.0.0/0"]
  ipv6_cidr_blocks=["::/0"]
  }



ingress{
  description="SSH"
  from_port=22
  to_port=22
  protocol="tcp"
  cidr_blocks=["0.0.0.0/0"]
  ipv6_cidr_blocks=["::/0"]
  }



egress{
  from_port=0
  to_port=0
  protocol="-1"
  cidr_blocks=["0.0.0.0/0"]
  ipv6_cidr_blocks=["::/0"]
  }

tags={
  Name="Test-sec-group"
  }
}








# Create Public Subnet 1

resource "aws_subnet" "Test_public_sub1" {
  vpc_id     = aws_vpc.Prod-rock-vpc.id
  cidr_block = var.cidr-for-public-1

  tags = {
    Name = "Test_public_sub1"
  }
}


# Create Public Subnet 2

resource "aws_subnet" "Test_public_sub2" {
  vpc_id     = aws_vpc.Prod-rock-vpc.id
  cidr_block = var.cidr-for-public-2

  tags = {
    Name = "Test_public_Sub2"
  }
}



# Create Private Subnet 1

resource "aws_subnet" "Test_priv_sub1" {
  vpc_id     = aws_vpc.Prod-rock-vpc.id
  cidr_block = var.cidr-for-private-1

  tags = {
    Name = "Test_priv_Sub1"
  }
}


# Create Private Subnet 2

resource "aws_subnet" "Test_priv_sub2" {
  vpc_id     = aws_vpc.Prod-rock-vpc.id
  cidr_block = var.cidr-for-private-2

  tags = {
    Name = "Test_priv_Sub2"
  }
}

# Create Public Route Table
resource "aws_route_table" "Test-pub-route-table" {
  vpc_id = aws_vpc.Prod-rock-vpc.id



  tags = {
    Name = "Test-pub-route-table"
  }
}


# Create Private Route Table
resource "aws_route_table" "Test-priv-route-table" {
  vpc_id = aws_vpc.Prod-rock-vpc.id



  tags = {
    Name = "Test-priv-route-table"
  }
}

# associate route table public 1

resource "aws_route_table_association" "public_route_table_association_1" {
  subnet_id      = aws_subnet.Test_public_sub1.id
  route_table_id = aws_route_table.Test-pub-route-table.id
}



# associate route table public 2

resource "aws_route_table_association" "public_route_table_association_2" {
  subnet_id      = aws_subnet.Test_public_sub2.id
  route_table_id = aws_route_table.Test-pub-route-table.id
}


# associate route table private

resource "aws_route_table_association" "private_route_table_association_1" {
  subnet_id      = aws_subnet.Test_priv_sub1.id
  route_table_id = aws_route_table.Test-priv-route-table.id
}




# associate route table private 2

resource "aws_route_table_association" "private_route_table_association_2" {
  subnet_id      = aws_subnet.Test_priv_sub2.id
  route_table_id = aws_route_table.Test-priv-route-table.id
}




#create Internet Gateway

resource "aws_internet_gateway" "Test-igw" {
  vpc_id = aws_vpc.Prod-rock-vpc.id

  tags = {
    Name = "Test-igw"
  }
}





#Create AWS Route

resource "aws_route" "public_igw_route" {
  route_table_id            = aws_route_table.Test-pub-route-table.id
  gateway_id                = aws_internet_gateway.Test-igw.id
  destination_cidr_block    = "0.0.0.0/0"
  
  
}



# Elastic IP
resource "aws_eip" "EIP_for_NG" {
  vpc = true
  associate_with_private_ip = "10.0.0.4"
  depends_on = [
    aws_internet_gateway.Test-igw
  ]
}


# NAT Gateway resource
resource "aws_nat_gateway" "Test-Nat-gateway" { 
allocation_id = aws_eip.EIP_for_NG.id 
subnet_id = aws_subnet.Test_public_sub1.id
} 


#Route NAT GW with private Route Table

resource "aws_route" "NatGW-association_with-private_RT" { 
route_table_id = aws_route_table.Test-priv-route-table.id
nat_gateway_id = aws_nat_gateway.Test-Nat-gateway.id
destination_cidr_block = "0.0.0.0/0" 
}



# create public server 1

resource "aws_instance" "Test-Server-1" {
ami = "ami-05a8c865b4de3b127"
instance_type = "t2.micro" 
key_name = "EC2_KP2" 
vpc_security_group_ids =[aws_security_group.Test-sec-group.id] 
associate_public_ip_address = true 
subnet_id = aws_subnet.Test_public_sub1.id
tags = { name = "Test-server-1" }
}


# create public server 2

resource "aws_instance" "Test-Server-2" {
ami = "ami-05a8c865b4de3b127"
instance_type = "t2.micro" 
key_name = "EC2_KP2" 
iam_instance_profile = aws_iam_instance_profile.ec2-role.name
vpc_security_group_ids =[aws_security_group.Test-sec-group.id] 
associate_public_ip_address = true
subnet_id = aws_subnet.Test_public_sub2.id
tags = { name = "Test-server-2" }
}