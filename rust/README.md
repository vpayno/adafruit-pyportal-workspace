# Adafruit KB2040 Rust Experiments

Journaling [Adafruit KB2040 Rust](https://crates.io/crates/adafruit-kb2040) experiments here.

## Installing Tools

The RP2024 uses a `ARM Cortex-M0+` processor.

Install Rust tooling dependencies.

```bash { background=false category=setup closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=rust-install-dependencies promptEnv=true terminalRows=10 }
# install rust tooling dependencies

set -e

sudo nala install -y --no-autoremove minicom picocom setserial libfuse2 libusb-1.0-0-dev libudev-dev cmake
printf "\n"

sudo nala install -y --no-autoremove gdb-multiarch gdb-arm-none-eabi openocd qemu-system-arm
printf "\n"

cargo install --locked cargo-binutils
cargo install --locked cargo-generate
cargo install --locked elf2uf2-rs
cargo install --locked probe-rs-tools
cargo install --locked cargo-hf2
cargo install --locked hf2-cli
cargo install --locked uf2conv

printf "\n"

rustup component add llvm-tools
printf "\n"

rustup target add thumbv6m-none-eabi  # M0, M0+, M1 (ARMv6-M)
printf "\n"

printf "Creating %s\n" /etc/udev/rules.d/99-adafruit.rules
sudo tee /etc/udev/rules.d/99-adafruit.rules <<EOF
ATTRS{idVendor}=="239a", ENV{ID_MM_DEVICE_IGNORE}="1"
SUBSYSTEM=="usb", ATTRS{idVendor}=="239a", MODE="0666"
SUBSYSTEM=="tty", ATTRS{idVendor}=="239a", MODE="0666"
EOF

printf "Creating %s\n" /etc/udev/rules.d/99-arduino.rules
sudo tee /etc/udev/rules.d/99-arduino.rules <<EOF
SUBSYSTEMS=="usb", ATTRS{idVendor}=="2341", GROUP="plugdev", MODE="0666"
EOF

printf "Creating %s\n" /etc/udev/rules.d/99-st-link.rules
sudo tee /etc/udev/rules.d/99-st-link.rules <<EOF
# STM32F3DISCOVERY rev A/B - ST-LINK/V2
ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", TAG+="uaccess"
# STM32F3DISCOVERY rev C+ - ST-LINK/V2-1
ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", TAG+="uaccess"
EOF

sudo udevadm control --reload-rules
printf "\n"

sudo udevadm trigger
printf "\n"

sudo lsusb
printf "\n"

sudo lsscsi
printf "\n"
```

## Experiments
