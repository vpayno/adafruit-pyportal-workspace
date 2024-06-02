#!/usr/bin/env bash

printf "\n"
printf "Installing Rust Deps and Tools:\n"
printf "\n"

declare deb_pkg
declare -a deb_pkgs=(
	minicom picocom setserial libfuse2 libusb-1.0-0-dev libudev-dev
	gdb-multiarch gdb-arm-none-eabi openocd qemu-system-arm cmake
)

# to reduce resolution conflicts, installing one at a time
time for deb_pkg in "${deb_pkgs[@]}"; do
	sudo apt install -y "${deb_pkg}"
done

declare crate
declare -a crates=(
	cargo-binutils
	cargo-generate
	elf2uf2-rs
	probe-rs-tools
	cargo-hf2
	hf2-cli
	uf2conv
)

for crate in "${crates[@]}"; do
	cargo install --locked "${crate}"
done

rustup target add thumbv6m-none-eabi
