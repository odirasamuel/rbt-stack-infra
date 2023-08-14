# rbt-stack-infra

This infra stack contains configuration for the automated AWS resources used for the opent robot stack - python package index web hosting, (eventually) app and robot software CI/CD.

See the stack subdirectories for more documentation on each stack.

The AWS accounts used by this repo are [profile1] (for the dev workspace) and [profile2] (for the staging and prod workspaces).

## Setup

You'll need to install [terraform](https://www.terraform.io/) through your favorite method to do anything in here. Linting also requires [shellcheck](https://www.shellcheck.net/) and [prettier](https://prettier.io/) and therefore a [node](https://nodejs.org/en/) install.

## Organization

### Stacks vs modules

The two components of this infrastructure directory are local modules in the `modules` directory and stacks in other directories.

A "stack" in this context is a chunk of infrastructure, probably contained in a VPC, that serves some complete purpose in and of itself. You should be able to give it a good name; if you can't, you probably need to reconsider what it's doing.

A stack should almost entirely consist of instantiating and configuring modules and have very little root-level configuration outside of that. Each stack has a separate terraform backend and state file from each other stack. This lets us plan and deploy each stack without affecting the others.

Modules in `modules`, on the other hand, should be content-agnostic; reusable; and focused on providing a single component of a larger stack - a VPC with its attendant configuration, or a hosting + CDN + DNS setup. A stack will probably use multiple modules.

### Workspaces

It's nice to be able to have different versions of a stack with different expectations around change controls, to provide a space for testing out changes both to the stack's infrastructure and to its eventual content. We do this with [terraform workspaces](https://www.terraform.io/language/state/workspaces). There is one set of workspaces for each stack: one named `prod`, one named `staging`, and one named `dev`.

`prod` is the canonical external-facing instance of the stack. It is the only public version. Only links to the prod instance should be circulated externally. Nothing should be pushed to prod, in content or infrastructure, without a full end-to-end test on staging, and things should only be pushed from `staging` to `prod` if doing so requires no changes - any required changes should be tested in `staging` first. `prod` lives on `profile2`.

`staging` is the end-to-end testing instance of the stack. Nothing should be pushed to prod without a basic test on `dev`. `staging` lives on `profile2`, but in a different vpc from `prod` and with different outward-facing urls.

`dev` is the anything-you-need instance of the stack. It may be automatically deployed on infrastructure or content branch pushes. Do not depend on `dev` being functional at any given point in time. Infrastructure changes to `dev` unfortunately can't really be isolated, so please talk to each other if you need a consistent `dev` environment for a day or two - but again, do _not_ ever rely on `dev` for anything. `dev` lives on `profile1`.

You can manage your workspaces with terraform directly, or rely on the makefile.

To check your current workspace

```terraform
terraform workspace show
```

To create a new workspace, say `staging`

```terraform
terraform workspace new staging
```

To switch to another workspace say, `prod`

```terraform
terraform workspace select prod
```

## Usage

Use the makefile. Each stack has three workspaces; each stack+workspace combo needs changing directories, running terraform workspace select, etc. The makefile can do this all for you.

### Linting and formatting

`make format` formats
`make lint` lints

### Planning

The makefile is set up to automatically handle running `terraform plan` for any combination of stack and workspace. You invoke makefile with the pattern `make plan-stack-name_workspacename`: the stack names are in kebab-case and the workspace name is separated from the stack name with an underscore. For instance, to run a plan for python-package-infrastructure on dev you'd run `make plan-stack2_dev`. To run a plan for ot3-ci on prod you'd run `make plan-stack1_prod`.

The plan rule will create a plan file of the same name in the current directory.

### Deploying

The makefile is setup to automatically handle running `terraform apply` with the appropriate workspace and stack selected. The rules are the same as for planning, but with the prefix `apply`: you run `make apply-stack-name_workspacename`. To deploy ot3-ci on staging, you run `make apply-stack1_staging`. To deploy python-package-index on dev, you run `make apply-stack2_dev`.

To confirm an apply, you'll have to type the stack and stage name in again.

## Creating a new stack

- Make a new subdirectory of `inf` named after your stack
- Add the new subdirectory stack/workspace name pairs to the makefile as `.SECONDARY` dependencies
- In the new subdirectory, make an empty `main.tf` and copy the `providers.tf` and `terraform.tf` files from another stack
- In your `terraform.tf`, change the `key` argument to the s3 backend to something including the name of your stack
- Run `terraform init` in your new directory
- Run `terraform workspace new dev`, `terraform workspace new staging`, `terraform workspace new prod` in your new directory

After this, there should be terraform state upstream, and you should be able to use the makefile in `inf/`. Now you can build your stack.

Please bias towards using modules for actual functionality (see above). Once you have a module, you can instantiate it in some file in your stack. We have the pattern of naming a file in a stack that instantiates a module the same as the module. For instance, you might make a file `vpc.tf` to instantiate the VPC for each workspace:

`vpc.tf`:

```terraform
module "dev_vpc" {
  count                 = (terraform.workspace == "dev") ? 1 : 0
  source                = "./modules/vpc"
  availability_zones    = var.availability_zones
  cidr_block            = var.cidr_block
  public_subnets_count  = var.public_subnets_count
  public_subnets_cidr   = var.public_subnets_cidr
  private_subnets_count = var.private_subnets_count
  private_subnets_cidr  = var.private_subnets_cidr
  nat_gateway_count     = var.nat_gateway_count
  elastic_ips           = var.elastic_ips
  providers = {
    aws = aws.profile@
  }
}
```

You'll want a file for default variables called `stackname.tfvars` (so, if your stack is named `my-stack`, it would be `my-stack.tfvars`). We want most data to be in a variable rather than open-coded in terraform.

Now you can plan:
`make plan-my-stack_dev`
