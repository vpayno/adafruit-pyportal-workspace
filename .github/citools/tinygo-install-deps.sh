#!/usr/bin/env bash

printf "\n"
printf "Installing TinyGo Deps and Tools:\n"
printf "\n"

declare deb_pkg
declare -a deb_pkgs=(
	minicom picocom setserial libfuse2 libusb-1.0-0-dev libudev-dev
	avr-libc avra avrdude avrdude-doc avrp dfu-programmer
	dpkg
)

# to reduce resolution conflicts, installing one at a time
time for deb_pkg in "${deb_pkgs[@]}"; do
	sudo apt install -y "${deb_pkg}"
done

declare crate
declare -a crates=(
	elf2uf2-rs
)

# in CI we don't need this
if command -v cargo >/dev/null; then
	for crate in "${crates[@]}"; do
		cargo install --locked "${crate}"
	done
fi
