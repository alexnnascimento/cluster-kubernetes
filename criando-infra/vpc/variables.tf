variable "region" {
  default = "us-east-1"
}
variable "vpc_name" {
  default = "vpc-lab"
}
variable "main_vpc_cidr" {
  default = "172.16.0.0/16"
}
variable "public_subnets_a" {
  default = "172.16.10.0/24"
}
variable "public_subnets_b" {
  default = "172.16.11.0/24"
}
variable "private_subnets_a" {
  default = "172.16.20.0/24"
}
variable "private_subnets_b" {
  default = "172.16.21.0/24"
}
#variable "sg_cluster_lab" {
#  default = "sg-015f0522c63279e5d" # Orientações para copia da VPC ID abaixo.
#}
variable "project_name" {
  default = "lab-cluster-k8s"
}