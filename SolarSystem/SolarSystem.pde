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

// Border offset
int BORDER = 20;

// The sun and planets
Sun sun;
Planet[] planets = new Planet[8];

// Information about the sun and the 8 planets
int NUM_PLANETS = 9;
int NUM_FIELDS = 13;
String[] rawData;
String[][] planetInfo = new String[NUM_PLANETS][NUM_FIELDS];

void setup() {
  size(displayHeight, displayHeight - 50, P3D);
  noStroke();
  
  // load in text file of planet information
  rawData = loadStrings("text/planetInfo.txt");
  for (int i = 0; i < NUM_PLANETS; i++)
  {
    // fill in the first element of each sub-array with the planet it corresponds to
    planetInfo[i][0] = str(i);
    for (int j = 1; j < NUM_FIELDS; j++)
    {
      // to access the right data from loadedData, multiply which row you're on by 13 and add the col
      planetInfo[i][j] = rawData[i*13 + j - 1];                                       
    }
  }
  
  // load planet Information to each planet
  Information sunInformation = new Information(planetInfo[0]);
  Information mercury = new Information(planetInfo[1]);
  Information venus = new Information(planetInfo[2]);
  Information earth = new Information(planetInfo[3]);
  Information mars = new Information(planetInfo[4]);
  Information jupiter = new Information(planetInfo[5]);
  Information saturn = new Information(planetInfo[6]);
  Information uranus = new Information(planetInfo[7]);
  Information neptune = new Information(planetInfo[8]);
  
  // load sun
  sun = new Sun(sunInformation);
  
  // load planets
  planets[0] = new Planet(mercury, 57.909227, 2.4397, 0.2408467, 4222.6, 0.20563593, 0.01, "textures/1_mercury.jpg"); // mercury
  planets[1] = new Planet(venus, 108.209475, 6.0518, 0.61519726, 2802.0, 0.00677672, 177.4, "textures/2_venus.jpg"); // venus
  planets[2] = new Planet(earth, 149.598262, 6.37100, 1.0000174, 24.0, 0.01671123, 23.4, "textures/3_earth.jpg"); // earth
  planets[3] = new Planet(mars, 227.943824, 3.3895, 1.8808476, 24.7, 0.0933941, 25.2, "textures/4_mars.jpg"); // mars
  planets[4] = new Planet(jupiter, 778.340821, 69.911, 11.862615, 9.9, 0.04838624, 3.1, "textures/5_jupiter.jpg"); // jupiter
  planets[5] = new Planet(saturn, 1426.666422, 58.232, 29.447498, 10.7, 0.05386179, 26.7, "textures/6_saturn.jpg"); // saturn
  planets[6] = new Planet(uranus, 2870.658186, 25.362, 84.016846, 17.2, 0.04725744, 97.8, "textures/7_uranus.jpg"); // uranus
  planets[7] = new Planet(neptune, 4498.396441, 24.622, 164.79132, 16.1, 0.00859048, 28.3, "textures/8_neptune.jpg"); // neptune
  
  // create camera
  cam = new PeasyCam(this, 0, 0, 0, 800);
  cam.setMinimumDistance(100);
  cam.setMaximumDistance(planets[7].orbitRadius * 1.1);
  
  // make some noise
  minim = new Minim(this);
  theme = minim.loadFile("sounds/space.mp3");
  theme.loop();
  theme.pause();
  
  // initialize simulation speed
  resetSpeed();
}

void draw() {
  background(0);
  
  if (STATE == RUNNING) {
    processInput();
    cameraTrack(tracker);
    sun.draw();
    for (Planet planet: planets) planet.draw();
    
    // display all HUD elements after this point
    for (int i = 0; i < planets.length; i++) {
      if (planets[i].clicked()) {
        tracker = (char) (i + 49);
      } 
    }
    
  } 
  
  else if (STATE == NOT_RUNNING) {
    startScreen();
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
  else if (key == 'f') togglePause();
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
 * Pause and upause the simulation speed
 */
float tmpSpeed;
void togglePause() {
  if (SPEED != 0) {
    tmpSpeed = SPEED;
    SPEED = 0;
  } else {
    SPEED = tmpSpeed;
  }
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
void cameraTrack(char tracker) {
  if (tracker == '0') {
    cam.lookAt(0, 0, 0, (long)0);
    displayInformation(sun.information);
  }
  else {
    int i = tracker - 49; // convert from char to index value
    cam.lookAt(planets[i].x, planets[i].y, planets[i].z, (long)0);
    displayInformation(planets[i].information);
  }
}

void startScreen() {
  resetShader(); // resetShader for drawing text
  noLights();
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
 
void displayInformation(Information information) {
  resetShader(); // resetShader for drawing text
  noLights();
  cam.beginHUD();
    textSize(70);
    textAlign(LEFT, TOP);
    text(information.info[1], BORDER, BORDER);
    textSize(20);
    textAlign(RIGHT, TOP);
    text(information.info[3], width - BORDER, 10 +  BORDER);
    text(information.info[4], width - BORDER, 40 + BORDER);
    text(information.info[12], width - BORDER, 70 + BORDER);
    text(information.info[8], width - BORDER, 100 + BORDER);
    textAlign(LEFT);
    text(information.info[5], BORDER, height - 100 );
    text(information.info[6], BORDER, height - 70 );
    text(information.info[7], BORDER, height - 40 );
    textAlign(RIGHT);
    text(information.info[9], width - BORDER, height - 100);
    text(information.info[10], width - BORDER, height - 70);
    text(information.info[11], width - BORDER, height - 40);
  cam.endHUD();
}
