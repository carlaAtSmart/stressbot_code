import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class pulSensor_STRESSBOT_20130515 extends PApplet {

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

 
 Serial port;

int test;                 // general debugger
int pulseRate = 0;        // used to hold pulse rate value from arduino (updated in serialEvent)
int Sensor = 0;           // used to hold raw sensor data from arduino (updated in serialEvent)
int IBI;                  // length of time between heartbeats in milliseconds (updated in serialEvent)
int ppgY;                 // used to print the pulse waveform

ArrayList<Integer> beatIntervals;

// initializing flags here
boolean pulse = false;    // made true in serialEvent when processing gets new IBI value from arduino


public void setup() {
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
public void draw() {
  background(255, 10);
  if (beatIntervals.size() > 20) { //take 20 beats to calibrate
    drawPoincare();
  }  
}

public void drawPoincare() {
  curveTightness(map(mouseX, 0, width, -5, 5));
  pushStyle();
  noFill();
  beginShape();
  int counter = 0;
      for (int i=beatIntervals.size()-16; i<beatIntervals.size(); i++) { //get the last 30 values
        float xPos = beatIntervals.get(i-1);
        xPos = normalizeIntervalVal(xPos, width); //normalize x-value
        float yPos = beatIntervals.get(i);
        yPos = normalizeIntervalVal(yPos, height); //get and normalize y-value
        curveVertex(xPos, yPos, 0);
      }
      endShape();
      popStyle();
    }

    public float normalizeIntervalVal(float _arrayVal, int _screenSize) {
      float _val = map(_arrayVal, 0, maxInterval(), 30, _screenSize-30);
      return _val;
    }

    public int maxInterval() {
      int maxVal = 0;
      for (int i=0; i<beatIntervals.size(); i++) {
        if (beatIntervals.get(i) > maxVal) {
          maxVal = beatIntervals.get(i);
        }
      }
      return maxVal;
    }

public void serialEvent(Serial port){   
   String inData = port.readStringUntil('\n');  
   
   if (inData.charAt(0) == 'Q'){          // leading 'Q' means time between beats in milliseconds
     inData = inData.substring(1);        // cut off the leading 'Q'
     inData = trim(inData);               // trim the \n off the end
     IBI = PApplet.parseInt(inData); 
     addBeat(IBI);                  // convert ascii string to integer IBI 
     println("IBI: " + IBI);                
     return;     
   }
   
   if (inData.charAt(0) == 'S'){          // leading 'S' means sensor data
     inData = inData.substring(1);        // cut off the leading 'S'
     inData = trim(inData);               // trim the \n off the end
     ppgY = PApplet.parseInt(inData);                  // convert the ascii string to ppgY
   return;     
   }   
   
    if (inData.charAt(0) == 'F'){          // leading 'S' means sensor data
     inData = inData.substring(1);        // cut off the leading 'F'
     inData = trim(inData);               // trim the \n off the end
   return;     
   }  
}// END OF SERIAL EVENT

public void addBeat(int _beatInterval) {
  beatIntervals.add(_beatInterval);
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "pulSensor_STRESSBOT_20130515" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
