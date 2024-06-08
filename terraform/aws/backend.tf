terraform {
  backend "s3" {
    # bucket = "sctp-ce5-tfstate-bucket-1"
    bucket = "soon-bucket-20240407-2200"
    key    = "ce5-group5-capstone-project.tfstate"
    region = "us-east-1"
  }
}