// This is a hello world experiment using the neopixel.
package main

import (
	"fmt"
	"image/color"
	"machine"
	"math/rand/v2"
	"time"

	"tinygo.org/x/drivers/ws2812"
)

func main() {
	fmt.Println("Adafruit KB2040 Hello World, NeoPixel Rainbow")

	// https://learn.adafruit.com/adafruit-pyportal/pinouts
	// https://tinygo.org/docs/reference/microcontrollers/machine/pyportal/

	var neoPixel machine.Pin = machine.NEOPIXEL
	neoPixel.Configure(machine.PinConfig{Mode: machine.PinOutput})
	ws := ws2812.NewWS2812(neoPixel)

	ledLow := []color.RGBA{{R: 0x00, G: 0x00, B: 0x00, A: 0x00}}

	var led machine.Pin = machine.D13
	led.Configure(machine.PinConfig{Mode: machine.PinOutput})

	state := false

	// infinite loop
	for {
		if state {
			led.Low()

			// instead of 0-255, using 0-128 to dimm the NeoPixel
			red := uint8(rand.IntN(128))
			green := uint8(rand.IntN(128))
			blue := uint8(rand.IntN(128))
			alpha := uint8(rand.IntN(128))

			ledHigh := []color.RGBA{{R: red, G: green, B: blue, A: alpha}}

			fmt.Println("NeoPixel: on", ledHigh)

			err := ws.WriteColors(ledHigh)
			if err != nil {
				fmt.Println("ERROR: failed to write ledHigh to NeoPixel")
			}
		} else {
			led.High()

			fmt.Println("NeoPixel: off")

			err := ws.WriteColors(ledLow)
			if err != nil {
				fmt.Println("ERROR: failed to write ledLow to NeoPixel")
			}
		}

		state = !state

		time.Sleep(time.Millisecond * 1_000)
	}
}
