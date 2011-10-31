/*
  IRDistance
 Reads an analog input from IR distance sensor on pin 0, prints the result to the serial monitor 
 
 This example code is in the public domain.
 */

void setup() {
  Serial.begin(9600);
}

void loop() {

  int sensorValue = analogRead(A0);
  int distance = sensorValueToCentimeters(sensorValue);
  
  Serial.println(distance);
}

long sensorValueToCentimeters(long sensorValue)
{
  float result = 0;
  float minValue = 170;
  float maxValue = 355;
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
