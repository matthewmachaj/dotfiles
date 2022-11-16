#!/bin/bash

# -------------------------------------------------------------------------------
# Dependency Installation
# -------------------------------------------------------------------------------
installRemotePackages() {
  print_step "Installing REMOTE packages"
  sudo apt-get install -y curl vim zsh
}

installLocalPackages() {
  print_step "Installing LOCAL packages"
  sudo apt-get install -y tmux
}

installStarship() {
  print_step "Installing Starship terminal prompt"

  STARSHIP_EXEC=/usr/local/bin/starship
  if [ -f $STARSHIP_EXEC ]; then
    skipping "Starship already installed at [$STARSHIP_EXEC]"
  else
    sh -c "$(curl -fsSL https://starship.rs/install.sh)"
  fi
}

installNeovimPythonProvider() {
  print_step "Install Python 3 'neovim' module into default virtualenv if it exists yet"

  if [ ! -z ${DEFAULT_PYTHON+x} ]; then
    if [ -f $DEFAULT_PYTHON/bin/python3 ]; then
      msg "Virtualenv exists so installing/re-installing 'neovim' module"
      $DEFAULT_PYTHON/bin/pip3 install neovim
    else
      skipping "Python 3 default virtualenv does NOT exist so installing module"
      warn "Some parts of Neovim may not work; make sure you run Ansible to install your default Python 3"
    fi
  else
      warn "DEFAULT_PYTHON is not set in the environment so not installing Python 3 'neovim' provider"
  fi
}


# -------------------------------------------------------------------------------
# Dotfile Symlinking
# -------------------------------------------------------------------------------
CONFIG_DIR=$DOTDIR/.config

REMOTE_CONFIGS=(
  bash
  nvim
  psql
  readline
  sh
  starship
  vim
  zsh
)

LOCAL_CONFIGS=(
  alacritty
  awesome
  parcellite
  tmux
  xmodmap
)

setupRemoteConfigDirSymlinks() {
  print_step "Setting up REMOTE dotfile symlinks in ~/.config"
  for conf in ${REMOTE_CONFIGS[@]}; do
    create_symlink_with_backup $CONFIG_DIR/$conf ~/.config/$conf
  done
}

setupLocalConfigDirSymlinks() {
  print_step "Setting up LOCAL dotfile symlinks in ~/.config"
  for conf in ${LOCAL_CONFIGS[@]}; do
    create_symlink_with_backup $CONFIG_DIR/$conf ~/.config/$conf
  done
}

setupRemoteHomeDirSymlinks() {
  print_step "Setting up REMOTE dotfile symlinks in ~/ directory"
  create_symlink_with_backup ~/.config/bash/.bash_profile ~/.bash_profile
  create_symlink_with_backup ~/.config/bash/.bashrc       ~/.bashrc
  create_symlink_with_backup ~/.config/psql/.psqlrc       ~/.psqlrc
  create_symlink_with_backup ~/.config/readline/inputrc    ~/.inputrc
  create_symlink_with_backup ~/.config/vim                ~/.vim
  create_symlink_with_backup ~/.config/zsh/.zshenv        ~/.zshenv

}

setupLocalHomeDirSymlinks() {
  print_step "Setting up LOCAL dotfile symlinks in ~/ directory"
  create_symlink_with_backup ~/.config/tmux               ~/.tmux
  create_symlink_with_backup ~/.config/tmux/tmux.conf     ~/.tmux.conf
}


setupLocalDotfiles() {
  print_step "Setup local dotfiles directory if it does not exist"
  if [ ! -d $LOCAL_DOTDIR ]; then
    msg "Making local dotfiles directory $LOCAL_DOTDIR"
    mkdir -p $LOCAL_DOTDIR

    msg "Initializing local dotfiles directory as git repository"
    cd $LOCAL_DOTDIR
    git init

    msg "Creating empty 'desktop' directory in repo for .desktop files"
    mkdir desktop

    msg "Creating symlink to .desktop files directory in ~/.local/share/applications"
    create_symlink_with_backup $LOCAL_DOTDIR/desktop ~/.local/share/applications/local_dotdir

    msg "Creating empty local 'aliases' file in repo"
    touch aliases

    msg "Creating empty local 'rc' file in repo"
    touch rc

    msg "Committing empty local aliases/rc files"
    git add aliases rc
    git commit -m"Initial commit - adding empty aliases/rc files"
  else
    skipping "Local dotfiles directory at $LOCAL_DOTDIR already exists"
  fi
}


# -------------------------------------------------------------------------------
#  Dotfile "Profile" Methods
# -------------------------------------------------------------------------------
setupMinimalSystem() {
  installRemotePackages
  installStarship
  setupRemoteConfigDirSymlinks
  setupRemoteHomeDirSymlinks
  installNeovimPythonProvider
}

setupPersonalSystem() {
  installRemotePackages
  installLocalPackages
  installStarship

  # .config Setup
  setupRemoteConfigDirSymlinks
  setupLocalConfigDirSymlinks
  setupRemoteHomeDirSymlinks
  setupLocalHomeDirSymlinks
  setupLocalDotfiles

  installNeovimPythonProvider
  .config/tmux/install.sh

  desktop/install.sh
  git/install.sh

  gui/vscode/install.sh

  # NOT for remote machines - TODO figure out how to flag when to run these
  # ssh/install.sh
}