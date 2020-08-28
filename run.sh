#!/bin/bash

host_shared_dir="$(realpath "$(pwd)")"
container_shared_dir="/$(pwd | slugify)"

# docker \
#     run \
#     --rm \
#     --privileged \
#     "--network=host" \
#     -v /var/run/docker.sock:/var/run/docker.sock \
#     -v "$host_shared_dir:/$container_shared_dir" \
#     -ti \
#     "--entrypoint=" \
#     openai-gpt-2-e12a391b:1.0 \
#     /run_jupyter.sh --allow-root

container_id="$(
docker \
    run \
    --rm \
    --privileged \
    "--network=host" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$host_shared_dir:/$container_shared_dir" \
    -ti \
    --detach \
    "--entrypoint=" \
    openai-gpt-2-e12a391b:1.0 \
    /bin/sh -c "trap 'exit 147' TERM; tail -f /dev/null & while wait \${!}; test \$? -ge 128; do true; done"
)"

echo "$container_id"

docker exec -it "$container_id" 'sh' '-c' '/bin/bash || /bin/zsh || sh'