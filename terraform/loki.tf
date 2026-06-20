data "aws_iam_policy_document" "loki_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "Federated"

      identifiers = [
        aws_iam_openid_connect_provider.eks.arn
      ]
    }

    condition {
      test = "StringEquals"

      variable = "${replace(
        aws_iam_openid_connect_provider.eks.url,
        "https://",
        ""
      )}:sub"

      values = [
        "system:serviceaccount:logging:loki"
      ]
    }
  }
}

resource "aws_iam_role" "loki_irsa" {
  name = "loki-irsa-role"

  assume_role_policy = data.aws_iam_policy_document.loki_assume_role.json
}

resource "aws_iam_role_policy_attachment" "loki_s3" {
  role       = aws_iam_role.loki_irsa.name
  policy_arn = "arn:aws:iam::948749907640:policy/LokiS3Policy"
}