
# this repository

This repository builds docker image for object detection using Yolov5 on Nvidia Jetson platform.
All operations below should be done on Jetson platform.

## setup

This operation makes default docker runtime 'nvidia'.

```bash
sudo ./setup.sh
```

## build

This operation build docker image named 'yolov5'.
Make sure this takes a few hours.

```bash
./build.sh
```

real    140m18.467s  
user    0m2.160s  
sys     0m1.524s  


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
           -e LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libgomp.so.1 \
           -v /tmp/.X11-unix/:/tmp/.X11-unix \
           -v /path/to/weights:/weights \
           yolov5 python3.8 detect.py --source 0 --weights /weights/my-weights.pt
```

## run csi-camera sample

To be able to run CSI camera on yolov5, the following pathch is required:
(See https://github.com/otamajakusi/dockerfile-yolov5-jetson/issues/3)

```diff
diff --git a/utils/datasets.py b/utils/datasets.py
index 43e4e59..14fa5c9 100755
--- a/utils/datasets.py
+++ b/utils/datasets.py
@@ -280,7 +280,35 @@ class LoadStreams:  # multiple IP or RTSP cameras
                 import pafy
                 s = pafy.new(s).getbest(preftype="mp4").url  # YouTube URL
             s = eval(s) if s.isnumeric() else s  # i.e. s = '0' local webcam
-            cap = cv2.VideoCapture(s)
+
+            def gstreamer_pipeline(
+                capture_width=1280,
+                capture_height=720,
+                display_width=1280,
+                display_height=720,
+                framerate=60,
+                flip_method=0,
+            ):
+                return (
+                    "nvarguscamerasrc ! "
+                    "video/x-raw(memory:NVMM), "
+                    "width=(int)%d, height=(int)%d, "
+                    "format=(string)NV12, framerate=(fraction)%d/1 ! "
+                    "nvvidconv flip-method=%d ! "
+                    "video/x-raw, width=(int)%d, height=(int)%d, format=(string)BGRx ! "
+                    "videoconvert ! "
+                    "video/x-raw, format=(string)BGR ! appsink"
+                    % (
+                        capture_width,
+                        capture_height,
+                        framerate,
+                        flip_method,
+                        display_width,
+                        display_height,
+                    )
+                )
+
+            cap = cv2.VideoCapture(gstreamer_pipeline(flip_method=0), cv2.CAP_GSTREAMER)
             assert cap.isOpened(), f'Failed to open {s}'
             w = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
             h = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
```

and then:

```bash
./run-csi-camera.sh
```

for more details: [https://github.com/JetsonHacksNano/CSI-Camera](https://github.com/JetsonHacksNano/CSI-Camera)
