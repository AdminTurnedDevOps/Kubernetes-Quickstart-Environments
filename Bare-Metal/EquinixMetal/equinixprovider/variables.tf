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
  default = "df61c8c8-1bda-4851-b04c-1fc312836bf6"
}

variable "token" {
  type = string
  sensitive = true
  default = ""
}

variable "public_ssh_key" {
  type = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDKxeP+rBVQRFD0BA1eVpM7ACqNWaGlvYk5iqk6/Q/qpGDCrPcA6oUC0wQlTMdRedGMnQL2FcLxBHTcN19xpo+qkfIT/YzOm1c8ziIu7/59634sx2XEyypKb+LJodaBdPxKqWbh0PO/xI/UJd/FncZhkep5cP5UTNem5Y6b0xPguigLEdM7HphrwAYezNaVjOJnxUKgYrd8hhs1DXXZ5pyVIlTUoGxqY+l6GTugEK9mB5+xfNJOB1fDZGbZp2L73vIlBYTfe162xxbuexoxlkqnBGo+Xg6aFxdkjiiTK78p4kCaC/PkqwG93+aDIEpLrJ/I8FIus+kKBDfouOqrMFciiaggbFDBfoudUuan+5F5JWNBiKtMDEt3AtC0gXG975fg9BlANmkYI4CotrahfHHGYhO9Gt52Pd4HP2BmN4E4gw0GhR618jHS/b4QbvmKx6pNlWW0WswcQXIA6w5zRA8kXgEIAdQIlIq34ePtktZ4NeieZ11W+E47BF/v39/uHeU= michael@michaels-MBP.fios-router.home"
}