//Sonar Theremin
//Liam Corley
//12-17-19


/*


*/

// the pin number of the sensor's output:
const int pingPin = 7;
// analog pin 0, rangePot in
const int aPotPin = 0;
const int dPotPin = 1;
const int sPotPin = 2;
const int rPotPin = 3;
const int gPotPin = 4;

// defines pins numbers for sonar sensor #2
const int trigPin = 4;
const int echoPin = 3;
// defines variables for sonar sensor #2
long duration;
int distance = 0;


void setup() {
  pinMode(trigPin, OUTPUT); // Sets the trigPin as an Output
  pinMode(echoPin, INPUT); // Sets the echoPin as an Input
  // initialize serial communication:
  Serial.begin(9600);
}

void loop() {
  //SONAR SENSOR #1 
  // establish variables for duration of the ping, and the distance result
  // in inches and centimeters:
  long duration, inches, cm;

  // The PING))) is triggered by a HIGH pulse of 2 or more microseconds.
  // Give a short LOW pulse beforehand to ensure a clean HIGH pulse:
  pinMode(pingPin, OUTPUT);
  digitalWrite(pingPin, LOW);
  delayMicroseconds(2);
  digitalWrite(pingPin, HIGH);
  delayMicroseconds(5);
  digitalWrite(pingPin, LOW);

  // The same pin is used to read the signal from the PING))): a HIGH pulse
  // whose duration is the time (in microseconds) from the sending of the ping
  // to the reception of its echo off of an object.
  pinMode(pingPin, INPUT);
  duration = pulseIn(pingPin, HIGH);

  // convert the time into a distance
  inches = microsecondsToInches(duration);
  cm = microsecondsToCentimeters(duration);

  // SONAR SENSOR #2
  // Clears the trigPin
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  // Sets the trigPin on HIGH state for 10 micro seconds
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  // Reads the echoPin, returns the sound wave travel time in microseconds
  duration = pulseIn(echoPin, HIGH);
  // Calculating the distance
  distance= duration*0.034/2;

  //Serial.print(inches);
  //Serial.print("in, ");
  //Serial.print(cm);
  //Serial.print("cm");
  //Serial.println();

  //Connect to Processing  
  int mapped_output = map (cm, 0, 60, 200, 2500); // Mapping the output of sonar to a pitch value for Processing
  //int mapped_output = map (cm, 0, 30, 200, 2500);// Mapping the output of sonar to a pitch value for Processing
  //int mapped_output = map (cm, 0, map(analogRead(rangePotPin), 0, 255, 20, 120), 200, 2500); // Mapping the output of sonar to a pitch value for Processing

  Serial.print (mapped_output);     // Send sonar sensor #1 data to Processing IDE
  Serial.print (":"); // delimeter
  Serial.print (analogRead(aPotPin));     // Send pot #0 data to Processing IDE
  Serial.print (":"); // delimeter
  Serial.print (analogRead(dPotPin));     // Send pot #1 data to Processing IDE
  Serial.print (":"); // delimeter
  Serial.print (analogRead(sPotPin));     // Send pot #2 data to Processing IDE
  Serial.print (":"); // delimeter
  Serial.print (analogRead(rPotPin));     // Send pot #3 data to Processing IDE
  Serial.print (":"); // delimeter
  Serial.print (analogRead(gPotPin));     // Send pot #4 data to Processing IDE
  Serial.print (":"); // delimeter
  Serial.print (map(distance, 0, 115, 200, 2000));     // Send sonar sensor #2 data to Processing IDE
  Serial.print (":"); // delimeter
  Serial.print (cm);     // Send sonar sensor #1 centimeter data to Processing IDE
  Serial.print ('\n');     // Send carriage return to Processing IDE
  delay(100);
}

long microsecondsToInches(long microseconds) {
  // According to Parallax's datasheet for the PING))), there are 73.746
  // microseconds per inch (i.e. sound travels at 1130 feet per second).
  // This gives the distance travelled by the ping, outbound and return,
  // so we divide by 2 to get the distance of the obstacle.
  // See: http://www.parallax.com/dl/docs/prod/acc/28015-PING-v1.3.pdf
  return microseconds / 74 / 2;
}

long microsecondsToCentimeters(long microseconds) {
  // The speed of sound is 340 m/s or 29 microseconds per centimeter.
  // The ping travels out and back, so to find the distance of the object we
  // take half of the distance travelled.
  return microseconds / 29 / 2;
}
