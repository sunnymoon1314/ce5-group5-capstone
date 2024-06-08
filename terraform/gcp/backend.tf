terraform {
  backend "gcs" {
    bucket = "enhanced-option-423814-n0-tf-state"
    prefix = "chap08"
  }
}
