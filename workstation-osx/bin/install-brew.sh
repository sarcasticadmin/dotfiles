#!/usr/bin/env bash

OS_PLATFORM=$(uname -s)
if [ ${OS_PLATFORM} == "Darwin" ];then  
  if ! command -v brew > /dev/null 2>&1; then
    echo "Installing HomeBrew package manager..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
    echo "Brew is already installed!"
  fi
fi
