module helloworld

go 1.22

require tinygo.org/x/drivers v0.27.0

require (
	github.com/aykevl/go-wasm v0.0.2-0.20220616010729-4a0a888aebdc // indirect
	github.com/blakesmith/ar v0.0.0-20150311145944-8bd4349a67f2 // indirect
	github.com/creack/goselect v0.1.2 // indirect
	github.com/gofrs/flock v0.8.1 // indirect
	github.com/google/shlex v0.0.0-20191202100458-e7afc7fbc510 // indirect
	github.com/inhies/go-bytesize v0.0.0-20220417184213-4913239db9cf // indirect
	github.com/marcinbor85/gohex v0.0.0-20200531091804-343a4b548892 // indirect
	github.com/mattn/go-colorable v0.1.8 // indirect
	github.com/mattn/go-isatty v0.0.12 // indirect
	github.com/mattn/go-tty v0.0.4 // indirect
	github.com/sigurn/crc16 v0.0.0-20211026045750-20ab5afb07e3 // indirect
	github.com/tinygo-org/tinygo v0.31.2 // indirect
	go.bug.st/serial v1.6.0 // indirect
	golang.org/x/sys v0.16.0 // indirect
	golang.org/x/tools v0.17.0 // indirect
	tinygo.org/x/go-llvm v0.0.0-20240106122909-c2c543540318 // indirect
)

replace (
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
	drivers => ../lib/drivers
	internal/bytealg => ../lib/tinygo/src/internal/bytealg
	internal/fuzz => ../lib/tinygo/src/internal/fuzz
	internal/reflectlite => ../lib/tinygo/src/internal/reflectlite
	internal/task => ../lib/tinygo/src/internal/task
	machine => ../lib/tinygo/src/machine/
	os => ../lib/tinygo/src/os/
	reflect => ../lib/tinygo/src/reflect/
	runtime => ../lib/tinygo/src/runtime/
	runtime/interrupt => ../lib/tinygo/src/runtime/interrupt/
	runtime/metrics => ../lib/tinygo/src/runtime/metrics/
	runtime/trace => ../lib/tinygo/src/runtime/trace/
	runtime/volatile => ../lib/tinygo/src/runtime/volatile/
	sync => ../lib/tinygo/src/sync/
	testing => ../lib/tinygo/src/testing/
)
