#Chewbacca: The Force needs coordinates.
#You need this first in order to see if you can authenticate to GCP

terraform {
  required_version = ">= 1.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

provider "google" {
  project = "theowaf-class7-5charliebrown"
  region  = "us-central1-a"

}

