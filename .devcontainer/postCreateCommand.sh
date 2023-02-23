#!/usr/bin/env bash

set -eux

# Create virtualenv
virtualenv .venv

# Initialize project if pyproject.toml is not exists
if [ ! -f pyproject.toml ]; then
    PROJECT_TMP_DIR="$(mktemp -d)/main"
    poetry new --src "$PROJECT_TMP_DIR"
    cp -r $(find $PROJECT_TMP_DIR -maxdepth 1 -not -path $PROJECT_TMP_DIR) .
fi

# Install package
poetry config virtualenvs.in-project true
poetry install

poetry completions bash >> ~/.bash_completion
