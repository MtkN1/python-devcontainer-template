# python-devcontainer-template

## 1. Checkout this repository

Checkout this repository from template repository or tarball.

### Checkout from template repository:

![](https://docs.github.com/assets/cb-95207/images/help/repository/use-this-template-button.png)

Then clone the created repository.

```sh
git clone https://github.com/<owner>/<repo>.git
```

### Checkout from tarball:

```sh
mkdir <repo>
cd <repo>
curl -fsSL https://github.com/MtkN1/python-devcontainer-template/archive/refs/heads/main.tar.gz | tar -xz --strip-components=1
```

## 2. Open Folder in Container

Using the VS Code [Dev Containers](https://code.visualstudio.com/docs/devcontainers/tutorial) extension.

![](https://code.visualstudio.com/assets/docs/devcontainers/tutorial/dev-containers-commands.png)

## 3. Develop and Debug

- Create and edit the `src/<module_name>/__main__.py` file as an entry point.
- Enter the `poetry add` command to add dependencies.
- Press F5 to debug.
- If necessary, edit the the `Dockerfile` to change the container configuration.
