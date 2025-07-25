
# Création des Web ACLs pour les domaines qui en ont besoin
resource "aws_wafv2_web_acl" "web_acl" {
  for_each = {
    for k, v in var.domain_configs : k => v
    if v.create_waf == true
  }
  
  name  = "${var.deployment_name}-${each.key}-web-acl"
  scope = "CLOUDFRONT"
  
  default_action {
    allow {}
  }

  # Règle pour bloquer les adresses IP anonymes (TOR, VPN, etc.)
  dynamic "rule" {
    for_each = each.value.waf_config.enable_anonymous_ip_protection ? [1] : []
    
    content {
      name     = "AWSManagedRulesAnonymousIpList"
      priority = 0

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesAnonymousIpList"
          vendor_name = "AWS"
          
          # Désactivation des règles problématiques
          rule_action_override {
            name = "SizeRestrictions_QUERYSTRING"
            action_to_use {
              count {}
            }
          }

          rule_action_override {
            name = "NoUserAgent_HEADER"
            action_to_use {
              count {}
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesAnonymousIpList"
        sampled_requests_enabled   = true
      }
    }
  }

  # Règle pour la protection contre la mauvaise réputation IP
  dynamic "rule" {
    for_each = each.value.waf_config.enable_ip_reputation_protection ? [1] : []
    
    content {
      name     = "AWSManagedRulesAmazonIpReputationList"
      priority = 1

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesAmazonIpReputationList"
          vendor_name = "AWS"
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesAmazonIpReputationList"
        sampled_requests_enabled   = true
      }
    }
  }

  # Règle pour la protection contre les mauvais bots
  dynamic "rule" {
    for_each = each.value.waf_config.enable_bad_bot_protection ? [1] : []
    
    content {
      name     = "AWSManagedRulesBotControlRuleSet"
      priority = 2

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesBotControlRuleSet"
          vendor_name = "AWS"
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWSManagedRulesBotControlRuleSet"
        sampled_requests_enabled   = true
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "BlockIPRuleMetrics"
    sampled_requests_enabled   = false
  }
}