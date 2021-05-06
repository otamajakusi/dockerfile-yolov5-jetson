FROM nvcr.io/nvidia/l4t-pytorch:r32.5.0-pth1.6-py3

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt install -y cmake libgtk2.0-dev wget
# ffmpeg
RUN apt install -y libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libavresample3
# gstreamer
RUN apt install -y libgstreamer-opencv1.0-0 libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev

RUN wget https://nvidia.box.com/shared/static/p57jwntv436lfrd78inwl7iml6p13fzh.whl -O torch-1.8.0-cp36-cp36m-linux_aarch64.whl
RUN python3 -m pip install torch-1.8.0-cp36-cp36m-linux_aarch64.whl
RUN git clone https://github.com/pytorch/vision torchvision
RUN cd torchvision && git checkout v0.9.0 && python3 setup.py install

RUN python3 -m pip install scikit-build
RUN git clone --recursive https://github.com/skvark/opencv-python.git
RUN python3 -m pip install --upgrade pip
RUN cd opencv-python && python3 -m pip wheel . --verbose && find . -name "opencv_python*.whl" | xargs python3 -m pip install
RUN git clone https://github.com/ultralytics/yolov5.git
RUN cd yolov5 && python3 -m pip install -r requirements.txt
WORKDIR /yolov5
