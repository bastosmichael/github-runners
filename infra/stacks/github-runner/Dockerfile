FROM ubuntu:22.04

RUN apt-get update \
  && apt-get install -y --no-install-recommends curl tar jq sudo git ca-certificates \
  && rm -rf /var/lib/apt/lists/*

RUN useradd -m githubrunner
WORKDIR /home/githubrunner/actions-runner

COPY start.sh .
RUN chmod +x start.sh

USER githubrunner

ENTRYPOINT ["./start.sh"]
