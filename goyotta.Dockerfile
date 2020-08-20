FROM ubuntu:focal

RUN apt update;  DEBIAN_FRONTEND="noninteractive" \
apt install -y libicu-dev icu-devtools libtinfo5 \
build-essential binutils pkgconf clang clangd lldb gdb gdbserver gcc \
wget file procps gzip tar grep gawk libssl-dev locales \
# Development Utils:
neovim emacs-nox kakoune curl git fossil tig tmux zsh unzip universal-ctags python3-pip 


RUN wget https://gitlab.com/YottaDB/DB/YDB/raw/master/sr_unix/ydbinstall.sh && \
chmod +x ydbinstall.sh && \
./ydbinstall.sh --utf8 default --installdir /opt/yottadb

ARG GOLANG_NAME=go1.14.6.linux-amd64
RUN  cd /tmp && wget https://golang.org/dl/$GOLANG_NAME.tar.gz && \
tar -C /usr/local -xzf /tmp/$GOLANG_NAME.tar.gz && \
rm /tmp/$GOLANG_NAME.tar.gz


# Add User
ARG USER_ID
ARG GROUP_ID
RUN addgroup --gid $GROUP_ID user && adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user
RUN mkdir /work

RUN mkdir -p /data/yottadb; \
mkdir -p /data/yottadb/g; \
mkdir -p /data/yottadb/r; \
mkdir -p /data/yottadb/o; \
chown -R user:user /data

# Set up user environment
WORKDIR /home/user

USER user

RUN \
mkdir -p /home/user/.config/nvim && \
mkdir -p /home/user/.config/tmux  && \
mkdir -p /home/user/scripts


ENV TERM=screen-256color
ENV GO111MODULE=on  LANG=en_US.UTF-8 LANGUAGE=en_US:en

ENV PATH=$PATH:/usr/local/go/bin:/home/user/go/bin
ENV PATH=$PATH:/home/user/.local/bin
ENV PATH=$PATH:/home/user/.cargo/bin

ENV PATH=$PATH:/opt/yottadb
ENV ydb_dir=/data  gtmdir=/data
ENV ydb_dist=/opt/yottadb  gtm_dist=/opt/yottadb
ENV ydb_global_dir=/data/yottadb/g
ENV ydb_gbldir=$ydb_global_dir/yottadb.gld
ENV gtmgbldir=$ydb_global_dir/yottadb.gld

RUN \
# RUST
wget https://sh.rustup.rs -O rustup.sh && \
chmod +x rustup.sh && \
zsh -c "./rustup.sh -y" && \
rm rustup.sh && \
# Starship
cargo install starship && \
# Go Tools
go get golang.org/x/tools/gopls@latest && \ 
go get github.com/go-delve/delve/cmd/dlv && \
# Python Tools
pip3 install --user pyls meson conan pylint prospector scons pynvim msgpack-python tmuxp 

USER root

COPY docker-scripts/tmux.conf ./.tmux.conf
COPY docker-scripts/tmux.conf.local ./.tmux.conf.local
COPY docker-scripts/nvmrc .nvmrc


COPY docker-scripts/nvim .config/nvim

COPY docker-scripts/zshrc /home/user/.zshrc
COPY docker-scripts/run_shell.sh ./scripts/run_shell.sh
COPY docker-scripts/yotta_config ./scripts/yotta_config
COPY docker-scripts/yottadb.gde ./scripts/yottadb.gde

RUN chown -R user:user /home/user/.config && \
chown -R user:user /home/user/scripts  && \
chown -R user:user /home/user/.nvmrc && \
chown -R user:user /home/user/.tmux*

USER user

#RUN $HOME/yotta_config
RUN \
locale-gen en_US.UTF-8 && \
git clone https://github.com/zplug/zplug.git $HOME/.zplug && \
zsh -c "npm install -g javascript-typescript-langserver" && \
\
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
nvim -E   +PlugInstall +qall || echo "installed plugins" 

WORKDIR /work

CMD $HOME/scripts/run_shell.sh
