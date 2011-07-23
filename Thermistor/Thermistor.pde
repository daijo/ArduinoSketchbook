/*
 * Thermistor temp reading
 *
 * 16 k ohmn balance resistor.
 */

#include <math.h>

#define BALANCE_RESISTOR 16000

double Thermister(int RawADC) {
 double Temp;
 Temp = log(((1024 * BALANCE_RESISTOR/RawADC) - BALANCE_RESISTOR));
 Temp = 1 / (0.001129148 + (0.000234125 + (0.0000000876741 * Temp * Temp ))* Temp );
 Temp = Temp - 273.15;            // Convert Kelvin to Celcius
 //Temp = (Temp * 9.0)/ 5.0 + 32.0; // Convert Celcius to Fahrenheit
 return Temp;
}

void setup() {
 Serial.begin(115200);
}

void loop() {
 Serial.println(int(Thermister(analogRead(0))));
 delay(100);
}
