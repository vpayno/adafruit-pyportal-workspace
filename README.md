# adafruit-pyportal-workspace

[![actionlint](https://github.com/vpayno/adafruit-pyportal-workspace/actions/workflows/gh-actions.yaml/badge.svg?branch=main)](https://github.com/vpayno/adafruit-pyportal-workspace/actions/workflows/gh-actions.yaml)
[![markdown](https://github.com/vpayno/adafruit-pyportal-workspace/actions/workflows/markdown.yaml/badge.svg?branch=main)](https://github.com/vpayno/adafruit-pyportal-workspace/actions/workflows/markdown.yaml)
[![rust](https://github.com/vpayno/adafruit-pyportal-workspace/actions/workflows/rust.yaml/badge.svg?branch=main)](https://github.com/vpayno/adafruit-pyportal-workspace/actions/workflows/rust.yaml)
[![spellcheck](https://github.com/vpayno/adafruit-pyportal-workspace/actions/workflows/spellcheck.yaml/badge.svg?branch=main)](https://github.com/vpayno/adafruit-pyportal-workspace/actions/workflows/spellcheck.yaml)
[![tinygo](https://github.com/vpayno/adafruit-pyportal-workspace/actions/workflows/tinygo.yaml/badge.svg?branch=main)](https://github.com/vpayno/adafruit-pyportal-workspace/actions/workflows/tinygo.yaml)
[![yaml](https://github.com/vpayno/adafruit-pyportal-workspace/actions/workflows/yaml.yaml/badge.svg?branch=main)](https://github.com/vpayno/adafruit-pyportal-workspace/actions/workflows/yaml.yaml)

Personal workspace for learning to use the Adafruit PyPortal M4 Express with Rust, TinyGo, Arduino and Python.

## Links

- [Adafruit PyPortal](https://learn.adafruit.com/adafruit-pyportal)

- [Arduino](https://learn.adafruit.com/adafruit-pyportal/using-with-arduino-ide)
- [CircuitPython](https://learn.adafruit.com/adafruit-pyportal/what-is-circuitpython)
- [Rust](https://crates.io/crates/pyportal)
- [TinyGo](https://tinygo.org/docs/reference/microcontrollers/pyportal/)

## Experiments

- [Arduino](./arduino/README.md)
- [CircuitPython](./circuitpython/README.md)
- [Rust](./rust/README.md)
- [TinyGo](./tinygo/README.md)

## RunMe Playbook

This and other readme files in this repo are RunMe Playbooks.

Use this playbook step/task to update the [RunMe](https://runme.dev) CLI.

If you don't have RunMe installed, you'll need to copy/paste the command. :)

```bash { background=false category=runme closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=setup-runme-install promptEnv=true terminalRows=10 }
go install github.com/stateful/runme/v3@v3
```

Install Playbook dependencies:

```bash { background=false category=runme closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=setup-runme-deps promptEnv=true terminalRows=10 }
go install github.com/charmbracelet/gum@latest
go install github.com/mikefarah/yq/v4@latest
```

## Generic Device/Firmware Playbook

Check installed firmware:

```bash { background=false category=setup-adafruit closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=adafruit-check-firmware promptEnv=true terminalRows=25 }
# check Adafruit firmware state

set -e

# all paths are relative to the /wippersnapper directory

stty cols 80
stty rows 25

declare OPT
declare TD

while [[ ${OPT} != "done" ]]; do
    gum format "# Please choose the USB target directory:"
    printf "\n"
    TD="$(gum choose $(find /mnt/chromeos/removable/ -maxdepth 1 -type d | grep -v -E '^/mnt/chromeos/removable/$') refresh done)"
    printf "\n"

    if [[ ${TD} == "refresh" ]]; then
        continue
    fi

    printf "Device contents (before):\n"
    tree "${TD}"
    printf "\n"

    printf "Waiting for device to flash and reboot"
    while [[ ! -d "${TD}" ]]; do
        printf "."
        sleep 1s
    done
    printf "\n\n"

    printf "Device contents (after):\n"
    tree "${TD}"
    printf "\n"

    if [[ -f ${TD}/INFO_UF2.TXT ]]; then
        tail -v "${TD}"/INFO_UF2.TXT
        printf "\n"

        file "${TD}"/CURRENT.UF2
        printf "\n"
    fi

    if [[ -f ${TD}/boot_out.txt ]]; then
        tail -v "${TD}"/boot_out.txt
        printf "\n"
    fi

    if [[ -f ${TD}/wipper_boot_out.txt ]]; then
        tail -v "${TD}"/wipper_boot_out.txt
        printf "\n"
    fi
done
true # so the job doesn't fail
```

Install Adafruit UF2 Bootloader:

Before you can update the board, you need to reboot the Adafruit PyPortal into update mode by

- double tap the `Reset` button
- wait for the `PORTALBOOT` drive to show up

```bash { background=false category=setup-adafruit closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=adafruit-install-bootloader promptEnv=true terminalRows=25 }
# install Adafruit bootloader

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

declare uf2_url="https://github.com/adafruit/uf2-samdx1/releases/download/v3.15.0/update-bootloader-pyportal_m4-v3.15.0.uf2"

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
while [[ ! -d ${TD} ]]; do
    printf "."
    sleep 1s
done
printf "\n\n"

printf "Device contents (after):\n"
tree "${TD}"
printf "\n"

tail -v "${TD}"/INFO_UF2.TXT
printf "\n"
```

Install [Adafruit PyPortal UF2 ESP32 firmware](https://learn.adafruit.com/upgrading-esp32-firmware/upgrade-all-in-one-esp32-airlift-firmware):

- [Adafruit WebSerial ESPTool](https://adafruit.github.io/Adafruit_WebSerial_ESPTool/)
- [ESP32 Airlift Firmware](https://learn.adafruit.com/upgrading-esp32-firmware/upgrade-all-in-one-esp32-airlift-firmware)

Before you can update the board, you need to reboot the Adafruit PyPortal into update mode by

- double tap the `Reset` button
- wait for the `PORTALBOOT` drive to show up

```bash { background=false category=setup-adafruit closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=adafruit-install-esp32fw promptEnv=true terminalRows=25 }
# install Adafruit ESP32 firmware

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

declare uf2_url="https://cdn-learn.adafruit.com/assets/assets/000/123/157/original/PyPortal_M4_ESP_32_Passthrough_TinyUSB_2023_07_30.uf2"

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

declare airlift_url="$(curl -sS https://api.github.com/repos/adafruit/nina-fw/releases/latest | jq -r '.assets[].browser_download_url')"

printf "Running: %s\n" "wget -c ${airlift_url}"
[[ -d fw ]] || mkdir fw
cd fw
time wget -c "${airlift_url}"
cd ..
printf "done.\n"
printf "\n"

printf "Use the Adafruit WebSerial ESPTool Tool to upload the NINA firmware bin file.\n"
```

Install [Adafruit PyPortal UF2 reset firmware](https://learn.adafruit.com/adafruit-pyportal/troubleshooting):

Before you can update the board, you need to reboot the Adafruit PyPortal into update mode by

- double tap the `Reset` button
- wait for the `PORTALBOOT` drive to show up

```bash { background=false category=setup-adafruit closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=adafruit-install-factory-reset promptEnv=true terminalRows=25 }
# install Adafruit factory-reset firmware

exit 1 # don't use this

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

declare uf2_url="https://cdn-learn.adafruit.com/assets/assets/000/072/252/original/PYPORTAL_QSPI_Eraser.UF2"

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
