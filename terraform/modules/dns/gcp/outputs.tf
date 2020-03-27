output "base_domain" {
  value = trim(google_dns_managed_zone.pbs_zone.dns_name, ".")
}

output "zone_name" {
  value = google_dns_managed_zone.pbs_zone.name
}