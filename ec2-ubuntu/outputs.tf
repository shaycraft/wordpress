output "public_dns" {
  value = aws_instance.wordpress_server.public_dns
}

output "public_ip" {
  value = aws_instance.wordpress_server.public_ip
}

output "private_dns" {
  value = aws_instance.wordpress_server.private_dns
}

output "private_ip" {
  value = aws_instance.wordpress_server.private_ip
}