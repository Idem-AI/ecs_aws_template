// ================= ECS AWS Template =================
{
  "archetype": "ecs_aws_template",
  "archetype_type": "aws",
  "description": "AWS ECS deployment template supporting services, optional database, CDN, WAF, and DNS integration via Route53.",
  "variables": {
    "deployment_name": {
      "type": "string",
      "description": "Name prefix applied to all deployed AWS resources.",
      "example": "myapp-prod"
    },
    "region": {
      "type": "string",
      "description": "AWS region where infrastructure will be deployed.",
      "example": "us-east-1"
    },
    "aws_access_key": {
      "type": "string",
      "description": "AWS access key for authentication.",
      "example": "AKIAIOSFODNN7EXAMPLE"
    },
    "aws_secret_key": {
      "type": "string",
      "description": "AWS secret key associated with the access key (sensitive).",
      "example": "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
    },
    "hosted_zone_id": {
      "type": "string",
      "description": "Route53 hosted zone ID for DNS record management.",
      "example": "Z3P5QSUBK4POTI"
    },
    "root_domain": {
      "type": "string",
      "description": "Root domain name for deployed services.",
      "example": "example.com"
    },
    "vpc_cidr": {
      "type": "string",
      "description": "CIDR block of the AWS VPC.",
      "example": "10.0.0.0/16"
    },
    "public_subnet_cidrs": {
      "type": "list(string)",
      "description": "List of CIDR blocks for public subnets.",
      "example": ["10.0.1.0/24", "10.0.2.0/24"]
    },
    "private_subnet_cidrs": {
      "type": "list(string)",
      "description": "List of CIDR blocks for private subnets.",
      "example": ["10.0.4.0/24", "10.0.5.0/24"]
    },
    "availability_zones": {
      "type": "list(string)",
      "description": "Availability zones used for resources.",
      "example": ["us-east-1a", "us-east-1b", "us-east-1c"]
    },
    "log_retention_days": {
      "type": "number",
      "description": "Number of days to retain CloudWatch logs.",
      "example": 30
    },
    "cdn_config": {
      "type": "object",
      "description": "Default configuration for CloudFront CDN.",
      "example": {
        "price_class": "PriceClass_100",
        "default_ttl": 3600,
        "min_ttl": 0,
        "max_ttl": 86400,
        "allowed_methods": ["GET", "HEAD", "OPTIONS"],
        "cached_methods": ["GET", "HEAD"]
      }
    },
    "waf_rules": {
      "type": "list(object)",
      "description": "List of WAF rules to apply to services.",
      "example": [
        {
          "name": "block-bad-bots",
          "priority": 1,
          "action": "BLOCK",
          "statement": { "type": "IPSetReferenceStatement", "parameters": { "ip_set_id": "123456" } },
          "visibility_config": {
            "cloudwatch_metrics_enabled": true,
            "metric_name": "blockedRequests",
            "sampled_requests_enabled": true
          }
        }
      ]
    },
    "services": {
      "type": "map(object)",
      "description": "Configuration of ECS services to deploy.",
      "example": {
        "frontend": {
          "name": "frontend",
          "image": "nginx:latest",
          "port": 80,
          "cpu": 256,
          "memory": 512,
          "desired_count": 2,
          "health_path": "/health",
          "environment": [{ "name": "API_URL", "value": "https://api.example.com" }],
          "secrets": [{ "name": "DB_PASSWORD", "value": "supersecret" }],
          "assign_public_ip": true,
          "enable_https": true,
          "enable_cdn": true,
          "enable_waf": false,
          "domain_name": "frontend.example.com",
          "certificate_arn": "arn:aws:acm:us-east-1:123456789012:certificate/abcd",
          "tags": { "Service": "frontend" }
        }
      }
    },
    "tags": {
      "type": "map(string)",
      "description": "Tags applied to all AWS resources.",
      "example": {
        "Project": "MyApp",
        "Environment": "production",
        "Terraform": "true"
      }
    },
    "database_engine": {
      "type": "string",
      "description": "Database engine to use (rds-mysql, rds-postgres, aurora-mysql, aurora-postgres, dynamodb, none).",
      "example": "rds-postgres"
    },
    "db_username": {
      "type": "string",
      "description": "Database username.",
      "example": "dbadmin"
    },
    "db_password": {
      "type": "string",
      "description": "Database password (sensitive).",
      "example": "P@ssword123!"
    },
    "db_name": {
      "type": "string",
      "description": "Primary database name.",
      "example": "appdb"
    },
    "instance_class": {
      "type": "string",
      "description": "RDS or Aurora instance class.",
      "example": "db.t3.micro"
    },
    "multi_az": {
      "type": "bool",
      "description": "Enable multi-AZ deployment for high availability.",
      "example": true
    },
    "enable_read_replica": {
      "type": "bool",
      "description": "Enable a read replica for RDS.",
      "example": false
    },
    "allocated_storage": {
      "type": "number",
      "description": "Allocated storage size (GB).",
      "example": 20
    },
    "additional_security_groups": {
      "type": "list(string)",
      "description": "Additional security groups attached to the database.",
      "example": ["sg-12345678", "sg-abcdef12"]
    }
  }
}

