
data "template_file" "inventory" {
  template = file("${path.module}/ansible/inventory.tpl")
  vars = {
    host = aws_eip.my_static_ip.public_ip
    path_to_ssh_pem_key = "${path.cwd}/ssh_private_keys/${var.key_name}"
  }
}

data "template_file" "var" {
  template = file("${path.module}/ansible/var.tpl")
  vars = {
    host = aws_eip.my_static_ip.public_ip
  }
}

# Create local ansible inventory file based on rendered content
resource "local_file" "inventory" {
  filename = "${path.module}/ansible/inventory.txt"
  content = data.template_file.inventory.rendered
}

resource "local_file" "var" {
  filename = "${path.module}/ansible/var.yml"
  content = data.template_file.var.rendered
}

# Execute our ansible playbook
resource "null_resource" "ansible_provision" {
  depends_on = [ 
    local_file.inventory,
    local_file.var
     ]
  triggers = {
    template = data.template_file.inventory.rendered
  }
  provisioner "local-exec" {
    command = "ansible-playbook -i ${path.module}/ansible/inventory.txt ${path.module}/ansible/playbook2.yml"
  }
}