void drawCalibrationStatus() {
  pushMatrix();
    translate(width/2, height/2);
    pushStyle();
      noStroke();
      fill(map(ppgY, 0, maxppgY, 255, 200));
      pushStyle();
      ellipseMode(CENTER);
      float counterPosX = -12*5*5+7.5;
        for (int i=0; i<beatsCount; i++) {
          fill(200);
          if (i < beatIntervals.size()) fill(80);
          rect(counterPosX, -15, 8, 15, 3);
          counterPosX += 25;
          // float _size = map(beatsCount-beatIntervals.size(), 0, beatsCount, 0, height-25);
          // ellipse(0, 0, _size, _size);
        }
      popStyle();
    popStyle();
    drawHeartRate(0,60);
    pushStyle();
      textAlign(CENTER);
      fill(0);
      textSize(30);
      if (getAverageBPM() > 0) {
        String heartRate = "Your Heartrate is " + str(getAverageBPM()) + " beats per minute, which is " + describeBPM() + ".";
        text(heartRate, 0, 130); //draw average bpm to screen
      }
      else text("calibrating", 0, 130);
    popStyle();
  popMatrix();
}

void drawHeartRate(int _xPos, int _yPos) {
  PImage bpmIcon = loadImage("BPMicon.png");
  pushStyle();
    ellipseMode(CENTER);
    imageMode(CENTER);
    rectMode(CENTER);
    pushStyle();
      noFill();
      stroke(0);
      rect(_xPos, _yPos, 70, 70);
    popStyle();
    fill(map(ppgY, 0, maxppgY, 230, 25));
    // ellipse(_xPos, _yPos, map(ppgY, 0, maxppgY, 10, 50), map(ppgY, 0, maxppgY, 10, 50));
    image(bpmIcon, _xPos, _yPos, map(ppgY, 0, maxppgY, 10, 50), map(ppgY, 0, maxppgY, 10, 50));
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
        float yPos = map(beatIntervals.get(i), minIBIVal, maxIBIVal, -150, 150); 
        curveVertex(xPos, yPos);
        xPos+=interval;
      }
      endShape();
    popStyle();
  popMatrix();
  return xStart-1;
}

// Variables to control background sine wave
float drawSineCurve(float xStart){
  float _waveLength = width/5;
  pushStyle();
    smooth();
    noFill();
    ellipseMode(CENTER);
    pushMatrix();
      translate(0, height/2); //move the coordinate system down to the middle of the screen
      strokeWeight(1);
      stroke(180);
      strokeWeight(25);
      stroke(200);
      beginShape(); //start drawing the curve
        float yPos = 150; //height of curve
        float controlLength = _waveLength/2;
        vertex(xStart, yPos);
        for(float i=xStart; i<width+_waveLength; i+=_waveLength){
          //calculate first control point at the bottom fo the wave
          float cp1X = i+controlLength;
          //calculate next point on curve
          float nextPtX = i+_waveLength;
          //calculate second control point
          float cp2X = nextPtX-controlLength;
          bezierVertex(cp1X, yPos, cp2X, yPos*-1, nextPtX, yPos*-1);
          yPos*=-1;         
        }
      endShape();
    popMatrix();
  popStyle();
  return xStart-1;
}