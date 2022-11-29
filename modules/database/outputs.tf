output "db_subnet_group_id" {
    value = aws_db_subnet_group.db_subnet.id
}

output "db_instance_id" {
    value = aws_db_instance.RDS_instance.id
}
