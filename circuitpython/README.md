# adafruit-kb2040 CircuitPython experiments

Journaling [Adafruit KB2040 CircuitPython](https://learn.adafruit.com/adafruit-kb2040/circuitpython) experiments here.

## Links

- [Adafruit KB2040 Overview](https://learn.adafruit.com/adafruit-kb2040)
- [Adafruit KB2040 Manual](https://cdn-learn.adafruit.com/downloads/pdf/adafruit-kb2040.pdf)
- [Adafruit KB2040 Pinouts](https://learn.adafruit.com/adafruit-kb2040/pinouts)
- [CircuitPython Libraries](https://circuitpython.org/libraries)
- [mpy-cross](https://adafruit-circuit-python.s3.amazonaws.com/index.html?prefix=bin/mpy-cross/)
- [CircuitPython Tutorial](https://learn.adafruit.com/welcome-to-circuitpython)
- [CircuitPython settings.toml](https://learn.adafruit.com/scrolling-countdown-timer/create-your-settings-toml-file)

## Editors

The mu editor needs a really old version of Python.

The [CircuitPython Web Editor](https://code.circuitpython.org/) might be a good alternative.
Nope, it doesn't look like you can import Adafruit libraries into the web editor.
You can use the web editor as a serial console.

## Installing Tools

Download the latest CircuitPython (uf2 file) for the [Adafruit KB2040](https://circuitpython.org/board/adafruit_kb2040/) and copy it to the RPI-PR2 drectory.

Install Adafruit CicruitPython firmware:

```bash { background=false category=setup-circuitpython closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=circuitpython-install-firmware promptEnv=true terminalRows=25 }
# install Adafruit CircuitPython firmware

set -e

if [[ ! -d /mnt/chromeos/removable/RPI-RP2/ ]]; then
    printf "ERROR: You need to share the RPI-RP2 volume with Linux\n"
    exit 1
fi

if [[ ! -f /mnt/chromeos/removable/RPI-RP2/INFO_UF2.TXT ]]; then
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

declare uf2_url="https://downloads.circuitpython.org/bin/adafruit_kb2040/en_US/adafruit-circuitpython-adafruit_kb2040-en_US-9.0.5.uf2"

printf "Running: %s\n" "wget -c ${uf2_url}"
[[ -d fw ]] || mkdir fw
cd fw
time wget -c "${uf2_url}"
cd ..
printf "done.\n"
printf "\n"

printf "Running: %s\n" "cp -v ./fw/adafruit-circuitpython-adafruit_kb2040-en_US-*uf2 ${TD}/"
cp -v ./fw/adafruit-circuitpython-adafruit_kb2040-en_US-*uf2 "${TD}/"
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
```

Install Adafruit libraries:

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

printf "Running: %s\n" "cp -v ./lib/*/*py ${TD}/lib/"
cp -v ./lib/*/*py "${TD}/lib/"
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

printf "Running: %s\n" "cp -v ${PF//code.py/settings.toml} ${TD}"
cp -v "${PF//code.py/settings.toml}" "${TD}"
printf "done.\n"
printf "\n"

printf "Running: %s\n" "cp -v ${PF} ${TD}"
cp -v "${PF}" "${TD}"
printf "done.\n"
printf "\n"

printf "Device contents (after):\n"
tree "${TD}"
printf "\n"

printf "Running: %s\n" "sync ${TD}"
sync "${TD}"
printf "\n"
```

Install [Adafruit KB2040 UF2 factory reset firmware](https://learn.adafruit.com/adafruit-kb2040/factory-reset):

Before you can update the board, you need to reboot the Adafruit KB2040 into update mode by

- holding the `Boot` button
- pressing the `Reset` button
- let go of the `Boot` button
- wait for the `RPI-RP2` drive to show up

```bash { background=false category=setup-circuitpython closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=circuitpython-factory-reset promptEnv=true terminalRows=25 }
# factory reset Adafruit firmware

set -e

if [[ ! -d /mnt/chromeos/removable/RPI-RP2/ ]]; then
    printf "ERROR: You need to share the RPI-RP2 volume with Linux\n"
    exit 1
fi

if [[ ! -f /mnt/chromeos/removable/RPI-RP2/INFO_UF2.TXT ]]; then
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

declare uf2_url="https://github.com/adafruit/Adafruit-KB2040-PCB/raw/main/factory-reset/kb2040-factory-reset.uf2"

printf "Running: %s\n" "wget -c ${uf2_url}"
[[ -d fw ]] || mkdir fw
cd fw
time wget -c "${uf2_url}"
cd ..
printf "done.\n"
printf "\n"

printf "Running: %s\n" "cp -v ./fw/kb2040-factory-reset.uf2 ${TD}/"
cp -v ./fw/kb2040-factory-reset.uf2 "${TD}/"
printf "done.\n"
printf "\n"
```

## Experiments
