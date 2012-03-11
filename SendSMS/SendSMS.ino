#include "SoftwareSerial.h"

SoftwareSerial mySerial(7, 8);

void setup() {
 mySerial.begin(19200); 
 Serial.begin(19200);  
 delay(300); 
 mySerial.print("");
 delay(300);
 mySerial.print("\r");
 delay(300);
 mySerial.print("AT+CMGF=1\r\n");
 delay(300);
 mySerial.print("AT+CMGS=\"+46123456789\"\r\n");
 delay(300);
 mySerial.print("Hello");
 delay(300);
 mySerial.write(26); 
}

void loop() {
  if(Serial.available()) {
    mySerial.print((unsigned char)Serial.read());
  } else  if(mySerial.available()) {
    Serial.print((unsigned char)mySerial.read());
  } 
}
