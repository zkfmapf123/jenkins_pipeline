locals {
    vpc_config = jsondecode(file("../../config/private-vpc.json"))

    vpc_azs = [for az in local.vpc_config.vpc.azs : "${var.region}${az}"]
    
    public_subnets =  {
        for i, vpc_azs in local.vpc_azs : vpc_azs => local.vpc_config.public.cidrs[i]
    }

    private_subnets =  {
        for i, vpc_azs in local.vpc_azs : vpc_azs => local.vpc_config.private.cidrs[i]
    }

    
}