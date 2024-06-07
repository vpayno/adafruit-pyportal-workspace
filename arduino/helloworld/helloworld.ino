#include <Adafruit_NeoPixel.h>

// How many internal neopixels do we have? some boards have more than one!
#define NUMPIXELS        1

Adafruit_NeoPixel pixels(NUMPIXELS, PIN_NEOPIXEL, NEO_GRB + NEO_KHZ800);

// the setup routine runs once when you press reset:
void setup() {
  Serial.begin(115200);

  Serial.println("Hello NeoPixel!");

#if defined(NEOPIXEL_POWER)
  // If this board has a power control pin, we must set it to output and high
  // in order to enable the NeoPixels. We put this in an #if defined so it can
  // be reused for other boards without compilation errors
  pinMode(NEOPIXEL_POWER, OUTPUT);
  digitalWrite(NEOPIXEL_POWER, HIGH);
#endif

  pixels.begin(); // INITIALIZE NeoPixel strip object (REQUIRED)
  pixels.setBrightness(20); // not so bright
}

// the loop routine runs over and over again forever:
void loop() {
  long color = random(0xFFFFFF);

  Serial.print("Color set to: ");
  Serial.println(color);

  // set color to random choice
  pixels.fill(color);
  pixels.show();
  delay(500); // wait half a second

  Serial.print("Color set to: ");
  Serial.println(0x000000);

  // turn off
  pixels.fill(0x000000);
  pixels.show();
  delay(500); // wait half a second
}
