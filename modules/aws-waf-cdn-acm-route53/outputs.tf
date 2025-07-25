# Certificats ACM créés
output "certificate_arns" {
  description = "ARNs des certificats ACM créés"
  value = {
    for k, v in aws_acm_certificate.cert : k => v.arn
  }
}

# Distributions CloudFront créées
output "cloudfront_distributions" {
  description = "Domaines des distributions CloudFront créées"
  value = {
    for k, v in aws_cloudfront_distribution.distribution : k => {
      domain_name = v.domain_name
      hosted_zone_id = v.hosted_zone_id
      arn = v.arn
    }
  }
}

# Web ACLs créées
output "web_acls" {
  description = "ARNs des Web ACLs créées"
  value = {
    for k, v in aws_wafv2_web_acl.web_acl : k => v.arn
  }
}

# Enregistrements DNS créés
output "dns_records" {
  description = "Noms des enregistrements DNS créés"
  value = merge(
    {
      for k, v in aws_route53_record.cdn_alias : k => v.name
    },
    {
      for k, v in aws_route53_record.alb_alias : k => v.name
    },
    {
      for k, v in aws_route53_record.caa : k => v.name
    }
  )
}

output "acm_certificate_arn" {
  description = "ACM Certificate ARN for HTTPS listener"
  value       = aws_acm_certificate.cert.arn
}
