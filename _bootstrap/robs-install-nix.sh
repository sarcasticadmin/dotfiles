#!/bin/sh
# shellcheck disable=SC2086,SC2162,SC2039
set -e

GPGKEY="B541D55301270E0BCF15CA5D8170B4726D7198DE"
VERSION="${1:-2.3.15}"
DIR=$(mktemp -d)
INSTALLER=${DIR}/install-nix-${VERSION}

echo "tempdir: ${DIR}"

echo "Getting nix installer script version: ${VERSION} and signiture"

if command -pv curl > /dev/null 2>&1 ; then
  curl -Ss -o ${INSTALLER} https://releases.nixos.org/nix/nix-${VERSION}/install
  curl -Ss -o ${INSTALLER}.asc https://releases.nixos.org/nix/nix-${VERSION}/install.asc
else
  { echo 'cannot find curl, nix install needs it to function'; exit 1; }
fi

# Less look at this downloaded installer just in case
less ${INSTALLER}

echo -e "Talking to gpg key server\n"

if ! gpg --list-keys ${GPGKEY}> /dev/null 2>&1; then
  gpg --keyserver pgp.mit.edu --recv-keys ${GPGKEY}
fi
gpg --verify ${INSTALLER}.asc

while true; do
    read -p "Do you wish to install nix? " yn
    case $yn in
        [Yy]* ) sh ${INSTALLER}; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
