#!/bin/bash
xhost +local:
# https://github.com/JetsonHacksNano/CSI-Camera
wget https://raw.githubusercontent.com/JetsonHacksNano/CSI-Camera/master/simple_camera.py -O simple_camera.py
docker run -it --rm --runtime nvidia --network host -e DISPLAY=$DISPLAY -v /tmp/.X11-unix/:/tmp/.X11-unix -v /tmp/argus_socket:/tmp/argus_socket -v $(pwd):/csi-camera yolov5 python3 /csi-camera/simple_camera.py
