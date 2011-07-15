/*
  LogicShrimpTest
  Uses 4 digital outputs to test the Logic Shrimp.
 
  This example code is in the public domain.
 */

unsigned int i;
boolean oneHigh;
boolean twoHigh;

void setup() {
  i = 0;  
  // initialize the digital pins as an output.
  pinMode(4, OUTPUT);
  pinMode(5, OUTPUT);
  pinMode(6, OUTPUT);
  pinMode(7, OUTPUT);
}

void loop() {
  
  if (i % 2) {
    oneHigh = !oneHigh;
    if (oneHigh) {
      digitalWrite(4, HIGH);
    } else {
      digitalWrite(4, LOW); 
    } 
  }
  
  if (i % 3) {
    twoHigh = !twoHigh;
    if (twoHigh) {
      digitalWrite(5, HIGH);
    } else {
      digitalWrite(5, LOW); 
    } 
  }
  
  if(oneHigh && twoHigh)  {
    digitalWrite(6, HIGH);
  } else {
    digitalWrite(6, LOW); 
  }
  
  if(oneHigh || twoHigh)  {
    digitalWrite(7, HIGH);
  } else {
    digitalWrite(7, LOW); 
  }
  
  delay(10);              // wait for a while
  
  i++;
}
