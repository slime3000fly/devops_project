variable "tenancy_ocid" {sensitive   = true}
variable "user_ocid" {sensitive   = true}
variable "fingerprint" {sensitive   = true}
variable "private_key_path" {sensitive   = true}
variable "private_key_password" {sensitive   = true}
variable "compartment_id" {
  type        = string
  sensitive   = true
}

variable "InstanceShape" {
    default = "VM.Standard.E2.1.Micro"
}

variable "ssh_public_key_path" {
    default = "C:\\Users\\Piotr\\.ssh\\id_rsa.pub "
}

variable "AD" {
    default = "1"
}

variable "region" {
  default = "eu-frankfurt-1"
}

variable "instance_ocpus" { default = 1 }

variable "instance_shape_config_memory_in_gbs" { default = 1 }
