terraform {
  required_version = "0.11.14"

  backend "gcs" {
    prefix = "ex/artifactory"
  }
}

provider "google" {
  region = "australia-southeast1"
	version = "~> 2.4"
}

provider "google-beta" {
  region = "australia-southeast1"
	version = "~> 2.4"
}

provider "random" {
	version = "~> 2.1"
}
