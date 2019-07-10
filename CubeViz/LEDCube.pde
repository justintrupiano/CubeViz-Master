class LEDCube{
	/// THE LEDCube CLASS CREATES A NEW CUBE WITH SPECIFIED DIMENTIONS ////

  // CUBE LAYOUT:
  // xSize, ySize, zSize == Dimensions of the cube
  // In the physical cube: (0,0,0) is in the first column, on the layer nearest the base, on the side with the input data cables.

	PVector cubePos;
	LEDStrip[][] ledStrips;
	int cubeHeight;
	int cubeDepth;
	int cubeWidth;
	int ledSpacing;

	//// PGraphics USED FOR SAVING VIZ FRAME IMAGES ////
	PGraphics frameImage; //// TODO THIS LIMITS THE SAVING OF FRAMES TO A SINGLE CALL, ELSE THERE WILL BE COLLISION PROBLEMS ////


  // TODO ADD CUBE ORIENTATION: TABLE TOP / CEILING
	LEDCube (int numStripsHeight,
				int numStripsDepth,
				int numLedPerStrip,
				int distBetweenLEDS
				)
				{
					cubeHeight 	= numStripsHeight;
					cubeDepth 	= numStripsDepth;
					cubeWidth 	= numLedPerStrip;
					ledSpacing	= distBetweenLEDS;

					cubePos 		= new PVector(0,0,0);

					ledStrips = new LEDStrip[cubeHeight][cubeDepth];
					for (int x = 0; x < cubeHeight; x++) {
						for (int y = 0; y < cubeDepth; y++) {
							ledStrips[x][y] = new LEDStrip(x, y, cubeWidth, ledSpacing);
						}
					}
				}

	void displayCube(){
			//// SHOW LEDS WITH CURRENT COLORS ////
			for (int x = 0; x < cubeHeight; x++) {
				for (int y = 0; y < cubeDepth; y++) {
					ledStrips[x][y].drawPoints();
				}
			}
		}

	void clearCube(){
		//// MAKE CUBE ONE SINGLE PROVIDED COLOR ////
				for (int x = 0; x < cubeHeight; x++) {
					for (int y = 0; y < cubeDepth; y++) {
						for (int z = 0; z < cubeWidth; z++){
							ledStrips[x][y].leds[z].ledOn 		= false;
							ledStrips[x][y].leds[z].ledColor 	= color(0);
					}
				}
			}
		}


	void colorCube(color thisColor){
		//// MAKE CUBE ONE SINGLE PROVIDED COLOR ////
				for (int x = 0; x < cubeHeight; x++) {
					for (int y = 0; y < cubeDepth; y++) {
						for (int z = 0; z < cubeWidth; z++){
						ledStrips[x][y].leds[z].ledColor = thisColor;
					}
				}
			}
		}

	void rgbColorSpace(){
		//// MAP RGB COLORSPACE ONTO CUBE --- MOSTLY USED FOR ORIENTATION DEBUGGING ////
		  for (int x = 0; x < cubeHeight; x++) {
		    for (int y = 0; y < cubeDepth; y++) {
		      for (int z = 0; z < cubeWidth; z++){
		        int xColor = int(map(x, 0, 15, 0, 255));
		        int yColor = int(map(y, 0, 15, 0, 255));
		        int zColor = int(map(z, 0, 15, 0, 255));
		        ledStrips[x][y].leds[z].ledColor       = color(xColor, yColor, zColor);
		    }
		  }
		}
	}




	void highlightCorners(){
		//// HIGHLIGHT CUBE CORNERS USING LEXOGRAPHIC ORDERING --- USED FOR ORIENTATION DEBUGGING ////
		ledStrips[0][0].leds[0].ledColor       	= color(0, 0, 0);
		ledStrips[0][0].leds[cubeWidth-1].ledColor      	= color(0, 0, 255);
		ledStrips[0][cubeDepth-1].leds[0].ledColor      	= color(0, 255, 0);
		ledStrips[0][cubeDepth-1].leds[cubeWidth-1].ledColor     	= color(0, 255, 255);
		ledStrips[cubeHeight-1][0].leds[0].ledColor      	= color(255, 0, 0);
		ledStrips[cubeHeight-1][0].leds[cubeWidth-1].ledColor     	= color(255, 0, 255);
		ledStrips[cubeHeight-1][cubeDepth-1].leds[0].ledColor      = color(255, 255, 0);
		ledStrips[cubeHeight-1][cubeDepth-1].leds[cubeWidth-1].ledColor     = color(255, 255, 255);
	}

	void saveFrames(int numFrames, String outputFilename){ //// TODO ADD START FRAME / END FRAME
			//// SAVE FRAMES INTO BMP FILE --- !! SHOULD BE CALLED IN DRAW FUNTION --AFTER-- APPLYING COLORS !! ////
			//// THE FORMAT OF THE FOR-LOOPS BELOW ARE SPECIFIC TO THE LAYOUT OF THE FISKE CUBE...
			//// ...THE DATA LINES START FROM THE BOTTOM OF EACH COLUMN AT THE 0TH LED AND SNAKE BACK AND FORTH UP THE COLUMN UNTIL THE 255TH LED.
			//// SEE CUBE SCHEMATICS FOR FURTHER EXPLINATION OF DATA-PATH. ////

		 if (frameCount == 1){ //// IF FIRST FRAME, MAKE NEW CANVAS GRAPHIC ////
			 frameImage = createGraphics(cubeHeight*cubeDepth*cubeWidth, numFrames);
			 // frame.background(color(0));
		 }

			frameImage.beginDraw();	//// BEGIN DRAWING TO CANVAS ////

				strokeWeight(1);
				int eachLed = 0; //// 0 - 4095
				int currentZ = 0;
				int zIncrement = 1;

				for (int x = 0; x < cubeHeight; x++) {
					for (int y = 0; y < cubeDepth; y++) {
							if(y % 2 == 0){
								//// EVERY OTHER LINE currentZ STARTS AT 0...
								//// ...THIS IS BECAUSE THE DATA LINES SNAKE BACK-AND-FORTH UP EACH COLUMN
								currentZ = 0;
							}
							else{
								currentZ = cubeWidth-1;
							}
							for (int z = 0; z < cubeWidth; z++){
								frameImage.stroke(ledStrips[x][y].leds[currentZ].ledColor);
								frameImage.point(eachLed, frameCount-1);
								eachLed++;
								currentZ += zIncrement;
							}
							zIncrement *= -1;
					}
				}

			frameImage.endDraw(); //// STOP DRAWING TO CANVAS ////

			if (frameCount == numFrames){
				frameImage.save(outputFilename);
			}

		}

}
