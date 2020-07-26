FROM debian:buster

RUN apt update; apt install -y build-essential clang lldb gdb gdbserver gcc wget file procps gzip tar binutils grep gawk libicu-dev pkgconf\
# Development Utils:
    emacs curl git fossil tig tmux fish bash unzip exuberant-ctags

RUN wget https://gitlab.com/YottaDB/DB/YDB/raw/master/sr_unix/ydbinstall.sh && \
chmod +x ydbinstall.sh && \
./ydbinstall.sh 


ARG GOLANG_NAME=go1.14.6.linux-amd64
RUN  cd /tmp && wget https://golang.org/dl/$GOLANG_NAME.tar.gz && \
tar -C /usr/local -xzf /tmp/$GOLANG_NAME.tar.gz && \
rm /tmp/$GOLANG_NAME.tar.gz


# Add User

ARG USER_ID
ARG GROUP_ID
RUN addgroup --gid $GROUP_ID user && adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user
RUN mkdir /work

WORKDIR /opt/nvim
RUN wget https://github.com/neovim/neovim/releases/download/v0.4.3/nvim.appimage && \
chmod u+x nvim.appimage && \
./nvim.appimage --appimage-extract && \
rm nvim.appimage && \
chmod -R 0755 /opt/nvim


# Set up user environment

USER user
WORKDIR /home/user

RUN mkdir -p /home/user/.config/fish && \
mkdir -p /home/user/.config/nvim && \
mkdir -p /home/user/.config/tmux


ENV GO111MODULE=on
ENV PATH=$PATH:/opt/nvim/squashfs-root/usr/bin
ENV PATH=$PATH:/usr/local/lib/yottadb/r128
ENV PATH=$PATH:/usr/local/go/bin:/home/user/go/bin
ENV PATH=$PATH:/home/user/.local/bin

COPY docker-scripts/nvim /home/user/.config/nvim
COPY docker-scripts/fish-bootstrap.sh /home/user/fish-bootstrap.sh
COPY docker-scripts/nvmrc /home/user/.nvmrc
COPY docker-scripts/fishfile /home/user/.config/fish/

RUN \
fish -c /home/user/fish-bootstrap.sh && \
fish -c nvm < ~/.nvmrc && \
\
go get golang.org/x/tools/gopls@latest && \ 
\
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
nvim -E   +PlugInstall +qall || echo "installed plugins" && \
\
bash -c "source /usr/local/lib/yottadb/r128/ydb_env_set" && \
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh


WORKDIR /work

ENTRYPOINT bash -c "source /usr/local/lib/yottadb/r128/ydb_env_set; exec /usr/bin/fish"
