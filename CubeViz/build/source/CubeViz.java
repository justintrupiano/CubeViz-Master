import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import peasy.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class CubeViz extends PApplet {

//// MOON DEMO
////
//// Code to create visualizations for Fiske's CubicAwe: A 16x16x16 LED Cube.
////
//// Contact Justin Trupiano with any questions:
//// justintrupiano.com
//// justintrupiano@gmail.com
////

String dataDir    = "../data/"; /// CHANGE TO LOCAL DATA FOLDER IF NEEDED
 /// PeasyCam LIBRARY
PeasyCam cam;

LEDCube ledCube;

Object3d saturnV;
Object3d flames;
float position = -100;


PShape newSphere;

public void settings(){
  // fullScreen(P3D, 1);
  size(500, 500, P3D);
}

public void setup(){

  background(51);
  //// cam and translate() center the cube on the screen and give rotate capabilities
  cam = new PeasyCam(this, 2000);
  cam.rotateX(PI*0.5f);
  cam.rotateZ(PI);
  ///////////////////////////////////////////////////////////////////////////////////

  //// LEDCube OBJECT REQUIRES INTS FOR X,Y,Z SIZES, AND DISTANCE BETWEEN THE LEDS.
  //// LEDCube(int height, int depth, int width, int distBetweenLEDS).
  ledCube = new LEDCube(16,16,16,100);

  //// INITIATE NEW 3D OBJECT
  // objectVar = new Object3d(new PVector(<<CENTER VECTOR>>),       //// POSITION OF OBJECT
  //                          new PVector(<<SCALE X,Y,Z>>),         //// SCALE OF OBJECT
  //                         cubeVar                                //// CUBE TO PUT OBJECT ON -- THIS IS IN CASE USER CREATES MULTIPLE CUBES
  //                         );

  saturnV = new Object3d(new PVector((ledCube.cubeHeight-0.75f)/2,
                                  (position),
                                  (ledCube.cubeWidth-0.75f)/2
                                  ),                  //// OBJECT POSITION
                          new PVector(1,1,1),   //// SCALE OF OBJECT
                          ledCube                     //// CUBE TO PUT OBJECT ON -- THIS IS INCASE USER CREATES MULTIPLE CUBES
                          );

  flames = new Object3d(new PVector((ledCube.cubeHeight-0.75f)/2,
                                  (position),
                                  (ledCube.cubeWidth-0.75f)/2
                                  ),                  //// OBJECT POSITION
                          new PVector(1,1,1),   //// SCALE OF OBJECT
                          ledCube                     //// CUBE TO PUT OBJECT ON -- THIS IS INCASE USER CREATES MULTIPLE CUBES
                          );

  saturnV.loadOBJ(dataDir + "saturnV_lowRes.obj"); //// THIS LOADS ONLY THE VERTS, SO THE MORE VERTS THE MORE DENSE THE DISPLAY
  // saturnV.loadOBJ(dataDir + "saturnV_lowRes.obj"); //// THIS LOADS ONLY THE VERTS, SO THE MORE VERTS THE MORE DENSE THE DISPLAY
  flames.loadOBJ(dataDir + "flames.obj"); //// THIS LOADS ONLY THE VERTS, SO THE MORE VERTS THE MORE DENSE THE DISPLAY

}


public void draw(){
  //// cam AND translate() CENTER THE CUBE ON THE SCREEN AND PROVIDE ROTATE CAPABILITIES TO THE USER ---- FOR VIEWING PURPOSES ONLY, DOES NOT AFFECT THE FINAL OUTPUT ////
  //// THIS IS LEFT SEPERATE FROM THE CUBE OBJECT CLASS SO THE USER WILL HAVE CHOICE OF PLACEMENT --- DEFAULT IS TOP LEFT CORNER ////
  background(51);
  translate(-((ledCube.ledSpacing)*(ledCube.cubeHeight-1))/2,
            -((ledCube.ledSpacing)*(ledCube.cubeDepth))/2,
            -((ledCube.ledSpacing)*(ledCube.cubeWidth-1))/2
            );
  ////////////////////////////////////////////////////////////////////////////////////

  ledCube.colorCube(color(00,15,33));
  if (position < 100){
    position += 1;
  }
  else{
    position = -100;
  }

  saturnV.objPosition.y = position;
  saturnV.drawObjectOnCube();	                    //// SET LEDS TO ON ////

  flames.objPosition.y  = position - 5;

  flames.colorObj(color(61, 101, 192)); /// BLUE-ISH
  flames.drawObjectOnCube();

  flames.objPosition.y  = position;

  flames.colorObj(color(221, 100, 53)); /// ORANGE-ISH
  flames.drawObjectOnCube();

  saturnV.colorObj(color(200, 200, 200));
  // flames.colorObj(color(200, 75, 0));
  // ledCube.highlightCorners();
  ledCube.saveFrames(800, "Output.bmp");        ////SAVES Output.bmp FILE WITH EVERY FRAME FROM START OF VIZ UNTIL FRAME OF SPECIFIED INT ////


  ledCube.displayCube();						            //// DISPLAYS CUBE FOR USER --- DATA IS STILL PROCESSED ////
  ledCube.clearCube(); 							            //// RESET ALL LEDS BACK TO color(0) --- READY FOR NEXT FRAME ////



}
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

	public void displayCube(){
			//// SHOW LEDS WITH CURRENT COLORS ////
			for (int x = 0; x < cubeHeight; x++) {
				for (int y = 0; y < cubeDepth; y++) {
					ledStrips[x][y].drawPoints();
				}
			}
		}

	public void clearCube(){
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


	public void colorCube(int thisColor){
		//// MAKE CUBE ONE SINGLE PROVIDED COLOR ////
				for (int x = 0; x < cubeHeight; x++) {
					for (int y = 0; y < cubeDepth; y++) {
						for (int z = 0; z < cubeWidth; z++){
						ledStrips[x][y].leds[z].ledColor = thisColor;
					}
				}
			}
		}

	public void rgbColorSpace(){
		//// MAP RGB COLORSPACE ONTO CUBE --- MOSTLY USED FOR ORIENTATION DEBUGGING ////
		  for (int x = 0; x < cubeHeight; x++) {
		    for (int y = 0; y < cubeDepth; y++) {
		      for (int z = 0; z < cubeWidth; z++){
		        int xColor = PApplet.parseInt(map(x, 0, 15, 0, 255));
		        int yColor = PApplet.parseInt(map(y, 0, 15, 0, 255));
		        int zColor = PApplet.parseInt(map(z, 0, 15, 0, 255));
		        ledStrips[x][y].leds[z].ledColor       = color(xColor, yColor, zColor);
		    }
		  }
		}
	}




	public void highlightCorners(){
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

	public void saveFrames(int numFrames, String outputFilename){ //// TODO ADD START FRAME / END FRAME
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
class singleLED {
	int 		ledColor;
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

	public void drawPoints(){
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
class Object3d{
	PVector 		objPosition;
	PVector 		objScale;
	float[][] 	objArray;
	LEDCube 		objCube;

	Object3d (PVector thisPos, PVector thisScale, LEDCube thisCube){
		objPosition 	= thisPos; 		//// POSITION OF OBJECT IN CUBE
		objScale 			= thisScale;	//// SCALE OF OBJECT ON CUBE (VARIES WITH OBJ)
		objCube 			= thisCube;		//// WHICH CUBE SHOULD THE OBJECT BE PLACED ON (FOR MULTIPLE CUBES)
	}

	public void loadOBJ(String objFilename){
		objArray 			= getObjArray(objFilename, "v ", " ", "//");
	}

	public float[][] getObjArray(String objFileName, String startSubString, String splitString, String separator){
		//// TODO AUTO DETECT TYPE OF OBJ FILE --- AS IS, THIS FUNCTION ONLY RECOGNIZES OBJ FILES WITH TRIANGULAR FACES ////

	  String[] objFile       = loadStrings(objFileName);
	  String[] stringArray   = new String[0];

	  for (int i =0; i < objFile.length; i++){
	    if (objFile[i].substring(0, 2).equals(startSubString)) {
	      stringArray = append(stringArray, objFile[i].substring(2));
	    }
	  }

	  objArray = new float[stringArray.length][0];

	  for (int i = 0; i < stringArray.length; i++) {
	    String[] thisString  	= split(stringArray[i].replaceAll(separator, " "), splitString);
	    float[] thisArray   	= new float[0];
	    for (int j = 0; j < thisString.length; j++) {
	        objArray[i] = append(objArray[i], PApplet.parseFloat(thisString[j]));
	    }
	  }
	  return objArray;
	}


	public void rotateObj (float theta, int direction){
		float sin_t = sin(theta);
		float cos_t = cos(theta);

		for (int v = 0; v < objArray.length-1; v++) {

			if (direction == X || direction == Y){ //// IS A SEPERATE Y NEEDED? I THINK IT FUNCTIONS THE SAME AS X IN THIS CONTEXT... CONVINCE ME OTHERWISE. ////
				float y = objArray[v][1];
				float z = objArray[v][2];
				objArray[v][1] = y * cos_t - z * sin_t;
				objArray[v][2] = z * cos_t + y * sin_t;
			}

			if (direction == Z){
	      float x = objArray[v][0];
	      float z = objArray[v][2];

	      objArray[v][0] = x * cos_t - z * sin_t;
	      objArray[v][2] = z * cos_t + x * sin_t;
		}
	}
}

	public void changeScale(PVector changeInScale){
		objScale = objScale.add(changeInScale);
	}

	public void drawObjectOnCube(){
		//// TODO CHANGE COLORS OF LEDS THAT CORRESPOND WITH THIS OBJECT
	  for (int v = 0; v < objArray.length; v++){

	    int x = Math.round(objPosition.x + (objArray[v][0])*objScale.x);
	    int y = Math.round(objPosition.y + (objArray[v][1])*objScale.y);
	    int z = Math.round(objPosition.z + (objArray[v][2])*objScale.z);

	    if (x < objCube.cubeHeight &&
	    	y < objCube.cubeDepth &&
	    	z < objCube.cubeWidth &&
	    	x >= 0 &&
	    	y >= 0 &&
	    	z >= 0
	    	)
	    {
	      	objCube.ledStrips[x][y].leds[z].ledOn = true;
					//// TODO COLOR SHOULD BE ASSIGNED DIRECTLY TO VECTORS IN COLORARRAY ////
	      	// objCube.ledStrips[thisX][thisY].leds[thisZ].ledColor 	= objectColor;
	    }
	  }
	}

	public void getShapeArray(int type, int size){
		shapeMode(CENTER);
		PShape newShape = createShape(type, size);
		//
		objArray = new float[newShape.getVertexCount()][0];
		for (int i = 0; i < newShape.getVertexCount(); i++){

			objArray[i] = append(objArray[i], newShape.getVertex(i).x);
			objArray[i] = append(objArray[i], newShape.getVertex(i).y);
			objArray[i] = append(objArray[i], newShape.getVertex(i).z);

		}
}


public void colorObj(int thisColor){
	for (int v = 0; v < objArray.length; v++){
	int x = Math.round(objPosition.x + (objArray[v][0])*objScale.x);
	int y = Math.round(objPosition.y + (objArray[v][1])*objScale.y);
	int z = Math.round(objPosition.z + (objArray[v][2])*objScale.z);

	if (x < objCube.cubeHeight &&
			y < objCube.cubeDepth &&
			z < objCube.cubeWidth &&
			x >= 0 &&
			y >= 0 &&
			z >= 0
			){
				objCube.ledStrips[x][y].leds[z].ledColor 	= thisColor;
			}
	}
}



	// void mapImage(String imageFile){
	// //// TODO SET TEXTURE MAPPING ////
	// ///// ITERATE THROUGH THE OBJARRAY AND ASSIGN COLORS TO EQULIVENT COLORARRAY POSITIONS
	// for (int v = 0; v < objArray.length; v++){
	// int x = Math.round(objPosition.x + (objArray[v][0])*objScale.x);
	// int y = Math.round(objPosition.y + (objArray[v][1])*objScale.y);
	// int z = Math.round(objPosition.z + (objArray[v][2])*objScale.z);
	//
	// if (x < objCube.cubeHeight &&
	// 		y < objCube.cubeDepth &&
	// 		z < objCube.cubeWidth &&
	// 		x >= 0 &&
	// 		y >= 0 &&
	// 		z >= 0
	// 		){
	// 			// objCube.ledStrips[x][y].leds[z].ledColor 	= thisColor;
	// 		}
	// }




	// void iterateImagePos(){
	// 	if (colorImagePos >= imageSize-iterateSpeed){
	// 		colorImagePos 	= 0;
	// 	}
	// 	else{
	// 		colorImagePos 	+= iterateSpeed;
	// 	}
	// }

	// 	for (int x = 0; x < objCube.cubeHeight; x++) {
	// 		for (int y = 0; y < objCube.cubeDepth; y++) {
	// 			for (int z = 0; z < objCube.cubeWidth; z++){
	// 				//// NEED TO ITERATE THROUGH ALL LEDS XYZ
	// 			// 	if (dist(x,y,z,objPosition) < 8){
	// 			/// IF LED IS ON:
	// 				if(ledOn){
	// 								ledStrips[x][y].leds[z].thisColor = color(earth.get(ledStrips[x][y].leds[z].colorImagePos, round(map(x, 0, numStripsHeight, 0, 1023))));
	// 								objCube.ledStrips[x][y].leds[z].ledColor 	= color(255, 0, 0);
	// 				}
	// 			// }
	// 		}
	// 	}
	// }

	// 	for (int v = 0; v < colorArray.length; v++){

	// 	    int thisX = Math.round(objPosition.x + (objArray[v][0])*objScale.x);
	// 	    int thisY = Math.round(objPosition.y + (objArray[v][1])*objScale.y);
	// 	    int thisZ = Math.round(objPosition.z + (objArray[v][2])*objScale.z);

	// 	    if (thisX < objCube.cubeHeight &&
	// 	    	thisY < objCube.cubeDepth &&
	// 	    	thisZ < objCube.cubeWidth &&
	// 	    	thisX >= 0 &&
	// 	    	thisY >= 0 &&
	// 	    	thisZ >= 0
	// 	    	)
	// 	    {
	// 	      	objCube.ledStrips[thisX][thisY].leds[thisZ].ledOn 			= true;

	// 	      	//// HERE BE DRAGONS... THE OBJECT SHOULDN'T HAVE A GLOBAL COLOR ////
	// 			objCube.ledStrips[thisX][thisY].leds[thisZ].ledColor 		= objectColor;
	// 	    }
	//   	}

	// 	if (style == 'RANDOM'){
	// 	//// GET RANDOM POINT FROM IMAGE ////

	// 	  }
	// 	if (style == 'ITERATE'){
	// 	//// LOOP THROUGH IMAGE PIXELS LEFT TO RIGHT ////

	// 	}

	// 	if (style == 'MAP'){
	// 	//// MAP ARRAY LOCATION TO PIXEL LOCATION ////
	// 	// ledStrips[x][y].leds[currentZ].thisColor = color(colorImage.get(ledStrips[x][y].leds[currentZ].colorImagePos, 1));
	// 	}

	// 	else{
	// 	}
	// 	  colorImage  = loadImage(dataDir + "filename.png");
	// }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "CubeViz" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
