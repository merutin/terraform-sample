variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "sample"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
}