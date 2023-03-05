data "aws_availability_zones" "avaliable" {
  
}

variable "cidr_block_vpc" {
    type = string
    default = "172.145.132.0/24"
}

variable "tag" {
    type = string
    default = "Pet-Project-App"
}


output "private_subnet_1" {
    value = aws_subnet.private_subnet_1
}

output "private_subnet_2" {
    value = aws_subnet.private_subnet_2
}


