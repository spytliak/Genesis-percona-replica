terraform {
  backend "s3" {
    bucket = "tfstate-project-genesis-dev"
    key    = "genesis/percona.tfstate"
    region = "us-east-1"
  }
}