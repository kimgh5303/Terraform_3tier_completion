# app_service.config.json.tpl
[
  {
    "name": "app-${app_name}",
    "image": "${aws_ecr_repository}:${tags}",
    "cpu": 10,
    "memory": 256,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 8080,
        "protocol": "tcp"
      }
    ],
    environment = [
      {name = "rds_endpoint", value = "${var.rds_endpoint}"},
      {name = "HOST", value = "${local.host}"},
      {name = "USERNAME", value = "${var.db_user.db_username}"},
      {name = "PASSWORD", value = "${var.db_user.db_password}"},
      {name = "DB", value = "${var.rds_db.db_name}"},
    ],
  }
]