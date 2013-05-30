class Eye {
  int size, posX, posY;
  int animLength = 0;
  ArrayList frames = new ArrayList(0);
  Eye (int _size, int _posX, int _posY) {
    //initialize eye object
    size = _size;
    posX = _posX;
    posY = _posY;
  }

  Eye(int _size, int _posX, int _posY, PImage _frames[]) {
    //initialize with optional frame array
    size = _size;
    posX = _posX;
    posY = _posY;
    animLength = _frames.length;
    println("image length: " + _frames.length);
//    frames = new ArrayList(_frames.length);
    for (int i=0; i<_frames.length; i++) {
      //fill the object array
      frames.add(i, _frames[i]);
    }
  }
  
  void addFrames() {
     print ("object size: " + frames.size()); 
  }
}

class Mouth {
  int expression;
  color mouthColor;
}

