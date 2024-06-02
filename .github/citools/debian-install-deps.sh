#!/usr/bin/env bash

printf "\n"
printf "Installing Debian 12 project dependencies:\n"
printf "\n"

declare deb_pkg
declare -a deb_pkgs=(
	lcov llvm clang clang libclang-dev
	build-essential curl wget libssl-dev
	pkg-config
)

# to reduce resolution conflicts, installing one at a time
time for deb_pkg in "${deb_pkgs[@]}"; do
	sudo apt install -y "${deb_pkg}"
done
