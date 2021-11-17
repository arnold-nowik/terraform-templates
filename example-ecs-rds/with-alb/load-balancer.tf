resource "aws_lb" "example-stg-alb" {
  name               = "example-stg-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.example-stg-sg-alb.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_target_group" "example-stg-alb-tg" {
  name     = "example-stg-alb-tg"
  port     = "8080"
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_lb_listener" "example-stg-alb-8080" {
  load_balancer_arn = aws_lb.example-stg-alb.arn
  port              = "8080"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example-stg-alb-tg.arn
  }
}
