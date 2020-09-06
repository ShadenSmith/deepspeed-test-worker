#!/bin/bash

if [[ -z "${DEEPSPEED_PAT}" ]]; then
    echo "\$DEEPSPEED_PAT must store personal auth token (PAT) for Azure Pipelines agent pool."
    exit 1
fi

if [[ -z "${DEEPSPEED_TEST_BASE}" ]]; then
    export DEEPSPEED_TEST_BASE="/tmp/deepspeed-testing"
    echo "Using DEEPSPEED_TEST_BASE=${DEEPSPEED_TEST_BASE}"
fi

#
# Install Azure Pipelines agent
#

AGENT_DIR=${DEEPSPEED_TEST_BASE}/agent
AGENT_VERSION="2.172.2"

mkdir -p ${AGENT_DIR}

pushd ${AGENT_DIR}
wget https://vstsagentpackage.azureedge.net/agent/${AGENT_VERSION}/vsts-agent-linux-x64-${AGENT_VERSION}.tar.gz -O agent.tar.gz
tar xf agent.tar.gz

echo "Installing prerequisites, you may be prompted for sudo password."
sudo ./bin/installdependencies.sh

./config.sh \
    --unattended \
    --url https://dev.azure.com/DeepSpeedMSFT \
    --pool DS_testing \
    --agent ${HOSTNAME} \
    --replace \
    --auth pat --token ${DEEPSPEED_PAT}

popd


#
# Install miniconda
#
CONDA_INSTALL_PATH=${DEEPSPEED_TEST_BASE}/miniconda3

pushd ${DEEPSPEED_TEST_BASE}

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda-latest.sh
bash miniconda-latest.sh \
    -b \
    -f \
    -p ${CONDA_INSTALL_PATH}

export PATH="${CONDA_INSTALL_PATH}/bin:${PATH}"

conda update -y -n base -c defaults conda

pushd ${AGENT_DIR}
./run.sh
