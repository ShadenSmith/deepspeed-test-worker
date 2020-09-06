# deepspeed-test-worker

This is a simple script for spinning up new Azure Pipelines agents to run
DeepSpeed integration tests. This script installs prerequisites, registers the worker,
and begins listening for jobs.

## Prerequisites
* `$DEEPSPEED_PAT` must store a [personal authentication token (PAT)](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/v3-linux?view=azure-devops#permissions) configured for DeepSpeed's GPU testing pool.
* `sudo` priviledges are required to install the agent prerequisite software. You may be
   prompted for a password once at the beginning of this script execution.

## Instructions
To spin up a worker, simply run:
```bash
DEEPSPEED_PAT=mytoken ./prep_test_node.sh
```

**Note:** the worker will stop once this script is killed. For continued execution, we
strongly recommend you run this script in a `tmux` or `screen` environment.

## Configuring

### Agent installation path
The testing agent sets up in `/tmp/deepspeed-testing/`  by default. You can change the base directory
by setting the environment variable `$DEEPSPEED_TEST_BASE` at the time of running:
```bash
DEEPSPEED_TEST_BASE=/my/fast/dir DEEPSPEED_PAT=mytoken ./prep_test_node.sh
```

**Note**: we recommend you base the testing agent on fast local storage.

### Data paths
DeepSpeed's model tests expect training data to be found under
* `/data/Megatron-LM`
* `/data/BingBertSquad`

We don't currently provide a way to configure the model test training data location.