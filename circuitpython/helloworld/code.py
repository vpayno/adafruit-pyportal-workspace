import random
import time

import board
import neopixel

print("NeoPixel Hello World")

pixels = neopixel.NeoPixel(board.NEOPIXEL, 1)

pixels[0] = (0, 85, 170)
pixels.show()
time.sleep(2.0)

while True:
    pixels[0] = (random.randint(0, 128), random.randint(0, 128), random.randint(0, 128))
    print("NeoPixel set to ", pixels[0])
    pixels.show()
    time.sleep(0.5)
