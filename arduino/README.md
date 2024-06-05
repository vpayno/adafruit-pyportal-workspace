# Adafruit KB2040 Arduino Experiments

Journaling [Adafruit KB2040 Arduino](https://learn.adafruit.com/adafruit-kb2040/arduino-ide-setup) experiments here.

## Links

- [Adafruit KB2040 Overview](https://learn.adafruit.com/adafruit-kb2040)
- [Adafruit KB2040 Manual](https://cdn-learn.adafruit.com/downloads/pdf/adafruit-kb2040.pdf)
- [Adafruit KB2040 Pinouts](https://learn.adafruit.com/adafruit-kb2040/pinouts)
- [Arduino Tutorial](https://learn.adafruit.com/adafruit-kb2040/arduino-ide-setup)
- [Arduino Documentation](https://docs.arduino.cc/)

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

Install the Arduino rp2040 boards package (also manually add it to your global IDE and CLI configs).

```bash { background=false category=setup-arduino closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=arduino-install-board promptEnv=true terminalRows=10 }
printf "board_manager:\n  additional_urls:\n    - %s\n" "https://github.com/earlephilhower/arduino-pico/releases/download/global/package_rp2040_index.json" | tee .arduino-cli.yaml
arduino-cli core update-index --config-file .arduino-cli.yaml
arduino-cli core install rp2040:rp2040 --config-file .arduino-cli.yaml
arduino-cli board details --fqbn rp2040:rp2040:adafruit_kb2040  # not a device query
```

Install Arduino libraries:

```bash { background=false category=setup-arduino closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=arduino-install-libraries promptEnv=true terminalRows=10 }
arduino-cli lib install "Adafruit NeoPixel"
```

## Arduino CLI commands

Compile and export the the bin, elf and uf2 files to `./build/rp2040.rp2040.adafruit_kb2040/`.

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

Before you can update the board, you need to reboot the Adafruit KB2040 into update mode by

- holding the `Boot` button
- pressing the `Reset` button
- let go of the `Boot` button
- wait for the `RPI-RP2` drive to show up

```bash { background=false category=deploy-arduino closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=arduino-cli-upload promptEnv=true terminalRows=25 }
# choose an arduino project and deploy it

if [[ ! -d /mnt/chromeos/removable/RPI-RP2/ ]]; then
    printf "ERROR: You need to share the RPI-RP2 volume with Linux\n"
    exit 1
fi

if [[ ! -f /mnt/chromeos/removable/RPI-RP2/INFO_UF2.TXT ]]; then
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

echo Running: cp -v ./build/rp2040.rp2040.adafruit_kb2040/*uf2 "${TD}"
cp -v ./build/rp2040.rp2040.adafruit_kb2040/*uf2 "${TD}"
echo done.
```

## Experiments

### [Hello World](helloworld/)

This experiment uses the example Adafruit KB2040 Neopixel blink sketch.
