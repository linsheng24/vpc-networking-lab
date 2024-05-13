data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_wafv2_ip_set" "allow_ipset" {
  name               = "allow-ipset"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = ["${chomp(data.http.myip.response_body)}/32"]
}

resource "aws_wafv2_web_acl" "web_acl" {
  name  = "web-acl"
  scope = "REGIONAL"

  default_action {
    block {}
  }

  rule {
    name     = "ip-whitelist"
    priority = 2

    action {
      allow {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.allow_ipset.arn
      }
    }

    visibility_config {
      metric_name                = "ip-whitelist"
      cloudwatch_metrics_enabled = false
      sampled_requests_enabled   = false
    }
  }

  rule {
    name     = "rate-limit"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 100
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      metric_name                = "rate-limit"
      cloudwatch_metrics_enabled = false
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    metric_name                = "web-acl-2-1"
    cloudwatch_metrics_enabled = false
    sampled_requests_enabled   = false
  }
}

resource "aws_wafv2_web_acl_association" "web_acl_assoc" {
  resource_arn = aws_lb.alb.arn
  web_acl_arn  = aws_wafv2_web_acl.web_acl.arn
}
