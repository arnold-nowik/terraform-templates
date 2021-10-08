# --- ASG configuration ---

data "aws_ami" "amazon_linux2_ecs" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-*"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

#SSH Key pair configuration
resource "aws_key_pair" "example-stg-pem" {
  key_name   = "examplestg"
  public_key = "YOUR_PUBLIC_KEY_HERE"
}

module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "4.6.0"

  # Autoscaling group
  name                      = "example-stg-asg"
  vpc_zone_identifier       = module.vpc.public_subnets
  min_size                  = 1
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"

  # Launch template
  lt_name                = "example-stg-launch-template"
  description            = "Example stg ECS launch template"
  update_default_version = true

  use_lt    = true
  create_lt = true

  image_id                 = data.aws_ami.amazon_linux2_ecs.id
  instance_type            = local.ec2_instance_type
  ebs_optimized            = true
  key_name                 = "examplestg"
  iam_instance_profile_arn = aws_iam_instance_profile.example-stg-ecs-instance-profile.arn
  user_data_base64         = filebase64("./user-data.sh")

  block_device_mappings = [
    {
      # Root volume
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 30
        volume_type           = "gp2"
      }
    }
  ]

  network_interfaces = [
    {
      delete_on_termination = true
      description           = "eth0"
      device_index          = 0
      security_groups       = [aws_security_group.example-stg-sg-allow-ssh.id]
    }
  ]
  tags = [
    {
      key                 = "Environment"
      value               = "stg"
      propagate_at_launch = true
    },
    {
      key                 = "Name"
      value               = "example-stg-asg"
      propagate_at_launch = true
    },
  ]
}

# --- ECS capacity provider configuration ---

resource "aws_ecs_capacity_provider" "example-stg-ecs-cp" {
  name = "example-stg-ecs-cp"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = module.asg.autoscaling_group_arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      status = "DISABLED"
    }
  }
}

# --- ECS Cluster configuration with CloudWatchLogs ---

resource "aws_cloudwatch_log_group" "example-stg-cloudwatch-log-group" {
  name = "example-stg-cloudwatch-log-group"
}

resource "aws_ecs_cluster" "example-stg-ecs-cluster" {
  name               = "example-stg-ecs-cluster"
  capacity_providers = [aws_ecs_capacity_provider.example-stg-ecs-cp.name]
  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"

      log_configuration {
        cloud_watch_log_group_name = aws_cloudwatch_log_group.example-stg-cloudwatch-log-group.name
      }
    }
  }
}

# --- ECS Service configuration ---

resource "aws_ecs_service" "example-stg-ecs-service" {
  name            = "example-stg"
  cluster         = aws_ecs_cluster.example-stg-ecs-cluster.id
  task_definition = aws_ecs_task_definition.example-stg-ecs-task-definition.arn
  desired_count   = 1
}
