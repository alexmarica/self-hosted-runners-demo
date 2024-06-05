FROM ubuntu:22.04
# use arguments to define the Personal Access Token used to retrieve the registration token, git operations etc
# the ARGs will be turned into ENV variables to be used by scripts running in the container (such as runner registration script)
ARG DEBIAN_FRONTEND=noninteractive
ARG REPO="alexmarica/self-hosted-runners-demo"
ARG PAT=""
ARG USER="runner"
ARG RUNNER_VERSION="2.316.1"
ARG WORKDIR=/home/$USER
ARG RUNNER_LABELS="test1,test2"
ENV REPO=$REPO
ENV PAT=$PAT
ENV RUNNER_LABELS=$RUNNER_LABELS
# install additional packages and add non-root user that the runner will use 
RUN apt update && apt upgrade && \
    apt -y install curl jq git && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -ms /bin/bash $USER && \
    mkdir -p WORKDIR/actions-runner
WORKDIR $WORKDIR
# install runner, copy startup script that configures and registers it
COPY start.sh actions-runner/start.sh
RUN cd $WORKDIR/actions-runner && \
    curl -o actions-runner-linux-x64-$RUNNER_VERSION.tar.gz -L https://github.com/actions/runner/releases/download/v$RUNNER_VERSION/actions-runner-linux-x64-2.316.1.tar.gz && \
    tar xzfv ./actions-runner-linux-x64-$RUNNER_VERSION.tar.gz && \
    chmod +x ./bin/installdependencies.sh && \
    ./bin/installdependencies.sh && \
    chmod +x start.sh && \
    rm -f ./actions-runner-linux-x64-$RUNNER_VERSION.tar.gz && \
    chown -R $USER:$USER $WORKDIR/actions-runner
USER $USER
ENTRYPOINT ["./actions-runner/start.sh"]