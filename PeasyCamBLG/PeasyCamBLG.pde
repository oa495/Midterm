import peasy.*;

PeasyCam cam;

int WINDOW_WIDTH = 1000, WINDOW_HEIGHT = 1000;

// position of the camera
float camX = 0, camY = 0, camZ = 0;

// camera viewing distance
float camView = 1100;

Planet mercury;
Planet venus;
Planet earth;
Planet mars;
Planet jupiter;
Planet saturn;
Planet uranus;
Planet neptune;

void setup() {
  size(WINDOW_WIDTH, WINDOW_HEIGHT, P3D);
  
  // create camera with starting position and starting viewing distance
  cam = new PeasyCam(this, camX, camY, camZ, camView);
  
  // set max and min viewing distance
  cam.setMinimumDistance(camView);
  cam.setMaximumDistance(camView);
  
  cam.rotateX(Math.PI / 6);
  
  
  // load planets
  mercury = new Planet(57.909227, 2.4397, 0.2408467, 0.20563593);
  venus = new Planet(108.209475, 6.0518, 0.61519726, 0.00677672);
  earth = new Planet(149.598262, 6.37100, 1.0000174, 0.01671123);
  mars = new Planet(227.943824, 3.3895, 1.8808476, 0.0933941);
  jupiter = new Planet(778.340821, 69.911, 11.862615, 0.04838624);
  saturn = new Planet(1426.666422, 58.232, 29.447498, 0.05386179);
  uranus = new Planet(2870.658186, 25.362, 84.016846, 0.04725744);
  neptune = new Planet(4498.396441, 24.622, 164.79132, 0.00859048);
}

boolean started = true;

void mousePressed() {
  started = true;
}

void draw(){
  if (started) {
    processInput();
    
    // update camera. zero means instantaneously.
    cam.lookAt(camX, camY, camZ, 0);
    
    // draw background
    background(0);
    
    // draw sun
    fill(225);
    sphere(50);
    
    // set sun lighting
    lightFalloff(1.0, 0.001, 0);
    pointLight(255,255,255,0,0,0);
    ambientLight(100, 100, 100);
    
    
    // draw planets
    mercury.draw();
    venus.draw();
    earth.draw();
    mars.draw();
    jupiter.draw();
    saturn.draw();
    uranus.draw();
    neptune.draw();
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
