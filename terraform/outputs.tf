output "aws_ec2_ip_address" {
    value = aws_instance.myapp-server.public_ip
}