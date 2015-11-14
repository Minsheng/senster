

import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import processing.serial.*;

Serial myPort;                       // The serial port
Capture cam;
OpenCV opencv;

int w = 320;   // width
int h = 240;   // height
int scaleVal = 2;

// These variables hold the x and y location for the middle of the detected face
int midFaceX = 0;
int midFaceY = 0;
// The variables correspond to the middle of the screen, and will be compared to the midFace values
int midScreenY = (h/2);
int midScreenX = (w/2);
int errorThreshold = 15; // This is the acceptable 'error' for the center of the screen.

// Movement controls to Arduino Servos (x servo, y servo)
int masterVariable[] = {
  0, 0
};
int x_correct = 0;
int y_correct = 0;

void setup() {     ////////////////////////////
  size(w, h);

  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }

    // The camera can be initialized directly using an 
    // element from the array returned by list():
    //cam = new Capture(this, "name=FaceTime HD Camera (Built-in),size=640x360,fps=30");           
    // "name=FaceTime HD Camera (Built-in),size=640x360,fps=30" This one works but not the others 
    // only works with 640,480

    cam = new Capture(this, cameras[3]);       
    //cameras[3] = name=USB2.0 Camera,size=320x240,fps=30    --- Fastest feed but small visual angle
    //cameras[0] = name=USB2.0 Camera,size=640x480,fps=30
    opencv = new OpenCV(this, w, h);
    opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
    cam.start();

    String portName = Serial.list()[5];
    myPort = new Serial(this, portName, 9600);
  }
}

void draw() {          ////////////////////////////
  //scale(scaleVal);

  if (cam.available() == true) {
    cam.read();
    opencv.loadImage(cam);
    //    println("loop");
  }

  image(cam, 0, 0);
  // The following does the same, and is faster when just drawing the image
  // without any additional resizing, transformations, or tint.
  //set(0, 0, cam);

  // Draw rectangle around face
  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  Rectangle[] faces = opencv.detect();
  //print(faces.length + "         ");                        // Print number of faces detected



  if (faces.length > 0) {
    midFaceY = faces[0].y + (faces[0].height/2);
    midFaceX = faces[0].x + (faces[0].width/2); 
    println( "x: " +  midFaceX + "    y: " + midFaceY); 
    for (int i = 0; i < faces.length; i++) {
      rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    }
  }

  //// Compare position of face to center (with error tolerance)
  // Y-Values
  if (midFaceY < (midScreenY - errorThreshold)) { // If face is above center and outside threshold
    y_correct = 2;
  } else if (midFaceY > (midScreenY + errorThreshold)) { // If face below
    y_correct = 1;
    // X-Values
  } else {
    y_correct = 0;
  }

  if (midFaceX < (midScreenX - errorThreshold)) {
    x_correct = 2;
  } else if (midFaceX > (midScreenX + errorThreshold)) {
    x_correct = 1;
  } else {
    x_correct = 0;
  }

  // fill masterVariable with control variables to send to Arduino



  // Serial Communication
  // Serial Communication (Send face information to Arduino)
  if (faces.length > 0) {
    byte[] masterVariable = new byte [2];   // convert integers into bytes for serial
    masterVariable[0] = byte(x_correct);
    masterVariable[1] = byte(y_correct);
    myPort.write(masterVariable);    //myPort.write(faces[i].x , faces[i].y);
    delay(10);
  }
}



