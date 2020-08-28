#!/bin/bash

host_shared_dir="$(realpath "$(pwd)")"
container_shared_dir="/$(pwd | slugify)"

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

# Fix a bug
docker exec -it "$container_id" 'sh' '-c' 'sed -i "s=tf.sort(=tf.contrib.framework.sort(=" src/sample.py'

docker cp `alt -q nvi` "$container_id":/usr/bin

# docker exec -it "$container_id" bash

# Set up poetry notebooks
docker cp $MYGIT/kylemcdonald/python-utils "$container_id":/gpt-2/src/utils
docker cp "$MYGIT/kylemcdonald/gpt-2-poetry/Generate GPT-2.py" "$container_id":/gpt-2/src/gen.py

docker exec -it "$container_id" 'sh' '-c' '/bin/bash || /bin/zsh || sh'