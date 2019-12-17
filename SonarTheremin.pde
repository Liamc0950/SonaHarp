//Sonar Theremin
//Liam Corley
//12-17-19


import processing.serial.*;    // Importing the serial library to communicate with the Arduino 
import ddf.minim.*;
import ddf.minim.ugens.*;
import oscP5.*;
import netP5.*;

//OSC to Pure data
String ipAddress="127.0.0.1";
int port = 9001;

OscP5  oscP5;
NetAddress ip;


float a, d, s, r;

String buff;
String[] buffArr;
Serial myPort;      // Initializing a vairable named 'myPort' for serial communication
Minim minim; //Initialize minim and audio output for oscillator
AudioOutput out;
Oscil wave;
float freq; //frequency value, provided from Arduino - 1st sonar sensor
float diaFreq; //1st sonar cm distance, for diatonic pitch

float oldFreq; //last frequency, stored to determine when notes change
float oldDiaFreq; //last frequency, stored to determine when notes change - for Diatonic

float amp = 0.8; //amplitude value, updated by gain pot
float pot0 = 0.5; //input from pot # 0
float pot1 = 0.5; //input from pot # 1
float pot2 = 0.5; //input from pot # 2
float pot3 = 0.5; //input from pot # 3
float pot4 = 0.5; //input from pot # 4
float melodyFreq; //2nd sonar sensor - melody sensor - frequency



MoogFilter  moog; //moog filter for low pass

GUI gui = new GUI();

boolean diatonic = false;

float background_color ;   // Variable for changing the background color

void setup ( ) {
  
  a = 0.11;
  d = 0.05;
  s = 0.05;
  r = 0.1;

  size (500, 600, P3D); // Size of the serial window, you can increase or decrease as you want

  /////////////////////Serial port setup for input from Arduino /////////////

  myPort  =  new Serial (this, "COM3", 9600); // Set the com port and the baud rate according to the Arduino IDE

  myPort.bufferUntil ( '\n' );   // Receiving the data from the Arduino IDE


  /////////////////////Oscillator outputs /////////////////////////////////
  minim = new Minim(this);

  // use the getLineOut method of the Minim object to get an AudioOutput object
  out = minim.getLineOut();
  
  // create a sine wave Oscil, set to 440 Hz, at 0.5 amplitude
  //wave = new Oscil( 440, 0.5f, Waves.SINE );
  // patch the Oscil to the output
  //wave.patch( out );

  // construct a law pass MoogFilter with a 
  // cutoff frequency of 1200 Hz and a resonance of 0.5
  moog    = new MoogFilter( 1200, 0.5 );
  moog.type = MoogFilter.Type.LP;
  
  //OSC connection to PD
  oscP5=new OscP5(this, port);
  ip=new NetAddress(ipAddress, port);

  //Add diatonic mode button
  gui.addButton(new Button(175, 500, 75, 50, "DIATONIC", "dia", color(200, 100, 255)));
  
} 

void serialEvent  (Serial myPort) {
  buff = myPort.readStringUntil ( '\n' );
  System.out.println(buff);
  buffArr = buff.split(":");
  freq = float (buffArr[0]);
  pot0 = map(float (buffArr[1]), 919.0, 1023.0, 0.01, 0.99);
  pot1 = map(float (buffArr[2]), 0.0, 1023.0, 0.01, 0.5);
  pot2 = map(float (buffArr[3]), 0.0, 1023.0, 0.01, 0.5);
  pot3 = map(float (buffArr[4]), 0.0, 1023.0, 0.01, 0.5);
  pot4 = map(float (buffArr[5]), 0.0, 1023.0, 0.01, 0.5);
  if(float (buffArr[6]) < 2000){
    melodyFreq = map(float (buffArr[6]), 0, 2000, 200, 2500);
  }
  
  diaFreq = float (buffArr[7]);
  
  a = pot1;
  d = pot2;
  s = pot3;
  r = pot4;
  amp = pot0;
  
} 


void draw ( ) {
  //send sensor #2 data to pd
  OscBundle bundle=new OscBundle();
  OscMessage freqMsg =new OscMessage("/freq");
  freqMsg.add(freq);
  bundle.add(freqMsg);
  oscP5.send(bundle, ip);
  
  background(map(freq, 200,2500,0,255), 0, 255);  //change background color based on freq

  stroke(255);
  strokeWeight(1);
  fill(255);
  
  //ADSR LABELS
  textSize(32);
  text("A", 100, 300); 
  text("D", 200, 300); 
  text("S", 300, 300); 
  text("R", 400, 300); 
  text("G", 400, 500); 
  
  //ADSR VALUE LABELS
  textSize(25);
  text(a, 75, 400); 
  text(d, 175, 400); 
  text(s, 275, 400); 
  text(r, 375, 400); 
  text(amp, 375, 550); 
  
  // draw the waveform of the output
  for (int i = 0; i < out.bufferSize() - 1; i++)
  {
    line( i, 50  - out.left.get(i)*50, i+1, 50  - out.left.get(i+1)*50 );
    line( i, 150 - out.right.get(i)*50, i+1, 150 - out.right.get(i+1)*50 );
  }
    
  
  //if frequency has changed, and we are not in diatonic mode
  //add a new note if not at limit (no hand in front of sensor)
  if(freq != oldFreq && freq < 2385.0 && !diatonic){
    oldFreq = freq; //set new oldFreq value
    out.playNote(0.0,1.0, new ToneInstrument(freq, amp)); //add notes to output (duration of 1 beat)
  }

  //if frequency has changed, and we are in diatonic mode
  //add a new note if not at limit (no hand in front of sensor)
  if(diaFreq != oldDiaFreq && diaFreq < 50 && diatonic){
    oldDiaFreq = diaFreq; //set new oldDiaFreq value
    System.out.println(getDiatonicFreq(diaFreq));
    out.playNote(0.0,1.0, new ToneInstrument(getDiatonicFreq(diaFreq), amp)); //add notes to output (duration of 1 beat)
  }

  gui.drawButtons(); //draw all buttons
  
  //Set diatonic boolean value based on button
  if(gui.getPressed("dia")){
    diatonic = true;
  }
  else{
    diatonic = false;
  }
  
}

void mousePressed(){
  gui.update();
}



//Maps cm distance value to diatonic scale (C) - Multiplied by 2 to raise octave
float getDiatonicFreq(float cm){
  switch(int (map(cm, 1, 50, 1, 7))) {
    case 1: 
      return 262.0 * 2;
    case 2: 
      return 294.8 * 2;
    case 3: 
      return 327.5 * 2;
    case 4: 
      return 349.3 * 2;
    case 5: 
      return 393.0 * 2;
    case 6: 
      return 436.7 * 2;
    case 7: 
      return 491.2 * 2;
  }
  return 0.0;
}
