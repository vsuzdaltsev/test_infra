variable "access_key" {}
variable "secret_key" {}
variable "region" {}
variable "token" {}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
  token      = var.token
}
