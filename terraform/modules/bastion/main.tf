module "cloudformation_stack" {
  source = "../ec2_asg"

  asg_name = "${var.name}"

  asg_max     = "${var.asg_max}"
  asg_desired = "${var.asg_desired}"
  asg_min     = "${var.asg_min}"

  subnet_list        = "${var.subnet_list}"
  launch_config_name = "${aws_launch_configuration.launch_config.name}"
}


resource "aws_launch_configuration" "launch_config" {
  security_groups = module.security_groups.instance_security_groups

  key_name                    = "${var.key_name}"
  image_id                    = "${var.image_id}"
  instance_type               = "${var.instance_type}"
  iam_instance_profile        = "${module.instance_profile.name}"
  user_data                   = "${var.user_data}"
  associate_public_ip_address = "${var.associate_public_ip_address}"

  lifecycle {
    create_before_destroy = true
  }
}

module "security_groups" {
  source = "../ec2_security_groups"

  name   = "${var.name}"
  vpc_id = "${var.vpc_id}"

  custom_security_groups            = var.custom_security_groups
  controlled_access_cidr_ingress    = var.controlled_access_cidr_ingress
  controlled_access_security_groups = []
}

module "instance_profile" {
  source = "../ec2_instance_profile"

  name = "${var.name}"
}
