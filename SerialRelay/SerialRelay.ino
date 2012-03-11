/*
 * Serial Relay
 */
 
#include <SoftwareSerial.h>

SoftwareSerial mySerial(7, 8);
 
void setup() {
  mySerial.begin(19200);               // the GPRS baud rate   
  Serial.begin(19200);                 // the GPRS baud rate   
}
 
void loop() {
  if(Serial.available()) {
    mySerial.print((unsigned char)Serial.read());
  } else  if(mySerial.available()) {
    Serial.print((unsigned char)mySerial.read());
  }   
}