// ================= GCP Cloud Run Template =================
{
  "archetype": "gcp_cloudrun_template",
  "archetype_type": "gcp",
  "description": "GCP Cloud Run deployment template supporting dynamic services, SQL/Spanner databases, optional Redis, CDN, WAF, and observability.",
  "variables": {
    "project_id": {
      "type": "string",
      "description": "GCP project ID",
      "example": "my-gcp-project"
    },
    "region": {
      "type": "string",
      "description": "Default region for Cloud Run and associated resources",
      "example": "europe-west1"
    },
    "dns_zone": {
      "type": "string",
      "description": "Name of the managed DNS zone in Cloud DNS",
      "example": "example-zone"
    },
    "dns_ttl": {
      "type": "number",
      "description": "TTL of DNS records in seconds",
      "example": 300
    },
    "deployment_name": {
      "type": "string",
      "description": "Unique prefix to name resources",
      "example": "myapp-prod"
    },
    "environment": {
      "type": "string",
      "description": "Target environment (dev, staging, prod)",
      "example": "prod"
    },
    "common_labels": {
      "type": "map(string)",
      "description": "Common labels applied to all resources",
      "example": { "team": "devops", "app": "myapp" }
    },
    "run_roles": {
      "type": "map(string)",
      "description": "IAM roles associated with the Cloud Run Service Account",
      "example": {
        "roles/run.admin": "",
        "roles/logging.logWriter": ""
      }
    },
    "db_engine": {
      "type": "string",
      "description": "Database engine type: 'sql' or 'spanner'",
      "example": "sql"
    },
    "services": {
      "type": "map(object)",
      "description": "Configuration of deployed Cloud Run services",
      "example": {
        "api": {
          "name": "api",
          "image": "gcr.io/my-project/api:latest",
          "port": 8080,
          "needs_database": true,
          "ingress": "INGRESS_TRAFFIC_ALL",
          "vpc_connector": "my-vpc-connector",
          "vpc_egress": "ALL_TRAFFIC",
          "cloudsql_instances": ["my-project:region:instance"],
          "environment": [{ "name": "ENV", "value": "prod" }],
          "resources": { "cpu": "1", "memory": "512Mi" },
          "scaling": { "min": 1, "max": 5 },
          "expose_lb": true,
          "enable_cdn": false,
          "domain_name": "api.example.com",
          "enable_waf": true,
          "waf_rules": [
            { "priority": 1, "action": "BLOCK", "source_ranges": ["0.0.0.0/0"] }
          ]
        }
      }
    },
    "engine": {
      "type": "string",
      "description": "Global database engine type: 'sql' or 'spanner'",
      "example": "sql"
    },
    "name": {
      "type": "string",
      "description": "Database instance name",
      "example": "mydb-instance"
    },
    "db_name": {
      "type": "string",
      "description": "Primary database name",
      "example": "appdb"
    },
    "db_version": {
      "type": "string",
      "description": "SQL engine version (MySQL/PostgreSQL)",
      "example": "MYSQL_8_0"
    },
    "db_tier": {
      "type": "string",
      "description": "Machine type for Cloud SQL",
      "example": "db-f1-micro"
    },
    "disk_size_gb": {
      "type": "number",
      "description": "SQL disk size in GB",
      "example": 20
    },
    "disk_type": {
      "type": "string",
      "description": "Disk type (PD_SSD or PD_HDD)",
      "example": "PD_SSD"
    },
    "enable_ha": {
      "type": "bool",
      "description": "Enable high availability mode for SQL",
      "example": true
    },
    "enable_replication": {
      "type": "bool",
      "description": "Enable replication for SQL",
      "example": false
    },
    "enable_binlog": {
      "type": "bool",
      "description": "Enable binary logging (required for replication)",
      "example": true
    },
    "backup_start_time": {
      "type": "string",
      "description": "SQL backup start time",
      "example": "03:00"
    },
    "db_user": {
      "type": "string",
      "description": "Default SQL username",
      "example": "admin"
    },
    "db_password": {
      "type": "string",
      "description": "SQL database password",
      "example": "S3cur3P@ss!"
    },
    "enable_deletion_protection": {
      "type": "bool",
      "description": "Prevent accidental deletion of the SQL database",
      "example": true
    },
    "spanner_nodes": {
      "type": "number",
      "description": "Number of nodes for Spanner",
      "example": 1
    },
    "spanner_processing_units": {
      "type": "number",
      "description": "Spanner processing units (alternative to nodes)",
      "example": 100
    },
    "spanner_multi_region": {
      "type": "bool",
      "description": "Enable multi-region deployment for Spanner",
      "example": false
    },
    "spanner_ddl": {
      "type": "list(string)",
      "description": "List of DDL statements for Spanner schema",
      "example": ["CREATE TABLE users (id INT64 NOT NULL, name STRING(MAX)) PRIMARY KEY(id)"]
    },
    "enable_observability": {
      "type": "bool",
      "description": "Enable Cloud Trace, Logging and Error Reporting",
      "example": true
    },
    "enable_redis": {
      "type": "bool",
      "description": "Enable a Redis instance (MemoryStore)",
      "example": true
    },
    "redis_memory_size_gb": {
      "type": "number",
      "description": "Redis memory size in GB",
      "example": 2
    },
    "labels": {
      "type": "map(string)",
      "description": "Labels applied to Redis resources",
      "example": { "tier": "cache" }
    },
    "redis_tier": {
      "type": "string",
      "description": "Redis instance type (BASIC or STANDARD_HA)",
      "example": "STANDARD_HA"
    },
    "redis_version": {
      "type": "string",
      "description": "Redis version",
      "example": "REDIS_7_X"
    },
    "redis_primary_zone": {
      "type": "string",
      "description": "Primary zone for Redis",
      "example": "us-central1-b"
    },
    "redis_secondary_zone": {
      "type": "string",
      "description": "Secondary zone for Redis",
      "example": "us-central1-c"
    }
  }
}

