data "aws_ami" "amazon_linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

locals {
  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y python3 git
    cd /home/ec2-user

    # simple Flask app
    cat > server.py <<'PY'
    from flask import Flask
    app = Flask(__name__)
    @app.route('/')
    def home():
        return "Hello from private EC2!"
    @app.route('/health')
    def health():
        return "ok"
    if __name__ == "__main__":
        app.run(host="0.0.0.0", port=8080)
    PY

    pip3 install flask
    python3 server.py > /var/log/server.log 2>&1 &
  EOF
  )
}

resource "aws_launch_template" "lt" {
  name_prefix   = "${var.project_name}-lt-"
  image_id      = data.aws_ami.amazon_linux2.id
  instance_type = var.instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  user_data = local.user_data

  network_interfaces {
    security_groups = [aws_security_group.ec2_sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project_name}-instance"
    }
  }
}

resource "aws_autoscaling_group" "asg" {
  name                = "${var.project_name}-asg"
  desired_capacity    = var.asg_desired
  min_size            = var.asg_min
  max_size            = var.asg_max
  vpc_zone_identifier = [for s in aws_subnet.private : s.id]

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.tg.arn]
  health_check_type = "ELB"
  health_check_grace_period = 60

  tag {
    key                 = "Name"
    value               = "${var.project_name}-instance"
    propagate_at_launch = true
  }
}
