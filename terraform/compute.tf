resource "aws_instance" "public" {
  ami                         = data.aws_ssm_parameter.latest_ami.value
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.public.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    set -euo pipefail
    dnf -y update
    dnf -y install nginx
    systemctl enable --now nginx
    echo "<h1>my-vpc is live</h1>" > /usr/share/nginx/html/index.html
  EOF

  tags = { Name = "my-instance-public" }
}

resource "aws_instance" "private" {
  ami                    = data.aws_ssm_parameter.latest_ami.value
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.private.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  tags = { Name = "my-instance-private" }
}
