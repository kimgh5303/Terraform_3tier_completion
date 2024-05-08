resource "aws_security_group" "db_sg" {
  description = "DB SEcurity Group"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    # var.ingress_rule["db"]에서 반환된 값을 새로운 맵(Map)으로 래핑
    for_each = {http = var.ingress_rule["db"]}

    content {
        description = ingress.value["description"]
        from_port   = ingress.value["from_port"]
        to_port     = ingress.value["to_port"]
        protocol    = ingress.value["protocol"]
        security_groups = [aws_security_group.asg_app_sg.id]
    }
  }

  dynamic "egress" {
    for_each = [var.egress_rule]

    content {
        from_port   = egress.value["from_port"]
        to_port     = egress.value["to_port"]
        protocol    = egress.value["protocol"]
        cidr_blocks = egress.value["cidr_blocks"]
    }
  }

  tags = {
    Name = format("%s-db-sg", var.tags["name"])
  }
}
