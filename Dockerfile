FROM ubuntu:18.04

# setup timezone
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# get and install building tools
RUN apt-get update && \
	apt-get install -y --no-install-recommends \
        build-essential \
        git \
        ninja-build \
        python3 \
        python3-dev \
        python3-pip \
        python3-setuptools \
        python3-wheel \
        python3-tk \
        && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists

# retrieve source code
COPY . /vmaf

# install python requirements
RUN pip3 install --upgrade pip
RUN pip3 install --no-cache-dir meson
RUN pip3 install --no-cache-dir -r /vmaf/python/requirements.txt

# setup environment
ENV PYTHONPATH=/vmaf/python/src:/vmaf:$PYTHONPATH
ENV PATH=/vmaf:/vmaf/src/libvmaf:$PATH

# make vmaf
RUN cd /vmaf && make

WORKDIR /root/
