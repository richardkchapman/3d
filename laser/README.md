Laser tracking for insects in flight
====================================

Inputs:

   Power
   AT programming interface
   Camera sync signal?

Outputs:
   Camera and shutter
   Flash (* N ?)
   Status LED
   Signal to Camera Axe (can this be the same as one of the flash ones?)
	Flash outputs are (can be) mono, camera is stereo
	Does the axe pinout work with optocoupler? Kinda but a pullup would be better.

   Does going back to the axe buy me anything? Two outputs already.... a battery pack... an available flash splitter... a UI...
   Does it lose me anything?
       bulk, weight, precise control, latency

   Does the half-press do anything for me?
      only if I get to press it early - e.g. half-press on the first putative hit - then it might start the stabilizer or something

Build without axe support initially. I can create adaptor cable to go from flash to axe.

Components:
output:
  1 stereo jack
  1-n mono jacks (or use stereo?)

  1-2 optoisolator per jack
  2 resistors per optoisolator

input
  2 connectors for lasers
  1 jack for pc-sync ? What would I use it for?

misc:
  6 way header
  phototransistor
  resistors/capacitors
  lasers
  on-off switch
  attiny84
  sockets?
  
Layout but don't populate outputs 2-n





