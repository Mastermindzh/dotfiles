#!/bin/bash
# .NET / C# development aliases, functions and environment setup.
#
# This file is NOT auto-sourced. It is opt-in: install.sh symlinks it to
# ~/.dotnet-aliases on machines where .NET development is wanted, and ~/.alias
# sources it only when that symlink exists.

# Entity Framework
alias efupdate="dotnet ef database update"
alias efmigrate="dotnet ef migrations add"
alias efremove="dotnet ef migrations remove"

# project scaffolding
alias dotnetnew="dotnet new webapi -o "

# nuget
alias nuget-force-clear-cache="nuget locals all -clear && nuget locals all -list | awk '{split($0,a,\": \"); print a[2];}' | xargs rm -rf"

# clean .NET build artifacts (bin/obj) recursively
alias clean-obj-bin='sudo find . -name "bin" -o -name "obj" -exec rm -rf {} \;'

# install a specific dotnet sdk version straight from Microsoft.
# The AUR `dotnet-sdk` package covers the current release; use this only when
# you need a specific/older SDK version side-by-side that the AUR doesn't carry.
dotnet-install-sdk() {
  if [ -z "$1" ]; then
    echo "Usage: dotnet-install-sdk <version>"
    return 1
  fi
  curl -sSL https://dot.net/v1/dotnet-install.sh | sudo bash /dev/stdin --version "$1" --install-dir /usr/share/dotnet
}

# generate and trust the ASP.NET Core HTTPS dev cert.
# On Linux `dotnet dev-certs https --trust` exports the cert to
# ~/.aspnet/dev-certs/trust and trusts it in the NSS (browser) store via
# `certutil` (provided by the `nss` package). OpenSSL-based clients such as the
# .NET runtime, curl and Aspire's gRPC dashboard client only pick it up when
# SSL_CERT_DIR includes that folder, which the env block below sets up.
# Requires: `openssl` and `certutil` (nss) on PATH.
dotnet-trust-dev-cert() {
  dotnet dev-certs https --clean
  dotnet dev-certs https --trust
  echo "ASP.NET Core HTTPS dev cert trusted. Restart your shell, browser and VS Code to pick it up."
}

# environment setup (only when a dotnet binary is available)
if hash dotnet 2>/dev/null; then
  export DOTNET_ROOT=/usr/share/dotnet
  MSBuildSDKsPathVersion=$(${DOTNET_ROOT}/dotnet --version)
  export MSBuildSDKsPath=$DOTNET_ROOT/sdk/$MSBuildSDKsPathVersion/Sdks
  export PATH="${PATH}:${DOTNET_ROOT}:~/.dotnet/tools"

  # let OpenSSL clients (.NET runtime, curl, Aspire) discover the trusted dev cert
  dotnet_dev_certs="$HOME/.aspnet/dev-certs/trust"
  case ":${SSL_CERT_DIR:-}:" in
    *":$dotnet_dev_certs:"*) ;; # already present, don't append again
    *) export SSL_CERT_DIR="${SSL_CERT_DIR:-/etc/ssl/certs}:$dotnet_dev_certs" ;;
  esac
  unset dotnet_dev_certs
fi
