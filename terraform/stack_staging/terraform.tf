terraform {
  required_version = ">= 0.9"

  backend "s3" {
    role_arn = "arn:aws:iam::299497370133:role/workflow-developer"

    bucket = "wellcomecollection-workflow-infra"
    key    = "terraform/archivematica-infra/stack_staging.tfstate"
    region = "eu-west-1"
  }
}

data "terraform_remote_state" "workflow" {
  backend = "s3"

  config = {
    role_arn = "arn:aws:iam::299497370133:role/workflow-read_only"

    bucket = "wellcomecollection-workflow-infra"
    key    = "terraform/workflow.tfstate"
    region = "eu-west-1"
  }
}

data "terraform_remote_state" "critical" {
  backend = "s3"

  config = {
    role_arn = "arn:aws:iam::975596993436:role/workflow-read_only"

    bucket = "wellcomecollection-storage-infra"
    key    = "terraform/archivematica-infra/critical_staging.tfstate"
    region = "eu-west-1"
  }
}
