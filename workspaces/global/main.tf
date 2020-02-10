provider "aws" {
    
    regions = "us-east-2"

}

terraform {
	backend "s3" {
		bucket = "469169qa780679234-terraform-test"
		key = "workspaces/terraform.tfstate"
		region = "us-east-2"
	
#		dynamodb_table = "terraform-test-locks"
#		encrypt = true
	}
}