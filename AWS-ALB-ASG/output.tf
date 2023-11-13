## printout Domain name
output "alb_dns" {
  value = aws_lb.lb.dns_name
}