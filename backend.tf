terraform {
  cloud {
    hostname     = "app.terraform.io"
    organization = "BFSI-C370-INFASTRUCTURE"

    workspaces {
      name = "bfsi-c360-dev-infra"
    }
  }
}


#terraform {
#  backend "local" {
#    path = "terraform.tfstate"
#  }
#}
