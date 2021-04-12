resource "aws_eip" "my_docker_ip" {
  instance = aws_instance.docker.id
  tags = {
    Name  = "Docker Server IP"
  }
}

resource "aws_instance" "docker" {
    ami           = data.aws_ami.latest_ubuntu.id
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.docker.id] 
    key_name = var.key_name
    user_data              = file("./docker_provisioning.sh")
    tags = {
    Name = "Wordpress server"
    Project = "AWS-Wordpress deployment"
  }
}

resource "aws_security_group" "docker" {  
  name        = "wordpressServer Security Group"
  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.cidr
    }
  }
}

output "docker_ip" {
  description = "Elatic IP address assigned to our WebSite"
  value       = aws_eip.my_docker_ip.public_ip
}

