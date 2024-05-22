# web_service.config.json.tpl
[
  {
    "name": "web-nginx-container",
    "image": "${aws_ecr_repository}:${tags}",
    "cpu": 10,
    "memory": 256,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80,
        "protocol": "tcp"
      }
    ],
    "environment": [
      {
        name = "ALB"
        value = "${var.alb_app_dns}"
      }
    ],
  }
]