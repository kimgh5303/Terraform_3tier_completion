# SSH 키 생성
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# SSH 키를 AWS에 등록
resource "aws_key_pair" "deployer" {
  key_name   = "ssh-key"
  public_key = tls_private_key.private_key.public_key_openssh
}

# 베스천 호스트 인스턴스 생성
resource "aws_instance" "bastion" {
  ami           = var.bastion-image-id
  instance_type = var.bastion-instance-type
  subnet_id     = aws_subnet.public-subnet1.id
  security_groups = [aws_security_group.bastion_sg.name]

  key_name = aws_key_pair.deployer.key_name

  tags = {
    Name = "bastion"
    Owner = var.owner-tag
  }
}

# 베스천 호스트 보안 그룹
resource "aws_security_group" "bastion_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "bastion-sg"
    Owner = var.owner_tag
  }
}