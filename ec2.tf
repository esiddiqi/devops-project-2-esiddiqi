resource "aws_instance" "demo-server" {
  ami             = "ami-0f960def03d1071d3"
  instance_type   = "t2.micro"
  key_name        = "emaad-keypair"
#  security_groups = ["demo-sg"]
  vpc_security_group_ids = [aws_security_group.demo-sg.id]
  subnet_id       = aws_subnet.project-2-subnet-01.id
  for_each = toset(["jenkins-master", "Jenkins-slave", "ansible"])
  tags = {
    Name = "${each.key}"
  }

}


resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "SSH Access to instance"
  vpc_id = aws_vpc.project-2-vpc.id

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "ssh-port"
  }

}


resource "aws_vpc" "project-2-vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    name = "project-2-vpc"
  }


}



resource "aws_subnet" "project-2-subnet-01" {
  cidr_block              = "10.1.1.0/24"
  vpc_id                  = aws_vpc.project-2-vpc.id
  map_public_ip_on_launch = "true"
  availability_zone       = "us-west-1a"
  tags = {
    name = "project-2-subnet-01"
  }
}

resource "aws_subnet" "project-2-subnet-02" {
  cidr_block              = "10.1.2.0/24"
  vpc_id                  = aws_vpc.project-2-vpc.id
  map_public_ip_on_launch = "true"
  availability_zone       = "us-west-1c"
  tags = {
    name = "project-2-subnet-02"
  }
}


resource "aws_internet_gateway" "project-2-igw" {
  vpc_id = aws_vpc.project-2-vpc.id
  tags = {
    name = "project-2-igw"
  }

}


resource "aws_route_table" "project-2-pub-rt" {
  vpc_id = aws_vpc.project-2-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project-2-igw.id
  }

}

resource "aws_route_table_association" "project-2-rta-public-sub-01" {
  subnet_id      = aws_subnet.project-2-subnet-01.id
  route_table_id = aws_route_table.project-2-pub-rt.id
}

resource "aws_route_table_association" "project-2-rta-public-sub-02" {
  subnet_id      = aws_subnet.project-2-subnet-02.id
  route_table_id = aws_route_table.project-2-pub-rt.id
}