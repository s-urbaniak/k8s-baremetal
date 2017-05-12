terraform {
  required_version = ">= 0.9.4"
}

variable "matchbox_dns_name" {
  description = "The DNS name of matchbox"
  type        = "string"
  default     = "matchbox.k8s"
}

variable "matchbox_ip" {
  description = "The IP address of matchbox"
  type        = "string"
  default     = "10.1.1.2"
}

# ca

resource "tls_private_key" "ca" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_self_signed_cert" "ca" {
  key_algorithm   = "${tls_private_key.ca.algorithm}"
  private_key_pem = "${tls_private_key.ca.private_key_pem}"

  subject {
    common_name  = "matchbox"
    organization = "matchbox"
  }

  is_ca_certificate     = true
  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "cert_signing",
  ]
}

resource "local_file" "ca-key" {
  content  = "${tls_private_key.ca.private_key_pem}"
  filename = "${path.cwd}/certs/ca.key"
}

resource "local_file" "ca-crt" {
  content  = "${tls_self_signed_cert.ca.cert_pem}"
  filename = "${path.cwd}/certs/ca.crt"
}

# server

resource "tls_private_key" "matchbox_server" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_cert_request" "matchbox_server" {
  key_algorithm   = "${tls_private_key.matchbox_server.algorithm}"
  private_key_pem = "${tls_private_key.matchbox_server.private_key_pem}"

  subject {
    common_name  = "matchbox_server"
    organization = "matchbox_server"
  }

  dns_names = [
    "${var.matchbox_dns_name}",
  ]

  ip_addresses = [
    "${var.matchbox_ip}",
  ]
}

resource "tls_locally_signed_cert" "matchbox_server" {
  cert_request_pem = "${tls_cert_request.matchbox_server.cert_request_pem}"

  ca_key_algorithm   = "${tls_self_signed_cert.ca.key_algorithm}"
  ca_private_key_pem = "${tls_private_key.ca.private_key_pem}"
  ca_cert_pem        = "${tls_self_signed_cert.ca.cert_pem}"

  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth",
  ]
}

resource "local_file" "matchbox_server-key" {
  content  = "${tls_private_key.matchbox_server.private_key_pem}"
  filename = "${path.cwd}/certs/server.key"
}

resource "local_file" "matchbox_server-crt" {
  content  = "${tls_locally_signed_cert.matchbox_server.cert_pem}"
  filename = "${path.cwd}/certs/server.crt"
}

# client

resource "tls_private_key" "matchbox_client" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_cert_request" "matchbox_client" {
  key_algorithm   = "${tls_private_key.matchbox_client.algorithm}"
  private_key_pem = "${tls_private_key.matchbox_client.private_key_pem}"

  subject {
    common_name  = "matchbox_client"
    organization = "matchbox_client"
  }
}

resource "tls_locally_signed_cert" "matchbox_client" {
  cert_request_pem = "${tls_cert_request.matchbox_client.cert_request_pem}"

  ca_key_algorithm   = "${tls_self_signed_cert.ca.key_algorithm}"
  ca_private_key_pem = "${tls_private_key.ca.private_key_pem}"
  ca_cert_pem        = "${tls_self_signed_cert.ca.cert_pem}"

  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth",
  ]
}

resource "local_file" "matchbox_client-key" {
  content  = "${tls_private_key.matchbox_client.private_key_pem}"
  filename = "${path.cwd}/certs/client.key"
}

resource "local_file" "matchbox_client-crt" {
  content  = "${tls_locally_signed_cert.matchbox_client.cert_pem}"
  filename = "${path.cwd}/certs/client.crt"
}

# registry

resource "tls_private_key" "registry" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_cert_request" "registry" {
  key_algorithm   = "${tls_private_key.registry.algorithm}"
  private_key_pem = "${tls_private_key.registry.private_key_pem}"

  subject {
    common_name  = "registry"
    organization = "registry"
  }

  dns_names = [
    "hub.k8s",
    "gcr.k8s",
    "quay.k8s",
  ]

  ip_addresses = [
    "10.1.1.1",
  ]
}

resource "tls_locally_signed_cert" "registry" {
  cert_request_pem = "${tls_cert_request.registry.cert_request_pem}"

  ca_key_algorithm   = "${tls_self_signed_cert.ca.key_algorithm}"
  ca_private_key_pem = "${tls_private_key.ca.private_key_pem}"
  ca_cert_pem        = "${tls_self_signed_cert.ca.cert_pem}"

  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth",
  ]
}

resource "local_file" "registry-key" {
  content  = "${tls_private_key.registry.private_key_pem}"
  filename = "${path.cwd}/certs/registry.key"
}

resource "local_file" "registry-crt" {
  content  = "${tls_locally_signed_cert.registry.cert_pem}"
  filename = "${path.cwd}/certs/registry.crt"
}
