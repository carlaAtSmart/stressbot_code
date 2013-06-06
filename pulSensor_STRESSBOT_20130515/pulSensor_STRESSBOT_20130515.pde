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
int maxppgY = 0;

ArrayList<Integer> beatIntervals; //store each beat interval in an Array List so we can compare multiple values over time

// initializing flags here
boolean pulse = false;    // made true in serialEvent when processing gets new IBI value from arduino


void setup() {
  background(255);
size(1024, 600, P3D); // Stage size
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
  int beatsToMeasure = 20;
if (beatIntervals.size() > beatsToMeasure) { //take beatsToMeasure beats to calibrate
  //drawPoincare();
  calculateWaveVariance(beatsToMeasure); //
}  
}

void calculateWaveVariance(int _sampleSize) {
  int[] sampleArray = new int[_sampleSize];
  int counter = 0;
  for (int i=beatIntervals.size()-_sampleSize; i<beatIntervals.size(); i++) { //load native array with sample values
    sampleArray[counter] = beatIntervals.get(i);
    counter++;
  }
  drawIntervalWaveAsBlobs(sampleArray);
  drawIntervalWaveAsCurve(sampleArray);
  // drawHeartRate();
}

void drawHeartRate() {
  pushStyle();
  ellipseMode(CENTER);
  rectMode(CENTER);
  pushStyle();
  noFill();
  stroke(0);
  rect(width-100, height-100, 70, 70);
  popStyle();
  ellipse(width-100, height-100, map(ppgY, 0, maxppgY, 10, 50), map(ppgY, 0, maxppgY, 10, 50));
  popStyle();
  // int calcBeatsPerMinute
}

void drawIntervalWaveAsBlobs(int[] _sampleArray) {
  int counter = 0;
  pushStyle();
  noStroke();
  fill(120);
  // fill(0, map(ppgY, 0, maxppgY, 200, 10));
  for (int i=0; i<_sampleArray.length; i++) { //look through the specified set of interval measurements
    float yPos = map(_sampleArray[i], 0, maxInterval(), height-60, 60);
    float xPos = map(counter, 0, _sampleArray.length, 30, width-30);
    // ellipse(xPos, yPos, map(ppgY, 0, maxppgY, 10, 50), map(ppgY, 0, maxppgY, 10, 50));
    ellipse(xPos, yPos, 30, 30);
    if (i == _sampleArray.length-1) {
      ellipse(xPos, yPos, map(ppgY, 0, maxppgY, 10, 50), map(ppgY, 0, maxppgY, 10, 50));
    }
    counter++;
  }
  popStyle();
}

void drawIntervalWaveAsCurve(int[] _sampleArray) {
  int counter = 0;
  pushStyle();
  noFill();
  stroke(0);
  beginShape();
  for (int i=0; i<_sampleArray.length; i++) { //look through the specified set of interval measurements
    float yPos = map(_sampleArray[i], 0, maxInterval(), height-60, 60);
    float xPos = map(counter, 0, _sampleArray.length, 30, width-30);
    curveVertex(xPos, yPos);
    counter++;
  }
  endShape();
  popStyle();
}

float maxInterval() { //get the largest value in the sample arrray
  float maxVal = 0;
  for (int i=0; i<beatIntervals.size(); i++) {
    if (beatIntervals.get(i) > maxVal) {
      maxVal = beatIntervals.get(i);
    }
  }
  return maxVal;
}
