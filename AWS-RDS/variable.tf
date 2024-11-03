# Variables for RDS Configuration
variable "db_name" {
  default = "Primary"
}
variable "db_rp" {
  default = "replica"
}
variable "db_user" {
  default = "appuser"
}
variable "db_password" {
  description = "The database password"
  default     = "QV4ORET6XFFXVRN1ZI" # Replace with a secure password
  sensitive   = true
}
variable "db_instance_class" {
  default = "db.t3.micro" # Cost-effective instance for development/testing
}
variable "read_replica_instance_class" {
  default = "db.t3.micro" # Instance type for read replica
}
variable "allocated_storage" {
  default = 20 # Storage size in GB
}
variable "max_allocated_storage" {
  default = 50 # Storage size in GB
}
variable "read_storage" {
  default = 20 # Storage size in GB
}
variable "max_read_storage" {
  default = 50 # Storage size in GB
}
