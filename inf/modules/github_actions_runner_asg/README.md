### The module block should be in this format

```terraform

module "runner_asg" {
  source = "git::ssh://git@github.com/Opentrons/terraform-modules//modules/github_actions_runner_asg?ref=main"
  instance_name = "github-actions-runner-asg"
  instance_type = "t2.micro"
  #amazon_linux ami
  ami_id = "ami-0f924dc71d44d23e2"
  vpc_id = module.vpc.vpc_id
  github_repo_pat_token = var.token
  github_repo_url = var.repo_url
  health_check_grace_period = 600
  desired_capacity = 1
  min_size = 1
  max_size = 3
  vpc_zone_identifier = "${module.vpc.private_subnet.*.id}"

}

```
