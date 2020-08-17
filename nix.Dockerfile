FROM nixos/nix

RUN nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
RUN nix-channel --update

# RUN nix-build -A pythonFull '<nixpkgs>'

# Add User
ARG UID
ARG GID
ARG USER
#RUN adduser --disabled-password  -g $GID -u $UID $USER && \
#mkdir /work && chown -R $USER:$USER /work

#USER $USER

#RUN nix-env -i neovim zsh tmux
