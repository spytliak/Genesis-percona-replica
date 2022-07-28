locals {

  azs = slice(data.aws_availability_zones.available.names,1,3)

}
