provider "aws" {
    region = var.AWS_REGION
}

# module "frontend" {
#     source          = "./modules/asg"

#     NAME            = "consul-demo-frontend"
#     USER_DATA       = file("./scripts/frontend.sh")
#     VPC_ZONE_ID     = [module.network.subnet.id]
#     LC_SG           = [module.network.sg.id]

#     ELB_SUBNETS     = [module.network.subnet.id]
#     ELB_SG          = [module.network.sg.id]
# }

module "frontend" {
    source          = "./modules/ec2"

    NAME            = "consul_demo_frontend"
    USER_DATA       = file("./scripts/frontend.sh")

    SUBNET          = module.network.subnet.id
    VPC_SG_IDS      = [module.network.sg.id]
    IAM_POLICIES    = ["arn:aws:iam::010629071893:policy/EC2DescribeInstances"]

    PUBLIC_IP       = true
    KEY             = "zoff3"
}

module "database" {
    source          = "./modules/ec2"

    NAME            = "consul_demo_database"
    USER_DATA       = file("./scripts/database.sh")
    IAM_POLICIES    = ["arn:aws:iam::010629071893:policy/EC2DescribeInstances"]
    KEY             = "zoff3"

    SUBNET          = module.network.subnet.id
    VPC_SG_IDS      = [module.network.sg.id]
}

module "consul" {
    source          = "./modules/ec2"

    NAME            = "consul_demo_mesh_server"
    USER_DATA       = file("./scripts/consul.sh")

    SUBNET          = module.network.subnet.id
    VPC_SG_IDS      = [module.network.sg.id]
    
    KEY             = "zoff3"
}

module "network" {
    source          = "./modules/network"
}
