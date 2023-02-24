#Criar VPC
resource "aws_vpc" "Main" {            
  cidr_block       = var.main_vpc_cidr 
  instance_tenancy = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-${var.project_name}"
  }
}

# Criar internet gateway e atachando na VPC
resource "aws_internet_gateway" "IGW" { 
  vpc_id = aws_vpc.Main.id              
}

# Criando public subnet_a
resource "aws_subnet" "publicsubnets_a" {
  vpc_id     = aws_vpc.Main.id
  cidr_block = var.public_subnets_a
  tags = {
    Name = "publicsubnet_a-${var.project_name}"
  }
} 

# Criando public subnet_b  
resource "aws_subnet" "publicsubnets_b" { 
  vpc_id     = aws_vpc.Main.id
  cidr_block = var.public_subnets_b
  tags = {
    Name = "publicsubnet_b-${var.project_name}"
  }

}

# Criando private subnet_a                 
resource "aws_subnet" "privatesubnets_a" {
  vpc_id     = aws_vpc.Main.id
  cidr_block = var.private_subnets_a 
  tags = {
    Name = "privatesubnet_a-${var.project_name}"
  }

 } 

# Criando private subnet_b                    
resource "aws_subnet" "privatesubnets_b" {
  vpc_id     = aws_vpc.Main.id
  cidr_block = var.private_subnets_b
  tags = {
    Name = "privatesubnet_b-${var.project_name}"
  }

}

resource "aws_eip" "nateIP" {
  vpc = true
}

# Criando nat gateway
resource "aws_nat_gateway" "NATgw" {
  allocation_id = aws_eip.nateIP.id
  subnet_id     = aws_subnet.privatesubnets_a.id
}

# Criando route table para public subnets
resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.Main.id
  route {
    cidr_block = "0.0.0.0/0" 
    gateway_id = aws_internet_gateway.IGW.id
  }
}

# Criando route table para private subnets
resource "aws_route_table" "PrivateRT" {
  vpc_id = aws_vpc.Main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NATgw.id
  }
}

# Associando route table as subnets publicas
resource "aws_route_table_association" "PublicRTassociation" {
  subnet_id      = "${aws_subnet.publicsubnets_a.id},${aws_subnet.publicsubnets_b.id}"
  route_table_id = aws_route_table.PublicRT.id
}

# Associando route table as subnets privadas
resource "aws_route_table_association" "PrivateRTassociation" {
  subnet_id      = "${aws_subnet.privatesubnets_a.id},${aws_subnet.privatesubnets_b.id}"
  route_table_id = aws_route_table.PrivateRT.id
}

# Habilitando resolvedor de DNS
resource "aws_vpc_dhcp_options" "dns_resolver" {
  domain_name_servers = ["8.8.8.8", "8.8.4.4"]
}

