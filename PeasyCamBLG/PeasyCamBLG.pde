import peasy.*;

PeasyCam cam;

int WINDOW_WIDTH = 640, WINDOW_HEIGHT = 480;

// position of the sphere
float x = 0, y = 0, z = 0;

// position of the camera
float camX = 0, camY = 0, camZ = 0;

// camera viewing distance
float camView = 150;

// shape data
PShape s;
float sRotY = 0;
float sScale = 30;

void setup() {
  size(WINDOW_WIDTH, WINDOW_HEIGHT, P3D);
  
  // create camera with starting position and starting viewing distance
  cam = new PeasyCam(this, camX, camY, camZ, camView);
  
  // set max and min viewing distance
  cam.setMinimumDistance(150);
  cam.setMaximumDistance(150);
  
  s = loadShape("dice3.obj");
  s.scale(sScale);
}

boolean started = false;

void mousePressed() {
  started = true; 
}

void draw(){
  if (started) {
    processInput();
    
    // update camera. the zero means instantaneously.
    cam.lookAt(camX, camY, camZ, 0);
    
    // draw background
    background(0);
    
    // draw a shape
    pushMatrix();
      translate(x, y, z);
      
      // make object spin
      sRotY += .01;
      if (sRotY > Math.PI * 2) sRotY = 0;
      rotateY(sRotY);
      
      // draw shape
      shape(s);
    popMatrix();
  } else {
    background(0);
    fill(255);
    textAlign(CENTER,CENTER);
    textSize(10);
    text("Click to start. \n Use W A S D Up Down to move around.", 0, 0, 0);
  }
}

// keep track of multiple key presses
boolean[] keys = new boolean[526];

boolean pressed(int k) {
  return keys[(int)k]; 
}

void keyPressed() {
  keys[keyCode] = true; 
}

void keyReleased() {
  keys[keyCode] = false; 
}

// keyboard controls
void processInput() {
  if (pressed('D')) camX += 5;
  if (pressed('A')) camX -= 5;
  if (pressed('W')) camY -= 5;
  if (pressed('S')) camY += 5;
  if (pressed(UP)) camZ -= 5;
  if (pressed(DOWN)) camZ += 5;
}
