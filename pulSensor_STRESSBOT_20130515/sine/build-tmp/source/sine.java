import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class sine extends PApplet {

public void setup() {
  size(1000, 600);
  background(255);
}

int fillVal = 0;
int fillInc = 1;
float xPos = 0; //x-axis position across the screen

public void draw() {
  noStroke();
  float waveVal = 0; //x-axis postion across this wave
  float increment = TWO_PI/20; //x-axis interval
  float pointCounter = 0; //where are we in the wave
  float xInc = 50;
  while (xPos < width) {
    fill(fillVal);
    ellipseMode(CENTER);
    float yPos = (height/2)+sin(waveVal)*100;
    ellipse(xPos, yPos, 30, 30);
    xPos += width/xInc;
    waveVal += increment;
    if (waveVal >= TWO_PI) waveVal = 0;
  }
  xPos = 0;
  fillVal += fillInc;
  if (fillVal <= 0 || fillVal >= 255) fillInc *= -1;
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sine" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
