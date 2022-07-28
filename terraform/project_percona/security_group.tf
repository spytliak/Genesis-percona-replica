#-------------------------------------------------------------------
# SSH
#-------------------------------------------------------------------
resource "aws_security_group" "ssh" {
  name        = "SG-APP-${var.project}-${var.env}"
  description = "Security Group for APP"
  vpc_id      = module.vpc.vpc_id # data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.ssh_cidr}", "${var.vpc_cidr}", "0.0.0.0/0"] #"0.0.0.0/0" needed for github actions - access from runner
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "SG-SSH-${var.project}-${var.env}"
    }
  )
}

#-------------------------------------------------------------------
# MYSQL
#-------------------------------------------------------------------
resource "aws_security_group" "mysql" {
  name        = "SG-MYSQL-${var.project}-${var.env}"
  description = "Security Group for mysql"
  vpc_id      = module.vpc.vpc_id # data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = var.allow_port_list["mysql"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["${var.vpc_cidr}"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "SG-MYSQL-${var.project}-${var.env}"
    }
  )
}