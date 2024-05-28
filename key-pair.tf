# 키 예시
# ssh-keygen -t rsa -b 4096 -C "" -f "/root/terraform/multi-tier-architecture-using-terraform/3tier-key" -N ""

#resource "aws_key_pair" "my-key" {
#  key_name   = var.key-name
#  public_key = file("3tier-key.pub")
#}