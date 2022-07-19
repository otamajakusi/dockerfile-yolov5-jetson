#!/bin/bash
if ! apt list --installed 2> /dev/null | grep nvidia-container-runtime; then
    apt update && apt install -y nvidia-container-runtime
fi
tee /etc/docker/daemon.json << EOF
{
    "runtimes": {
        "nvidia": {
            "path": "nvidia-container-runtime",
            "runtimeArgs": []
        }
    },
    "default-runtime": "nvidia"
}
EOF
systemctl restart docker
