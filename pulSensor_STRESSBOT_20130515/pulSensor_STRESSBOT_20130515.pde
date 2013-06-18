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

IntList beatIntervals; //store each beat interval in an IntList so we can compare multiple values over time
int beatsCount = 24; //number of beats to sample from the IntList

float sineCurveStart = 0; //intitialize default point to start the sivewave


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
  port = new Serial(this, Serial.list()[6], 115200); // choose the right baud rate
  port.bufferUntil('\n');          // arduino will end each ascii number string with a carriage return 
  port.clear();                    // flush the Serial buffer
}  // END OF SETUP

//----------------------------------------------------------------
void draw() {
  background(255);
  if (personIsNear) {
    //TODO: draw wakwup animation
    if (fingerIsInserted) {
      //draw intro animation
      if(beatIntervals.size() == beatsCount) sineCurveStart = getIBICycleCrestPoint();
      if(beatIntervals.size() <= beatsCount) introHeartBeat();
      else { //take beatsCount beats to calibrate
        // background(map(ppgY, 0, maxppgY, ));
        sineCurveStart = drawSineCurve(sineCurveStart);
        ibiCurveStart = drawIntervalWaveAsCurve(ibiCurveStart); //draw the curve version of the beat intervals
        }
      }
    }
  }

