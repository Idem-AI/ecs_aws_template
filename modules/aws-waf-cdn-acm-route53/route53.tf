# Data source pour les zones hébergées existantes
data "aws_route53_zone" "zone" {
  for_each = var.domain_configs
  
  name         = each.value.hosted_zone_name
  private_zone = false
}

# Enregistrements de validation pour les certificats ACM
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in local.domain_validation_options : "${dvo.domain_key}-${dvo.domain_name}" => dvo
  }

  allow_overwrite = true
  name            = each.value.resource_record_name
  records         = [each.value.resource_record_value]
  type            = each.value.resource_record_type
  zone_id         = data.aws_route53_zone.zone[each.value.domain_key].zone_id
  ttl             = 60
}

# Création des enregistrements DNS pour chaque domaine
# Pour les domaines avec CDN
resource "aws_route53_record" "cdn_alias" {
  for_each = {
    for k, v in var.domain_configs : k => v
    if v.create_cdn == true
  }

  zone_id = data.aws_route53_zone.zone[each.key].zone_id
  name    = each.value.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.distribution[each.key].domain_name
    zone_id                = aws_cloudfront_distribution.distribution[each.key].hosted_zone_id
    evaluate_target_health = false
  }

  allow_overwrite = true
}

# Pour les domaines sans CDN (redirection directe vers l'ALB)
resource "aws_route53_record" "alb_alias" {
  for_each = {
    for k, v in var.domain_configs : k => v
    if v.create_cdn == false && can(v.alb_config)
  }

  zone_id = data.aws_route53_zone.zone[each.key].zone_id
  name    = each.value.domain_name
  type    = "A"

  alias {
    name                   = each.value.alb_config.dns_name
    zone_id                = each.value.alb_config.zone_id
    evaluate_target_health = true
  }

  allow_overwrite = true
}

# Enregistrements CAA pour la sécurité des certificats
resource "aws_route53_record" "caa" {
  for_each = {
    for k, v in var.domain_configs : k => v
    if v.create_cdn == true
  }

  zone_id = data.aws_route53_zone.zone[each.key].zone_id
  name    = each.value.domain_name
  type    = "CAA"
  ttl     = 3600

  records = [
    "0 issue \"amazon.com\"",
    "0 issue \"amazontrust.com\"",
    "0 issue \"awstrust.com\"",
    "0 issue \"amazonaws.com\"",
    "0 issuewild \";\""
  ]

  allow_overwrite = true
}