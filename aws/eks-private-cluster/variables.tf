variable "private_subnet_id_1" {
  type = string
  default = "subnet-0fe1b0e51b1b06de8"
}

variable "private_subnet_id_2" {
  type = string
  default = "subnet-05af3ab0479a38e85"
}

variable "desired_size" {
  type = string
  default = 1
}
variable "min_size" {
  type = string
  default = 1
}