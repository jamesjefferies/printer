Printer Hardware
================

This is a guide to building your own printer.


Components
----------

* An [Arduino][] (tested against the Uno R3)
* An [ethernet + SD card shield][ethernet-shield]
* An SD card to put in the shield.
* A printer (available from [adafruit][], [sparkfun][], [proto-pic][])
* Wires to plug them all together, power and program them.

You should also download and install the [Arduino 1.0 IDE](http://ardunio.cc). Once you have the Ardunio software installed, you'll need to ensure you have

* The lazyatom [Thermal Printer Library][arduino-library] which supports printing "rich" graphics
* The [Bounce][arduino-bounce] arduino library, which makes the button more reliable

These should both be installed into your Arduino libraries directory (see [http://arduino.cc/it/Reference/Libraries](http://arduino.cc/it/Reference/Libraries) for more details about how to do this).


Setup
--------------

* Plug the Arduino and Ethernet Shield together
* Format the SD card as MS-DOS (FAT16), and put it in the shield
* Plug the printer into the Arduino (follow directions in [the sketch][])
* Plug the printer into power
  - The printer can potentially draw quite a high current, so I power it separately from the Arduino, although that might be paranoid.
* Connect an ethernet cable to the shield, and make sure the other end connects to the network in some way.
* Program the Arduino with [the sketch][]
  - You will need to change the IP to that of your server
* Turn everything on

(TODO - make this a bit more detailed)




[Arduino]: http://ardunio.cc
[ethernet-shield]: http://arduino.cc/en/Main/ArduinoEthernetShield
[adafruit]: https://www.adafruit.com/products/600
[sparkfun]: http://www.sparkfun.com/products/10438
[proto-pic]: http://proto-pic.co.uk/thermal-printer/
[arduino-library]: https://github.com/lazyatom/Thermal-Printer-Library
[arduino-bounce]: http://www.arduino.cc/playground/Code/Bounce
[the sketch]: https://github.com/freerange/printer/blob/master/printer.ino