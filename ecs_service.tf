resource "aws_ecs_service" "hello_world" {
  name            = "hello-world-service"
  cluster         = "arn:aws:ecs:us-east-1:214712740451:cluster/ecs"
  task_definition = "arn:aws:ecs:us-east-1:214712740451:cluster/ecs"
  desired_count   = "var.app_count"
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = "sg-0551d0f7731151aa3"
    subnets         = "subnet-0794f192b8185a46a"
  }

  load_balancer {
    target_group_arn = "aws_lb_target_group.hello_world.arn:aws:elasticloadbalancing:us-east-1:214712740451:targetgroup/ecs/e6b42b0588ce541f"
    container_name   = "hello-world-app"
    container_port   = 3000
  }

  depends_on = "hello_world"
}
