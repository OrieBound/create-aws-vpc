output "public_ip" {
  value = aws_instance.public.public_ip
}

output "website_url" {
  value = "http://${aws_instance.public.public_ip}/"
}

output "private_instance_ip" {
  value = aws_instance.private.private_ip
}
