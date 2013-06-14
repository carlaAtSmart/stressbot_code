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

IntList beatIntervals; //store each beat interval in an Array List so we can compare multiple values over time
int beatsCount = 24; //number of beats to sample from the ArrayList

// initializing flags here
boolean pulse = false;    // made true in serialEvent when processing gets new IBI value from arduino
boolean personIsNear = true; // set true in serialEvent when prox sensor is activated
boolean fingerIsInserted = true; //set true in serialEvent when photocell is activated


void setup() {
  frameRate(20);
  background(255);
  size(1024, 600); // Stage size
  // screenMask = loadImage("stressbot-screen-mask.png");

  beatIntervals = new IntList(); //create empty array list

    // FIND AND ESTABLISH CONTACT WITH THE SERIAL PORT
  println(Serial.list());       // print a list of available serial ports
  port = new Serial(this, Serial.list()[0], 115200); // choose the right baud rate
  port.bufferUntil('\n');          // arduino will end each ascii number string with a carriage return 
  port.clear();                    // flush the Serial buffer
}  // END OF SETUP

//----------------------------------------------------------------
void draw() {
  background(255);
  if (personIsNear) {
    //TODO: draw wakwup animation
    if (fingerIsInserted) {
      //TODO: draw intro animation
      if(beatIntervals.size() <= beatsCount) {
        drawHeartRate(width/2, height/2);
        pushStyle();
          textSize(40);
          fill(175);
          text(beatsCount - beatIntervals.size(), width/2, (height/2)-60);
        popStyle();
      }
      else { //take beatsCount beats to calibrate
        sineCurveStart = drawSineCurve(sineCurveStart);
        drawHeartRate(width-80, height-80);
        ibiCurveStart = drawIntervalWaveAsCurve(ibiCurveStart); //draw the curve version of the beat intervals
        }
      }
    }
  }

void drawHeartRate(int _xPos, int _yPos) {
  pushStyle();
  ellipseMode(CENTER);
  rectMode(CENTER);
  pushStyle();
  noFill();
  stroke(0);
  rect(_xPos, _yPos, 70, 70);
  popStyle();
  fill(map(ppgY, 0, maxppgY, 230, 25));
  ellipse(_xPos, _yPos, map(ppgY, 0, maxppgY, 10, 50), map(ppgY, 0, maxppgY, 10, 50));
  popStyle();
}

float ibiCurveStart = 0;

float drawIntervalWaveAsCurve(float xStart) {
  float interval = width/(beatsCount-4);
  float xPos = xStart-interval; //set the first point off-screen as it is a control point and won't be drawn
  pushMatrix();
    translate(0, height/2); //move vertical origin to center of screen. This will likely change to accomodate the frame overlay
    pushStyle();
      noFill();
      strokeWeight(20);
      smooth();
      stroke(0);
      beginShape();
      for (int i=0; i<beatIntervals.size(); i++) {  //step through the set of interval vals
        float yPos = map(beatIntervals.get(i), 0, 1500, -150, 150); 
        curveVertex(xPos, yPos);
        xPos+=interval;
      }
      endShape();
    popStyle();
  popMatrix();
  return xStart-1;
}

void drawIntervalWaveAsBlobs(int[] _sampleArray) {
  int counter = 0;
  pushStyle();
  noStroke();
  fill(120);
  for (int i=0; i<_sampleArray.length; i++) { //look through the specified set of interval measurements
    float yPos = map(_sampleArray[i], 0, maxInterval(), height-60, 60);
    float xPos = map(counter, 0, _sampleArray.length, 30, width-30);
    ellipse(xPos, yPos, 30, 30);
    if (i == _sampleArray.length-1) {
      ellipse(xPos, yPos, map(ppgY, 0, maxppgY, 10, 50), map(ppgY, 0, maxppgY, 10, 50));
    }
    counter++;
  }
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
