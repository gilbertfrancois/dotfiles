#!/usr/bin/env bash

echo "--- Installing skuld"
if [[ `uname -s` == "Darwin" ]]; then
    sudo git config --system --unset credential.helper
    brew tap DEEP-IMPACT-AG/hyperdrive
    brew install skuld
elif [[ `uname -s` == "Linux" ]]; then
    if [[ `uname -m` == "aarch64" ]]; then
        sudo cp skuld/skuld_linux_aarch64 /usr/local/bin/skuld
    elif [[ `uname -m` == "x86_64" ]]; then
        sudo cp skuld/skuld_linux_amd64 /usr/local/bin/skuld
    fi
fi

