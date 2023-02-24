module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  for_each = toset(["control_node", "worker_node_1", "worker_node_2"])

  name = "instance-${each.key}"

  ami                    = "ami-0557a15b87f6559cf"
  instance_type          = "t2.medium"
  key_name               = "lab-alex-ansible"
  monitoring             = false
  vpc_security_group_ids = ["sg-015f0522c63279e5d"]
  subnet_id              = "subnet-08f4e648c4d338ce4"
  iam_role_name          = "SSM-Cursino"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}