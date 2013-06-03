/*     PulseSensor Amped HRV Poncaire Plot
 
 This is an HRV visualizer code for Pulse Sensor.
 Use this with PulseSensorAmped_Arduino_1.1 Arduino code and the Pulse Sensor Amped hardware.
 This code will draw a Poncaire Plot of the IBI (InterBeat Interval) passed from Arduino.
 The Poncaire method of visualizing HRV trends is to plot the current IBI against the last IBI. 
 key press commands included in this version:
 press 'S' or 's' to take a picture of the data window. (.jpg image)
 press 'c' to clear the graph 
 Created by Joel Murphy, early 2013
 This code released into the public domain without promises or caveats.
 */

import processing.serial.*;
Serial port;

int test;                 // general debugger
int pulseRate = 0;        // used to hold pulse rate value from arduino (updated in serialEvent)
int Sensor = 0;           // used to hold raw sensor data from arduino (updated in serialEvent)
int IBI;                  // length of time between heartbeats in milliseconds (updated in serialEvent)
int ppgY;                 // used to print the pulse waveform

ArrayList<Integer> beatIntervals;



// initializing flags here
boolean pulse = false;    // made true in serialEvent when processing gets new IBI value from arduino


void setup() {
  background(255);
  size(1024, 600); // Stage size
  // screenMask = loadImage("stressbot-screen-mask.png");

  beatIntervals = new ArrayList(); //create empty array list

  // FIND AND ESTABLISH CONTACT WITH THE SERIAL PORT
  println(Serial.list());       // print a list of available serial ports
  port = new Serial(this, Serial.list()[0], 115200); // choose the right baud rate
  port.bufferUntil('\n');          // arduino will end each ascii number string with a carriage return 
  port.clear();                    // flush the Serial buffer
}  // END OF SETUP

//----------------------------------------------------------------
void draw() {
  background(255);
  if (beatIntervals.size() > 11) {
    // println("ready");
    drawPoincare();
  }  
}

void drawPoincare() {
  for (int i=beatIntervals.size()-10; i<beatIntervals.size(); i++) { //get the last 10 values
    pushStyle();
      noStroke();
      fill(0, 255, 0);
      float xPos = beatIntervals.get(i);
      xPos = normalizeIntervalVal(xPos, width); //normalize x-value
      float yPos = beatIntervals.get(i-1);
      yPos = normalizeIntervalVal(yPos, height); //get and normalize y-value
      // println("xPos: " + xPos + "yPos: " + yPos);
      ellipse(xPos, yPos, 15, 15);
    popStyle();
  }
}

float normalizeIntervalVal(float _arrayVal, int _screenSize) {
  float _val = map(_arrayVal, 0, 1500, 30, _screenSize-30);
  return _val;
}