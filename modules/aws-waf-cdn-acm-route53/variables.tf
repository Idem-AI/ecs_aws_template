variable "deployment_name" {
  type        = string
  description = "Nom du déploiement (préfixe pour les noms de ressources)"
}

variable "domain_configs" {
  description = "Configuration des domaines et de leurs ressources associées"
  type = map(object({
    domain_name          = string
    hosted_zone_name     = string
    create_cdn          = bool
    cdn_config = optional(object({
      origin_domain_name = string
      origin_path       = string
      price_class       = string
      aliases           = list(string)
      web_acl_arn      = string
      cache_policy_id  = string
      origin_request_policy_id = string
      allowed_methods   = list(string)
      cached_methods    = list(string)
      viewer_protocol_policy = string
    }))
    create_waf = bool
    waf_config = optional(object({
      enable_anonymous_ip_protection = bool
      enable_ip_reputation_protection = bool
      enable_bad_bot_protection     = bool
    }))
    alb_config = optional(object({
      dns_name = string
      zone_id  = string
    }))
    tags = map(string)
  }))
}

variable "default_tags" {
  description = "Tags par défaut à appliquer à toutes les ressources"
  type        = map(string)
  default     = {}
}

variable "region" {
  description = "La région AWS où déployer les ressources"
  type        = string
}

variable "acm_region" {
  description = "La région où créer les certificats ACM (doit être us-east-1 pour CloudFront)"
  type        = string
  default     = "us-east-1"
}

# variable "alb" {}
# variable "root-domain" {}
