output "endpoint" {
  value = aws_instance.Wordpresstest.public_dns
}

output "ip" {
  value = aws_instance.Wordpresstest.public_ip
}