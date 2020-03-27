output "cf_api_endpoint" {
  value = "api.${local.sys_domain}"
}

output "cf_admin_username" {
  value = "admin"
}

output "cf_admin_password" {
  value = random_password.admin_password.result
}