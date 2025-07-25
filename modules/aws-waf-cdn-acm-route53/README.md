# Module AWS WAF, CDN, ACM et Route53

Ce module Terraform permet de gérer de manière centralisée la configuration de WAF, CloudFront (CDN), ACM (certificats SSL) et Route53 pour vos applications hébergées sur AWS.

## Fonctionnalités

- Création et gestion de certificats ACM
- Configuration de distributions CloudFront (CDN)
- Mise en place de règles WAF avancées
- Gestion des enregistrements DNS dans Route53
- Support de plusieurs domaines et sous-domaines
- Configuration flexible pour les applications avec et sans CDN

## Utilisation

### Configuration minimale

```hcl
module "cdn_infrastructure" {
  source = "./modules/aws-waf-cdn-acm-route53"
  
  deployment_name = "my-app"
  region         = "us-east-1"
  
  domain_configs = {
    frontend = {
      domain_name      = "app.example.com"
      hosted_zone_name = "example.com."
      create_cdn       = true
      create_waf       = true
      
      cdn_config = {
        origin_domain_name = "my-alb-1234567890.region.elb.amazonaws.com"
        aliases           = ["app.example.com"]
      }
      
      waf_config = {
        enable_anonymous_ip_protection = true
      }
    }
  }
}
```

### Configuration complète

Voir l'exemple dans `examples/waf-cdn-acm-route53/main.tf` pour une configuration complète avec plusieurs domaines et options avancées.

## Variables d'entrée

### `deployment_name` (obligatoire)
Nom du déploiement, utilisé comme préfixe pour les noms de ressources.

### `region` (obligatoire)
Région AWS où déployer les ressources.

### `domain_configs` (obligatoire)
Map des configurations de domaine. Chaque entrée peut avoir les attributs suivants :

#### Configuration de base
- `domain_name` (obligatoire) : Le nom de domaine complet (ex: "app.example.com")
- `hosted_zone_name` (obligatoire) : Le nom de la zone hébergée dans Route53 (avec un point à la fin, ex: "example.com.")
- `create_cdn` (bool, optionnel, par défaut false) : Si vrai, crée une distribution CloudFront
- `create_waf` (bool, optionnel, par défaut false) : Si vrai, crée une Web ACL WAF
- `tags` (map, optionnel) : Tags à appliquer aux ressources

#### Configuration CDN (`create_cdn = true`)
- `origin_domain_name` (obligatoire) : Le domaine d'origine (ex: ALB, S3, etc.)
- `origin_path` (optionnel) : Le chemin de base pour les requêtes vers l'origine
- `price_class` (optionnel, par défaut "PriceClass_All") : Classe de prix CloudFront
- `aliases` (obligatoire) : Liste des noms de domaine alternatifs (CNAMEs)
- `allowed_methods` (optionnel, par défaut ["GET", "HEAD", "OPTIONS"]) : Méthodes HTTP autorisées
- `cached_methods` (optionnel, par défaut ["GET", "HEAD"]) : Méthodes HTTP mises en cache
- `viewer_protocol_policy` (optionnel, par défaut "redirect-to-https") : Politique de protocole

#### Configuration WAF (`create_waf = true`)
- `enable_anonymous_ip_protection` (bool, optionnel) : Active la protection contre les IPs anonymes (TOR, VPN)
- `enable_ip_reputation_protection` (bool, optionnel) : Active la protection contre les IPs à mauvaise réputation
- `enable_bad_bot_protection` (bool, optionnel) : Active la protection contre les mauvais bots

## Sorties

- `certificate_arns` : ARNs des certificats ACM créés
- `cloudfront_distributions` : Détails des distributions CloudFront créées
- `web_acls` : ARNs des Web ACLs créées
- `dns_records` : Noms des enregistrements DNS créés

## Exemples

Voir le répertoire `examples/` pour des exemples d'utilisation complets.

## Notes importantes

1. Les certificats ACM pour CloudFront doivent être créés dans la région us-east-1.
2. Les modifications de distribution CloudFront peuvent prendre jusqu'à 30 minutes à se propager.
3. Assurez-vous que votre zone hébergée Route53 est correctement configurée avant d'utiliser ce module.
