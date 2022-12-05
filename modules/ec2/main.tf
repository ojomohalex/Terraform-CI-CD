data "aws_ami" "linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  owners = ["amazon"]
}

resource "aws_launch_template" "ec2module_bastion" {
  name_prefix            = "ec2_web"
  image_id               = data.aws_ami.linux.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [var.webserver_security_group_id]
  user_data              = filebase("script.sh")

  tags = {
    Name = "ec2_bastion"
  }
}

resource "aws_autoscaling_group" "ec2_bastion" {
  name                = "as_bastion"
  vpc_zone_identifier = [var.public_subnet_az1_id, var.public_subnet_az2_id]
  min_size            = 2
  max_size            = 2
  desired_capacity    = 2

  launch_template {
    id      = aws_launch_template.ec2module_bastion.id
    # version = "$Latest"
  }
}

resource "aws_launch_template" "ec2module_app" {
  name_prefix            = "ec2_app"
  image_id               = data.aws_ami.linux.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [var.appserver_security_group_id]
  

  tags = {
    Name = "ec2_app_tier"
  }
}

resource "aws_autoscaling_group" "as_app" {
  name                = "ec2As_app"
  vpc_zone_identifier = [var.private_app_subnet_az1_id, var.private_app_subnet_az2_id]
  min_size            = 2
  max_size            = 3
  desired_capacity    = 2

  launch_template {
    id      = aws_launch_template.ec2module_app.id
    # version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.as_app.id
  alb_target_group_arn = var.alb_tg
}
