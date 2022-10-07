#!/bin/bash
set -e

if [ ! -f /etc/nv_tegra_release ]; then
    echo "Error: $0 should be run on the Jetson platform."
    exit 1
fi
if [[ $(cat /etc/nv_tegra_release) =~ ^.*REVISION:[^\S]([0-9]*\.[0-9]).*$ ]]; then
    case ${BASH_REMATCH[1]} in
        [67].*) sudo docker build -t yolov5 . $1 ;;
        * ) echo "unknown jetpack ${BASH_REMATCH[1]}"
            exit 1 ;;
    esac
fi