// ================= GCP 3-Tiers Compute Template =================
{
  "archetype": "gcp_3tiers_compute",
  "archetype_type": "gcp",
  "description": "GCP 3-tier Compute deployment template with support for managed instances, database, DNS, CDN, health checks, and optional security features.",
  "variables": {
    "project_id": {
      "type": "string",
      "description": "GCP project ID",
      "example": "my-gcp-project"
    },
    "region": {
      "type": "string",
      "description": "GCP region where resources will be deployed",
      "example": "europe-west1"
    },
    "zones": {
      "type": "list(string)",
      "description": "List of zones used for resources",
      "example": ["europe-west1-b", "europe-west1-c"]
    },
    "single_zone": {
      "type": "bool",
      "description": "Deploy in a single zone instead of multiple zones",
      "example": false
    },
    "deployment_name": {
      "type": "string",
      "description": "Prefix used to name all deployed resources",
      "example": "myapp-prod"
    },
    "network_name": {
      "type": "string",
      "description": "Name of the VPC network",
      "example": "my-vpc"
    },
    "subnets": {
      "type": "list(object({ zone=string, cidr=string }))",
      "description": "List of subnets with zone and CIDR",
      "example": [
        { "zone": "europe-west1-b", "cidr": "10.0.1.0/24" },
        { "zone": "europe-west1-c", "cidr": "10.0.2.0/24" }
      ]
    },
    "instance_template": {
      "type": "object",
      "description": "Configuration for instance templates",
      "example": {
        "machine_type": "e2-medium",
        "image_family": "debian-11",
        "image_project": "debian-cloud",
        "tags": ["web", "frontend"],
        "metadata": { "startup-script": "#!/bin/bash\necho Hello World" }
      }
    },
    "target_size": {
      "type": "number",
      "description": "Number of instances to launch per managed instance group",
      "example": 2
    },
    "domains": {
      "type": "list(string)",
      "description": "List of domain names to configure",
      "example": ["example.com", "app.example.com"]
    },
    "enable_cdn": {
      "type": "bool",
      "description": "Enable CDN for the deployed services",
      "example": true
    },
    "health_check_port": {
      "type": "number",
      "description": "Port used for health checks",
      "example": 80
    },
    "health_check_path": {
      "type": "string",
      "description": "Path used for health checks",
      "example": "/"
    },
    "credentials_file": {
      "type": "string",
      "description": "Path to the GCP credentials JSON file",
      "example": "/home/user/gcp-creds.json"
    },
    "db_tier": {
      "type": "string",
      "description": "Machine type for the database",
      "example": "db-f1-micro"
    },
    "db_version": {
      "type": "string",
      "description": "Database engine version",
      "example": "MYSQL_8_0"
    },
    "high_availability": {
      "type": "bool",
      "description": "Enable high availability for the database",
      "example": true
    },
    "backup_start_time": {
      "type": "string",
      "description": "Start time for database backups",
      "example": "03:00"
    },
    "database_name": {
      "type": "string",
      "description": "Name of the main database",
      "example": "appdb"
    },
    "user_name": {
      "type": "string",
      "description": "Database username",
      "example": "dbadmin"
    },
    "user_password": {
      "type": "string",
      "description": "Database password (sensitive)",
      "example": "P@ssword123!"
    },
    "dns_zone_name": {
      "type": "string",
      "description": "DNS managed zone name",
      "example": "example-zone"
    },
    "domain": {
      "type": "string",
      "description": "Root domain for DNS records",
      "example": "example.com"
    },
    "record_name": {
      "type": "string",
      "description": "DNS record name",
      "example": "www"
    },
    "ttl": {
      "type": "number",
      "description": "TTL of DNS records in seconds",
      "example": 300
    },
    "cdn_protocol": {
      "type": "string",
      "description": "Protocol used by CDN (HTTP/HTTPS)",
      "example": "HTTP"
    },
    "cdn_timeout_sec": {
      "type": "number",
      "description": "Timeout in seconds for CDN connections",
      "example": 30
    },
    "cache_mode": {
      "type": "string",
      "description": "CDN cache mode",
      "example": "CACHE_ALL_STATIC"
    },
    "default_ttl": {
      "type": "number",
      "description": "Default TTL for cached objects in seconds",
      "example": 3600
    },
    "enable_apis": {
      "type": "bool",
      "description": "Enable the creation of required GCP services (APIs)",
      "example": true
    },
    "enable_armor": {
      "type": "bool",
      "description": "Enable Google Cloud Armor protection",
      "example": false
    },
    "custom_rules": {
      "type": "map(object({ priority=number, action=string, description=string, versioned_expr=string, src_ip_ranges=list(string), custom_expr=string }))",
      "description": "Custom security rules to apply",
      "example": {
        "rule1": {
          "priority": 1000,
          "action": "allow",
          "description": "Allow internal traffic",
          "versioned_expr": "SRC_IPS_V1",
          "src_ip_ranges": ["10.0.0.0/8"],
          "custom_expr": ""
        }
      }
    }
  }
}

