# Création des distributions CloudFront pour les domaines qui en ont besoin
resource "aws_cloudfront_distribution" "distribution" {
  for_each = {
    for k, v in var.domain_configs : k => v
    if v.create_cdn == true
  }

  origin {
    domain_name = each.value.cdn_config.origin_domain_name
    origin_path = try(each.value.cdn_config.origin_path, "")
    origin_id   = "${var.deployment_name}-${each.key}-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CDN for ${each.key}"
  default_root_object = "index.html"
  price_class         = lookup(each.value.cdn_config, "price_class", "PriceClass_All")
  
  # Utilisation du WAF si activé
  web_acl_id = each.value.create_waf ? aws_wafv2_web_acl.web_acl[each.key].arn : null
  
  # Configuration des alias
  aliases = each.value.cdn_config.aliases

  default_cache_behavior {
    allowed_methods  = lookup(each.value.cdn_config, "allowed_methods", ["GET", "HEAD", "OPTIONS"])
    cached_methods   = lookup(each.value.cdn_config, "cached_methods", ["GET", "HEAD"])
    target_origin_id = "${var.deployment_name}-${each.key}-origin"
    compress         = true

    forwarded_values {
      query_string = true
      headers      = ["Origin", "Access-Control-Request-Method", "Access-Control-Request-Headers"]
      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = lookup(each.value.cdn_config, "viewer_protocol_policy", "redirect-to-https")
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Configuration des restrictions géographiques
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Configuration du certificat SSL
  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.cert[each.key].certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  # Dépendances
  depends_on = [
    aws_acm_certificate_validation.cert
  ]

  tags = merge(var.default_tags, each.value.tags, {
    Name = "${var.deployment_name}-${each.key}-distribution"
  })
}
