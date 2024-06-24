# 키 예시
# ssh-keygen -t rsa -b 4096 -C "" -f "/root/terraform/multi-tier-architecture-using-terraform/3tier-key" -N ""

#resource "aws_key_pair" "my-key" {
#  key_name   = var.key-name
#  public_key = file("3tier-key.pub")
#}

# SSH 키 생성
resource "tls_private_key" "private_key" {
  algorithm = "RSA"                           # RSA 암호화 알고리즘
  rsa_bits  = 2048                            # 키 길이를 2048 비트로 설정
}

# SSH 키를 AWS에 등록
resource "aws_key_pair" "deployer" {
  key_name   = "ssh-key"
  public_key = tls_private_key.private_key.public_key_openssh   # 공개 키 데이터
}

# SSH 키를 로컬 파일로 저장
resource "local_file" "private_key_pem" {
  content  = tls_private_key.private_key.private_key_pem        # 비공개 키 내용
  filename = "${path.module}/ec2_key.pem"                       # # 저장될 파일 경로와 이름
}

# 비공개 키 파일 경로를 출력
output "private_key_path" {
  value = local_file.private_key_pem.filename
}