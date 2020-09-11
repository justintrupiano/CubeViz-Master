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

Object3d saturnV;
Object3d flames;
float position = -100;


PShape newSphere;

void settings(){
  // fullScreen(P3D, 1);
  size(500, 500, P3D);
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

  //// INITIATE NEW 3D OBJECT
  // objectVar = new Object3d(new PVector(<<CENTER VECTOR>>),       //// POSITION OF OBJECT
  //                          new PVector(<<SCALE X,Y,Z>>),         //// SCALE OF OBJECT
  //                         cubeVar                                //// CUBE TO PUT OBJECT ON -- THIS IS IN CASE USER CREATES MULTIPLE CUBES
  //                         );

  saturnV = new Object3d(new PVector((ledCube.cubeHeight-0.75)/2,
                                  (position),
                                  (ledCube.cubeWidth-0.75)/2
                                  ),                  //// OBJECT POSITION
                          new PVector(1,1,1),   //// SCALE OF OBJECT
                          ledCube                     //// CUBE TO PUT OBJECT ON -- THIS IS INCASE USER CREATES MULTIPLE CUBES
                          );

  flames = new Object3d(new PVector((ledCube.cubeHeight-0.75)/2,
                                  (position),
                                  (ledCube.cubeWidth-0.75)/2
                                  ),                  //// OBJECT POSITION
                          new PVector(1,1,1),   //// SCALE OF OBJECT
                          ledCube                     //// CUBE TO PUT OBJECT ON -- THIS IS INCASE USER CREATES MULTIPLE CUBES
                          );

  saturnV.loadOBJ(dataDir + "saturnV_lowRes.obj"); //// THIS LOADS ONLY THE VERTS, SO THE MORE VERTS THE MORE DENSE THE DISPLAY
  // saturnV.loadOBJ(dataDir + "saturnV_lowRes.obj"); //// THIS LOADS ONLY THE VERTS, SO THE MORE VERTS THE MORE DENSE THE DISPLAY
  flames.loadOBJ(dataDir + "flames.obj"); //// THIS LOADS ONLY THE VERTS, SO THE MORE VERTS THE MORE DENSE THE DISPLAY

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
