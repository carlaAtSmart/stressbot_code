void setup() {
  size(1000, 600);
  background(255);
}

int fillVal = 0;
int fillInc = 1;
float xPos = 0; //x-axis position across the screen

void draw() {
  noStroke();
  float waveVal = 0; //x-axis postion across this wave
  float increment = TWO_PI/20; //x-axis interval
  float pointCounter = 0; //where are we in the wave
  while (xPos < width) {
    fill(fillVal);
    ellipseMode(CENTER);
    float yPos = (height/2)+sin(waveVal)*100;
    println(yPos);
    ellipse(xPos, yPos, 30, 30);
    xPos += 15;
    waveVal += increment;
    if (waveVal >= TWO_PI) waveVal = 0;
  }
  xPos = -10;
  fillVal += fillInc;
  if (fillVal <= 0 || fillVal >= 255) fillInc *= -1;
}

