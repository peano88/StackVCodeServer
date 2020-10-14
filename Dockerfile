FROM ubuntu:latest
# install stuff
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    apt-utils \
    sudo \
    curl \
    wget \
    git  \
    g++  \
    gcc \
    libc6-dev \
    libffi-dev \ 
    libgmp-dev \ 
    make \ 
    xz-utils \ 
    zlib1g-dev \
    gnupg \ 
    netbase \
    libicu-dev \ 
    libncurses-dev \ 
    libgmp-dev

# Create user and give permission
RUN \
	groupadd -g 500 -r alonzo && \
	useradd -m -d /home/alonzo alonzo -u 500 -g alonzo && \
	echo alonzo:alonzo | chpasswd && \
	echo root:root | chpasswd && \
	usermod -aG sudo alonzo

RUN echo 'alonzo:alonzo' | chpasswd
RUN echo 'alonzo    ALL=NOPASSWD: ALL' >> /etc/sudoers

USER alonzo
WORKDIR /home/alonzo

# install Stack (this takes time)
RUN wget -qO- https://get.haskellstack.org | sh
ENV PATH="/home/alonzo/.local/bin:${PATH}"

# install HLS
RUN git clone https://github.com/haskell/haskell-language-server --recurse-submodules
RUN cd haskell-language-server && stack install.hs hls

# vcode server
RUN curl -fsSL https://code-server.dev/install.sh | sh
# Go!
COPY scripts/init.sh /home/alonzo/.local/bin/init.sh

CMD init.sh alonzo
