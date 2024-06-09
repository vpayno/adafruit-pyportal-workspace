module helloworld

go 1.22

require tinygo.org/x/drivers v0.27.0

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
	machine => ../lib/tinygo/src/machine/
	os => ../lib/tinygo/src/os/
	reflect => ../lib/tinygo/src/reflect/
	runtime  => ../lib/tinygo/src/runtime/
	runtime/interrupt  => ../lib/tinygo/src/runtime/interrupt/
	runtime/volatile  => ../lib/tinygo/src/runtime/volatile/
	runtime/metrics  => ../lib/tinygo/src/runtime/metrics/
	runtime/trace  => ../lib/tinygo/src/runtime/trace/
	sync  => ../lib/tinygo/src/sync/
	testing  => ../lib/tinygo/src/testing/
)
