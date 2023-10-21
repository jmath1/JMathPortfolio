output "s3_bucket_name" {
    value = aws_s3_bucket.static_files.bucket
}

output "db_security_group_id" {
    value = module.security_group.security_group_id
}

output "db_host_address" {
    value = module.db.db_instance_address
}