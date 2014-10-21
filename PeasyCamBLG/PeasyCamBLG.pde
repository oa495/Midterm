import peasy.*;

PeasyCam cam;

int WINDOW_WIDTH = 800, WINDOW_HEIGHT = 600;

// position of the camera
float camX = 0, camY = 0, camZ = 0;

// camera viewing distance
float camView = 800;

// planets
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
  
  // create camera
  cam = new PeasyCam(this, camX, camY, camZ, camView);
  cam.setMinimumDistance(camView / 4);
  cam.setMaximumDistance(camView * 4);
  
  // start screen
  background(0);
  textSize(40);
  textAlign(CENTER, CENTER);
  text("Click and drag mouse to look around. \n Press spacebar to reset camera view", 0, 0, 0);
  
  // load planets
  mercury = new Planet(57.909227, 2.4397, 0.2408467, 0.20563593);
  venus = new Planet(108.209475, 6.0518, 0.61519726, 0.00677672);
  earth = new Planet(149.598262, 6.37100, 1.0000174, 0.01671123);
  mars = new Planet(227.943824, 3.3895, 1.8808476, 0.0933941);
  jupiter = new Planet(778.340821, 69.911, 11.862615, 0.04838624);
  saturn = new Planet(1426.666422, 58.232, 29.447498, 0.05386179);
  uranus = new Planet(2870.658186, 25.362, 84.016846, 0.04725744);
  neptune = new Planet(4498.396441, 24.622, 164.79132, 0.00859048);
  
  // initial camera angle
  cam.rotateX(Math.PI / 6);
}

boolean started = false;
void mousePressed() {started = true;}

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
  lightFalloff(1.0, 0.0005, 0);
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
}
}

// keep track of multiple key presses
boolean[] keys = new boolean[526];
boolean pressed(int k) {return keys[(int)k];}
void keyPressed() {keys[keyCode] = true;}
void keyReleased() {keys[keyCode] = false;}

// define all keyboard controls here
void processInput() {
  if (pressed(' ')) {
    cam.reset(100);
  }
}
