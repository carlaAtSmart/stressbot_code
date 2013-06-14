void introHeartBeat() {
  pushMatrix();
    translate(width/2, height/2);
    pushStyle();
      noStroke();
      fill(map(ppgY, 0, maxppgY, 255, 200));
      for (int i=0; i<beatsCount; i++) {
        float _size = map(beatsCount-beatIntervals.size(), 0, beatsCount, 0, height-25);
        ellipse(0, 0, _size, _size);
      }
    popStyle();
    drawHeartRate(0,0);
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
