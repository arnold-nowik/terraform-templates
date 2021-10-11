

resource "aws_ecs_task_definition" "example-stg-ecs-task-definition" {
  family                = "example-stg"
  container_definitions = <<CONTAINER_DEFINITION
[
    {
        "name": "${var.ecs_repository_name}",
        "image": "${var.ecs_repository_uri}",
        "essential": true,
        "memory": 128,
        "portMappings": [
            {
                "containerPort": 80,
                "hostPort": 8080
            }
        ],
        "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-group": "${aws_cloudwatch_log_group.example-stg-cloudwatch-log-group.name}",
            "awslogs-region": "${local.region}",
            "awslogs-stream-prefix": "ecs"
          }
         }
    }
]
CONTAINER_DEFINITION
}

