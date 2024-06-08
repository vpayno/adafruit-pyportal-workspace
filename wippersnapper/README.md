# Adafruit PyPortal WipperSnapper Experiments

Journaling [Adafruit PyPortal WipperSnapper](https://learn.adafruit.com/quickstart-adafruit-io-wippersnapper/wippersnapper-overview) experiments here.

## Links

- [Adafruit PyPortal Overview](https://learn.adafruit.com/adafruit-pyportal)
- [Adafruit PyPortal Manual](https://cdn-learn.adafruit.com/downloads/pdf/adafruit-pyportal.pdf)
- [Adafruit PyPortal Pinouts](https://learn.adafruit.com/adafruit-pyportal/pinouts)
- [Adafruit IO](https://io.adafruit.com/)
- [Adafruit WipperSnapper](https://learn.adafruit.com/quickstart-adafruit-io-wippersnapper/wippersnapper-overview)

## Installing Tools

Download the latest WipperSnapper (uf2 file) for the [Adafruit PyPortal](https://www.adafruit.com/product/4116) and copy it to the `PORTALBOOT` drectory.

```bash { background=false category=setup-wippersnapper closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=wippersnapper-download-firmware promptEnv=true terminalRows=25 }
# download Adafruit WipperSnapper firmware

set -e

# all paths are relative to the /wippersnapper directory

stty cols 80
stty rows 25

declare TD

declare uf2_url="https://io.adafruit.com/wipper_releases/pyportal-tinyusb"

rm -fv ./fw/wippersnapper.pyportal_tinyusb.uf2
printf "Running: %s\n" "wget -c ${uf2_url}"
[[ -d fw ]] || mkdir fw
cd fw || exit 1
time wget -c "${uf2_url}"
mv -v pyportal-tinyusb wippersnapper.pyportal_tinyusb.uf2
cd .. || exit 1
printf "done.\n"
printf "\n"
```

Install [Adafruit PyPortal UF2 WipperSnapper WiFi firmware](https://io.adafruit.com/vpayno/devices/new/pyportal-tinyusb/uf2/step-4):

Before you can update the board, you need to reboot the Adafruit PyPortal into update mode by

- double tap the `Reset` button
- wait for the `PORTALBOOT` drive to show up

```bash { background=false category=setup-wippersnapper closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=wippersnapper-install-firmware promptEnv=true terminalRows=25 }
# install Adafruit WipperSnapper firmware

set -e

if [[ ! -d /mnt/chromeos/removable/PORTALBOOT/ ]]; then
    printf "ERROR: You need to share the PORTALBOOT volume with Linux\n"
    exit 1
fi

if [[ ! -f /mnt/chromeos/removable/PORTALBOOT/INFO_UF2.TXT ]]; then
    printf "ERROR: Board isn't in UF2 update mode\n"
    exit 1
fi

# all paths are relative to the /wippersnapper directory

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

declare uf2_url="https://io.adafruit.com/wipper_releases/pyportal-tinyusb"

printf "Running: %s\n" "cp -v ./fw/wippersnapper.pyportal_tinyusb.uf2 ${TD}/"
cp -v ./fw/wippersnapper.pyportal_tinyusb.uf2 "${TD}/"
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

tail -v "${TD}"/wipper_boot_out.txt
printf "\n"
```

## Experiments
