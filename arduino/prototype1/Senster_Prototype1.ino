#include <VarSpeedServo.h>

int masterVariable[] = {0,0}; // Input array of variables from processing

VarSpeedServo ServoX;
VarSpeedServo ServoY;
VarSpeedServo ServoNeck;
int servoXPin = 2;
int servoX_lastPosition = 65;  // range   // start position = 65
int servoYPin = 4;
int servoY_lastPosition = 60;     // range 0-180 // start position 
int servoNeckPin = 8; 
int servoNeck_lastPosition = 30;   //  range 0-35 // start position between 0-30

int pos = 0;    // variable to store the servo position
int moveSpeed = 200;
int speedScalerY = 1;
int speedScalerX = 1;
int servoMin = 0;
int servoMax = 170;

void setup() {
  // put your setup code here, to run once:
  ServoX.attach (servoXPin, servoMin, servoMax); // Connect servo to pin
  ServoY.attach(servoYPin, servoMin, servoMax);
  ServoNeck.attach(servoNeckPin, servoMin, servoMax);
  ServoY.slowmove (servoY_lastPosition, moveSpeed);
  ServoX.slowmove (servoX_lastPosition, moveSpeed);
  ServoNeck.slowmove (servoNeck_lastPosition, moveSpeed);

  Serial.begin(9600);
}

void loop() {   

  while (Serial.available()<2) {} // Wait 'till there are 2 Bytes waiting
  for(int n=0; n<2; n++){
  masterVariable[n] = Serial.read(); // Then: Get them.
  }

  if (masterVariable[1]==2){
    ServoY.slowmove (servoY_lastPosition+=speedScalerY, moveSpeed);
  } else if(masterVariable[1]==1){
    ServoY.slowmove (servoY_lastPosition-=speedScalerY, moveSpeed);
  }

  if (masterVariable[0]==1){
    ServoX.slowmove (servoX_lastPosition-=speedScalerX, moveSpeed);
  } else if(masterVariable[0]==2){
    ServoX.slowmove (servoX_lastPosition+=speedScalerX, moveSpeed);
  }



  
}









  
//  if(Serial.available()){
//    int incomingValue = Serial.read();
//    faceXY[currentValue] = incomingValue;
//    currentValue++;
//    if(currentValue > 1){
//      currentValue = 0;
//    }
//    analogWrite(9, faceXY[0]);
//    Serial.print(faceXY[0]); Serial.print("        ");
//    Serial.println(faceXY[1]);

    
    
  
/*
void loop() {

  
  // put your main code here, to run repeatedly:
pos = random(0, 180);;
posDiff = pos - lastPos;
myservo.slowmove (pos, moveSpeed);
delay(300);


}
*/

  

  
  
 
