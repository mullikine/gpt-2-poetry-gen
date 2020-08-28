#!/bin/bash

container_shared_dir="/$(pwd | slugify)"

docker run --rm --privileged "--network=host" -v /var/run/docker.sock:/var/run/docker.sock -v "$(pwd):/$(pwd | slugify)" -ti "--entrypoint=" openai-gpt-2-e12a391b:1.0 /run_jupyter.sh --allow-root