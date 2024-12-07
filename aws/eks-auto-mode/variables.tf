variable "subnet_id_1" {
  type = string
  default = "subnet-00eaa3ab643abea76"
}

variable "subnet_id_2" {
  type = string
  default = "subnet-081d97174d250cffd"
}

variable "desired_size" {
  type = string
  default = 2
}
variable "min_size" {
  type = string
  default = 2
}

variable "k8sVersion" {
  default = "1.31"
  type = string
}