#!/bin/bash
nvidia_containe_installed=$(apt list nvidia-container --installed 2> /dev/null | wc -l)
if [ ${nvidia_containe_installed} = 1 ]; then
    apt update && apt install -y nvidia-container
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
