output "base_domain" {
  value = trim(google_dns_managed_zone.zone.dns_name, ".")
}

output "zone_name" {
  value = google_dns_managed_zone.zone.name
}

output "blocker" {
  value = null_resource.out_blocker.id
}