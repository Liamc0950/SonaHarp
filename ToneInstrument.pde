//Sonar Theremin
//Liam Corley
//12-17-19


//ToneInstrument, uses oscillator to output notes for minim
//Supports ADSR

// Every instrument must implement the Instrument interface so 
// playNote() can call the instrument's methods.
class ToneInstrument implements Instrument
{
  // create all variables that must be used througout the class
  Oscil sineOsc;
  ADSR  adsr;
  
  // constructor for this instrument
  ToneInstrument( float frequency, float amplitude )
  {    
    // create new instances of any UGen objects as necessary
    sineOsc = new Oscil( frequency, amplitude, Waves.SINE );
    
    //Constructor for an ADSR envelope.
    //ADSR(float maxAmp, float attTime, float decTime, float susLvl, float relTime, float befAmp, float aftAmp)
    //adsr = new ADSR( 0.5, 0.01, 0.05, 0.5, 0.5 ); // Just want to keep a copy of these parameters because they're pretty cool
    adsr = new ADSR( 0.5, a, d, s, r );
    
    // construct a low pass MoogFilter with a 
    // cutoff frequency of 1000 Hz and a resonance of 0.5
    moog = new MoogFilter( 1000, 0.5 );
    moog.type = MoogFilter.Type.LP;

    // patch everything together up to the final output
    sineOsc.patch( adsr );
    sineOsc.patch(moog);
  }
  
  // every instrument must have a noteOn( float ) method
  void noteOn( float dur )
  {
    // turn on the ADSR
    adsr.noteOn();
    // patch to the output
    adsr.patch( out );
   }
  
  // every instrument must have a noteOff() method
  void noteOff()
  {
    // tell the ADSR to unpatch after the release is finished
    adsr.unpatchAfterRelease( out );
    // call the noteOff 
    adsr.noteOff();
  }
}
