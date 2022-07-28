terraform {
  backend "s3" {
    bucket = "tfstate-project-genesis"
    key    = "genesis/percona.tfstate"
    region = "us-east-1"
  }
}