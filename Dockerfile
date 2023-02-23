# Build args for Dev, Build and Runtime Containers
ARG PYTHON_VERSION=3.11
ARG DEBIAN_RELEASE=bullseye

# Stage: Dev Container
FROM mcr.microsoft.com/devcontainers/python:0-${PYTHON_VERSION}-${DEBIAN_RELEASE} AS devcontainer

# Install APT packages
RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y --no-install-recommends \
    bash-completion

# Install Poetry for development
RUN --mount=type=cache,target=/root/.cache \
    pipx install poetry

# Stage: Builder
FROM python:${PYTHON_VERSION}-${DEBIAN_RELEASE} AS builder

# Install Poetry for build
RUN --mount=type=cache,target=/root/.cache \
    pip install -U pip poetry

WORKDIR /usr/src/app

# Export requirements.txt and build dependencies
RUN --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    --mount=type=bind,source=poetry.lock,target=poetry.lock \
    poetry export -o requirements.txt --without-hashes \
    && pip wheel -w wheels -r requirements.txt

# Build main package
RUN --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    --mount=type=bind,source=src,target=src \
    --mount=type=bind,source=README.md,target=README.md \
    poetry build -f wheel

# Stage: Runtime
FROM python:${PYTHON_VERSION}-slim-${DEBIAN_RELEASE} AS runtime

WORKDIR /usr/src/app

# Install dependencies
RUN --mount=type=bind,from=builder,source=/usr/src/app/requirements.txt,target=requirements.txt \
    --mount=type=bind,from=builder,source=/usr/src/app/wheels,target=wheels \
    pip install --no-cache-dir --no-index -f wheels -r requirements.txt

# Install main package
RUN --mount=type=bind,from=builder,source=/usr/src/app/dist,target=dist \
    pip install --no-cache-dir --no-index -f dist main

RUN adduser -u 5678 --disabled-password --gecos "" appuser
USER appuser

# Run module
ENTRYPOINT ["python", "-m", "main"]
