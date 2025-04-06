# STEP 1
# create security group for ALB and for instances in ASG
# allow traffic in on ports 80
resource "aws_security_group" "alb_security_group" {
  name   = "Allow HTTP connections from everywhere"
  vpc_id = aws_vpc.sample_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "webserver_security_group" {
  name   = "Allow HTTP connections from ALB"
  vpc_id = aws_vpc.sample_vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# STEP 2
# setup ASG (launch template and autoscaling group)
resource "aws_launch_template" "sample_asg_launch_template" {
  name_prefix            = "web-server"
  image_id               = var.ami_id # Ubuntu jammmy
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.webserver_security_group.id]
  key_name               = "XXXXXXXXXX"

  user_data = base64encode(<<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y nginx
    sudo systemctl enable nginx
    sudo systemctl start nginx
    echo "<html><head><title>Sample Web Server</title></head><body><h1>Hello from $(hostname)</h1></body></html>" > index.html
    sudo cp index.html /var/www/html/index.html
  EOF
  )
}

resource "aws_autoscaling_group" "sample_asg" {
  name                      = "webserver-asg"
  desired_capacity          = 2
  max_size                  = 6
  min_size                  = 2
  vpc_zone_identifier       = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  health_check_type         = "EC2"
  health_check_grace_period = 300
  termination_policies      = ["OldestInstance"]

  launch_template {
    id      = aws_launch_template.sample_asg_launch_template.id
    version = "$Latest"
  }
}

# STEP 3
# create ALB and link to ASG
resource "aws_lb" "sample_alb" {
  name               = "sample-alb"
  security_groups    = [aws_security_group.alb_security_group.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  internal           = false
  load_balancer_type = "application"

  tags = {
    Name = "sample-alb"
  }
}

resource "aws_lb_target_group" "sample_alb_target_group" {
  name     = "web-server-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.sample_vpc.id

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/"
  }

  tags = {
    name = "web-server-target-group"
  }
}

resource "aws_lb_listener" "sample_alb_listener" {
  load_balancer_arn = aws_lb.sample_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.sample_alb_target_group.arn
    type             = "forward"
  }
}

resource "aws_autoscaling_attachment" "sample_aws_autoscaling_attachment" {
  lb_target_group_arn    = aws_lb_target_group.sample_alb_target_group.arn
  autoscaling_group_name = aws_autoscaling_group.sample_asg.id
}
