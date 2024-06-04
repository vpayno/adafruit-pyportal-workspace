# Adafruit KB2040 TinyGo experiments

Journaling [Adafruit KB2040 TinyGo](https://tinygo.org/docs/reference/microcontrollers/feather-rp2040/) experiments here.

Hopefully This will work with the non-feather version of the board.

Hopefully TinyGo will work with the [Adafruit KB2040](https://www.adafruit.com/product/5302) since the documentation says
it works with the [Adafruit Feather KB2040](https://www.adafruit.com/product/4884).

## Links

- [Adafruit KB2040 Overview](https://learn.adafruit.com/adafruit-kb2040)
- [Adafruit KB2040 Manual](https://cdn-learn.adafruit.com/downloads/pdf/adafruit-kb2040.pdf)
- [Adafruit KB2040 Pinouts](https://learn.adafruit.com/adafruit-kb2040/pinouts)
- [TinyGo Tutorial](https://tinygo.org/docs/tutorials/)
- [TinyGo Documentation](https://tinygo.org/docs/)
- [TinyGo Drivers](https://github.com/tinygo-org/drivers)

## Installing Tools

Install TinyGo depdendencies:

```bash { background=false category=setup-tinygo closeTerminalOnSuccess=true excludeFromRunAll=true interactive=true interpreter=bash name=tinygo-install-dependencies promptEnv=true terminalRows=10 }
# install Atmel AVR microcontroller packages
sudo nala install -y --no-autoremove avr-libc avra avrdude avrdude-doc avrp dfu-programmer
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
```

## Experiments
