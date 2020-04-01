output "cf_api_endpoint" {
  description = "Cloud Foundry API endpoint"
  value       = module.cf-for-k8s.cf_api_endpoint
}

output "cf_admin_username" {
  description = "Cloud Foundry admin username"
  value       = module.cf-for-k8s.cf_admin_username
}

output "cf_admin_password" {
  description = "Cloud Foundry admin password"
  value       = module.cf-for-k8s.cf_admin_password
}

output "harbor_endpoint" {
  description = "Harbor registry endpoint"
  value       = "https://${module.harbor.harbor_domain}"
}

output "harbor_admin_username" {
  description = "Harbor registry admin username"
  value       = module.harbor.harbor_admin_username
}

output "harbor_admin_password" {
  description = "Harbor registry admin password"
  value       = module.harbor.harbor_admin_password
}