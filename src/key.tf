resource "tls_private_key" "ssh_key" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.key_pair_name
  public_key = trimspace(tls_private_key.ssh_key.public_key_openssh)
}

resource "local_file" "private_key" {
  content  = tls_private_key.ssh_key.private_key_openssh
  filename = "${var.key_pair_name}.pem"
  provisioner "local-exec" {
    command = "chmod 400 ${var.key_pair_name}.pem"
  }
}
