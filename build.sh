#! /usr/bin/env bash

if [ "$(uname)" == "Darwin" ]; then
    export DOTNET_INSTALL_DIR="$PWD/.dotnetsdk"
    export CLI_VERSION="2.0.0"
    curl -sSL https://raw.githubusercontent.com/dotnet/cli/rel/1.0.0/scripts/obtain/dotnet-install.sh | bash /dev/stdin --version "$CLI_VERSION" --install-dir "$DOTNET_INSTALL_DIR"
    export PATH="$DOTNET_INSTALL_DIR:$PATH"
else
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-trusty-prod trusty main" > /etc/apt/sources.list.d/dotnetdev.list'
    sudo apt-get update
    sudo apt-get install dotnet-sdk-2.0.0
fi

dotnet restore

if [ -z ${MONO_BUILD+x} ]; then
    # Build with dotnet
    dotnet build Grpc.Tools.MsBuild.sln -v normal
else
    # Build with Mono
    msbuild
fi
