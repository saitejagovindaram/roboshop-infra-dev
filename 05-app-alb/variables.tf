variable "project_name" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "common_tags" {
  default = {
    Terraform   = "true"
    Environment = "dev"
    Project = "roboshop"
  }
}

variable "zone_name" {
  default = "saitejag.site"
}