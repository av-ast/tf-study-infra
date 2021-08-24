resource "aws_iam_user" "ecs_exec" {
  name = "ecs-exec"
}

resource "aws_iam_access_key" "ecs_exec" {
  user = aws_iam_user.ecs_exec.name
}

resource "aws_iam_user_policy" "ecs_exec" {
  name = "ecs_exec"
  user = aws_iam_user.ecs_exec.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AccessECSEXEC"
        Effect = "Allow"
        Action = [
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcEndpoints",
          "ecs:ListClusters",
          "ecs:DescribeClusters",
          "ecs:DescribeTaskDefinition",
          "ecs:ExecuteCommand",
          "ecs:ListTasks",
          "ecs:DescribeTasks",
          "iam:SimulatePrincipalPolicy",
          "ssm:StartSession",
        ]
        Resource = "*"
      },
    ]
  })
}

resource "aws_route53_zone" "zone" {
  name = var.domain
}

resource "aws_acm_certificate" "wildcard" {
  domain_name = var.domain
  subject_alternative_names = ["*.${var.domain}"]
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.wildcard.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  type            = each.value.type
  records         = [each.value.record]
  ttl             = 60
  zone_id = aws_route53_zone.zone.id
}

resource "aws_acm_certificate_validation" "validation" {
  certificate_arn         = aws_acm_certificate.wildcard.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}
