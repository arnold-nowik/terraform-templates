# --- Instance role configuration for ECS EC2 instance ---

resource "aws_iam_instance_profile" "example-stg-ecs-instance-profile" {
  name = "example-stg-ecs-instance-profile"
  role = aws_iam_role.example-stg-iam-ecs-role.name
}

resource "aws_iam_role" "example-stg-iam-ecs-role" {
  name = "example-stg-ecs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

}

resource "aws_iam_policy" "example-stg-iam-access-s3" {
  name = "example-stg-iam-access-s3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:*"]
        Effect   = "Allow"
        Resource = [aws_s3_bucket.example-stg-s3-bucket.arn, join("", [aws_s3_bucket.example-stg-s3-bucket.arn, "/*"])]
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "example-stg-iam-attach-managed-ecs-policy" {
  role       = aws_iam_role.example-stg-iam-ecs-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "example-stg-iam-attach-s3-policy-for-ecs" {
  role       = aws_iam_role.example-stg-iam-ecs-role.name
  policy_arn = aws_iam_policy.example-stg-iam-access-s3.arn
}

resource "aws_iam_service_linked_role" "example-stg-iam-ecs-linked-role" {
  aws_service_name = "ecs.amazonaws.com"
}
