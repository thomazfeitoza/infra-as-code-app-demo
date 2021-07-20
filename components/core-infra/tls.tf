resource "tls_private_key" "lb_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "lb_csr" {
  key_algorithm   = tls_private_key.lb_key.algorithm
  private_key_pem = tls_private_key.lb_key.private_key_pem

  subject {
    common_name  = var.app_domain
    organization = "IaC Demo App"
  }
}

resource "cloudflare_origin_ca_certificate" "lb_cert" {
  csr          = tls_cert_request.lb_csr.cert_request_pem
  hostnames    = [var.app_domain, "*.${var.app_domain}"]
  request_type = "origin-rsa"
}

resource "google_compute_ssl_certificate" "app_certificate" {
  name        = "cloudflare-origin-certificate"
  private_key = tls_private_key.lb_key.private_key_pem
  certificate = cloudflare_origin_ca_certificate.lb_cert.certificate
}
