output "internal_alb_dns" {
  description = "DNS name of the internal application load balancer"
  value       = aws_lb.internal.dns_name
}

output "app_tg_arn" {
  description = "ARN of the app tier target group"
  value       = aws_lb_target_group.app.arn
}

output "asg_name" {
  description = "Name of the app tier Auto Scaling Group"
  value       = aws_autoscaling_group.app.name
}
