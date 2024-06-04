# adafruit-kb2040-workspace

[![actionlint](https://github.com/vpayno/adafruit-kb2040-workspace/actions/workflows/gh-actions.yaml/badge.svg?branch=main)](https://github.com/vpayno/adafruit-kb2040-workspace/actions/workflows/gh-actions.yaml)
[![markdown](https://github.com/vpayno/adafruit-kb2040-workspace/actions/workflows/markdown.yaml/badge.svg?branch=main)](https://github.com/vpayno/adafruit-kb2040-workspace/actions/workflows/markdown.yaml)
[![rust](https://github.com/vpayno/adafruit-kb2040-workspace/actions/workflows/rust.yaml/badge.svg?branch=main)](https://github.com/vpayno/adafruit-kb2040-workspace/actions/workflows/rust.yaml)
[![spellcheck](https://github.com/vpayno/adafruit-kb2040-workspace/actions/workflows/spellcheck.yaml/badge.svg?branch=main)](https://github.com/vpayno/adafruit-kb2040-workspace/actions/workflows/spellcheck.yaml)
[![yaml](https://github.com/vpayno/adafruit-kb2040-workspace/actions/workflows/yaml.yaml/badge.svg?branch=main)](https://github.com/vpayno/adafruit-kb2040-workspace/actions/workflows/yaml.yaml)

Personal workspace for learning to use the Adafruit KB2040 with Rust, TinyGo, Arduino and Python.

## Links

- [Adafruit KB2040](https://learn.adafruit.com/adafruit-kb2040)

- [Arduino](https://learn.adafruit.com/adafruit-kb2040/arduino-ide-setup)
- [Rust](https://crates.io/crates/adafruit-kb2040)
- [TinyGo](https://tinygo.org/docs/reference/microcontrollers/feather-rp2040/)

## Experiments

- [Arduino](./arduino/README.md)
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
