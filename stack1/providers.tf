provider "aws" {
  profile = "profile1-admin"
  alias   = "profile1-alias"

  region = "us-east-1"

  default_tags {
    tags = {
      
    }
  }
}


provider "aws" {
  profile = "profile2-admin"
  alias   = "profile2-alias"

  region = "us-east-1"

  default_tags {
    tags = {
      
    }
  }
}

