import random
import time

import board
import neopixel
from adafruit_button import Button
from adafruit_pyportal import PyPortal

print("PyPortal Hello NeoPixel")

# should write this to the FS instead of the console
print(dir(board))
time.sleep(1.0)

pixel_brightness: float = 0.3
pixel = neopixel.NeoPixel(board.NEOPIXEL, 30, brightness=pixel_brightness)
pixel.fill(0)

colors: list[tuple[int, int, int]] = [
    (255, 0, 0),  # red
    (255, 34, 0),  # orange
    (255, 170, 0),  # yellow
    (0, 255, 0),  # green
    (0, 255, 255),  # cyan
    (0, 0, 255),  # blue
    (153, 0, 255),  # violet
    (255, 0, 51),  # magenta
    (255, 51, 119),  # pink
    (85, 125, 255),  # aqua
    (255, 255, 255),  # white
    (0, 0, 0),  # off
]

cwd: str = ("/" + __file__).rsplit("/", 1)[0]
bg_image: str = cwd + "/quote_background.bmp"
font_file: str = cwd + "/fonts/Arial-ItalicMT-17.bdf"

time.sleep(2.0)

pyportal = PyPortal(
    default_bg=bg_image,
    text_font=font_file,
    text_position=((20, 120)),
    text_color=(0xFFFFFF),
)

pyportal.preload_font()

color: tuple[int, int, int] = colors[-1]

button = Button(
    x=135,
    y=90,
    width=60,
    height=60,
    style=Button.SHADOWROUNDRECT,
    fill_color=color,
    outline_color=0x222222,
    name="neocolor",
)

pyportal.splash.append(button)

while True:
    pixel.fill(color)
    print("NeoPixel set to ", color)
    time.sleep(1.0)
    color = random.choice(colors)
    button.fill_color = color
