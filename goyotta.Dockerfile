FROM ubuntu:focal

RUN apt update;  DEBIAN_FRONTEND="noninteractive" \
apt install -y libicu-dev icu-devtools libtinfo5 \
build-essential binutils pkgconf clang clangd lldb gdb gdbserver gcc \
wget file procps gzip tar grep gawk \
# Development Utils:
neovim emacs-nox kakoune curl git fossil tig tmux fish bash unzip universal-ctags python3-pip 


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

RUN mkdir -p /home/user/.config/fish && \
mkdir -p /home/user/.config/nvim && \
mkdir -p /home/user/.config/tmux


ENV GO111MODULE=on  LANG=en_US.UTF-8 LANGUAGE=en_US:en

ENV PATH=$PATH:/usr/local/go/bin:/home/user/go/bin
ENV PATH=$PATH:/home/user/.local/bin
ENV PATH=$PATH:/home/user/.cargo/bin

ENV PATH=$PATH:/opt/yottadb
ENV ydb_dir=/data 
ENV ydb_dist=/opt/yottadb 
ENV ydb_gbldir=/data/yottadb/g/yottadb.gld

COPY docker-scripts/nvim .config/nvim
COPY docker-scripts/fish-bootstrap.sh ./fish-bootstrap.sh
COPY docker-scripts/nvmrc .nvmrc
COPY docker-scripts/fishfile .config/fish/
COPY docker-scripts/yotta_config ./yotta_config
COPY docker-scripts/tmux.conf ./.tmux.conf

RUN chown -R user:user /home/user

USER user

RUN $HOME/yotta_config

RUN wget https://sh.rustup.rs -O rustup.sh && \
cat rustup.sh && \
chmod +x rustup.sh && \
fish -c "./rustup.sh -y" && \
rm rustup.sh

RUN \
fish -c /home/user/fish-bootstrap.sh && \
fish -c fisher && \
fish -c nvm < ~/.nvmrc && \
\
go get golang.org/x/tools/gopls@latest && \ 
go get github.com/go-delve/delve/cmd/dlv && \
fish -c "npm install -g javascript-typescript-langserver" && \
pip3 install --user pyls meson conan pylint prospector scons tmuxp && \
\
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
nvim -E   +PlugInstall +qall || echo "installed plugins" 

ENV TERM=screen-256color
WORKDIR /work

CMD fish -c tmux
