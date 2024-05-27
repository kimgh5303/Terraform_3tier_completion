# 키 예시
# ssh-keygen -t rsa -b 4096 -C "" -f "/root/terraform/multi-tier-architecture-using-terraform/3tier-key" -N ""

#resource "aws_key_pair" "my-key" {
#  key_name   = var.key-name
#  public_key = file("3tier-key.pub")
#}

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

# SSH 키를 로컬 파일로 저장
resource "local_file" "private_key_pem" {
  content  = tls_private_key.private_key.private_key_pem
  filename = "${path.module}/ec2_key.pem"
}

output "private_key_path" {
  value = local_file.private_key_pem.filename
}