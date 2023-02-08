provider "aws" {
  region     = "us-east-1"
  access_key = "YOUR-ACCESS-KEY"
  secret_key = "YOUR-SECRET-KEY"
}
terraform {
  backend "s3" {
    bucket     = "terraform-backend-vincent"
    key        = "vincent-app.tfstate"
    region     = "us-east-1"
    access_key = "YOUR-ACCESS-KEY"
    secret_key = "YOUR-SECRET-KEY"
  }
}
module "ec2" {
  source         = "../modules/ec2"
  az             = var.az
  instance_type  = "t2.nano"
  aws_common_tag = var.aws_common_tag
  sg             = "${module.sg.aws_security_group}"
}
module "eip" {
  source      = "../modules/eip"
  instance_id = "${module.ec2.instance_id}"
}

module "sg" {
  source  = "../modules/sg"
  sg_name = var.security_group_name

}
module "ebs" {
  source      = "../modules/ebs"
  az          = var.az
  ebs_size    = var.ebs_size
  instance_id = "${module.ec2.instance_id}"
}
