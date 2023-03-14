variable "subnet_id_1" {
  type = string
  default = "subnet-00eaa3ab643abea76"
}

variable "subnet_id_2" {
  type = string
  default = "subnet-081d97174d250cffd"
}

variable "AMI" {
  type = string
  default = "BOTTLEROCKET_x86_64"
}

variable "desired_size" {
  type = string
  default = 1
}
variable "min_size" {
  type = string
  default = 1
}