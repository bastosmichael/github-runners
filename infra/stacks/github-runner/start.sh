#!/bin/bash
set -euo pipefail

if [ -z "${GITHUB_ORG_URL:-}" ] || [ -z "${GITHUB_TOKEN:-}" ]; then
  echo "GITHUB_ORG_URL and GITHUB_TOKEN must be set."
  exit 1
fi

if [[ ! "${GITHUB_ORG_URL}" =~ ^https?://[^/]+/[^/]+(/[^/]+)?/?$ ]]; then
  echo "GITHUB_ORG_URL must include an organization or repository path (e.g., https://github.com/my-org or https://github.com/my-org/my-repo)."
  exit 1
fi

RUNNER_VERSION="${RUNNER_VERSION:-2.323.0}"
RUNNER_LABELS="${RUNNER_LABELS:-docker,ubuntu-22.04}"
RUNNER_NAME_PREFIX="${RUNNER_NAME_PREFIX:-github-runner}"

cleanup() {
  if [ -f .runner ]; then
    echo "Removing runner registration..."
    ./config.sh remove --unattended --token "$GITHUB_TOKEN" || true
  fi
}

trap cleanup EXIT INT TERM

if [ ! -f .runner ]; then
  echo "Downloading GitHub Actions runner v${RUNNER_VERSION}..."
  curl -fL -o actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"

  tar xzf actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

  RUNNER_NAME="${RUNNER_NAME_PREFIX}-${HOSTNAME}"

  echo "Configuring runner ${RUNNER_NAME}..."
  ./config.sh --url "$GITHUB_ORG_URL" \
    --token "$GITHUB_TOKEN" \
    --labels "$RUNNER_LABELS" \
    --name "$RUNNER_NAME" \
    --unattended \
    --replace
fi

./run.sh
