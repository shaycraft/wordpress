terraform {
  cloud {
    organization = "mr-gav-meow"

    workspaces {
      name = "wordpress-ami"
    }
  }
}
