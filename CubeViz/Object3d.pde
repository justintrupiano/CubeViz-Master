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

	void loadOBJ(String objFilename){
		objArray 			= getObjArray(objFilename, "v ", " ", "//");
	}

	float[][] getObjArray(String objFileName, String startSubString, String splitString, String separator){
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
	        objArray[i] = append(objArray[i], float(thisString[j]));
	    }
	  }
	  return objArray;
	}


	void rotateObj (float theta, int direction){
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

	void changeScale(PVector changeInScale){
		objScale = objScale.add(changeInScale);
	}

	void drawObjectOnCube(){
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

	void getShapeArray(int type, int size){
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


void colorObj(color thisColor){
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
