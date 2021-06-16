resource "aws_instance" "server" {
    ami                         = var.AMI
    instance_type               = var.INSTANCE_TYPE
    associate_public_ip_address = var.PUBLIC_IP
    key_name                    = var.KEY

    iam_instance_profile        = aws_iam_instance_profile.iam_profile.name
    
    subnet_id                   = var.SUBNET
    vpc_security_group_ids      = var.VPC_SG_IDS

    user_data                   = var.USER_DATA

    tags = {
        Name = var.NAME
    }
}

resource "aws_iam_instance_profile" "iam_profile" {
    name                = join("_", [var.NAME, "server_iam_profile"])
    role                = aws_iam_role.iam_role.name
}

resource "aws_iam_role" "iam_role" {
    name                = join("_", [var.NAME, "server_iam_role"])
    assume_role_policy  = var.IAM_BASE_POLICY
}

resource "aws_iam_role_policy_attachment" "iam_policy_attachments" {
    for_each            = toset(var.IAM_POLICIES)

    policy_arn          = each.value
    role                = aws_iam_role.iam_role.name
}
