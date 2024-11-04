variable "name" {
  type = string
}
variable "region" {
  type = string
}
variable "environment" {
  type = string
}
variable "availablity_zones" {
  type = list(string)
}
variable "vpc_cidr" {
  type = string
}
variable "public_subnets" {
  type = list(string)
}
variable "private_subnets" {
  type = list(string)
}
variable "enable_nat_gw" {
  type = bool
}
variable "enable_single_nat_gw" {
  type = bool
}
variable "enable_vpn_gw" {
  type = bool
}
variable "addon_tags" {
  type = map(string)
}
variable "k8s_version" {
  type = string
}
variable "node_group_specs" {
  type = any
}
variable "iam_admin_group" {
  type = string
}