#!/bin/bash

echo ECS_CLUSTER="${ecs-cluster-name}" >> /etc/ecs/ecs.config
# ECS_CLUSTER 환경변수를 설정하고 ECS 에이전트 설정 파일(ecs.config)에 추가
# Terraform에서 제공한 변수를 참조하여 해당 클러스터 이름을 동적으로 삽입
