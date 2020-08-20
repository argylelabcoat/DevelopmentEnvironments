FROM nixos/nix

# RUN nix-build -A pythonFull '<nixpkgs>'

RUN nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
RUN nix-channel --update

RUN nix-env -i neovim zsh tmux
