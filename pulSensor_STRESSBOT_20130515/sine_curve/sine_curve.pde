

void setup(){
	size(1024, 600);
}

void draw(){
	background(255);
	drawSineCurve();	
}

void drawSineCurve(){
	pushStyle();
		smooth();
		strokeWeight(10);
		stroke(100);
		noFill();
		ellipseMode(CENTER);
		pushMatrix();
			translate(0, height/2); //move the coordinate system down to the middle of the screen
			line(0, 0, width, 0);
			beginShape(); //start drawing the curve
				float yPos = 200; //height of curve
				float xStart = 0;
				float controlLength = map(mouseX, 0, width, 10, 150);
				text(controlLength, 50, -50);
				float waveCount = 7;
				vertex(xStart, yPos);
				for(float i=xStart; i<width; i+=(width/waveCount)){
					//calculate first control point
					float cp1X = i+controlLength;
					fill(255, 0, 0);
					ellipse(cp1X, yPos, 5, 5);
					//calculate next point on curve
					float nextPtX = i+(width/waveCount);
					fill(0, 255, 0);
					ellipse(nextPtX, yPos*-1, 5, 5);
					//calculate second control point
					float cp2X = nextPtX-controlLength;
					fill(0, 0, 255);
					ellipse(cp2X, yPos*-1, 5, 5);
					noFill();
					bezierVertex(cp1X, yPos, cp2X, yPos*-1, nextPtX, yPos*-1);
					yPos*=-1;					
				}
			endShape();
		popMatrix();
	popStyle();
}