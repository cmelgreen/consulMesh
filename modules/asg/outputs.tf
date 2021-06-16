output "elb_endpoint" {
    value = aws_elb.elb.dns_name
}

output "asg" {
    value = aws_autoscaling_group.asg
}