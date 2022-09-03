# Create the VPC

resource "aws_vpc" "terra_vpc" {
  cidr_block       = var.cidr-for-vpc
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "terra_vpc"
  }
}





# Create Public Subnet 1

resource "aws_subnet" "public_sub1" {
  vpc_id     = aws_vpc.terra_vpc.id
  cidr_block = var.cidr-for-public-1

  tags = {
    Name = "Public_Sub1"
  }
}


# Create Public Subnet 2

resource "aws_subnet" "Public_sub2" {
  vpc_id     = aws_vpc.terra_vpc.id
  cidr_block = var.cidr-for-public-2

  tags = {
    Name = "Public_Sub2"
  }
}



# Create Private Subnet 1

resource "aws_subnet" "private_sub1" {
  vpc_id     = aws_vpc.terra_vpc.id
  cidr_block = var.cidr-for-private-1

  tags = {
    Name = "Private_Sub1"
  }
}


# Create Private Subnet 2

resource "aws_subnet" "private_sub2" {
  vpc_id     = aws_vpc.terra_vpc.id
  cidr_block = var.cidr-for-private-2

  tags = {
    Name = "Private_Sub2"
  }
}

# Create Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.terra_vpc.id



  tags = {
    Name = "public_route_table"
  }
}


# Create Private Route Table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.terra_vpc.id



  tags = {
    Name = "private_route_table"
  }
}

# associate route table public 1

resource "aws_route_table_association" "public_route_table_association_1" {
  subnet_id      = aws_subnet.public_sub1.id
  route_table_id = aws_route_table.public_route_table.id
}



# associate route table public 2

resource "aws_route_table_association" "public_route_table_association_2" {
  subnet_id      = aws_subnet.Public_sub2.id
  route_table_id = aws_route_table.public_route_table.id
}


# associate route table private

resource "aws_route_table_association" "private_route_table_association_1" {
  subnet_id      = aws_subnet.private_sub1.id
  route_table_id = aws_route_table.private_route_table.id
}




# associate route table private 2

resource "aws_route_table_association" "private_route_table_association_2" {
  subnet_id      = aws_subnet.private_sub2.id
  route_table_id = aws_route_table.private_route_table.id
}




#create Internet Gateway

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.terra_vpc.id

  tags = {
    Name = "IGW"
  }
}





#Create AWS Route

resource "aws_route" "public_igw_route" {
  route_table_id            = aws_route_table.public_route_table.id
  gateway_id                = aws_internet_gateway.IGW.id
  destination_cidr_block    = "0.0.0.0/0"
  
  
}
