output "open_vpn_ip" {
  value = aws_instance._.public_ip
}

output "open_vpn_public_dns" {
  value = aws_instance._.public_dns
}

# output "vpc_id" {
#   value = module.vpc.vpc_id
# }

output "vpc_cidr" {
  value = var.vpc_cidr
}

# output "vpc_main_route_table_id" {
#   value = module.vpc.vpc_main_route_table_id
# }

# output "public_route_table_id" {
#   value = module.vpc.public_route_table_ids[0]

# }

# output "public_subnets_cidr_blocks" {
#   value = module.vpc.public_subnets_cidr_blocks
# }
