# Adafruit KB2040 Arduino Experiments

Journaling [Adafruit KB2040 Arduino](https://learn.adafruit.com/adafruit-kb2040/arduino-ide-setup) experiments here.

## Installing Tools

Install [Arduino](https://docs.arduino.cc/software/ide/) tooling dependencies.

```bash { background=false category=setup closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=arduino-install-dependencies promptEnv=true terminalRows=10 }
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

```bash { background=false category=setup closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=arduino-install-cli promptEnv=true terminalRows=10 }
# install arduino cli
if ! go install github.com/arduino/arduino-cli@latest; then
    curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | BINDIR="${HOME}/bin" sh
    arduino-cli version
fi
```

Install the Arduino IDE:

```bash { background=false category=setup closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=arduino-install-ide promptEnv=true terminalRows=10 }
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

Aditional Boards Manager URLs:

- [rp2040](https://github.com/earlephilhower/arduino-pico/releases/download/global/package_rp2040_index.json)

## Experiments
