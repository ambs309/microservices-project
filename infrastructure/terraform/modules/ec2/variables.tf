variable "name_prefix" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "instance_profile_name" {
  type = string
}

variable "allowed_ssh_cidr" {
  type = string
}

variable "key_name" {
  type    = string
  default = null
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "root_volume_size" {
  type    = number
  default = 20
}
