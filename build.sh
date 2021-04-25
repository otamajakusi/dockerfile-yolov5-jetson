#!/bin/bash
if [[ $(cat /etc/nv_tegra_release) =~ ^.*REVISION:[^\S]([0-9]*\.[0-9]).*$ ]]; then
    case ${BASH_REMATCH[1]} in
        5.*) sudo docker build -t yolov5 . ;;
        4.*) sudo docker build -t yolov5 -f Dockerfile.jetpack4.4 . ;;
        * ) echo "unknown jetpack ${BASH_REMATCH[1]}" ;;
    esac
fi
