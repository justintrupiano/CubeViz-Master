//// MOON DEMO
////
//// Code to create visualizations for Fiske's CubicAwe: A 16x16x16 LED Cube.
////
//// Contact Justin Trupiano with any questions:
//// justintrupiano.com
//// justintrupiano@gmail.com
////

String dataDir    = "../data/"; /// CHANGE TO LOCAL DATA FOLDER IF NEEDED
import peasy.*; /// PeasyCam LIBRARY
PeasyCam cam;

LEDCube ledCube;

Object3d moon;

PShape newSphere;

void settings(){
  fullScreen(P3D, 1);
}

void setup(){

  background(51);
  //// cam and translate() center the cube on the screen and give rotate capabilities
  cam = new PeasyCam(this, 2000);
  cam.rotateX(PI*0.5);
  cam.rotateZ(PI);
  ///////////////////////////////////////////////////////////////////////////////////

  //// LEDCube OBJECT REQUIRES INTS FOR X,Y,Z SIZES, AND DISTANCE BETWEEN THE LEDS.
  //// LEDCube(int height, int depth, int width, int distBetweenLEDS).
  ledCube = new LEDCube(16,16,16,100);

  //// INITIATE NEW Object3d OBJECT. POSITIONED IN THE CENTER OF THE CUBE, WITH A SCALE ON THE XYZ COORDINATES.
  moon = new Object3d(new PVector((ledCube.cubeHeight-0.75)/2,
                                  (ledCube.cubeDepth-0.75)/2,
                                  (ledCube.cubeWidth-0.75)/2
                                  ),                  //// OBJECT POSITION
                          new PVector(8,8,8),   //// SCALE OF OBJECT
                          ledCube                     //// CUBE TO PUT OBJECT ON -- THIS IS INCASE USER CREATES MULTIPLE CUBES
                          );

  moon.loadOBJ(dataDir + "crecentMoon.obj");
}



void draw(){
  //// cam AND translate() CENTER THE CUBE ON THE SCREEN AND PROVIDE ROTATE CAPABILITIES TO THE USER ---- FOR VIEWING PURPOSES ONLY, DOES NOT AFFECT THE FINAL OUTPUT ////
  //// THIS IS LEFT SEPERATE FROM THE CUBE OBJECT CLASS SO THE USER WILL HAVE CHOICE OF PLACEMENT --- DEFAULT IS TOP LEFT CORNER ////
  background(51);
  translate(-((ledCube.ledSpacing)*(ledCube.cubeHeight-1))/2,
            -((ledCube.ledSpacing)*(ledCube.cubeDepth))/2,
            -((ledCube.ledSpacing)*(ledCube.cubeWidth-1))/2
            );
  ////////////////////////////////////////////////////////////////////////////////////

  moon.drawObjectOnCube(); 	//// SET LEDS TO ON AND APPLY SET COLOR --- COLOR PARAMETER SHOULD BE MOVED TO ITS OWN FUNCTION ////
  moon.rotateObj(0.01, Z);
  moon.colorObj(color(255, 255, 250));

  ledCube.saveFrames(500, "Output.bmp");        ////SAVES Output.bmp FILE WITH EVERY FRAME FROM START OF VIZ UNTIL FRAME OF SPECIFIED INT ////
  ledCube.displayCube();						            //// DISPLAYS CUBE FOR USER --- DATA IS STILL PROCESSED ////
  ledCube.clearCube(); 							            //// RESET ALL LEDS BACK TO color(0) --- READY FOR NEXT FRAME ////



}
