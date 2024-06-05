#!/bin/bash

FULL_PATH=$(dirname "$(realpath $0)")
echo Trying to register runner on repo: $REPO with labels: $RUNNER_LABELS
REG_TOKEN=$(curl -s -X POST -H "Authorization: token ${PAT}" -H "Accept: application/vnd.github+json" https://api.github.com/repos/${REPO}/actions/runners/registration-token | jq .token --raw-output) 
echo Using temporary registration token: $REG_TOKEN
$FULL_PATH/config.sh --unattended --labels $RUNNER_LABELS --url https://github.com/${REPO} --token ${REG_TOKEN} 
cleanup() 
    { 
        echo "Removing runner... " 
        $FULL_PATH/config.sh remove --token ${REG_TOKEN}
        exit 0
    } 
trap 'cleanup' SIGINT SIGTERM
$FULL_PATH/run.sh & wait $!