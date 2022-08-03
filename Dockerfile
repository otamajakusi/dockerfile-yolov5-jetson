FROM nvcr.io/nvidia/l4t-base:r32.7.1

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install -y cmake libgtk2.0-dev wget python3.8 python3.8-dev python3-pip
# ffmpeg
RUN apt install -y libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libavresample3
# gstreamer
RUN apt install -y libgstreamer-opencv1.0-0 libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev

RUN python3.8 -m pip install --upgrade pip
RUN python3.8 -m pip install setuptools gdown
RUN gdown https://drive.google.com/uc?id=1hs9HM0XJ2LPFghcn7ZMOs5qu5HexPXwM
RUN python3.8 -m pip install torch-1.11.0a0+gitbc2c6ed-cp38-cp38-linux_aarch64.whl
RUN apt install -y git
RUN git clone --depth=1 https://github.com/pytorch/vision torchvision -b v0.12.0
RUN apt install -y libomp5 libopenblas-base libopenmpi-dev libjpeg-dev
RUN python3.8 -m pip install cython --upgrade
RUN cd torchvision && TORCH_CUDA_ARCH_LIST='5.3;6.2;7.2' FORCE_CUDA=1 python3.8 setup.py install

RUN python3.8 -m pip install scikit-build
RUN git clone --recursive --depth=1 --recurse-submodules --shallow-submodules https://github.com/skvark/opencv-python.git
RUN cd opencv-python && python3.8 -m pip wheel . --verbose && find . -name "opencv_python*.whl" | xargs python3.8 -m pip install
RUN git clone https://github.com/WongKinYiu/yolov7
RUN cd yolov7 && python3.8 -m pip install -r requirements.txt
WORKDIR /yolov7
