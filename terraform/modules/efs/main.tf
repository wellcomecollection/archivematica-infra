module "asg" {
  source = "git::https://github.com/wellcometrust/terraform.git//ec2/prebuilt/ondemand?ref=v11.3.1"

  name = "${var.asg_name}"

  image_id = "${var.image_id}"

  controlled_access_cidr_ingress = ["${var.controlled_access_cidr_ingress}"]

  custom_security_groups      = ["${var.custom_security_groups}"]
  ssh_ingress_security_groups = ["${var.ssh_ingress_security_groups}"]

  subnet_list = ["${var.subnets}"]
  vpc_id      = "${var.vpc_id}"
  key_name    = "${var.key_name}"
  user_data   = "${data.template_file.userdata.rendered}"

  asg_max     = "${var.asg_max}"
  asg_desired = "${var.asg_desired}"
  asg_min     = "${var.asg_min}"

  instance_type = "${var.instance_type}"
}

data "template_file" "userdata" {
  template = "${file("${path.module}/efs.tpl")}"

  vars {
    cluster_name  = "${var.cluster_name}"
    efs_fs_id     = "${var.efs_fs_id}"
    efs_host_path = "${var.efs_host_path}"
    region        = "${var.region}"
  }
}

module "instance_policy" {
  source = "git::https://github.com/wellcometrust/terraform.git//ecs/modules/ec2/modules/instance_role_policy?ref=v11.3.1"

  cluster_name               = "${var.cluster_name}"
  instance_profile_role_name = "${module.asg.instance_profile_role_name}"
}