resource "aws_ecs_task_definition" "nginxapp" {
  family                   = "nginxapptask"
#   requires_compatibilities = ["FARGATE"]
#   network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048

  container_definitions = <<DEFINITION
[
  {
    "image": "nginx:latest",
    "name": "nginx",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
DEFINITION
}

# resource "aws_iam_role" "ecs-iam-role" {
#   name = "ecs-iam-role"

#   path = "/"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "ecs.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# EOF
# }

resource "aws_ecs_service" "ecsservice" {
  name            = "nginxservice"
  cluster         = "levanecscluster"
#   iam_role        = aws_iam_role.ecs-iam-role.arn
  task_definition = aws_ecs_task_definition.nginxapp.arn
  desired_count   = 2

  depends_on = [
    aws_ecs_task_definition.nginxapp
  ]
}
