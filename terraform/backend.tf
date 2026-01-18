terraform {
  backend "gcs" {
    bucket  = "our-shield-480712-i3-tfstate" # The bucket you just created
    prefix  = "terraform/state"
  }
}