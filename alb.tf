resource "aws_lb" "default" {
  name            = "ecs-lb"
  subnets         = "subnet-06d9db5a1de59d5c7"
  security_groups = "sg-0551d0f7731151aa3"
}

resource "aws_lb_target_group" "hello_world" {
  name        = "example-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "vpc-0382f51c959645e99"
  target_type = "ip"
}

resource "aws_lb_listener" "hello_world" {
  load_balancer_arn = "arn:aws:elasticloadbalancing:us-east-1:214712740451:loadbalancer/net/ecs/fb14ab50529d4118"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn ="arn:aws:elasticloadbalancing:us-east-1:214712740451:targetgroup/ecs/e6b42b0588ce541f"
    type             = "forward"
  }
}