// ================= AWS Web EC2 + Aurora Template =================
{
  "archetype": "aws-web-ec2-aurora",
  "archetype_type": "aws",
  "description": "AWS template for deploying EC2 instances with Aurora or RDS database, supporting Multi-AZ, read replicas, and security group configuration.",
  "variables": {
    "db_engine_type": {
      "type": "string",
      "description": "Type of database: aurora or RDS",
      "example": "aurora"
    },
    "engine": {
      "type": "string",
      "description": "Database engine type: mysql or postgres",
      "example": "mysql"
    },
    "engine_version": {
      "type": "string",
      "description": "Version of the database engine",
      "example": "8.0"
    },
    "name": {
      "type": "string",
      "description": "Base name for all resources",
      "example": "myapp"
    },
    "username": {
      "type": "string",
      "description": "Master username for the database",
      "example": "dbadmin"
    },
    "password": {
      "type": "string",
      "description": "Master password for the database (sensitive)",
      "example": "P@ssword123!"
    },
    "db_name": {
      "type": "string",
      "description": "Name of the main database",
      "example": "appdb"
    },
    "allocated_storage": {
      "type": "number",
      "description": "Allocated storage for RDS instances (ignored for Aurora)",
      "example": 20
    },
    "instance_class": {
      "type": "string",
      "description": "Instance class for the database",
      "example": "db.t3.medium"
    },
    "aurora_instance_count": {
      "type": "number",
      "description": "Number of Aurora instances to deploy",
      "example": 2
    },
    "multi_az": {
      "type": "bool",
      "description": "Enable Multi-AZ deployment (RDS only)",
      "example": true
    },
    "enable_read_replica": {
      "type": "bool",
      "description": "Enable read replica for RDS",
      "example": false
    },
    "publicly_accessible": {
      "type": "bool",
      "description": "Whether the database should be publicly accessible",
      "example": false
    },
    "backup_retention": {
      "type": "number",
      "description": "Number of days to retain database backups",
      "example": 7
    },
    "private_subnet_ids": {
      "type": "list(string)",
      "description": "List of private subnet IDs for database deployment",
      "example": ["subnet-0123456789abcdef0", "subnet-0abcdef1234567890"]
    },
    "vpc_security_group_ids": {
      "type": "list(string)",
      "description": "List of VPC security group IDs associated with the database",
      "example": ["sg-0123456789abcdef0"]
    },
    "tags": {
      "type": "map(string)",
      "description": "Additional tags to apply to database resources",
      "example": { "Environment": "production", "Project": "MyApp" }
    }
  }
}


