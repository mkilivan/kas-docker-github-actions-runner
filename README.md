# Kas Docker GitHub Actions Runner
This repo is to create a new self-hosted GitHub actions runners to build Yocto projects with kas. GitHub actions itself does not support using docker from a self hosted runner yet, thanks to [docker-github-actions-runner](https://github.com/myoung34/docker-github-actions-runner) project that run self-hosted GitHub actions runner in a Docker container. 

## How to run the self-hosted runner application
### Examples
docker-compose.yml
```yml
version: '2.3'

services:
  worker:
    image: mkilivan/kas-docker-github-actions-runner:latest
    environment:
      REPO_URL: https://github.com/example/repo
      RUNNER_NAME: example-name
      RUNNER_TOKEN: someGithubTokenHere
      RUNNER_WORKDIR: /tmp/runner/work
      RUNNER_GROUP: my-group
      RUNNER_SCOPE: 'repo'
      LABELS: linux,x64,gpu
    security_opt:
      # needed on SELinux systems to allow docker container to manage other docker containers
      - label:disable
    volumes:
      - '/var/run/docker.sock:/var/run/docker.sock'
      - '/tmp/runner:/tmp/runner'
      # note: a quirk of docker-in-docker is that this path
      # needs to be the same path on host and inside the container,
      # docker mgmt cmds run outside of docker but expect the paths from within
```

## How to use kas in workflow
```yml
name: kas build demo
on: [push]
jobs:
  build:
    runs-on: self-hosted
    steps:
        run: kas build your-project.yml
```
