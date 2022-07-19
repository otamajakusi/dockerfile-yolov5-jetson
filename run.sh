#!/bin/bash
xhost +local:
sudo docker run \
       -it \
       --rm \
       --runtime nvidia \
       --network host \
       --device /dev/video0:/dev/video0:mrw \
       -e DISPLAY=$DISPLAY \
       -e LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libgomp.so.1 \
       -v /tmp/.X11-unix/:/tmp/.X11-unix \
       yolov5 python3.8 detect.py --source 0
