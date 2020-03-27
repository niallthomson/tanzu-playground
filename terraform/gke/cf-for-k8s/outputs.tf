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