# terraform 로그
export TF_LOG=DEBUG
terraform apply -var-file="terraform.tfvars" -var-file="secret.tfvars" -auto-approve

unset TF_LOG
