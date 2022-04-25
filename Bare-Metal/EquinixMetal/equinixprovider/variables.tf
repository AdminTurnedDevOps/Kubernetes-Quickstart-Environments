variable "server_size" {
  type = string
  default = "n2.xlarge.x86"
}

variable "datacenter" {
  type = string
  default = "ny5"
}

variable "OS" {
  type = string
  default = "ubuntu_21_04"
}

variable "hostname" {
  type = string
  default = "k8stesting"
}

variable "project_id" {
  type = string
  default = ""
}

variable "token" {
  type = string
  sensitive = true
  default = ""
}

variable "public_ssh_key" {
  type = string
  default = ""
}