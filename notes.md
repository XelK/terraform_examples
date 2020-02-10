# variables:
* available types:
	* string, number, bool, list, map, set, object, tuple, and any
* can contain:
	* description 
	* default
	* type
## declaring:
```
variable "NAME" {
  [CONFIG ...]
}
```
## using vars:
```
${var.server_port}
```
## types: 
### numbers
```
variable "number_example" {
  description = "An example of a number variable in Terraform"
  type        = number
  default     = 42
}
```
### lists
```
variable "list_numeric_example" {
  description = "An example of a numeric list in Terraform"
  type        = list(number)
  default     = [1, 2, 3]
}
```
### maps
```
variable "map_example" {
  description = "An example of a map in Terraform"
  type        = map(string)

  default = {
    key1 = "value1"
    key2 = "value2"
    key3 = "value3"
  }
}
```
### structural types
```
variable "object_example" {
  description = "An example of a structural type in Terraform"
  type        = object({
    name    = string
    age     = number
    tags    = list(string)
    enabled = bool
  })

  default = {
    name    = "value1"
    age     = 42
    tags    = ["a", "b", "c"]
    enabled = true
  }
}
```
## data:
* __a data source represents a pieace of read-only information that is fetched from the provider. Not create anything new, it's just query the provider's APIs for data and to make the data available to the rest of your Terraform code.__
* declaring: 
```
data "<PROVIDER>_<TYPE>" "<NAME>" {
	[CONFIG ...]
}
```
* using: 
```
	data.<PROVIDER>_<TYPE>.<NAME>.<ATTRIBUTE> 
	data.aws_vpc.default.id
```

## terraform_remote_state
__Terraform remote state data source permit to read information from another remote state. The date in this state will be accessible in read-only manner__



-----------
### create graph
terraform graph | dot -Tsvg > graph.svg   ## permit to create graph

--------
## AWS 
* Application Load Balancer (ALB)
	* Best suited for load balancing of HTTP and HTTPS traffic. Operates at the application layer (Layer 7) of the OSI model.
* Network Load Balancer (NLB)
	* Best suited for load balancing of TCP, UDP, and TLS traffic. Can scale up and down in response to load faster than the ALB (the NLB is designed to scale to tens of millions of requests per second). Operates at the transport layer (Layer 4) of the OSI model.
* Classic Load Balancer (CLB)
	* This is the “legacy” load balancer that predates both the ALB and NLB. It can handle HTTP, HTTPS, TCP, and TLS traffic, but with far fewer features than either the ALB or NLB. Operates at both the application layer (L7) and transport layer (L4) of the OSI model
