output "read_replica_endpoint" {
  value = aws_db_instance.postgres_read_replica.endpoint
}
output "primary_endpoint" {
  value = aws_db_instance.postgres_instance.endpoint
}