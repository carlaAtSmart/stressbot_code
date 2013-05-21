/*
Optional handler to make it easier to make separate displays for the top and bottom of the bot's face.
This is a very thin extension of the createGraphics functionality, and a bit of a hack at that, as it
doesn't actually extend the PGraphics class, but rather just calls the constructors in Processing. 
If we find we need to build more functionality this can serve as a scaffolding.
*/

class Display {
  int dispHeight, dispWidth, dispCornerRadius, dispLocX, dispLocY;
  PGraphics dispBuffer; //create a buffer for this display viewport

//Call the constructor passing in height, width, corner radius, x-location, y-location
  Display (int _dispHeight, int _dispWidth, int _dispCornerRadius, int _dispLocX, int _dispLocY) {
   dispHeight = _dispHeight;
   dispWidth = _dispWidth;
   dispCornerRadius = _dispCornerRadius;
   dispLocX = _dispLocX;
   dispLocY = _dispLocY;
   dispBuffer = createGraphics(dispHeight, dispWidth, P2D);
  }
  
  void updateDisplay() {
    dispBuffer.beginDraw();
  }
  // put graphics between calling these two methods
  
  void drawDisplay() {
    dispBuffer.endDraw();
    image(dispBuffer, dispLocX, dispLocY);
  }
}

