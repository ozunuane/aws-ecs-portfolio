variable "networks" {
  type = map(any)
  default = {
    # rds = {
    #   subnets   = ["10.1.240.0/22", "10.1.244.0/22", "10.1.0.0/22"]
    #   is_public = true
    # }

    # ddb = {
    #   subnets   = ["10.1.12.0/22", "10.1.16.0/22", "10.1.20.0/22"]
    #   is_public = false
  }
}


variable "env" {
  default = "staging"
}

variable "vpc_id" {

}

variable "subnet_name" {
  default = "default"
}