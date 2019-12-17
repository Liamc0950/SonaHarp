# SonarTheremin
This project is an attempt to use sonar sensors to control audio synthesis and output. Sonar sensors capture distance data of a user's 
hand's relative position to the sensor, and send this data to an Arduino Uno. Five 10K potentiometers are also connected to the Arduino.  
These control ADSR filters and overall gain of the output. 

Data is sent from the Arduino to Processing over the COM3 serial port at 9600 baud.  Since multiple values need to be sent to Processing, 
I sent one string over the serial port each cycle, terminated by a newline and delimeted by ":".  This is received by Processing, split,
and stored in an array.  These values could then be stored to their corresponding Processing variables.

In Processing, I used Minim to output synthesized audio.  Minim provides a playNote() method which plays a single note at a given frequency
for a given duration.  Playing separate notes this way means that my project doesn't really sound or function like a theremin, but the 
separated note effect also sounds cool, and I'm happy with how it functions.  Minim also provides ADSR filters, which allows for 
significant shaping of the output sound.

My project offers two frequency mapping modes: the default mode, and a diatonic mode. In the defualt mode, frequency is mapped from the 
sonar sensor to a frequency value between 200hz and 2500hz. Diatonic mode instead maps distances to specific notes in the C Diatonic scale.
This mode allows for more control of which notes are played, making the instrument easier to play, and keeping the player in key.

In the Processing output window, a waveform of the audio ouput is drawn. The ADSR and gain values are also drawn in this window, as well as
a toggle button to control the note mapping mode. To create the button, I created a Button class and a GUI class.  The GUI class handles the updating of any buttons added to the sketch, and the Button class holds individual button data.  This will allow me to expand the project and add more buttons and potentially other GUI elements more easily.

The final part of my project is a simple particle-based visualizer created as a Purr Data patch.  I used mrpeach to send data from Procesing to Purr Data. I only sent the main sonar sensor data, which I used in Purr Data to set the velocity of the particles.
