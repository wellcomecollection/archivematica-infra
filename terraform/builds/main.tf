resource "aws_iam_user" "travis_ci" {
  name = "travis-archivematica-infra"
}

resource "aws_iam_access_key" "travis_ci" {
  user = aws_iam_user.travis_ci.name
}

data "aws_iam_policy_document" "travis_permissions" {
  statement {
    actions = [
      "s3:Get*",
    ]

    resources = [
      "arn:aws:s3:::wellcomecollection-workflow-infra/archivematica/debs/*",
    ]
  }

  statement {
    actions = [
      "ecr:*",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "ssm:PutParameter",
    ]

    resources = [
      "arn:aws:ssm:eu-west-1:${local.account_id}:parameter/*",
    ]
  }
}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

data "aws_caller_identity" "current" {}


resource "aws_iam_user_policy" "travis_ci" {
  user   = aws_iam_user.travis_ci.name
  policy = data.aws_iam_policy_document.travis_permissions.json
}

data "template_file" "aws_credentials" {
  template = <<EOF
[default]
aws_access_key_id=$${access_key_id}
aws_secret_access_key=$${secret_access_key}
EOF

  vars = {
    access_key_id     = aws_iam_access_key.travis_ci.id
    secret_access_key = aws_iam_access_key.travis_ci.secret
  }
}

data "archive_file" "secrets" {
  type        = "zip"
  output_path = "../../secrets.zip"

  source {
    content  = data.template_file.aws_credentials.rendered
    filename = "credentials"
  }

  source {
    content  = "[default]\nregion = eu-west-1"
    filename = "config"
  }
}