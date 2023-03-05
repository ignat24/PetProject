provider "aws"{
    region = "eu-west-2"
    profile = "aws-terraform"
}


resource "aws_instance" "bastion_host" {
    
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_subnet_1
    associate_public_ip_address = true

    
}