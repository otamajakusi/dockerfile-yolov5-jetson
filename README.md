
# this repository

This repository builds docker image for object detection using Yolov5 on Nvidia Jetson platform.
All operations below should be done on Jetson platform.

## setup

This operation makes default docker runtime 'nvidia'.

```bash
./setup.sh
```

## build

This operation build docker image named 'yolov5'.
Make sure this takes a few hours.

```bash
./build.sh
```

If the build fails, use `--no-cache` option to clean the docker build cache.

```bash
./build.sh --no-cache
```

## run

This operation detects objects with camera connected to /dev/video0.

```bash
./run.sh
```

## run with your own weights

You can use your own weights(my-weights.pt), as follows:

```bash
mkdir -p /path/to/weights
cp my-weights.pt /path/to/weights
xhost +local:
docker run -it --rm \
           --runtime nvidia \
           --network host \
           --device /dev/video0:/dev/video0:mrw \
           -e DISPLAY=$DISPLAY \
           -v /tmp/.X11-unix/:/tmp/.X11-unix \
           -v /path/to/weights:/weights \
           yolov5 python3 detect.py --source 0 --weights /weights/my-weights.pt
```

## run csi-camera sample

for more details: [https://github.com/JetsonHacksNano/CSI-Camera](https://github.com/JetsonHacksNano/CSI-Camera)

```bash
./run-csi-camera.sh
```
