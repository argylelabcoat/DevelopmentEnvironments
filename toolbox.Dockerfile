FROM registry.fedoraproject.org/f32/fedora-toolbox:32

RUN dnf update -y;  \
dnf install -y git xz wget

ENV TERM=screen-256color
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


