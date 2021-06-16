resource "aws_autoscaling_group" "asg" {
    name                        = var.NAME

    min_size                    = var.ASG_MIN
    max_size                    = var.ASG_MAX
    desired_capacity            = var.ASG_DESIRED

    health_check_grace_period   = var.HEALTH_PERIOD
    health_check_type           = var.HEALTH_TYPE
    force_delete                = var.FORCE_DELETE

    launch_configuration        = aws_launch_configuration.lc.name
    vpc_zone_identifier         = var.VPC_ZONE_ID

    load_balancers              = [aws_elb.elb.name]
}

resource "aws_launch_configuration" "lc" {
    name                        = "${var.NAME}-${formatdate("YY-MM-DD-HH-mm", timestamp())}"

    image_id                    = var.AMI
    instance_type               = var.INSTANCE_TYPE
    user_data                   = var.USER_DATA

    security_groups             = var.LC_SG
    iam_instance_profile        = aws_iam_instance_profile.iam_profile.name
    key_name                    = var.KEY

    associate_public_ip_address = var.PUBLIC_IP

    root_block_device {
        volume_type             = var.VOL_TYPE
        volume_size             = var.VOL_SIZE
    }

    lifecycle {
        // AWS throws an error if false
        create_before_destroy   = true
    }
}

resource "aws_elb" "elb" {
    name                        = "${var.NAME}-elb"
    security_groups             = var.ELB_SG
    subnets                     = var.ELB_SUBNETS

    listener {
        lb_port                 = var.ELB_PORT
        lb_protocol             = var.ELB_PROTOCOL
        instance_port           = var.ELB_INSTANCE_PORT
        instance_protocol       = var.ELB_INSTANCE_PROTOCOL
    }

    health_check {
        healthy_threshold       = var.HEALTH_THRESHOLD
        unhealthy_threshold     = var.UNHEALTH_THRESHOLD
        timeout                 = var.HEALTH_TIMEOUT
        interval                = var.HEALTH_INTERVAL
        target                  = "${var.ELB_INSTANCE_PROTOCOL}:${var.ELB_INSTANCE_PORT}/"
    }
}

resource "aws_iam_role" "iam_role" {
    name                        = "${var.NAME}_iam_role"
    force_detach_policies       = true

    assume_role_policy          = var.IAM_BASE_POLICY
}

resource "aws_iam_instance_profile" "iam_profile" {
    name                        = "${var.NAME}_iam_policy"
    role                        = aws_iam_role.iam_role.name
}

resource "aws_iam_role_policy_attachment" "iam_policy_attachments" {
    for_each                    = toset(var.IAM_POLICIES)

    policy_arn                  = each.value
    role                        = aws_iam_role.iam_role.name
}