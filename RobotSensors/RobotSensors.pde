#include <SerialLCD.h>
#include <NewSoftSerial.h> 

const boolean USE_LCD = true;
const int pingPin = 7;
const int irPinFront = A3;
const int irPinFrontLeft = A1;
const int irPinFrontRight = A5;

unsigned long cycle = 0;

// initialize the library
SerialLCD slcd(11,12);

void setup() {

  if(USE_LCD) {
  // set up lcd
  slcd.begin();
  } else {
    // initialize serial communication:
    Serial.begin(9600);
  }
}

void loop()
{
  
  // establish variables for duration of the ping, 
  // and the distance result in inches and centimeters:
  long duration, pingcm, sensorValue, ircmFront, ircmFrontLeft, ircmFrontRight;
      
  // send and receive ping
  duration = ping();

  // convert the time into a distance
  pingcm = microsecondsToCentimeters(duration);
  
  // read IRs
  sensorValue = analogRead(irPinFront);
  ircmFront = sensorValueToCentimeters(sensorValue);
  
  sensorValue = analogRead(irPinFrontLeft);
  ircmFrontLeft = sensorValueToCentimeters(sensorValue);

  sensorValue = analogRead(irPinFrontRight);
  ircmFrontRight = sensorValueToCentimeters(sensorValue);
      
  if ((cycle % 10) == 0) { // stuff todo less often
    
    cycle = 0;
    
    if(USE_LCD) {
      
      slcd.clear();
    
      slcd.home();
      slcd.print("Ping:");
      slcd.print(pingcm, DEC);
      slcd.print("cm");
    
      slcd.setCursor(0,1);
      slcd.print("IR:");
      slcd.print(ircmFrontLeft, DEC);
      slcd.print(":");
      slcd.print(ircmFront, DEC);
      slcd.print(":");
      slcd.print(ircmFrontRight, DEC);
      slcd.print("cm");
    } else {
      
      Serial.print("Ping:");
      Serial.print(pingcm);
      Serial.print("cm");
      Serial.println();
  
      Serial.print("IR:");
      Serial.print(ircmFrontLeft);
      Serial.print(":");
      Serial.print(ircmFront);
      Serial.print(":");
      Serial.print(ircmFrontRight);
      Serial.print("cm");
      Serial.println();
    }
  }
  
  cycle++;
  delay(100);
}

long ping()
{
  // The PING))) is triggered by a HIGH pulse of 2 or more microseconds.
  // Give a short LOW pulse beforehand to ensure a clean HIGH pulse:
  pinMode(pingPin, OUTPUT);
  digitalWrite(pingPin, LOW);
  delayMicroseconds(2);
  digitalWrite(pingPin, HIGH);
  delayMicroseconds(5);
  digitalWrite(pingPin, LOW);

  // The same pin is used to read the signal from the PING))): a HIGH
  // pulse whose duration is the time (in microseconds) from the sending
  // of the ping to the reception of its echo off of an object.
  pinMode(pingPin, INPUT);
  return pulseIn(pingPin, HIGH);
}

long microsecondsToCentimeters(long microseconds)
{
  // The speed of sound is 340 m/s or 29 microseconds per centimeter.
  // The ping travels out and back, so to find the distance of the
  // object we take half of the distance travelled.
  return microseconds / 29 / 2;
}

long sensorValueToCentimeters(long sensorValue)
{
  float result = 0;
  float minValue = 50;
  float maxValue = 500;
  int minDistance = 20;
  int maxDistance = 80;
  
  if (sensorValue < minValue) {
    result = maxDistance;
  } else if (sensorValue > maxValue) {
    result = minDistance;
  } else {
    result = (((maxValue - sensorValue) / (maxValue - minValue)) * (maxDistance - minDistance)) + 20;
  }

  return result;
}
