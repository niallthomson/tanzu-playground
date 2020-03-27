data "google_dns_managed_zone" "root_zone" {
  name = var.base_zone_name
}

resource "google_dns_managed_zone" "zone" {
  name        = var.environment_name
  dns_name    = "${var.dns_prefix}.${data.google_dns_managed_zone.root_zone.dns_name}"
  description = "DNS zone"
}

resource "google_dns_record_set" "ns_record" {
  managed_zone = data.google_dns_managed_zone.root_zone.name
  name = "${var.dns_prefix}.${data.google_dns_managed_zone.root_zone.dns_name}"
  rrdatas = google_dns_managed_zone.zone.name_servers
  
  ttl = 30
  type = "NS"

  provisioner "local-exec" {
    command = "sleep 30"
  }
}

resource "null_resource" "blocker" {
  depends_on = [google_dns_record_set.ns_record]
}