#-------------------------------------------------------------------
# EC2 
#-------------------------------------------------------------------
# - Master Server
#-------------------------------------------------------------------
resource "aws_instance" "master" {
  ami           = data.aws_ami.ubuntu_linux_latest.id
  instance_type = var.instance_type["master"]
  vpc_security_group_ids = [
    aws_security_group.ssh.id,
    aws_security_group.mysql.id
  ]
  subnet_id                   = flatten([data.aws_subnets.public.ids])[0]
  associate_public_ip_address = true
  user_data                   = templatefile("./templates/hostname.tpl", { hostname = "${var.host_name["master"]}-${var.env}" })
  key_name                    = var.ssh_key["install"] ? aws_key_pair.ssh-key[0].key_name : var.ssh_key["exist"]

  root_block_device {
    volume_size = "20"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.host_name["master"]}-${var.env}"
    }
  )

  depends_on = [
    aws_key_pair.ssh-key,
    aws_security_group.ssh,
    aws_security_group.mysql,
    module.vpc
  ]
}

/*
resource "aws_ebs_volume" "master_volume" {
     availability_zone = data.aws_availability_zones.available.names
     size              = 10
     type = "gp3"
     tags = merge(
      var.common_tags,
      { 
        Name = "master_volume-${var.project}"
      }
    )
}

resource "aws_volume_attachment" "master_volume" {
     device_name = "/dev/xvdb"
     volume_id   = aws_ebs_volume.master_volume.id
     instance_id = aws_instance.master.id
     skip_destroy = true
}
*/

#-------------------------------------------------------------------
# - Slave Servers
#-------------------------------------------------------------------
resource "aws_instance" "slave" {
  count         = var.vm_slave_count
  ami           = data.aws_ami.ubuntu_linux_latest.id
  instance_type = var.instance_type["slave"]
  vpc_security_group_ids = [
    aws_security_group.ssh.id,
    aws_security_group.mysql.id
  ]
  subnet_id                   = flatten([data.aws_subnets.public.ids])[count.index]
  associate_public_ip_address = true
  user_data                   = templatefile("./templates/hostname.tpl", { hostname = "${var.host_name["slave"]}-${format("%02d", count.index + 1)}-${var.env}" })
  key_name                    = var.ssh_key["install"] ? aws_key_pair.ssh-key[0].key_name : var.ssh_key["exist"]

  root_block_device {
    volume_size = "20"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.host_name["slave"]}-${format("%02d", count.index + 1)}-${var.env}"
    }
  )

  depends_on = [
    aws_key_pair.ssh-key,
    aws_security_group.ssh,
    aws_security_group.mysql,
    module.vpc
  ]
}

/*
resource "aws_ebs_volume" "slave_volume" {
     availability_zone = data.aws_availability_zones.available.names[count.index]
     size              = 10
     type = "gp3"
     tags = merge(
      var.common_tags,
      { 
        Name = "slave_volume-${var.project}"
      }
    )
}

resource "aws_volume_attachment" "slave_volume" {
     device_name = "/dev/xvdb"
     volume_id   = aws_ebs_volume.slave_volume.id
     instance_id = aws_instance.slave[0].id
     skip_destroy = true
}
*/