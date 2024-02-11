resource "aws_ssm_parameter" "aws_acm_arm" {
  name  = "/${var.project_name}/${var.environment}/aws_acm_arm"
  type  = "String"
  value = aws_acm_certificate.saitejag_site.arn
}