#!/usr/bin/env bash

set -eux

# Create virtualenv
virtualenv .venv

# Initialize project if pyproject.toml is not exists
if [ ! -f pyproject.toml ]; then
    PROJECT_TMP_DIR="$(mktemp -d)/$(basename $PWD)"
    poetry new --src "$PROJECT_TMP_DIR"
    cp -r $(find $PROJECT_TMP_DIR -maxdepth 1 -not -path $PROJECT_TMP_DIR) .
fi

# Install package
poetry config virtualenvs.in-project true
poetry install

poetry completions bash >> ~/.bash_completion

# Substitute package name
PYPROJECT_FILE="$(tomljson pyproject.toml)"

# Substitute package and module names
export PYPROJECT_PACKAGE_NAME="$(echo $PYPROJECT_FILE | jq -r '.tool.poetry.name')"
export PYPROJECT_MODULE_NAME="$(echo $PYPROJECT_FILE | jq -r '.tool.poetry.packages[0].include')"

TMP_FILE="$(mktemp)"
envsubst '$PYPROJECT_PACKAGE_NAME $PYPROJECT_MODULE_NAME' < Dockerfile > "${TMP_FILE}"
mv "${TMP_FILE}" Dockerfile

TMP_FILE="$(mktemp)"
envsubst '$PYPROJECT_MODULE_NAME' < .vscode/launch.json > "${TMP_FILE}"
mv "${TMP_FILE}" .vscode/launch.json
