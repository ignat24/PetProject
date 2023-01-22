provider "aws"{
    region = "eu-west-2"
    profile = "aws-terraform"
}

resource "aws_instance" "app_server" {
  ami           = "ami-084e8c05825742534"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}