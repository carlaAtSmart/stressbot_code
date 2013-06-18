void introHeartBeat() {
  pushMatrix();
    translate(width/2, height/2);
    pushStyle();
      noStroke();
      fill(map(ppgY, 0, maxppgY, 255, 200));
      pushStyle();
      ellipseMode(CENTER);
      float counterPosX = -12*5*5+5;
        for (int i=0; i<beatsCount; i++) {
          fill(100);
          if (i < beatIntervals.size()) fill(200);
          rect(counterPosX, -15, 8, 15, 3);
          counterPosX += 25;
          // float _size = map(beatsCount-beatIntervals.size(), 0, beatsCount, 0, height-25);
          // ellipse(0, 0, _size, _size);
        }
      popStyle();
    popStyle();
    drawHeartRate(0,50);
    pushStyle();
      textAlign(CENTER);
      fill(0);
      textSize(30);
      text(str(getAverageBPM()), 0, 100);
    popStyle();
  popMatrix();
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
        float yPos = map(beatIntervals.get(i), beatIntervals.min(), beatIntervals.max(), -150, 150); 
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
