output "address" {
    description = "Database endpoint"
    value = aws_db_instance.tf_example_db.address
}
output "port" {
    description = "Port of database"
    value = aws_db_instance.tf_example_db.port
}
