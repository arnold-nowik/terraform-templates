resource "aws_ecr_repository" "example-stg-ecr" {
  name                 = "example-stg-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
