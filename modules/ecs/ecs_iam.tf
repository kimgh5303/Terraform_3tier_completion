data "aws_iam_policy_document" "ecs_service_policy" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_service_role" {
  assume_role_policy = data.aws_iam_policy_document.ecs_service_policy.json

  tags = {
    Name = format("%s-iam-ecs", var.tags.value),
    key                 = var.tags.key
    value               = var.tags.value
  }
}

resource "aws_iam_role_policy_attachment" "ecs_service_role_attachment" {
  role       = aws_iam_role.ecs_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}