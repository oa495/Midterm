import peasy.*;

PeasyCam cam;

int WINDOW_WIDTH = 800, WINDOW_HEIGHT = 600;

int GAME_STATE = 0;
private static final int NOT_RUNNING = 0;
private static final int RUNNING = 1;

// position of the camera
float camX = 0, camY = 0, camZ = 0;

// camera viewing distance
float camView = 800;

// eight planets
Planet[] planets = new Planet[8];

void setup() {
  size(WINDOW_WIDTH, WINDOW_HEIGHT, P3D);
  
  // create camera
  cam = new PeasyCam(this, camX, camY, camZ, camView);
  cam.setMinimumDistance(camView / 4);
  cam.setMaximumDistance(camView * 4);
  cam.rotateX(Math.PI / 6);
  
  // load planets
  planets[0] = new Planet(57.909227, 2.4397, 0.2408467, 0.20563593);
  planets[1] = new Planet(108.209475, 6.0518, 0.61519726, 0.00677672);
  planets[2] = new Planet(149.598262, 6.37100, 1.0000174, 0.01671123);
  planets[3] = new Planet(227.943824, 3.3895, 1.8808476, 0.0933941);
  planets[4] = new Planet(778.340821, 69.911, 11.862615, 0.04838624);
  planets[5] = new Planet(1426.666422, 58.232, 29.447498, 0.05386179);
  planets[6] = new Planet(2870.658186, 25.362, 84.016846, 0.04725744);
  planets[7] = new Planet(4498.396441, 24.622, 164.79132, 0.00859048);
}

void draw() {
  // always update camera. zero means instantaneously.
  cam.lookAt(camX, camY, camZ, 0);
  
  if (GAME_STATE == NOT_RUNNING) {
    background(0);
    textSize(40);
    textAlign(CENTER, CENTER);
    text("Click and drag mouse to look around \n" + 
         "Scroll to zoom in and out \n" +
         "Press spacebar to start or pause \n" +
         "C: reset camera angle \n" +
         "D: default camera angle \n" +
         "W: increase orbit speed \n" +
         "S: decrease orbit speed \n" + 
         "R: reset orbit speed \n" +
         "P: realign planet orbits \n"
    , 0, 0, 0);
  }
  
  if (GAME_STATE == RUNNING) {
    processInput();
    
    // draw background
    background(0);
    
    // draw sun
    fill(235);
    sphere(50);
    
    // set sun lighting
    lightFalloff(1.0, 0.0006, 0);
    pointLight(255,255,255,0,0,0);
    ambientLight(100, 100, 100);
    
    // draw planets
    for (Planet planet: planets) planet.draw();
  }
}

// keep track of multiple key presses
boolean[] keys = new boolean[526];
boolean pressed(int k) {return keys[(int)k];}

// define static keyboard controls here
void keyPressed() {
  keys[keyCode] = true;
  
  if (key == ' ') toggleRunning();
  if (key == 'c') cam.reset(100);
  if (key == 'd') {
    cam.reset(0);
    cam.rotateX(Math.PI / 6);
  }
}

void keyReleased() {keys[keyCode] = false;}

// define fluid keyboard controls here
void processInput() {
  if (pressed('W')) {
    for (Planet planet: planets) {
      planet.speed++;
    }
  }
  
  if (pressed('S')) {
    for (Planet planet: planets) {
      planet.speed--;
    }
  }
  
  if (pressed('R')) {
    for (Planet planet: planets) {
      planet.speed = 1;
    }
  }
  
  if (pressed('P')) {
    for (Planet planet: planets) {
      planet.rY = 0;
    }
  }
}

void toggleRunning() {
  if (GAME_STATE == NOT_RUNNING) GAME_STATE = RUNNING;
  else GAME_STATE = NOT_RUNNING;
}
