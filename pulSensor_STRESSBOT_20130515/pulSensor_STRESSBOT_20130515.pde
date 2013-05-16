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
PFont font, botFont, largerFont;
Serial port;

int test;                 // general debugger
int pulseRate = 0;        // used to hold pulse rate value from arduino (updated in serialEvent)
int Sensor = 0;           // used to hold raw sensor data from arduino (updated in serialEvent)
int IBI;                  // length of time between heartbeats in milliseconds (updated in serialEvent)
int ppgY;                 // used to print the pulse waveform
int FINGER;               //from Photocell on Arduino - if sensor is blocked there's a finger
int[] PPG;                // array of live PPG datapoints
float[] beatTimeX;          // array of X coordinates
int[] beatTimeY;          // array of Y coordinates
int numPoints = 100;      // size of coordinate arrays. sets number of displayed datapoints
int upperH;
float xPos = 97;          // sets the start xPos value to the edge of the graph field
float horizInterval = .05; //the distance between points on the plot
float ySin =0;                //the sin wave
int timer;                 // simple timer to time operations

float oldXBlue = 75;        // to store previous values for line drawing (5000 temporary test value)
float oldYBlue = 0;
float oldXGreen = 75;
float oldYGreen = 0;


// initializing flags here
boolean pulse = false;    // made true in serialEvent when processing gets new IBI value from arduino


void setup() {
  background(0);
  size(1024, 600); // Stage size
  defineFaceAnim();


  //PULSE DATA SCREEN

  beatTimeX = new float[numPoints];    // these two arrays hold the Poncaire Plot data
  beatTimeY = new int[numPoints];    // size of array determines number of displayed points
  PPG = new int[150];                // PPG array that that prints heartbeat waveform
  for (int i=0; i<150; i++) {
    PPG[i] = height/2+65;             // initialize PPG widow with dataline at midpoint
  }
  ppgY = height/2+65;                // initialize ppgY this variable gets updated with new 
  // pulse wave data from Arduino
  //  LOAD THE FONTS
  font = loadFont("Arial-BoldMT-36.vlw");
  largerFont = loadFont("Arial-BoldMT-40.vlw");
  botFont = loadFont("smartneuecond-24.vlw");
  textFont(font);
  textAlign(CENTER);
  rectMode(CENTER);

  // FIND AND ESTABLISH CONTACT WITH THE SERIAL PORT
  println(Serial.list());       // print a list of available serial ports
  port = new Serial(this, Serial.list()[0], 115200); // choose the right baud rate
  port.bufferUntil('\n');          // arduino will end each ascii number string with a carriage return 
  port.clear();                    // flush the Serial buffer
}  // END OF SETUP

//----------------------------------------------------------------
void draw() {
  if (FINGER==0) {
    //FACE
    println(FINGER);  // print if there's a finger or not to the serial monitor
    background(0);//clear screen
    drawFaceAnim();
    timer = millis(); // set timer
  }
  else {
    println(FINGER); // print if there's a finger or not to the serial monitor
    confirmation();
    if ((timer + 3000) < millis()) {  // timer which waits 3 seconds while showing confirmation screen
      if (FINGER == 1) { // checks that the finger is still on
        HR_screen();
      } 
      else {
        putFingerBack();
      }
    }
  }
}  //END OF DRAW



void HR_screen() {
  background(0);//clear screen
  //PULSE
  frameRate(60);
  noStroke(); 
  createPlotWindow();
  refreshWave(xPos);//draw the previous dots

    //  draw the current data point as a red dot `
  fill(250, 0, 0);
  // float  x = map(beatTimeX[0],0,1500,75,600);  // scale the data to fit the screen
  xPos = xPos+horizInterval;

  if (xPos > 847) {         // resets xPos when it reaches the edge of the graph field
    xPos = 97;            // put in something else here to trigger that the reading is done
  }                       // or at least clear out the array holding the values if it should continue to read


  float  y = map(beatTimeY[0], 0, 1500, 615, 25);  // invert y so it looks normal
  ellipse(xPos, y, 5, 5);   // print datapoints as dots 5 pixel diameter


  // print IBI value, which was just graphed on the n axis
  fill(255, 253, 248);    // eggshell white
  text("n: "+IBI+"mS", width-85, 50);
  drawPulseWave();
  noStroke();
}




