variable "name" {
  description = "name of your infra"
  type = string
}

variable "region" {
  description = "region of aws"
  type = string
}

variable "enable_dns_hostname" {
  description = "VPC enable DNS hostname"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "VPC enable DNS support"
  type        = bool
  default     = true
}

variable "availability_zones_count" {
  description = "The number of AZs."
  type        = number
  default     = 2
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_bits" {
  description = "The number of subnet bits for the CIDR. For example, specifying a value 8 for this parameter will create a CIDR with a mask of /24."
  type        = number
  default     = 8
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    "Project"     = "TerraformEKS"
    "Environment" = "Development"
  }
}

variable "ng1_instance_type" {
  description = "worker node type"
  type        = string
  default     = "t2.medium"
}
variable "k8s_version" {
  description = "K8s version"
  type = string
  default = "1.26"
}
variable "ng1_desired_size" {
  description = "node group desire size"
  type = number
  default = 2
}

variable "ng1_min_size" {
  description = "node group min size"
  type = number
  default = 1
}

variable "ng1_max_size" {
  description = "node group max size"
  type = number
  default= 5
}
variable "ng2_instance_type" {
  description = "worker node type"
  type        = string
  default     = "t2.medium"
}
variable "ng2_desired_size" {
  description = "node group desire size"
  type = number
  default = 2
}

variable "ng2_min_size" {
  description = "node group min size"
  type = number
  default = 1
}

variable "ng2_max_size" {
  description = "node group max size"
  type = number
  default= 5
}

variable "disk_size" {
  description = "worker node disk size"
  type = number
  default = 20
}
