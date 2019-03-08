workflow "Build, Test, and Publish kata-deploy" {
  on = "push"
  resolves = ["docker-push-ref"]
}

action "tag-filter" {
  uses = "actions/bin/filter@master"
  args = "tag"
}

action "docker-build" {
  needs = "tag-filter"
  uses = "actions/docker/cli@master"
  args = "build --build-arg KATA_VER=${GITHUB_REF##*/} -t katadocker/kata-deploy ./kata-deploy"
}

action "docker-tag" {
  needs = "docker-build"
  uses = "actions/docker/tag@master"
  args = "kata-deploy katadocker/kata-deploy"
}

action "docker-login" {
  needs = "docker-tag"
  uses = "actions/docker/login@master"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "docker-push-sha" {
  needs = "docker-login"
  uses = "actions/docker/cli@master"
  args = "push katadocker/kata-deploy:$GITHUB_SHA"
}

action "aks-test" {
  needs = "docker-push-sha"
  uses = "./kata-deploy/action"
  secrets = ["AZ_APPID", "AZ_PASSWORD", "AZ_SUBSCRIPTION_ID"]
}

action "docker-push-ref" {
  needs = "aks-test"
  uses = "actions/docker/cli@master"
  args = "push katadocker/kata-deploy:${GITHUB_REF##*/}"
}