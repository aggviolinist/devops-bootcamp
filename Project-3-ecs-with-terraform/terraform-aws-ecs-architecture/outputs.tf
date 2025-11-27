output "private_subnet_names_and_tiers" {
  value = {
    for s in aws_subnet.private_subnet :
    s.tags.Name => s.tags.tier
  }
}