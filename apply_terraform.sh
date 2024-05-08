#!/bin/bash
# 스크립트 파일을 실행하여 Terraform 적용
terraform apply -var-file="terraform.tfvars" -var-file="secret.tfvars" -auto-approve

# 터미널에 실행 권한 부여
# chmod +x apply_terraform.sh

# 스크립트 실행
# ./apply_terraform.sh

# 특정 모듈만 실행
# terraform apply -var-file="terraform.tfvars" -var-file="secret.tfvars" -target=module.모듈이름 -auto-approve

# 삭제 명령어
# terraform destroy -var-file="terraform.tfvars" -var-file="secret.tfvars" -auto-approve