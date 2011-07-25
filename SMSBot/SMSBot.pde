/*
 * An Arduino Sketch to use a GPRS Sheild to receive and reply to text messages.
 *
 * © 2011 Daniel Hjort
 * CC BY-SA 3.0 http://creativecommons.org/licenses/by-sa/3.0/
 */

#include "NewSoftSerial.h"

NewSoftSerial mySerial(7, 8);

// Configuration
const int DEFAULT_WAIT = 1000;
const int MAX_BUFFER_LEN = 80;
const int MAX_NUMBER_LEN = 20;
const int MAX_MESSAGE_LEN = 140;

#define DEBUG true
#define USE_SOFT_SERIAL true

// Serial/debug macros
#if USE_SOFT_SERIAL
  #define SIM900_SEND_CTRLZ mySerial.print(26,BYTE);
  #define SIM900_READ mySerial.read();
  #define SIM900_AVAILABLE mySerial.available()
  #if DEBUG
    #define LOG(s) Serial.print(s);
    #define SIM900_SEND(s) mySerial.print(s); Serial.print("<<< "); Serial.print(s);
  #else
    #define LOG(s)
    #define SIM900_SEND(s) mySerial.print(s);
  #endif
#else
  #define SIM900_SEND(s) Serial.print(s);
  #define SIM900_SEND_CTRLZ Serial.print(26,BYTE);
  #define SIM900_READ Serial.read();
  #define SIM900_AVAILABLE Serial.available()
  #define LOG(s)
#endif

// Globals
char* buffer;
unsigned int buffer_pos;
unsigned int rx_msg_count;
unsigned int tx_msg_count;
char *lastPhoneNbr;
char *lastMsg;

void setup() {

  buffer = (char*)malloc(MAX_BUFFER_LEN);
  buffer_pos = 0;
  rx_msg_count = 0;
  tx_msg_count = 0;
  lastPhoneNbr = (char*)malloc(MAX_NUMBER_LEN);
  lastMsg = (char*)malloc(MAX_MESSAGE_LEN);

  #if USE_SOFT_SERIAL
    mySerial.begin(19200);
  #endif
  Serial.begin(19200); 

  SIM900_SEND("\r")
  delay(DEFAULT_WAIT);            //Wait for a second while the modem sends an "OK"
  SIM900_SEND("AT+CMGF=1\r\n")    //Because we want to send the SMS in text mode
  delay(DEFAULT_WAIT);

  //Serial.print("AT+CSCA=\"+919032055002\"\r");  //Setting for the SMS Message center number,
  //delay(1000);                                  //uncomment only if required and replace with
                                                  //the message center number obtained from
                                                  //your GSM service provider.
}

void loop() {

  if(SIM900_AVAILABLE)  {
    unsigned char latestChar = (unsigned char)SIM900_READ
    if(buffer_pos < MAX_BUFFER_LEN) {

      buffer[buffer_pos] = latestChar;
      buffer_pos++;

      if(latestChar == '\r' || latestChar == '\n') {

        // new line
        buffer[buffer_pos] = '\0';

        parseATCommand(buffer);

        buffer_pos = 0;
        *buffer = '\0';
      }
    }
  }
}

// Parse methods
void parseATCommand(char* line) {
  LOG(">>> ")
  LOG(line)
  LOG("\r\n")

  char* str = strstr(line, "+CMTI: \"SM\",");
  if(str != 0) {

    // parse out the message id
    char* msgID = parseForMessageID(line);
    // compose AT command to read the message
    char* reply = concat("AT+CMGR=", msgID);

    SIM900_SEND(reply)
    SIM900_SEND("\r\n")
    free(reply);
  }

  str = strstr(line, "+CMGR:");
  if(str != 0) {

    // parse out the phone number
    parseForPhoneNumber(line);

    sendGreetingTo(lastPhoneNbr);
  }
}

char* parseForMessageID(char* line) {

  return strchr(line, ',') + 1;
}

void parseForPhoneNumber(char* line) {
  char* nbrStart = strchr(line, ',') + 2;
  char* nbrEnd = strchr(nbrStart, ',') - 1;

  memcpy(lastPhoneNbr, nbrStart, nbrEnd - nbrStart);
  lastPhoneNbr[nbrEnd - nbrStart] = '\0';

  LOG("Found number: ")
  LOG(lastPhoneNbr)
  LOG("\r\n")
}

void sendGreetingTo(char* number) {
  char* command1 = concat("AT+CMGS=\"",number);
  char* command2 = concat(command1, "\"\r\n");

  SIM900_SEND(command2);
  delay(DEFAULT_WAIT);
  SIM900_SEND("SIM900 and Arduino say Hi!\r\n");
  delay(DEFAULT_WAIT);
  SIM900_SEND_CTRLZ

  free(command1);
  free(command2);
}

// Utility methods
char* concat(char* str1, char* str2) {
  size_t len1 = strlen(str1);
  size_t len2 = strlen(str2);

  char* s = (char*)malloc(len1 + len2 + 2);
  memcpy(s, str1, len1);
  s[len1] = ' ';
  memcpy(s + len1, str2, len2 + 1);
  return s;
}
