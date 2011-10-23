/* Sketch for sending data to a Pachube feed using the GPRS shield. */

/* Cellcard config
*
* Connect name: 	GPRS Cellcard
* International Access Point Name(APN): 	cellcard
* Data bearer/connection type: 	GPRS
* User name: 	mobitel
* Password: 	mobitel
* Authentication: 	normal
* WAP/Proxy address: 	203.144.95.100
* Port: 	8080 (8080 for http and 9201 for wap)
* Homepage: 	http://www.cellcard.com.kh/mobile
*/


#include <NewSoftSerial.h>
 
NewSoftSerial GPRS_Serial(7, 8);
 
void setup()
{
  GPRS_Serial.begin(19200);  //GPRS Shield baud rate
  Serial.begin(19200);
 
setup_start:
 
  Serial.println("Turn on GPRS Modem and wait for 1 minute.");
  Serial.println("and then press a key");
  Serial.println("Press c for power on configuration");
  Serial.println("press any other key for uploading");
  Serial.flush();
  while(Serial.available() == 0);
  if(Serial.read()=='c')
  {
    Serial.println("Executing AT Commands for one time power on configuration");
 
    GPRS_Serial.flush();
 
    GPRS_Serial.println("ATE0"); //Command echo off
    Serial.println("ATE0   Sent");
    if(GPRS_Serial_wait_for_bytes(4,10) == 0)
    {  
      Serial.println("Timeout");
      goto setup_start;
    }
    else
    {
      Serial.print("Received:");
      while(GPRS_Serial.available()!=0)
      {
        Serial.print((unsigned char)GPRS_Serial.read());
        Serial.print("\n");
      }
    }
 
    GPRS_Serial.println("AT+CIPMUX=0"); //We only want a single IP Connection at a time.
    Serial.println("AT+CIPMUX=0   Sent");
    if(GPRS_Serial_wait_for_bytes(4,10) == 0)
    {  
      Serial.println("Timeout");
      goto setup_start;
    }
    else
    {
      Serial.print("Received:");
      while(GPRS_Serial.available()!=0)
      {
        Serial.print((unsigned char)GPRS_Serial.read());
        Serial.print("\n");
      }
    }
 
    GPRS_Serial.println("AT+CIPMODE=0"); //Selecting "Normal Mode" and NOT "Transparent Mode" as the TCP/IP Application Mode
    Serial.println("AT+CIPMODE=0    Sent!");
    if(GPRS_Serial_wait_for_bytes(4,10) == 0)
    {  
      Serial.println("Timeout");
      goto setup_start;
    }
    else
    {
      Serial.print("Received:");
      while(GPRS_Serial.available()!=0)
      {
        Serial.print((unsigned char)GPRS_Serial.read());
        Serial.print("\n");
      }
    }
 
    GPRS_Serial.println("AT+CGDCONT=?");
    Serial.println("AT+CGDCONT=?   Sent!");
    if(GPRS_Serial_wait_for_bytes(4,10) == 0)
    {  
      Serial.println("Timeout");
      goto setup_start;
    }
    else
    {
      Serial.print("Received:");
      while(GPRS_Serial.available()!=0)
      {
        Serial.print((unsigned char)GPRS_Serial.read());
        Serial.print("\n");
      }
    }
 
    GPRS_Serial.println("AT+CGDCONT=1,\"IP\",\"cellcard\"");
    Serial.println("AT+CGDCONT=1,\"IP\",\"cellcard\"   Sent!");
    if(GPRS_Serial_wait_for_bytes(4,10) == 0)
    {  
      Serial.println("Timeout");
      goto setup_start;
    }
    else
    {
      Serial.print("Received:");
      while(GPRS_Serial.available()!=0)
      {
        Serial.print((unsigned char)GPRS_Serial.read());
        Serial.print("\n");
      }
    }
 
    GPRS_Serial.println("AT+CSTT=\"cellcard\",\"mobitel\",\"mobitel\""); //Start Task and set Access Point Name (and username and password if any)
    Serial.println("AT+CSTT=\"cellcard\",\"mobitel\",\"mobitel\"   Sent!");
    if(GPRS_Serial_wait_for_bytes(4,10) == 0)
    {  
      Serial.println("Timeout");
      goto setup_start;
    }
    else
    {
      Serial.print("Received:");
      while(GPRS_Serial.available()!=0)
      {
        Serial.print((unsigned char)GPRS_Serial.read());
        Serial.print("\n");
      }
    }
 
    GPRS_Serial.println("AT+CIPSHUT"); //Close any GPRS Connection if open
    Serial.println("AT+CIPSHUT  Sent!");
    if(GPRS_Serial_wait_for_bytes(7,10) == 0)
    {  
      Serial.println("Timeout");
      goto setup_start;
    }
    else
    {
      Serial.print("Received:");
      while(GPRS_Serial.available()!=0)
      {
        Serial.print((unsigned char)GPRS_Serial.read());
        Serial.print("\n");
      }
    }
  }
}
 
