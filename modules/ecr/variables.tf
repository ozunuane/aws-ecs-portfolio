variable "ecr_repo" {
  type = map(any)
  default = {

    sv-user = {
      image_tag_mutability     = true
      image_scan_on_push       = true
      encryption_type          = "AES256"
      attach_repository_policy = false
      create_lifecycle_policy  = false
    }

    sv-notify = {
      image_tag_mutability     = true
      image_scan_on_push       = true
      encryption_type          = "AES256"
      attach_repository_policy = false
      create_lifecycle_policy  = false
    }



    sv-core-api = {
      image_tag_mutability     = true
      image_scan_on_push       = true
      encryption_type          = "AES256"
      attach_repository_policy = false
      create_lifecycle_policy  = false
    }

    combyn-website = {
      image_tag_mutability     = true
      image_scan_on_push       = true
      encryption_type          = "AES256"
      attach_repository_policy = false
      create_lifecycle_policy  = false
    }


    sv-expense = {
      image_tag_mutability     = true
      image_scan_on_push       = true
      encryption_type          = "AES256"
      attach_repository_policy = false
      create_lifecycle_policy  = false
    }

    frontend-svc  = {
      image_tag_mutability     = true
      image_scan_on_push       = true
      encryption_type          = "AES256"
      attach_repository_policy = false
      create_lifecycle_policy  = false
    }

    mongo = {
      image_tag_mutability     = true
      image_scan_on_push       = true
      encryption_type          = "AES256"
      attach_repository_policy = false
      create_lifecycle_policy  = false
    }

  }
}