FROM nvcr.io/nvidia/l4t-base:r32.5.0

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install -y cmake libgtk2.0-dev wget python3.8 python3.8-dev python3-pip
# ffmpeg
RUN apt install -y libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libavresample3
# gstreamer
RUN apt install -y libgstreamer-opencv1.0-0 libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev

RUN python3.8 -m pip install --upgrade pip
RUN python3.8 -m pip install setuptools gdown
RUN gdown https://drive.google.com/uc?id=1V231Nmx42vXTo5nq_YsV_BouZwBE9vjh
# RUN wget https://nvidia.box.com/shared/static/p57jwntv436lfrd78inwl7iml6p13fzh.whl -O torch-1.8.0-cp36-cp36m-linux_aarch64.whl
RUN python3.8 -m pip install torch-1.8.0a0+56b43f4-cp38-cp38-linux_aarch64.whl
RUN apt install -y git
RUN git clone --depth=1 https://github.com/pytorch/vision torchvision -b release/0.9
RUN apt install -y libomp5 libopenblas-base libopenmpi-dev libjpeg-dev
RUN cd torchvision && python3.8 setup.py install

RUN python3.8 -m pip install scikit-build
RUN git clone --recursive --depth=1 --recurse-submodules --shallow-submodules https://github.com/skvark/opencv-python.git
RUN cd opencv-python && python3.8 -m pip wheel . --verbose && find . -name "opencv_python*.whl" | xargs python3.8 -m pip install
RUN git clone https://github.com/ultralytics/yolov5.git -b v6.1
RUN cd yolov5 && python3.8 -m pip install -r requirements.txt
WORKDIR /yolov5
