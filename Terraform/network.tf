data "aws_availability_zones" "avaliable" {
  
}

resource "aws_vpc" "main_vpc"{
    cidr_block = "172.145.132.0/24"

    tags = {
        Name = "VPC-Pet-Project"
        Project = "Pet Project"
    }
}

resource "aws_subnet" "public_subnet_1" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "172.145.132.0/26"
    availability_zone = data.aws_availability_zones.avaliable.names[0]
    map_public_ip_on_launch = true

    tags = {
        Name = "Public-Subnet-1"
        Project = "Pet Project"
    }
    
    depends_on = [
        aws_vpc.main_vpc
    ]
}

resource "aws_subnet" "public_subnet_2" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "172.145.132.64/26"
    availability_zone = data.aws_availability_zones.avaliable.names[1]

    tags = {
        Name = "Public-Subnet-2"
        Project = "Pet Project"
    }
    
    depends_on = [
        aws_vpc.main_vpc
    ]
}

resource "aws_subnet" "private_subnet_1" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "172.145.132.128/26"
    availability_zone = data.aws_availability_zones.avaliable.names[0]

    tags = {
        Name = "Private-Subnet-1"
        Project = "Pet Project"
    }
    
    depends_on = [
        aws_vpc.main_vpc
    ]
}

resource "aws_subnet" "private_subnet_2" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "172.145.132.192/26"
    availability_zone = data.aws_availability_zones.avaliable.names[1]

    tags = {
        Name = "Private-Subnet-2"
        Project = "Pet Project"
    }

    depends_on = [
        aws_vpc.main_vpc
    ]
}

resource "aws_internet_gateway" "IG"{
    vpc_id = aws_vpc.main_vpc.id

    tags = {
        Name = "IG"
        Project = "Pet Project"
    }

}

resource "aws_eip" "elastic_ip"{
    count = 2
    vpc = true

    tags = {
        Name = "EIP-${count.index + 1}" 
    }
}

resource "aws_nat_gateway" "nat_gateway_1"{
    allocation_id = aws_eip.elastic_ip[0].id
    subnet_id = aws_subnet.public_subnet_1.id

    tags = {
        Name = "NAT-Public-1"
    }
}

resource "aws_nat_gateway" "nat_gateway_2"{
    allocation_id = aws_eip.elastic_ip[1].id
    subnet_id = aws_subnet.public_subnet_2.id

    tags = {
        Name = "NAT-Public-2"
    }
}