# Stack1

This stack provides EC2 autoscaling groups running github action runners, integrated with github via the process described [here](https://docs.github.com/en/actions/hosting-your-own-runners/autoscaling-with-self-hosted-runners). It has one ASG connected to https://github.com/opent/oe-core and one connected to https://github.com/opent/opent.

It may be deployed locally using a github personal authentication token created for your account with the `public_repo` scope and dropped in a `.env` file in the `inf` directory:

```sh
cat inf/.env
#!/usr/bin/env bash

export TF_VAR_runner_pool_github_token_monorepo=ghp_githubtokengoeshere
export TF_VAR_runner_pool_github_token_openembedded=ghp_githubtokengoeshere
```

The github tokens can be the same or can be different if using fine-grained tokens.

The stack also provides S3 static storage behind a cloudfront distribution. Everything is in a VPC. The storage is accessible via

- dev: dev.ot3-development.builds.opent.com
- staging: staging.ot3-development.builds.opent.com
- prod: ot3-development.builds.opent.com

## Deploying

All workspaces are planned on push.

Dev is deployed when pushed to `main`.

Staging is deployed on a tag push matching `ot3-ci@v*-staging*`. The largest number should be the currently-deployed version.

Prod is deployed on a tag push matching `ot3-ci@v*`.
