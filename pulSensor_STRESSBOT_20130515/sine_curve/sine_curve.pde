float waveStart = 0;
float waveOffset = 1;
float waveCount = 6;
float waveLength = width/waveCount;

void setup(){
	size(1024, 600);
}

void draw(){
	background(255);
	drawSineCurve(waveStart, waveCount);	
	waveStart -= 1;
}

void drawSineCurve(float xStart, float _waveCount){
	float _waveLength = width/_waveCount;
	pushStyle();
		smooth();
		noFill();
		ellipseMode(CENTER);
		pushMatrix();
			translate(0, height/2); //move the coordinate system down to the middle of the screen
			strokeWeight(1);
			stroke(180);
			line(0, 0, width, 0);
			strokeWeight(40);
			stroke(0, 25);
			beginShape(); //start drawing the curve
				float yPos = 200; //height of curve
				float controlLength = _waveLength/1.8;
				vertex(xStart, yPos);
				for(float i=xStart; i<width+_waveLength; i+=_waveLength){
					//calculate first control point
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
}