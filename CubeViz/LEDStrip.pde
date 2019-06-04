class singleLED {
	color 		ledColor;
	boolean 	ledOn = false;

	singleLED (){
		ledColor = color(0);
	}
}

class LEDStrip {
	singleLED[] 	leds;
	PVector 		stripPos;
	int 			cubeWidth;
	int 			ledSpacing;
	int 			ledSize = 10; 

	boolean 		showNums = false;

	LEDStrip (int x, int y, int numLedPerStrip, int distBetweenLEDS){
		ledSpacing 	= distBetweenLEDS;
		cubeWidth 	= numLedPerStrip;
		leds 		= new singleLED[cubeWidth];
		stripPos 	= new PVector(0, x, y);

		for (int z = 0; z < cubeWidth; z++){
			leds[z] = new singleLED();
		}
	}

	void drawPoints(){
		strokeWeight(ledSize);
		for (int x = 0; x < cubeWidth; x++){
				stroke(leds[x].ledColor);
				point(x*ledSpacing, stripPos.y*ledSpacing, stripPos.z*ledSpacing);

			if(showNums){
			  text("(" + str(x) + ", " + str(stripPos.y) + ", " + str(stripPos.z) + ") ",
					x*ledSpacing, stripPos.y*ledSpacing, stripPos.z*ledSpacing);
			}
		}
	}
}
