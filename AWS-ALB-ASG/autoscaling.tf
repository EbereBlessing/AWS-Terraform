resource "aws_autoscaling_group" "ec2-cluster" {
  name                 = "${var.tag}-auto_scaling_group"
  min_size             = var.autoscale_min
  max_size             = var.autoscale_max
  desired_capacity     = var.autoscale_desired
  health_check_type    = "EC2"
  launch_configuration = aws_launch_configuration.ec2.name
  vpc_zone_identifier  = element(aws_subnet.private_subnet.*.id, count.index)
  target_group_arns    = [aws_alb_target_group.TG.arn]
}