#!/bin/bash

echo ECS_CLUSTER="${ecs-cluster-name}" >> /etc/ecs/ecs.config

# EC2 메타데이터 서비스에서 토큰 생성
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
# 가용 영역 ID 조회
RZAZ=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone-id)
# 인스턴스 ID 조회
IID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
# 로컬 IP 주소 조회
LIP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)