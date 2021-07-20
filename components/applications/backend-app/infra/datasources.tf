data "terraform_remote_state" "core_infra" {
  backend = "local"
  config = {
    path = "${path.module}/../../../core-infra/terraform.tfstate"
  }
}

data "google_client_config" "provider" {}
