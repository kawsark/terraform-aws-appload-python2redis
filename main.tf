variable "private_key_data" {}

variable "target_host" {}

variable "target_user" {
  default = "ubuntu"
}

variable "redis_host" {}

variable "redis_port" {
  default = "6379"
}

variable "redis_password" {}

# Render userdata
data "template_file" "startup_script" {
  template = "${file("${path.module}/clientms.sh.tpl")}"

  vars {
    redis_host = "${var.redis_host}"
    redis_port  = "${var.redis_port}"
    redis_password  = "${var.redis_password}"
  }
}

resource "null_resource" "python2redis" {
  connection {
    type = "ssh"
    user = "${var.target_user}"
    host = "${var.target_host}"
    private_key = "${var.private_key_data}"
  }

  provisioner "file" {
    content     = "${data.template_file.startup_script.rendered}"
    destination = "/tmp/script.sh"
  }

  provisioner "remote-exec" {
    inline = [
    "chmod +x /tmp/script.sh",
      "/tmp/script.sh args",
    ]
  }
}