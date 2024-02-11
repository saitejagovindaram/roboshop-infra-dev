variable "project_name" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "common_tags" {
    default = {
        Terraform = true
        Environment = "Dev" 
        Project = "Roboshop"
    }
}