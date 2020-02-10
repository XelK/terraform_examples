variable "db_password" {
    description = "The password for the database"
    type = string
}

variable "db_name" {
    description = "The name to use for the database"
    type = string
    default = "terraform_db_example_test"
  
}