//----------------------------------------------------------------
void createPlotWindow() {
  //  begin by printing title & etc.
  textFont(font); 
  fill(255, 253, 248);            // eggshell white  
  text("Pulse Sensor HRV Poncaire Plot", width/2-50, 40);

  textFont(font); 
  // fill(255, 253, 248);                        // eggshell white
  fill(172, 172, 172); 
  rect(width/2-40, height/2, 750, 480);     // draw phase space
  fill(200);                                // get ready to print phase space scale
  text("0mS", 40, height-25);                 // origin, scaled in mS
  for (int i=500; i<=1500; i+=500) {         // print x scale
    text(i, 40, map(i, 0, 1500, 615, 75));
  }
  for (int i=500; i<=1500; i+=500) {         // print  y scale
    text(i, 75+map(i, 0, 1500, 0, 550), height-10);
  }
  stroke(0, 30, 250);                         // get ready to draw gridlines
  for (int i=0; i<1500; i+=100) {            // draw grid lines on axes
    line(75, map(i, 0, 1500, 614, 26), 85, map(i, 0, 1500, 614, 26)); //y axis
    line(75+map(i, 0, 1500, 0, 549), height-35, 75+map(i, 0, 1500, 0, 549), height-45); // x axis
  }
  noStroke();
  // print axes legend
  fill(255, 253, 10);
  text("n", 75+map(750, 0, 1500, 0, 550), height-10);    // n is the most recent IBI value
  text("n-1", 40, map(750, 0, 1500, 615, 75));               // n-1 is the one we got before n
}//end createPlotWindow


//---------------------------------------------------------------- 

void drawPulseWave() {
  // GRAPH THE LIVE SENSOR DATA
  // move the y coordinate of the pulse waveform over one pixel left
  for (int i = 0; i < PPG.length-1; i++) {  
    PPG[i] = PPG[i+1];   // new data enters on the right at pulseY.length-1
  }
  //   scale and constrain incoming Pulse Sensor value to fit inside the pulse window
  PPG[PPG.length-1] = int(map(ppgY, 50, 950, (height/2+65)+225, (height/2+65)-225));

  fill(255, 253, 248);    // eggshell white
  noStroke();
  rect(width-85, height/2, 150, 480);    // pulse window
  strokeWeight(1);
  stroke(250, 0, 0);                         // use red for the pulse wave

  for (int i=1; i<PPG.length-1; i++) {      // draw the waveform shape
    PPG[i] = constrain(PPG[i], 60, 540);   // constrain the waveform to stay within the area
    line(width-160+i, PPG[i], width-160+(i-1), PPG[i-1]);
  }
}//end drawPulseWave

//----------------------------------------------------------------

void refreshWave(float whereisX) {
  //move data points left as new ones are added
  //    DRAW THE POINCARE PLOT


  if (pulse == true) {                    // check for new data from arduino
    pulse = false;                       // drop the pulse flag
    for (int i=numPoints-1; i>0; i--) {   // shift the data in n and n-1 arrays 
      beatTimeY[i] = beatTimeY[i-1];
      beatTimeX[i] = beatTimeX[i-1];     // shift the data point through the array
    }
    //beatTimeY[0] = beatTimeX[1];       // toss the last n into the current n-1
    beatTimeY[0] = IBI;                // update the current n
    beatTimeX[0] = whereisX;
  }
  //  draw a hystory of the data points as blue dots
  for (int i=1; i<numPoints; i++) {
    //float  x = map(beatTimeX[i],0,1500,75,600);  // scale the data to fit the screen
    float x = beatTimeX[i];
    float y = map(beatTimeY[i], 0, 1500, 615, 25);  // invert y so it looks normal

    fill(0, 0, 255);//blue
    ellipse(x, y, 4, 4);   // print datapoints as dots 2 pixel diameter


    ySin = sin(x/5)*30;  //perfect sin wave for comparison


    fill(0, 255, 0);//green 
    ellipse(x, ySin+250, 4, 4);
  }
} //END OF REFRESH WAVE

//----------------------------------------------------------------

