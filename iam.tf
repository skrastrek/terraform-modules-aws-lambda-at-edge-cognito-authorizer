resource "aws_iam_role" "this" {
  name               = var.name
  assume_role_policy = module.assume_role_policy_document.json

  tags = var.tags
}

module "assume_role_policy_document" {
  source = "github.com/skrastrek/terraform-modules-aws-iam//policy-document/service-assume-role?ref=v0.2.0"

  service_identifiers = ["lambda.amazonaws.com", "edgelambda.amazonaws.com"]
}

resource "aws_iam_role_policy_attachment" "aws_lambda_basic_execution_role" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

module "config_secrets_manager_secret_read" {
  source = "github.com/skrastrek/terraform-modules-aws-iam//role-policy/secrets-manager-secret-read?ref=v0.2.0"

  role_name   = aws_iam_role.this.name
  policy_name = "config-secret-read"
  secret_arn  = aws_secretsmanager_secret.config.arn
}
