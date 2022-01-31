#!/bin/bash

set -e
set -o pipefail

source $DOTDIR/lib/common.sh

#-------------------------------#
# Helper Methods                #
#-------------------------------#
install_packages() {
  print_step "Installing required packages"
  sudo apt install -y curl tmux vim zsh
}

install_starship() {
  print_step "Installing Starship terminal prompt"

  STARSHIP_EXEC=/usr/local/bin/starship
  if [ -f $STARSHIP_EXEC ]; then
    skipping "Starship already installed at [$STARSHIP_EXEC]"
  else
    sh -c "$(curl -fsSL https://starship.rs/install.sh)"
  fi
}

#-------------------------------#
# MAIN                          #
#-------------------------------#
# install_packages
# install_starship

.config/install.sh
.config/nvim/install.sh
.config/tmux/install.sh

desktop/install.sh
git/install.sh

# NOT for remote machines - TODO figure out how to flag when to run these
ssh/install.sh
