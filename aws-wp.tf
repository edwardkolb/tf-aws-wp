provider "aws" {
    region     = var.region
}

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.jenkins.id
  tags = {
    Name  = "Jenkins Server IP"
  }
}

resource "aws_instance" "jenkins" {
    ami           = data.aws_ami.latest_ubuntu.id
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.jenkins_server.id] 
    key_name = var.key_name
    
    tags = {
    Name = "Jenkins server"
    Project = "AWS-Wordpress deployment"
  }
}

resource "aws_security_group" "jenkins_server" {  
  name        = "JenkinsServer Security Group"
  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.cidr
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.cidr
  }
}

output "jenkins_ip" {
  description = "Elatic IP address assigned to our WebSite"
  value       = aws_eip.my_static_ip.public_ip
}


data "template_file" "inventory" {
  template = file("${path.module}/ansible/inventory.tpl")
  vars = {
    host = aws_eip.my_static_ip.public_ip
    path_to_ssh_pem_key = "${path.cwd}/ssh_private_keys/${var.key_name}"
  }
}

# Create local ansible inventory file based on rendered content
resource "local_file" "inventory" {
  filename = "${path.module}/ansible/inventory.txt"
  content = data.template_file.inventory.rendered
}


# Execute our ansible playbook
resource "null_resource" "ansible_provision" {
  depends_on = [ local_file.inventory ]
  triggers = {
    template = data.template_file.inventory.rendered
  }
  provisioner "local-exec" {
    command = "ansible-playbook -i ${path.module}/ansible/inventory.txt ${path.module}/ansible/playbook2.yml"
  }
}