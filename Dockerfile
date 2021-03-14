FROM nvcr.io/nvidia/l4t-pytorch:r32.4.4-pth1.6-py3

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install -y cmake libgtk2.0-dev wget

RUN wget https://nvidia.box.com/shared/static/p57jwntv436lfrd78inwl7iml6p13fzh.whl -O torch-1.8.0-cp36-cp36m-linux_aarch64.whl
RUN python3 -m pip install torch-1.8.0-cp36-cp36m-linux_aarch64.whl
RUN git clone https://github.com/pytorch/vision torchvision
RUN cd torchvision && git checkout v0.9.0 && python3 setup.py install

RUN python3 -m pip install scikit-build
RUN python3 -m pip install opencv-python
RUN git clone https://github.com/ultralytics/yolov5.git
RUN cd yolov5 && python3 -m pip install -r requirements.txt
WORKDIR /yolov5
