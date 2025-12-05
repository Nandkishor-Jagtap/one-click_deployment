output "alb_dns" {
  value       = aws_lb.app_alb.dns_name
  description = "ALB DNS to test the API"
}

output "vpc_id" {
  value = aws_vpc.main.id
}
