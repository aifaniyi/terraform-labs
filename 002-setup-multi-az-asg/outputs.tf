output "elb_dns_name" {
  value       = aws_lb.sample_alb.dns_name
  description = "The DNS name of the ELB"
}
