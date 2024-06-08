# Adafruit PyPortal Arduino Experiments

Journaling [Adafruit PyPortal Arduino](https://learn.adafruit.com/adafruit-pyportal/setup) experiments here.

## Links

- [Adafruit PyPortal Overview](https://learn.adafruit.com/adafruit-pyportal)
- [Adafruit PyPortal Manual](https://cdn-learn.adafruit.com/downloads/pdf/adafruit-pyportal.pdf)
- [Adafruit PyPortal Pinouts](https://learn.adafruit.com/adafruit-pyportal/pinouts)
- [Arduino Tutorial](https://learn.adafruit.com/adafruit-pyportal/setup)
- [Arduino Documentation](https://docs.arduino.cc/)
- [Arduino Test](https://learn.adafruit.com/adafruit-pyportal/arduino-test)

## Installing Tools

Install [Arduino](https://docs.arduino.cc/software/ide/) tooling dependencies.

```bash { background=false category=setup-arduino closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=arduino-install-dependencies promptEnv=true terminalRows=10 }
# install arduino tooling dependencies

set -e

printf "\n"

sudo nala install -y --no-autoremove minicom picocom setserial libfuse2

sudo tee /etc/udev/rules.d/99-arduino.rules <<EOF
SUBSYSTEMS=="usb", ATTRS{idVendor}=="2341", GROUP="plugdev", MODE="0666"
EOF

sudo udevadm control --reload-rules
printf "\n"

sudo lsusb
printf "\n"
```

Install the Arduino CLI:

```bash { background=false category=setup-arduino closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=arduino-install-cli promptEnv=true terminalRows=10 }
# install arduino cli

printf "Adding fqbn config.\n"
printf "%s\n" "arduino:samd:adafruit_pyportal" | tee .arduino-fqbn.conf
printf "\n"

printf "Adding local copy of the arduino cli config.\n"
arduino-cli config dump | tee .arduino-cli.yaml
yamlfix --config-file ~/.vim/configs/yamlfix-custom.toml .arduino-cli.yaml
printf "\n"

if ! go install github.com/arduino/arduino-cli@latest; then
    curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | BINDIR="${HOME}/bin" sh
    arduino-cli version
fi
```

Install the Arduino IDE:

```bash { background=false category=setup-arduino closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=arduino-install-ide promptEnv=true terminalRows=10 }
# install arduino ide
set -e

mkdir -pv "${HOME}/.local/"
cd "${HOME}/.local/" || exit

printf -v zip_url "%s" "$(curl -sS https://api.github.com/repos/arduino/arduino-ide/releases/latest | jq -r '.assets[].browser_download_url' | grep '_Linux_64bit.zip$')"
printf -v zip_ver "%s" "$(curl -sS https://api.github.com/repos/arduino/arduino-ide/releases/latest | jq -r '.name')"
printf -v zip_name "%s" "$(curl -sS https://api.github.com/repos/arduino/arduino-ide/releases/latest | jq -r '.assets[].name' | grep Linux_64bit.zip)"

wget "${zip_url}"
unzip "./${zip_name}"
rm -fv "./${zip_name}"
rm -fv arduino-ide
ln -sv "./arduino-ide_${zip_ver}_Linux_64bit" arduino-ide

mkdir -pv "${HOME}/bin"
cat > "${HOME}/bin/arduino-ide" <<-EOF
#!/usr/bin/env bash

cd "${HOME}/.local/arduino-ide" || exit

exec ./arduino-ide "${@}"
EOF
chmod -v a+x "${HOME}/bin/arduino-ide"
```

Install PyPortal [Arduino self-test](https://learn.adafruit.com/adafruit-pyportal/arduino-test) firmware:

```bash { background=false category=setup-arduino closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=arduino-install-selftest promptEnv=true terminalRows=25 }
# install Adafruit Arduino self-test firmware

set -e

if [[ ! -d /mnt/chromeos/removable/PORTALBOOT/ ]]; then
    printf "ERROR: You need to share the PORTALBOOT volume with Linux\n"
    exit 1
fi

if [[ ! -f /mnt/chromeos/removable/PORTALBOOT/INFO_UF2.TXT ]]; then
    printf "ERROR: Board isn't in UF2 update mode\n"
    exit 1
fi

# all paths are relative to the /circuitpython directory

stty cols 80
stty rows 25

declare TD

gum format "# Please choose the deploy target directory:"
printf "\n"
TD="$(gum choose $(find /mnt/chromeos/removable/ -maxdepth 1 -type d | grep -v -E '^/mnt/chromeos/removable/$'))"
printf "\n"

printf "Device contents (before):\n"
tree "${TD}"
printf "\n"

declare uf2_url="https://cdn-learn.adafruit.com/assets/assets/000/107/658/original/PyPortal_Self_Test.UF2"

printf "Running: %s\n" "wget -c ${uf2_url}"
[[ -d fw ]] || mkdir fw
cd fw
time wget -c "${uf2_url}"
cd ..
printf "done.\n"
printf "\n"

printf "Running: %s\n" "cp -v ./fw/${uf2_url##*/} ${TD}/"
cp -v "./fw/${uf2_url##*/}" "${TD}/"
printf "done.\n"
printf "\n"
```

Install the Arduino SAMD boards package (also manually add it to your global IDE and CLI configs).

It seems like it should be supported but I can't find the FQBN for it.
I guess I need to experiment to see which one was used for the precompiled UF2 files Adafruit makes available.

```text
Port         Protocol Type              Board Name FQBN Core
/dev/ttyACM0 serial   Serial Port (USB) Unknown
```

```bash { background=false category=setup-arduino closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=arduino-install-board promptEnv=true terminalRows=10 }
printf "board_manager:\n  additional_urls:\n    - %s\n" "https://adafruit.github.io/arduino-board-index/package_adafruit_index.json" | tee .arduino-cli.yaml
arduino-cli core update-index --config-file .arduino-cli.yaml
arduino-cli core install arduino:samd --config-file .arduino-cli.yaml
arduino-cli board listall | grep arduino:samd
arduino-cli board details --fqbn arduino:samd:adafruit_pyboard # not a device query
```

Install Arduino libraries:

```bash { background=false category=setup-arduino closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=arduino-install-libraries promptEnv=true terminalRows=10 }
arduino-cli lib install "Adafruit NeoPixel"
```

## Arduino CLI commands

Compile and export the the bin, elf and uf2 files to `./build/arduino.samd.adafruit_pyportal/`.

```bash { background=false category=build-arduino closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=arduino-cli-compile promptEnv=true terminalRows=25 }
# choose an arduino project and build it

set -e

# all paths are relative to the /arduino directory

stty cols 80
stty rows 25

declare WD

gum format "# Please choose an Arduino project to build:"
printf "\n"
WD="$(gum choose $(find ./ -maxdepth 1 -type d | grep -v -E '^[.][/]$'))"

cd "${WD}" || exit 1
pwd
ls
printf "\n"

../tool-compile
```

Before you can update the board, you need to reboot the Adafruit PyPortal into update mode by

- double-tap the `Reset` button
- wait for the `PORTALBOOT` drive to show up

```bash { background=false category=deploy-arduino closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=arduino-cli-upload promptEnv=true terminalRows=25 }
# choose an arduino project and deploy it

if [[ ! -d /mnt/chromeos/removable/PORTALBOOT/ ]]; then
    printf "ERROR: You need to share the PORTALBOOT volume with Linux\n"
    exit 1
fi

if [[ ! -f /mnt/chromeos/removable/PORTALBOOT/INFO_UF2.TXT ]]; then
    printf "ERROR: Board isn't in UF2 update mode\n"
    exit 1
fi

set -e

# all commands are relative to the /arduino directory

stty cols 80
stty rows 25

declare WD
declare TD

gum format "# Please choose an Arduino project to deploy:"
printf "\n"
WD="$(gum choose $(find ./ -maxdepth 1 -type d | grep -v -E '^[.][/]$'))"

gum format "# Please choose the deploy target directory:"
printf "\n"
TD="$(gum choose $(find /mnt/chromeos/removable/ -maxdepth 1 -type d | grep -v -E '^/mnt/chromeos/removable/$'))"

cd "${WD}" || exit 1
pwd
ls
printf "\n"

echo Running: cp -v ./build/arduino:samd.adafruit_pyportal/*uf2 "${TD}"
cp -v ./build/arduino:samd.adafruit_pyportal/*uf2 "${TD}"
echo done.
```

## Experiments

### [Hello World](helloworld/)

This experiment uses the example Adafruit PyPortal Neopixel blink sketch.
