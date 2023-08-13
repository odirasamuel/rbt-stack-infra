# Stack2

This stack provides a python package index hosted at https://pypi.opent.com/simple/ on robotics-robot-stack_prod. Staging is at https://staging.pypi.opent.com/simple/ also on robotics-robot-stack_prod; dev is at https://dev.pypi.opent/branchname/simple/ on robotics-robot-stack_dev.

The stack consists of S3 static storage behind a cloudfront distribution, all wrapped up in a VPC. It is to provide a PEP-503-compliant simple python package index. The content of the package index is controlled at https://github.com/opent/python-package-index .

## Deploying

All workspaces are planned on push.

Dev is deployed when pushed to `main`.

Staging is deployed on a tag push matching `python-package-index@v*-staging`. The largest number should be the currently-deployed version.

Prod is deployed on a tag push matching `python-package-index@v*`.

You can deploy locally if you want (and have appropriate permissions) but DO NOT DO IT for prod and think hard about whether to do it for staging or not. Dev is a playground.

> **Note**
> When applying terraform configuration in the staging workspace, you will see an error like this;
> Error: error creating IAM OIDC Provider: EntityAlreadyExists: Provider with url https://token.actions.githubusercontent.com already exists.
> │ status code: 409, request id: fbc23318-2ccd-41f3-8632-e9fc7cb7eccc
> │
> │ with module.staging_uploader[0].aws_iam_openid_connect_provider.oidc,
> │ on ../modules/uploader/main.tf line 53, in resource "aws_iam_openid_connect_provider" "oidc":
> │ 53: resource "aws_iam_openid_connect_provider" "oidc" {

> This is as a result of the staging and prod workspace located in the same account. It should be ignored.

> The above procedures can be replicated in creating a static s3 web hosting & uploader configuration for any environment in any stack directory.

The OIDC provider is used to grant github short-lived credentials needed for authentication in gihub actions. This involves specifying a role to assume without implicitly providing an access key and secret key.