// ================= AWS Serverless Template =================
{
  "archetype": "aws_serverless_template",
  "archetype_type": "aws",
  "description": "AWS Serverless deployment template including Lambda functions, API Gateway, DynamoDB, Amplify, IAM roles, and observability.",
  "variables": {
    "aws_region": {
      "type": "string",
      "description": "AWS region for deployment",
      "example": "eu-west-1"
    },
    "name": {
      "type": "string",
      "description": "Logical name for the deployment",
      "example": "idem-serverless-app"
    },
    "environment": {
      "type": "string",
      "description": "Deployment environment (dev, staging, prod)",
      "example": "dev"
    },
    "tags": {
      "type": "map(string)",
      "description": "Tags applied to all resources",
      "example": { "Project": "MyApp", "Environment": "dev" }
    },
    "enable_api": {
      "type": "bool",
      "description": "Enable API Gateway",
      "example": true
    },
    "enable_dynamodb": {
      "type": "bool",
      "description": "Enable DynamoDB table",
      "example": true
    },
    "enable_amplify": {
      "type": "bool",
      "description": "Enable Amplify application",
      "example": false
    },
    "lambda_role_arn": {
      "type": "string",
      "description": "Existing IAM role ARN for Lambda (leave empty to create one)",
      "example": ""
    },
    "amplify_role_arn": {
      "type": "string",
      "description": "Existing IAM role ARN for Amplify (leave empty to create one)",
      "example": ""
    },
    "create_iam_for_dev": {
      "type": "bool",
      "description": "Automatically create IAM roles for dev convenience (not recommended for prod)",
      "example": false
    },
    "functions": {
      "type": "list(object)",
      "description": "List of Lambda function definitions with memory, runtime, timeout, environment, Git repository, and VPC configuration",
      "example": [
        {
          "name": "getStudent",
          "handler": "handler.get",
          "runtime": "python3.9",
          "memory": 128,
          "timeout": 30,
          "publish": true,
          "git_repo": "https://github.com/example/repo.git",
          "git_branch": "main",
          "env": { "ENV": "dev" },
          "role_arn": "",
          "vpc_config": {
            "subnet_ids": ["subnet-12345"],
            "security_group_ids": ["sg-12345"]
          }
        }
      ]
    },
    "api_routes": {
      "type": "list(object)",
      "description": "List of API Gateway routes with HTTP methods mapped to Lambda functions and optional CORS/authorization",
      "example": [
        {
          "path": "students",
          "methods": [
            { "http_method": "GET", "lambda_name": "getStudent", "authorization": "NONE", "enable_cors": true },
            { "http_method": "POST", "lambda_name": "addStudent", "authorization": "NONE", "enable_cors": true }
          ]
        }
      ]
    },
    "dynamodb_table_name": {
      "type": "string",
      "description": "DynamoDB table name",
      "example": "students"
    },
    "dynamodb_billing_mode": {
      "type": "string",
      "description": "DynamoDB billing mode: PROVISIONED or PAY_PER_REQUEST",
      "example": "PAY_PER_REQUEST"
    },
    "dynamodb_read_capacity": {
      "type": "number",
      "description": "Read capacity units (used only if PROVISIONED)",
      "example": 5
    },
    "dynamodb_write_capacity": {
      "type": "number",
      "description": "Write capacity units (used only if PROVISIONED)",
      "example": 5
    },
    "dynamodb_hash_key": {
      "type": "string",
      "description": "Primary hash key for DynamoDB table",
      "example": "id"
    },
    "amplify": {
      "type": "object",
      "description": "Amplify application configuration",
      "example": {
        "app_name": "myapp",
        "repository": "https://github.com/example/amplify.git",
        "branch": "main",
        "domain_name": "myapp.example.com"
      }
    },
    "enable_observability": {
      "type": "bool",
      "description": "Enable logging and monitoring (e.g., CloudWatch)",
      "example": true
    },
    "tf_state_bucket": {
      "type": "string",
      "description": "S3 bucket for Terraform remote state",
      "example": "myapp-tf-state"
    },
    "tf_state_dynamodb_table": {
      "type": "string",
      "description": "DynamoDB table for Terraform state locking",
      "example": "myapp-tf-lock"
    }
  }
}
