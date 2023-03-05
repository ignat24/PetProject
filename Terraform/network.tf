resource "aws_vpc" "main_vpc"{
    cidr_block = var.cidr_block_vpc

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
        Project = var.tag
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
        Project = var.tag
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
        Project = var.tag
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
        Project = var.tag
    }

    depends_on = [
        aws_vpc.main_vpc
    ]
}

resource "aws_internet_gateway" "IG"{
    vpc_id = aws_vpc.main_vpc.id

    tags = {
        Name = "IG"
        Project = var.tag
    }

}

resource "aws_eip" "elastic_ip"{
    vpc = true

    tags = {
        Name = "EIP" 
    }
}

resource "aws_nat_gateway" "nat_gateway"{
    allocation_id = aws_eip.elastic_ip.id
    subnet_id = aws_subnet.public_subnet_1.id

    tags = {
        Name = "NAT-Public-1"
    }
}

# resource "aws_nat_gateway" "nat_gateway_2"{
#     allocation_id = aws_eip.elastic_ip[1].id
#     subnet_id = aws_subnet.public_subnet_2.id

#     tags = {
#         Name = "NAT-Public-2"
#     }
# }


resource "aws_route_table" "public_route" {
    vpc_id = aws_vpc.main_vpc.id

    route {
            cidr_block = "0.0.0.0/0"
            gateway_id = aws_internet_gateway.IG.id
        }
    tags = {
        Name = "Public Route Table"
        Project = var.tag
    }
    
}

resource "aws_route_table" "private_route" {
    vpc_id = aws_vpc.main_vpc.id

    route {
            cidr_block = "0.0.0.0/0"
            nat_gateway_id = aws_nat_gateway.nat_gateway.id
        }
    
     tags = {
        Name = "Private Route Table"
        Project = var.tag
    }
    
}

resource "aws_route_table_association" "public_subnets_associate_1" {
    subnet_id = aws_subnet.public_subnet_1.id
    route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "public_subnets_associate_2" {
    subnet_id = aws_subnet.public_subnet_2.id
    route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "private_subnets_associate_1" {
    subnet_id = aws_subnet.private_subnet_1.id
    route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "private_subnets_associate_2" {
    subnet_id = aws_subnet.private_subnet_2.id
    route_table_id = aws_route_table.public_route.id
}