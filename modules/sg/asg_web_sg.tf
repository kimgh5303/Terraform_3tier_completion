resource "aws_security_group" "asg_web_sg" {
  description = "ASG WEB Security Group"
  vpc_id      = var.vpc_id

  # HTTP traffic
  dynamic "ingress" {
    for_each = {http = var.ingress_rule["http"]}  # Only HTTP rule

    content {
        description  = ingress.value["description"]
        from_port    = ingress.value["from_port"]
        to_port      = ingress.value["to_port"]
        protocol     = ingress.value["protocol"]
        security_groups = [aws_security_group.alb_web_sg.id]
    }
  }

  # SSH traffic
  dynamic "ingress" {
    for_each = {ssh = var.ingress_rule["ssh"]}  # Only SSH rule

    content {
      description  = ingress.value["description"]
      from_port    = ingress.value["from_port"]
      to_port      = ingress.value["to_port"]
      protocol     = ingress.value["protocol"]
      cidr_blocks  = ingress.value["cidr_blocks"]
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
    Name = format("%s-asg-web-sg", var.tags.value)
    key                 = var.tags.key
    value               = var.tags.value
  }
}
