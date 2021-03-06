FROM ubuntu:latest
# install stuff
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    apt-utils \
    curl \
    sudo \
    g++  \
    gcc \
    git  \
    gnupg \ 
    libc6-dev \
    libffi-dev \ 
    libicu-dev \ 
    libgmp-dev \
    libncurses-dev \ 
    make \ 
    netbase \
    wget \
    xz-utils \ 
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Create user and give permission
ARG user=alonzo
RUN \
	groupadd -g 500 -r $user && \
	useradd -m -d /home/$user $user -u 500 -g $user && \
	echo $user:$user | chpasswd && \
	echo root:root | chpasswd && \
	usermod -aG sudo $user

RUN echo "${user}    ALL=NOPASSWD: ALL" >> /etc/sudoers

USER $user
WORKDIR /home/$user

# install Stack 
RUN wget -qO- https://get.haskellstack.org | sh
ENV PATH="/home/${user}/.local/bin:${PATH}"

# # install HLS (this takes time)
RUN git clone https://github.com/haskell/haskell-language-server --recurse-submodules
RUN cd haskell-language-server && stack install.hs hls
RUN cd $WORKDIR && rm -rf haskell-language-server

# # vcode server
RUN curl -fsSL https://code-server.dev/install.sh | sh
# # Go!
COPY --chown=$user:$user scripts/init.sh /home/$user/.local/bin/init.sh
RUN chmod u+x /home/$user/.local/bin/init.sh

CMD init.sh
