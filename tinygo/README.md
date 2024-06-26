# Adafruit PyPortal TinyGo experiments

Journaling [Adafruit PyPortal TinyGo](https://tinygo.org/docs/reference/microcontrollers/pyportal/) experiments here.

Hopefully This will work with the non-feather version of the board.

## Links

- [Adafruit PyPortal Overview](https://learn.adafruit.com/adafruit-pyportal)
- [Adafruit PyPortal Manual](https://cdn-learn.adafruit.com/downloads/pdf/adafruit-pyportal.pdf)
- [Adafruit PyPortal Pinouts](https://learn.adafruit.com/adafruit-pyportal/pinouts)
- [TinyGo Tutorial](https://tinygo.org/docs/tutorials/)
- [TinyGo Documentation](https://tinygo.org/docs/)
- [TinyGo Drivers](https://github.com/tinygo-org/drivers)
- [TinyGo PyPortal Documentation](https://tinygo.org/docs/reference/microcontrollers/machine/pyportal/)
- [TinyGo Packages](https://tinygo.org/docs/reference/lang-support/stdlib/)

## Editor

Getting `gopls` working requires the use of [tinygo-edit](https://github.com/sago35/tinygo-edit).

Didn't work with `helix` but it did work with `vim`. It only accepts the command name without file arguments.

```text
tinygo-edit --editor vim --target pyportal
```

## Installing Tools

Install TinyGo depdendencies:

```bash { background=false category=setup-tinygo closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=tinygo-install-dependencies promptEnv=true terminalRows=10 }
# install Atmel AVR microcontroller packages
sudo nala install -y --no-autoremove avr-libc avra avrdude avrdude-doc avrp dfu-programmer

go install github.com/sago35/tinygo-edit@latest
```

Install TinyGo:

```bash { background=false category=setup-tinygo closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=tinygo-install-cli promptEnv=true terminalRows=10 }
# install tinygo deb package

set -e

wget -c "$(curl -sSL https://api.github.com/repos/tinygo-org/tinygo/releases/latest | jq -r '.assets[].browser_download_url' | grep amd64[.]deb)"
printf "\n"

sudo dpkg -i "$(curl -sSL https://api.github.com/repos/tinygo-org/tinygo/releases/latest | jq -r '.assets[].name' | grep 'amd64[.]deb')"
printf "\n"

tinygo version
printf "\n"

# https://dev.to/sago35/tinygo-vim-gopls-48h1
cd /usr/local/lib/tinygo/src || exit 1
for d in device/* internal/* machine/ os/ reflect/ runtime/ runtime/interrupt/ runtime/volatile/ runtime/metrics/ runtime/trace/ sync/ testing/; do
    [[ -d ${d} ]] && sudo touch "${d}"/go.mod
done
sudo tee go.mod <<-EOF
module tinygo.org/x/drivers

go 1.22

replace (
EOF
for d in device/* internal/* machine/ os/ reflect/ runtime/ runtime/interrupt/ runtime/volatile/ runtime/metrics/ runtime/trace/ sync/ testing/; do
    printf "\t%s => %s\n" "${d}" "/usr/local/lib/tinygo/src/${d}" | sudo tee -a go.mod
done
sudo tee -a go.mod <<-EOF
)
EOF
find /usr/local/lib/tinygo/src -type f -name go.mod
cd -

jq . > pyportal.json <<EOF
{
  "inherits": [
    "atsamd51j20a"
  ],
  "build-tags": [
    "pyportal",
    "ninafw",
    "ninafw_machine_init"
  ],
  "serial": "usb",
  "flash-1200-bps-reset": "true",
  "flash-method": "msd",
  "serial-port": [
    "239a:8035",
    "239a:8036"
  ]
}
EOF
```

Setup new TinyGo module:

```bash { background=false category=setup-tinygo closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=tinygo-module-new promptEnv=true terminalRows=10 }
set -e

export PN="projectname"

mkdir "${PN}"
cd "${PN}"
go mod init "${PN}"
go get tinygo.org/x/drivers
ln -sv ../pyportal.json ./pyportal.json

tee -a go.mod <<-EOF

replace (
    drivers => ../lib/drivers
	device/arm => ../lib/tinygo/src/device/arm
	device/arm64 => ../lib/tinygo/src/device/arm64
	device/asm.go => ../lib/tinygo/src/device/asm.go
	device/avr => ../lib/tinygo/src/device/avr
	device/esp => ../lib/tinygo/src/device/esp
	device/gba => ../lib/tinygo/src/device/gba
	device/kendryte => ../lib/tinygo/src/device/kendryte
	device/nrf => ../lib/tinygo/src/device/nrf
	device/nxp => ../lib/tinygo/src/device/nxp
	device/riscv => ../lib/tinygo/src/device/riscv
	device/rp => ../lib/tinygo/src/device/rp
	device/sam => ../lib/tinygo/src/device/sam
	device/sifive => ../lib/tinygo/src/device/sifive
	device/stm32 => ../lib/tinygo/src/device/stm32
	internal/bytealg => ../lib/tinygo/src/internal/bytealg
	internal/fuzz => ../lib/tinygo/src/internal/fuzz
	internal/reflectlite => ../lib/tinygo/src/internal/reflectlite
	internal/task => ../lib/tinygo/src/internal/task
	machine/ => ../lib/tinygo/src/machine/
	os/ => ../lib/tinygo/src/os/
	reflect/ => ../lib/tinygo/src/reflect/
	runtime/ => ../lib/tinygo/src/runtime/
	runtime/interrupt/ => ../lib/tinygo/src/runtime/interrupt/
	runtime/volatile/ => ../lib/tinygo/src/runtime/volatile/
	runtime/metrics/ => ../lib/tinygo/src/runtime/metrics/
	runtime/trace/ => ../lib/tinygo/src/runtime/trace/
	sync/ => ../lib/tinygo/src/sync/
	testing/ => ../lib/tinygo/src/testing/
)
EOF
```

## TinyGo CLI commands

Compile and export the the elf and uf2 files to the project directory.

Using target `pyportal` seems to work for the Adafruit PyPortal.

```bash { background=false category=build-tinygo closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=tinygo-cli-compile promptEnv=true terminalRows=25 }
# choose an tinygo project and build it

set -e

# all paths are relative to the /tinygo directory

stty cols 80
stty rows 25

declare PF
declare WD
declare FN

gum format "# Please choose a TinyGo project to build:"
printf "\n"
PF="$(gum choose $(find ./* -maxdepth 1 -type f -name '*[.]go';))"
printf "\n"

# working directory
WD="$(dirname "${PF}")"
cd "${WD}" || exit

# project file
FN="$(basename "${PF}")"

echo Running: rm -fv "${FN//.go/.elf}" "${FN//.go/.uf2}"
time rm -fv "${FN//.go/.elf}" "${FN//.go/.uf2}"
printf "\n"

echo Running: tinygo build -target=./pyportal.json -o "${FN%.go}.uf2" "${FN}"
time tinygo build -target=./pyportal.json -o "${FN%.go}.uf2" "${FN}"
printf "\n"

# https://github.com/microsoft/uf2/blob/master/utils/uf2families.json
# tried base 0x00000000 and 0x00004000, neither works
# echo Running: uf2conv --base 0x00004000 --family=0x55114460 --output "${FN//.go/.uf2}" "${FN//.go/.elf}"
# time uf2conv --base 0x00004000 --family=0x55114460 --output "${FN//.go/.uf2}" "${FN//.go/.elf}"
# printf "\n"

file ./*uf2
printf "\n"

ls -lhv ./*uf2
printf "\n"
```

Before you can update the board, you need to reboot the Adafruit PyPortal into update mode by

- holding the `Boot` button
- pressing the `Reset` button
- let go of the `Boot` button
- wait for the `PORTALBOOT` drive to show up

```bash { background=false category=deploy-tinygo closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=tinygo-cli-upload promptEnv=true terminalRows=25 }
# choose a tinygo project and deploy it

if [[ ! -d /mnt/chromeos/removable/PORTALBOOT/ ]]; then
    printf "ERROR: You need to share the PORTALBOOT volume with Linux\n"
    exit 1
fi

if [[ ! -f /mnt/chromeos/removable/PORTALBOOT/INFO_UF2.TXT ]]; then
    printf "ERROR: Board isn't in UF2 update mode\n"
    exit 1
fi

set -e

# all paths are relative to the /tinygo directory

stty cols 80
stty rows 25

declare PF
declare TD

gum format "# Please choose a TinyGo project to deploy:"
printf "\n"
PF="$(gum choose $(find . -type f -name '*.uf2'))"
printf "\n"

if [[ -z ${PF} ]]; then
    printf "ERROR: no UF2 file selected\n"
    exit 1
fi

gum format "# Please choose the deploy target directory:"
printf "\n"
TD="$(gum choose $(find /mnt/chromeos/removable/ -maxdepth 1 -type d | grep -v -E '^/mnt/chromeos/removable/$'))"
printf "\n"

echo Running: cp -v "${PF}" "${TD}"
cp -v "${PF}" "${TD}"
echo done.
```

## Experiments

### [Hello World](helloworld/)

Using the official [TinyGo Tutorial](https://tinygo.org/docs/tutorials/) for this experiment.

Ok, after a lot of searching for how to use a NeoPixel with TinyGo, got it to work. Also got the LED working.

- Serial output doesn't work.
- Using this [pinout](https://learn.adafruit.com/adafruit-pyportal/pinouts) guide.

Current LSP setup, linting, etc, not working very well with TinyGo.
I got most of my debugging help from `tinygo build`.
Still, Arduino and TinyGo seems like the best options for me so far.
