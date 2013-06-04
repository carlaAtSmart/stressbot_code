int frame = 0; // The frame to display
int textX = 512;
int textY = 530;  
PImage[] images = new PImage[7]; // Image array

void defineFaceAnim() {
  images[0] = loadImage("botFace1-01.png");
  images[1] = loadImage("botFace2-01.png");
  images[2] = loadImage("botFace3-01.png");
  images[3] = loadImage("botFace0-01.png");
  images[4] = loadImage("botFace3-01.png");
  images[5] = loadImage("botFace2-01.png");
  images[6] = loadImage("botFace1-01.png");
}

void drawFaceAnim() {
  frameRate(15);
  frame++;
  if (frame == images.length) {
    frame = 0;
    delay(int(random(1000, 3000)));
  }
  image(images[frame], 0, 0);

  textFont(botFont); 
  fill(255, 253, 248);            // eggshell white
  textAlign(CENTER);
  text("Hello! Place your finger on the sensor to measure your stress.", textX, textY);
}

void confirmation() {
  background(0);//clear
  image(images[3], 0, 0);
  textFont(botFont); 
  fill(255, 253, 248);            // eggshell white
  text("Great! Now stay still while I read your heart rate.", textX, textY);
}

void putFingerBack() {
  frameRate(15);
  frame++;
  if (frame == images.length) {
    frame = 0;
    delay(int(random(1000, 3000)));
  }
  image(images[frame], 0, 0);
}

