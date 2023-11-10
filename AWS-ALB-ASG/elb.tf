# Application Load balancer
resource "aws_lb" "lb" {
  name               ="${var.tag}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb_sg.id, ]
  subnets            = [aws_subnet.public_subnet1, aws_subnet.public_subnet2]
}
# Target Group Creation
resource "aws_lb_target_group" "TG" {
  name        = "${var.tag}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  health_check {
    path                = var.health_check
    port                = "traffic-port"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 60
    matcher             = "200"
  }
}

resource "aws_lb_listener" "http_application" {
  load_balancer_arn = aws_lb.lb.id
  port              = "80"
  protocol          = "HTTP"
  depends_on        =  [aws_lb_target_group.TG]
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.TG.arn
  }
}
  resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.ec2-cluster.id
  lb_target_group_arn    = aws_lb_target_group.TG.arn
}


