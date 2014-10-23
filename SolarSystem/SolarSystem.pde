// camera
import peasy.*;
PeasyCam cam;

// camera tracker
// '0' means centered on sun. '1' through '8' track planets
char tracker = '0';

// sound
import ddf.minim.*;
Minim minim;
AudioPlayer theme;

// simulation state
int STATE = 0;
static final int NOT_RUNNING = 0;
static final int RUNNING = 1;

// simulation speed
static float SPEED;

// The sun and planets
Sun sun;
Planet[] planets = new Planet[8];

// Information about the 8 planets
Information mercury;
Information venus;
Information earth;
Information mars;
Information jupiter;
Information saturn;
Information uranus;
Information neptune;

void setup() {
  size(displayWidth, displayHeight, P3D);
  noStroke();
  
  // load sun
  sun = new Sun();
  
  // TO-DO: load planet Information 
  mercury = new Information("Mercury");
  venus = new Information("Venus");
  earth = new Information("Earth");
  mars = new Information("Mars");
  jupiter = new Information("Jupiter");
  saturn = new Information("Saturn");
  uranus = new Information("Uranus");
  neptune = new Information("Neptune");
  
  // load planets
  planets[0] = new Planet(mercury, 57.909227, 2.4397, 0.2408467, 0.20563593, "textures/1_mercury.jpg"); // mercury
  planets[1] = new Planet(venus, 108.209475, 6.0518, 0.61519726, 0.00677672, "textures/2_venus.jpg"); // venus
  planets[2] = new Planet(earth, 149.598262, 6.37100, 1.0000174, 0.01671123, "textures/3_earth.jpg"); // earth
  planets[3] = new Planet(mars, 227.943824, 3.3895, 1.8808476, 0.0933941, "textures/4_mars.jpg"); // mars
  planets[4] = new Planet(jupiter, 778.340821, 69.911, 11.862615, 0.04838624, "textures/5_jupiter.jpg"); // jupiter
  planets[5] = new Planet(saturn, 1426.666422, 58.232, 29.447498, 0.05386179, "textures/6_saturn.jpg"); // saturn
  planets[6] = new Planet(uranus, 2870.658186, 25.362, 84.016846, 0.04725744, "textures/7_uranus.jpg"); // uranus
  planets[7] = new Planet(neptune, 4498.396441, 24.622, 164.79132, 0.00859048, "textures/8_neptune.jpg"); // neptune
  
  // create camera
  cam = new PeasyCam(this, 0, 0, 0, 800);
  cam.setMinimumDistance(150);
  cam.setMaximumDistance(planets[7].orbitRadius * 1.1);
  
  // make some noise
  minim = new Minim(this);
  theme = minim.loadFile("sounds/space.mp3");
  theme.loop();
  theme.pause();
  
  // reset simulation speed
  resetSpeed();
}

void draw() {
  background(0);
  
  if (STATE == RUNNING) {
    cameraTrack(tracker);
    
    processInput();
    sun.draw();
    
    for (Planet planet: planets) planet.draw();
    
    for (Planet planet: planets) {
      // display planet's name if hovered. This code does not yet work
      if (planet.hovered()) {
        cam.beginHUD();
        noLights();
        textSize(50);
        textAlign(LEFT, TOP);
        text(planet.information.name, 0, 0);
        textAlign(RIGHT, TOP);
        text(planet.information.name, width, 0);
        textAlign(LEFT);
        text(planet.information.name, 0, height - 100 );
        textAlign(RIGHT);
        text(planet.information.name, width, height - 100);
        cam.endHUD();
      } 
    }
    
  } 
  
  else if (STATE == NOT_RUNNING) {
    resetShader(); // resetShader for drawing text
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
}

// keep track of multiple key presses
boolean[] keys = new boolean[526];
boolean pressed(int k) {return keys[(int)k];}
void keyReleased() {keys[keyCode] = false;}
void keyPressed() {
  keys[keyCode] = true;
  
  // define static keyboard controls here
  if (key == ' ') toggleRunning();
  else if (key == 'c') cam.reset(100);
  else if (key == 'd') defaultAngle();
  else if (key == 'p') realignPlanets();
  else if (key == 'r') resetSpeed();
  else if (key == 'l') sun.toggleLighting();
  else if (key >= '0' && key <= '8') tracker = key;
}

// define fluid keyboard controls here
void processInput() {
  if (pressed('W')) speedUp();
  if (pressed('S')) slowDown();
}

/**
 * Stop and start the simulation
 */
void toggleRunning() {
  if (STATE == NOT_RUNNING) {
    defaultAngle();
    theme.play();
    STATE = RUNNING;
  }
  else {
    cam.reset(0);
    theme.pause();
    STATE = NOT_RUNNING;
  }
}

/**
 * Define the default camera angle
 */
void defaultAngle() {
  cam.reset(0);
  cam.rotateY(PI / -2);
  cam.rotateX(PI / 6);
}

/**
 * @return the speed of the simulation
 */
static float getSpeed() {
  return SPEED;
}

/**
 * Speed up the simulation
 */
void speedUp() {
  SPEED += .1;
}

/**
 * Slow down the simulation
 */
void slowDown() {
  SPEED -= .1;
}

/**
 * Reset the simulation speed
 */
void resetSpeed() {
  SPEED = .2;
}

/**
 * Realign the orbits of all the planets
 */
void realignPlanets() {
  for (Planet planet: planets) planet.rY = 0;
}

/**
 * Update the camera tracker
 */
void cameraTrack(int tracker) {
  if (tracker == '0') cam.lookAt(0, 0, 0, (long)0);
  else {
    int i = tracker - 49; // convert from char to index value
    cam.lookAt(planets[i].x, planets[i].y, planets[i].z, (long)0);
  }
}
