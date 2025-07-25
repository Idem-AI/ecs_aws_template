resource "aws_acm_certificate" "cert" {
  for_each = {
    for k, v in var.domain_configs : k => v
    if v.create_cdn == true
  }

  domain_name       = each.value.domain_name
  validation_method = "DNS"
  provider          = aws.acm

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.default_tags, each.value.tags, {
    Name = "${var.deployment_name}-${each.key}-cert"
  })
}

# Validation des certificats via DNS
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in local.domain_validation_options : "${dvo.domain_key}-${dvo.resource_record_name}" => dvo
  }

  allow_overwrite = true
  name            = each.value.resource_record_name
  records         = [each.value.resource_record_value]
  ttl             = 60
  type            = each.value.resource_record_type
  zone_id         = data.aws_route53_zone.zone[each.value.domain_key].zone_id
}

resource "aws_acm_certificate_validation" "cert" {
  for_each = {
    for k, v in aws_acm_certificate.cert : k => v
  }

  certificate_arn         = each.value.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn if can(regex("^${each.key}-", record.name))]
  provider                = aws.acm
}

# Locals pour gérer les options de validation de domaine
locals {
  domain_validation_options = flatten([
    for domain_key, domain in var.domain_configs : [
      for dvo in domain.create_cdn ? aws_acm_certificate.cert[domain_key].domain_validation_options : [] : merge(dvo, {
        domain_key = domain_key
      })
    ]
  ])
}

# Provider ACM (doit être dans us-east-1 pour CloudFront)
provider "aws" {
  alias  = "acm"
  region = var.acm_region
}

# Data source pour les zones hébergées existantes
data "aws_route53_zone" "zone" {
  for_each = {
    for k, v in var.domain_configs : k => v
    if v.create_cdn == true
  }
  
  name         = each.value.hosted_zone_name
  private_zone = false
}