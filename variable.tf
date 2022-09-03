

variable "cidr-for-vpc" {
    description = "the cidr for vpc"
    default = "10.0.0.0/16"
    type = string
}




variable "region-name" {
    description = "making a region a variable"
    default = "eu-west-2"
    type = string
}


variable "cidr-for-public-1" {
    description = "public cidr 1"
    default = "10.0.1.0/24"
    type = string
}



variable "cidr-for-public-2" {
    description = "public cidr 2"
    default = "10.0.2.0/24"
    type = string
}



variable "cidr-for-private-1" {
    description = "private cidr 1"
    default = "10.0.110.0/24"
    type = string
}


variable "cidr-for-private-2" {
    description = "private cidr 2"
    default = "10.0.150.0/24"
    type = string
}



variable "AZ-1" {
    description = "availability zone"
    default = "eu-west-2a"
    type = string
}