output "web_alb_dns" {
  description = "Public DNS name of the web tier ALB (the application URL)"
  value       = aws_lb.web.dns_name
}

output "web_tg_arn" {
  description = "ARN of the web tier target group"
  value       = aws_lb_target_group.web.arn
}

output "asg_name" {
  description = "Name of the web tier Auto Scaling Group"
  value       = aws_autoscaling_group.web.name
}
