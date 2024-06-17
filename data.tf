data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

data "aws_region" "current" {}

data "aws_partition" "current" {}

output "caller_region" {
  value = data.aws_region.current.name
}
#To assume Role 
data "aws_iam_policy_document" "example" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}
#To attach policy to the role
data "aws_iam_policy_document" "example1" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [
    "arn:aws:s3:::${aws_s3_bucket.example2.id}",
    ]
  }
  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject",]
    resources = [
    "arn:aws:s3:::${aws_s3_bucket.example2.id}/*",
    ]
    
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control",]
  }
}
}
#Policy for Eventbridge 
data "aws_iam_policy_document" "test" {
  statement {
    sid    = "DevAccountAccess"
    effect = "Allow"   
    actions = ["events:PutEvents",]
    resources = [
    "arn:aws:events:::${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:event-bus/default",
    ]    
  }
}