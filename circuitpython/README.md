# Adafruit PyPortal CircuitPython Experiments

Journaling [Adafruit PyPortal CircuitPython](https://learn.adafruit.com/adafruit-pyportal/circuitpython) experiments here.

## Links

- [Adafruit PyPortal Overview](https://learn.adafruit.com/adafruit-pyportal)
- [Adafruit PyPortal Manual](https://cdn-learn.adafruit.com/downloads/pdf/adafruit-pyportal.pdf)
- [Adafruit PyPortal Pinouts](https://learn.adafruit.com/adafruit-pyportal/pinouts)
- [CircuitPython Libraries](https://circuitpython.org/libraries)
- [mpy-cross](https://adafruit-circuit-python.s3.amazonaws.com/index.html?prefix=bin/mpy-cross/)
- [CircuitPython Tutorial](https://learn.adafruit.com/welcome-to-circuitpython)
- [CircuitPython settings.toml](https://learn.adafruit.com/scrolling-countdown-timer/create-your-settings-toml-file)

## Libraries

- [Adafruit CircuitPython NeoPixel](https://docs.circuitpython.org/projects/neopixel/en/latest/)

## Editors

The mu editor needs a really old version of Python.

The [CircuitPython Web Editor](https://code.circuitpython.org/) might be a good alternative.
Nope, it doesn't look like you can import Adafruit libraries into the web editor.
You can use the web editor as a serial console.

## Installing Tools

Install Adafruit CicruitPython firmware:

Before you can update the board, you need to reboot the Adafruit PyPortal into update mode by

- double tap the `Reset` button
- wait for the `PORTALBOOT` drive to show up

```bash { background=false category=setup-circuitpython closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=circuitpython-install-firmware promptEnv=true terminalRows=25 }
# install Adafruit CircuitPython firmware

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

declare uf2_url="https://downloads.circuitpython.org/bin/pyportal/en_US/adafruit-circuitpython-pyportal-en_US-9.0.5.uf2"

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

sleep 5s

printf "Waiting for device to flash and reboot"
while [[ ! -d /mnt/chromeos/removable/CIRCUITPY/ ]]; do
    printf "."
    sleep 1s
done
printf "\n\n"

printf "Device contents (after):\n"
tree /mnt/chromeos/removable/CIRCUITPY/
printf "\n"

tail -v /mnt/chromeos/removable/CIRCUITPY/boot_out.txt
printf "\n"
```

Install Adafruit [CircuitPython libraries](https://circuitpython.org/libraries):

```bash { background=false category=setup-circuitpython closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=circuitpython-install-libraries promptEnv=true terminalRows=25 }
# install Adafruit CircuitPython libraries

set -e

if [[ ! -d /mnt/chromeos/removable/CIRCUITPY/ ]]; then
    printf "ERROR: You need to share the CIRCUITPY volume with Linux\n"
    exit 1
fi

if [[ ! -f /mnt/chromeos/removable/CIRCUITPY/boot_out.txt ]]; then
    printf "ERROR: Board isn't in CircuitPython update mode\n"
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

declare zip_url="https://github.com/adafruit/Adafruit_CircuitPython_Bundle/releases/download/20240604/adafruit-circuitpython-bundle-9.x-mpy-20240604.zip"

cd lib || exit 1
printf "Running: %s\n" "wget -c ${zip_url}"
wget -c "${zip_url}"
unzip "${zip_url##*/}"
cd - || exit 1

printf "Running: %s\n" "cp -v ./lib/adafruit-circuitpython-bundle-9.x-mpy-*/lib ${TD}/"
cp -vr ./lib/adafruit-circuitpython-bundle-9.x-mpy-*/lib "${TD}/"
printf "done.\n"
printf "\n"

printf "Device contents (after):\n"
tree "${TD}"
printf "\n"
```

Deploy selected code.py file to USB drive:

```bash { background=false category=setup-circuitpython closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=circuitpython-install-code promptEnv=true terminalRows=25 }
# install code.py file

set -e

if [[ ! -d /mnt/chromeos/removable/CIRCUITPY/ ]]; then
    printf "ERROR: You need to share the CIRCUITPY volume with Linux\n"
    exit 1
fi

if [[ ! -f /mnt/chromeos/removable/CIRCUITPY/boot_out.txt ]]; then
    printf "ERROR: Board isn't in CircuitPython update mode\n"
    exit 1
fi

# all paths are relative to the /circuitpython directory

stty cols 80
stty rows 25

declare PF

gum format "# Please choose a CircuitPython project to build:"
printf "\n"
PF="$(gum choose $(find ./* -maxdepth 1 -type f -name 'code.py';))"
printf "\n"

declare TD

gum format "# Please choose the deploy target directory:"
printf "\n"
TD="$(gum choose $(find /mnt/chromeos/removable/ -maxdepth 1 -type d | grep -v -E '^/mnt/chromeos/removable/$'))"
printf "\n"

printf "Device contents (before):\n"
tree "${TD}"
printf "\n"

printf "Running: %s\n" "cp -v ${PF//code.py/secrets}.* ${TD}"
cp -v "${PF//code.py/secrets}".* "${TD}"
printf "done.\n"
printf "\n"

printf "Running: %s\n" "cp -v ${PF} ${TD}"
cp -v "${PF}" "${TD}"
printf "done.\n"
printf "\n"

printf "Device contents (after):\n"
ls "${TD}"
printf "\n"

printf "Running: %s\n" "sync ${TD}"
sync "${TD}"
printf "\n"
```

## Experiments

### [Hello World](helloworld/)

Simple program that blinks the NeoPixel and changes it's color randomly.
