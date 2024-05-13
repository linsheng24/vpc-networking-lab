resource "aws_security_group" "left_alb_security_group" {
  name        = "sg_alb"
  description = "sg for incoming"
  vpc_id      = module.left_vpc.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "left-alb-security-group"
  }
}

resource "aws_lb_target_group" "alb_tg" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.left_vpc.vpc_id

  tags = {
    Name = "left-public-alb-tg"
  }
}

resource "aws_lb_target_group_attachment" "alb_tga" {
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = module.left_public_ec2.instance_id
  port             = 80
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

resource "aws_lb" "alb" {
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.left_alb_security_group.id]
  subnets            = module.left_vpc.public_subnets

  tags = {
    Name = "left-public-alb"
  }

  depends_on = [module.left_vpc]
}
