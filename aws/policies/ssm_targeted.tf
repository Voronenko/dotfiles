data "aws_iam_policy" "AmazonEC2ContainerRegistryPowerUser" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

data "aws_iam_policy" "AmazonEC2ContainerRegistryFullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

data "aws_iam_policy" "AmazonEC2FullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

data "aws_iam_policy" "AmazonEC2ReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

data "aws_iam_policy" "AmazonS3FullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

data "aws_iam_policy" "IAMUserChangePassword" {
  arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

data "aws_iam_policy_document" "IAMUserAllowKeyRotation" {
  statement {
    actions = [
      "iam:ListUsers",
      "iam:GetAccountPasswordPolicy"
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    actions = [
      "iam:*AccessKey*",
      "iam:DeleteAccessKey",
      "iam:ChangePassword",
      "iam:GetUser",
      "iam:*ServiceSpecificCredential*",
      "iam:*SigningCertificate*",
      "iam:CreateAccessKey",
      "iam:ListAccessKeys"
    ]
    resources = ["arn:aws:iam::*:user/users/$${aws:username}"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "IAMUserAllowKeyRotation" {
  # ... other configuration ...
  name        = "IAMUserAllowKeyRotation"
  policy      = data.aws_iam_policy_document.IAMUserAllowKeyRotation.json
  description = "Allow users to change their own IAM keys"
}

// Allow SSM access to EC2 instances with `Component: SSM` tag only
data "aws_iam_policy_document" "IAMUserAllowSSMAccess" {
  statement {
    effect = "Allow"
    actions = [
      "ssm:StartSession",
    ]
    resources = [
      "arn:aws:ec2:*:*:instance/*",
    ]
    condition {
      test = "StringLike"
      values = [
        "SSN",
      ]
      variable = "ssm:resourceTag/Component"
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "ssm:TerminateSession",
    ]
    resources = [
      "arn:aws:ssm:*:*:session/$${aws:username}-*",
    ]
  }
}

resource "aws_iam_policy" "IAMUserAllowSSMAccess" {
  name        = "IAMUserAllowSSMAccess"
  policy      = data.aws_iam_policy_document.IAMUserAllowSSMAccess.json
  description = "Allow SSM access to EC2 instances with `Component: SSM` tag only"
}
