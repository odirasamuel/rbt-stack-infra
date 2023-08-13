# rbt-stack-infra

Terraform infrastructure for the rbt stack AWS accounts.

## Dev Setup

[![Open in VSCode Remote - Containers](https://img.shields.io/static/v1?label=Remote%20-%20Containers&message=Open&color=blue&logo=visualstudiocode)](https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/opent/rbt-stack-infra)

- [Development Containers](https://containers.dev/)
- [VSCode](https://code.visualstudio.com/docs/remote/containers)
- [devcontainer features](https://code.visualstudio.com/blogs/2022/09/15/dev-container-features)

> Though you may bind mind mount from your local drive, on Mac and Windows disk performance is not great. Cloning the repository into a volume has proven preferable.

1. [Install Docker](https://docs.docker.com/engine/install/)
2. [Use GitHub CLI as your credentials helper.](https://docs.github.com/en/get-started/getting-started-with-git/caching-your-github-credentials-in-git#github-cli)
3. If you already have VS Code and Docker installed, you can click the badge above or [here](https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/opent/rbt-stack-infra) to get started. Clicking these links will cause VS Code to automatically install the Remote - Containers extension if needed, clone the source code into a container volume, and spin up a dev container for use.
4. Note that the first build will take a few minutes but is sped up by our caching of the devcontainer image.
5. Manually Use VSCode
   1. Open the command pallet (command+shift+P)
   2. Start typing this command `Remote-Containers: Clone Repository in Named Container Volume...` ![File > Open Recent](/docs/images/command_pallet.png)
   3. Follow the prompts entering the URL for this repository and the name for the volume.
6. Do Work!
7. To reopen this environment, open VScode and use menu option File > Open Recent
   ![File > Open Recent](/docs/images/use_recent.png)
