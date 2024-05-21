# app_service.config.json.tpl

[
  {
    "name": "app-${app_name}",
    "image": "${aws_ecr_repository}:${tag}",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 8080,
        "protocol": "tcp"
      }
    ],
    "cpu": 2,
    "environment": [
      {
        "name": "PORT",
        "value": "${host_port}"
      }
    ],
    "ulimits": [
      {
        "name": "nofile",
        "softLimit": 65536,
        "hardLimit": 65536
      }
    ],
    "mountPoints": [],
    "memory": 512,
    "volumesFrom": []
  }
]