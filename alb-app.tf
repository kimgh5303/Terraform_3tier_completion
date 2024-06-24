resource "aws_lb" "alb-app" {
  name               = var.alb-app-name

  # 내부 IP 주소를 사용하는 내부 로드 밸런서인지, 외부 IP 주소를 사용하는 공개 로드 밸런서인지 지정
  internal           = true
  load_balancer_type = "application"                                            # 로드밸런서 유형 지정. 애플리케이션 로드 밸런서          
  security_groups    = [aws_security_group.alb-security-group-app.id]           # 로드 밸런서에 연결할 보안 그룹을 지정
  subnets            = [aws_subnet.app-subnet1.id, aws_subnet.app-subnet2.id]   # 로드 밸런서가 위치할 서브넷 지정

  tags = {
    Name = var.alb-app-name
    Owner = var.owner-tag
  }
}
