terraform {
  backend "gcs" {
    bucket  = "our-shield-480712-i3-tfstate"
    prefix  = "terraform/state"
  }
}