variable "bucket_name" {
  description = "bucket for the remote state of terraform"
  type        = string
  default     = "469169qa780679234-terraform-test"
}

variable "table_name" {
  description = "table for the lock state of terraform"
  type        = string
  default     = "terraform-test-locks"
}