void loop()
{
loop_start:
 
  Serial.println("Press a key to read temperature and upload it");
  Serial.flush();
  while(Serial.available() == 0);
  Serial.read();
 
  //getTemp102();
  //Serial.print("TMP102 Temperature = ");
  //Serial.println(convertedtemp);
 
  GPRS_Serial.println("AT+CIPSTART=\"TCP\",\"api.pachube.com\",\"80\""); //Open a connection to Pachube.com
  Serial.println("AT+CIPSTART=\"TCP\",\"api.pachube.com\",\"80\"  Sent!");
  if(GPRS_Serial_wait_for_bytes(12,255) == 0)
  {  
    Serial.println("Timeout");
    goto loop_start;
  }
  else
  {
    Serial.print("Received:");
    while(GPRS_Serial.available()!=0)
    {
      Serial.print((unsigned char)GPRS_Serial.read());
      Serial.print("\n");
    }
  }
 
  GPRS_Serial.flush();
  GPRS_Serial.println("AT+CIPSEND"); //Start data through TCP connection
  Serial.println("AT+CIPSEND  Sent!");
  if(GPRS_Serial_wait_for_bytes(1,100) == 0)
  {  
    Serial.println("Timeout");
    goto loop_start;
  }
  else
  {
    Serial.print("Received:");
    while(GPRS_Serial.available()!=0)
    {
      Serial.print((unsigned char)GPRS_Serial.read());
      Serial.print("\n");
    }
  }
 
  GPRS_Serial.flush();
 
  //Emulate HTTP and use PUT command to upload temperature datapoint using Comma Seperate Value Method
  GPRS_Serial.print("PUT /v2/feeds/24300.csv HTTP/1.1\r\n");
  Serial.println("PUT /v2/feeds/24300.csv HTTP/1.1  Sent!");
  delay(300);
 
  GPRS_Serial.print("Host: api.pachube.com\r\n"); 
  Serial.println("Host: api.pachube.com  Sent!");
  delay(300);
 
  GPRS_Serial.print("X-PachubeApiKey: InhcuAxN_0BqUu4SvS4EPUWhTglRnjl6F9ibvMfr0hc\r\n"); //REPLACE THIS KEY WITH YOUR OWN PACHUBE API KEY
  Serial.println("X-PachubeApiKey: InhcuAxN_0BqUu4SvS4EPUWhTglRnjl6F9ibvMfr0hc  Sent!"); //REPLACE THIS KEY WITH YOUR OWN PACHUBE API KEY
  delay(300);
 
  GPRS_Serial.print("Content-Length: 12\r\n"); 
  Serial.print("Content-Length: 12  Sent!"); 
  delay(300);
 
  GPRS_Serial.print("Connection: close\r\n\r\n"); 
  Serial.print("Connection: close  Sent!"); 
  delay(300);
  GPRS_Serial.print("01,100"); // <datastream_id>,<value>
  delay(300);
  GPRS_Serial.print("\r\n"); 
  delay(300);
  GPRS_Serial.print("\r\n"); 
  delay(300);
  GPRS_Serial.print(0x1A,BYTE);
  delay(300); //Send End Of Line Character to send all the data and close connection
  if(GPRS_Serial_wait_for_bytes(20,255) == 0)
  {  
    Serial.println("Timeout");
    goto loop_start;
  }
  else
  {
    Serial.print("Received:");
    while(GPRS_Serial.available()!=0)
    {
      Serial.print((unsigned char)GPRS_Serial.read());
      Serial.print("\n");
    }
  }

  GPRS_Serial.flush();
  GPRS_Serial.println("AT+CIPSHUT"); //Close the GPRS Connection
  Serial.println("AT+CIPSHUT  Sent!");
  if(GPRS_Serial_wait_for_bytes(4,100) == 0)
  {  
    Serial.println("Timeout");
    goto loop_start;
  }
  else
  {
    Serial.print("Received:");
    while(GPRS_Serial.available()!=0)
    {
      Serial.print((unsigned char)GPRS_Serial.read());
      Serial.print("\n");
    }
  }
}
 
char GPRS_Serial_wait_for_bytes(char no_of_bytes, int timeout)
{
  while(GPRS_Serial.available() < no_of_bytes)
  {
    delay(200);
    timeout-=1;
    if(timeout == 0)
    {
      return 0;
    }
  }
  return 1;
}


