import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import peasy.*; 
import ddf.minim.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class SolarSystem extends PApplet {

/*********************************
 * Solar System Simulator
 * @author Braden Gammon
 * @author Katy Herrick
 * @author Omayeli Arenyeka
 *
 * Planet textures, TextureSphere example, and "space.mp3" found by Omayeli.
 * Text layout and "planetInfo.txt" by Katy.
 * Main programming by Braden Gammon.
*********************************/

// camera

PeasyCam cam;

// camera tracker
// '0' means centered on sun. '1' through '8' track planets
char tracker = '0';

// sound

Minim minim;
AudioPlayer theme;

// simulation state
int STATE = 0;
static final int NOT_RUNNING = 0;
static final int RUNNING = 1;

// simulation speed
static float SPEED;

// layout border offset
int BORDER = 20;

// the sun and planets
Sun sun;
Planet[] planets = new Planet[8];

// Information about the sun and the 8 planets
int NUM_PLANETS = 9;
int NUM_FIELDS = 13;
String[] rawData;
String[][] planetInfo = new String[NUM_PLANETS][NUM_FIELDS];

public boolean sketchFullScreen() {
  return true;
}

public void setup() {
  size(displayWidth, displayHeight, OPENGL);
  noStroke();
  
  // load in text file of planet information
  rawData = loadStrings("text/planetInfo.txt");
  for (int i = 0; i < NUM_PLANETS; i++) {
    // fill in the first element of each sub-array with the planet it corresponds to
    planetInfo[i][0] = str(i);
    for (int j = 1; j < NUM_FIELDS; j++) {
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
  planets[0] = new Planet(mercury, 57.909227f, 2.4397f, 0.2408467f, 4222.6f, 0.20563593f, 0.01f, "textures/1_mercury.jpg"); // mercury
  planets[1] = new Planet(venus, 108.209475f, 6.0518f, 0.61519726f, 2802.0f, 0.00677672f, 177.4f, "textures/2_venus.jpg"); // venus
  planets[2] = new Planet(earth, 149.598262f, 6.37100f, 1.0000174f, 24.0f, 0.01671123f, 23.4f, "textures/3_earth.jpg"); // earth
  planets[3] = new Planet(mars, 227.943824f, 3.3895f, 1.8808476f, 24.7f, 0.0933941f, 25.2f, "textures/4_mars.jpg"); // mars
  planets[4] = new Planet(jupiter, 778.340821f, 69.911f, 11.862615f, 9.9f, 0.04838624f, 3.1f, "textures/5_jupiter.jpg"); // jupiter
  planets[5] = new Planet(saturn, 1426.666422f, 58.232f, 29.447498f, 10.7f, 0.05386179f, 26.7f, "textures/6_saturn.jpg"); // saturn
  planets[6] = new Planet(uranus, 2870.658186f, 25.362f, 84.016846f, 17.2f, 0.04725744f, 97.8f, "textures/7_uranus.jpg"); // uranus
  planets[7] = new Planet(neptune, 4498.396441f, 24.622f, 164.79132f, 16.1f, 0.00859048f, 28.3f, "textures/8_neptune.jpg"); // neptune
  
  // create camera
  cam = new PeasyCam(this, 0, 0, 0, 800);
  cam.setMinimumDistance(100);
  cam.setMaximumDistance(planets[7].orbitRadius * 1.1f);
  
  // make some noise
  minim = new Minim(this);
  theme = minim.loadFile("sounds/space.mp3");
  theme.loop();
  theme.pause();
  
  // initialize simulation
  resetSpeed();
  defaultAngle();
}

public void draw() {
  background(0);
  
  if (STATE == RUNNING) {
    processInput();
    sun.draw();
    for (Planet planet: planets) planet.draw();
    cameraTrack(tracker);
  } 
  
  else if (STATE == NOT_RUNNING) {
    startScreen();
  }
}

/**
 * Select a planet onclick
 */
public void mousePressed() {
  for (int i = 0; i < planets.length; i++) {
    if (planets[i].clicked()) tracker = (char) (i + 49);
  }
}

// keep track of multiple key presses
boolean[] keys = new boolean[526];
public boolean pressed(int k) {return keys[(int)k];}
public void keyReleased() {keys[keyCode] = false;}
public void keyPressed() {
  keys[keyCode] = true;
  
  if (key == ' ') toggleRunning();
  if (key == 'c') cam.reset(100);
  if (STATE == RUNNING) {
    // define static keyboard controls here
    if (key == 'd') defaultAngle();
    else if (key == 't') topDownAngle();
    else if (key == 'p') realignPlanets();
    else if (key == 'r') resetSpeed();
    else if (key == 'l') sun.toggleLighting();
    else if (key == 'f') togglePause();
    else if (key == 'z') resetZoom();
    else if (key >= '0' && key <= '8') tracker = key;
  }
}

// define fluid keyboard controls here
public void processInput() {
  if (pressed('W')) speedUp();
  if (pressed('S')) slowDown();
}

/**
 * Stop and start the simulation
 */
public void toggleRunning() {
  if (STATE == NOT_RUNNING) {
    theme.play();
    STATE = RUNNING;
  }
  else {
    theme.pause();
    STATE = NOT_RUNNING;
  }
}

/**
 * Define the default camera angle
 */
public void defaultAngle() {
  cam.reset(0);
  cam.rotateY(PI / -2);
  cam.rotateX(PI / 6);
}

/**
 * Define top down camera angle
 */
public void topDownAngle() {
  cam.reset(0);
  cam.rotateY(PI / -2);
  cam.rotateX(PI / 2);
}

/**
 * @return the speed of the simulation
 */
public static float getSpeed() {
  return SPEED;
}

/**
 * Speed up the simulation
 */
public void speedUp() {
  SPEED += .1f;
}

/**
 * Slow down the simulation
 */
public void slowDown() {
  SPEED -= .1f;
}

/**
 * Reset the simulation speed
 */
public void resetSpeed() {
  SPEED = .1f;
}

/**
 * Pause and upause the simulation speed
 */
float tmpSpeed;
public void togglePause() {
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
public void realignPlanets() {
  for (Planet planet: planets) planet.rY = 0;
}

/**
 * Reset camera zoom distance
 */
public void resetZoom() {
  cam.setDistance(800);
}

/**
 * Update the camera tracker
 */
public void cameraTrack(char tracker) {
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

public void startScreen() {
  resetShader(); // resetShader for drawing text
  noLights();
  cam.beginHUD();
    textSize(80);
    textAlign(CENTER, CENTER);
    text("THE SOLAR SYSTEM", width / 2, 100);
    textSize(40);
    text("Press the spacebar", width / 2, 200);
    textSize(18);
    textAlign(LEFT,BOTTOM);
    text("C: Reset Camera angle \n" +
         "D: Default camera angle \n" +
         "T: Top down camera angle \n" +
         "Z: Reset camera zoom \n" +
         "W: Increase simulation speed \n" +
         "S: Decrease simulation speed \n" + 
         "R: Reset orbit speed \n" +
         "P: Realign Planet orbits \n" + 
         "L: Toggle natural Lighting \n" + 
         "0: Center on Sun \n" + 
         "1 - 8: Track the planets", 
         BORDER, height - BORDER);
    textAlign(RIGHT, BOTTOM);
    text("Click and drag: look around \n" + 
         "Click on a planet to select it \n" +
         "Scroll: zoom in and out \n" +
         "Spacebar: Pause and unpause \n" + 
         "Created by Braden, Yeli, and Katy", 
         width - BORDER, height - BORDER);
  cam.endHUD();
}
 
public void displayInformation(Information information) {
  resetShader(); // resetShader for drawing text
  noLights();
  cam.beginHUD();
    textSize(70);
    textAlign(LEFT, TOP);
    text(information.info[1], BORDER, BORDER);
    textSize(20);
    textAlign(RIGHT, TOP);
    text(information.info[3], width - BORDER, 10 + BORDER);
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
/**
 * Stores information about a planet
 * @author Braden Gammon
 */
class Information {
  String[] info;
  
  public Information(String[] info) {
    this.info = info;
  } 
}
/**
 * A planet in the Solar System
 * data taken from http://nssdc.gsfc.nasa.gov/planetary/factsheet/
 * @author Braden Gammon
 */
public class Planet extends TextureSphere {
  public static final float EARTH_SPEED = .007f;
  public static final float EARTH_YEAR = 365.25f / 10; // decrease value to slow down axial rotation
  
  Information information;
  
  boolean clicked = false;
  
  float x = 0, y = 0, z = 0; // translation
  float tilt = 0, rY = 0, rAxis = 0; // axial tilt in degrees, orbit rotation, axial rotation
  
  float orbitRadius; // radius of semi-major axial orbit
  float period; // length of orbit relative to earth's orbit
  float e; // eccentricity of elliptical orbit
  float day; // length of day in hours
  
  float centerX, centerY, d;
  
  public Planet(Information information, float orbitRadius, float planetRadius, float period, float day, float e, float tilt, String textureFile) {
    super(planetRadius, textureFile);
    this.information = information;
    this.orbitRadius = orbitRadius;
    this.period = period;
    this.day = day;
    this.e = e;
    this.tilt = tilt;
  }
  
  public void draw() {
    updatePosition();
    
    pushMatrix();
      // position planet
      translate(x, y, z);
      
      
      // rotate the planet to its axial tilt
      rotateX(radians(tilt));
      
      // make the planet spin on its axis
      rotateY(rAxis);
      
      // compute the screen position of the center point of this planet
      centerX = screenX(0,0,0);
      centerY = screenY(0,0,0);
      
      // compute the edge of the sphere
      // this code does not work well
      float edgeX = screenX(radius, radius, radius);
      float edgeY = screenY(radius, radius, radius);
      
      // compute the distance between the center and the edge
      // this code does not work well
      d = dist(centerX, centerY, edgeX, edgeY);
      
      // is the mouse over this planet?
      if (hovered()) tint(255, 155);
      else noTint(); 
      
      // draw planet
      textureSphere();
    popMatrix();
  }
  
  public void updatePosition() {
    rY += EARTH_SPEED / period * SolarSystem.getSpeed();
    if (rY > PI * 2) rY -= PI * 2;
    else if (rY < PI * -2) rY += PI * 2;
    x = orbitRadius * (1 + e) / (1 + e * cos(rY)); 
    z = x * -1 * sin(rY);
    x *= cos(rY);
    rAxis += EARTH_SPEED * EARTH_YEAR * 24 / day * SolarSystem.getSpeed();
    if (rAxis > PI * 2) rAxis -= PI * 2;
    else if (rAxis < PI * -2) rAxis += PI * 2;
  }
  
  public boolean hovered() {
    if (dist(mouseX, mouseY, centerX, centerY) < d) return true;
    return false;
  }
  
  public boolean clicked() {
    if (mousePressed && hovered()) return true;
    return false;
  }
}
/**
 * A light-emitting sun
 * @author Braden Gammon
 */
public class Sun extends TextureSphere {
  private static final float SUN_SIZE = 50;
  
  // if true, use texlight shader to produce realistic lighting
  // if false, everything in the scene has full ambient lighting 
  boolean naturalLighting = true;
  
  Information information;
  
  float size;
  
  public Sun(Information information) {
    super(SUN_SIZE, "textures/0_sun.jpg");
    this.information = information;
  }
  
  public void draw() {
    
    // draw sun
    shader(texShader);
    noTint();
    textureSphere();
    
    if (naturalLighting) {
      // set sun lighting
       shader(texlightShader);
       pointLight(255,229,180,0,0,0);
    } else resetShader();
  }
  
  public void toggleLighting() {
    naturalLighting = !naturalLighting;
  }
}
/**
 * A sphere with a mapped image texture
 * Original: https://processing.org/examples/texturesphere.html
 * Edited: Braden Gammon
 */
public class TextureSphere {
  private static final int DEFAULT_DETAIL = 30;
  
  PImage texture;
  PShader texShader;
  PShader texlightShader;
  
  int detail = DEFAULT_DETAIL;
  float radius;
  
  int numPointsW;
  int numPointsH;
  float[] coorX;
  float[] coorY;
  float[] coorZ;
  float[] multXZ;
  
  public TextureSphere(float radius, String textureFile) {
    this.radius = radius;
    texture = loadImage(textureFile);
    texShader = loadShader("shaders/texfrag.glsl", "shaders/texvert.glsl");
    texlightShader = loadShader("shaders/texlightfrag.glsl", "shaders/texlightvert.glsl");
    initializeSphere();
  }
  
  /**
   * Calculate the coordinates of the sphere object
   */
  public void initializeSphere() {
    // The number of points around the width and height
    numPointsW = detail + 1;
    int numPointsH_2pi = detail;  // How many actual pts around the sphere (not just from top to bottom)
    numPointsH = ceil((float)numPointsH_2pi / 2) + 1;  // How many pts from top to bottom (abs(....) b/c of the possibility of an odd numPointsH_2pi)

    coorX = new float[numPointsW];   // All the x-coor in a horizontal circle radius 1
    coorY = new float[numPointsH];   // All the y-coor in a vertical circle radius 1
    coorZ = new float[numPointsW];   // All the z-coor in a horizontal circle radius 1
    multXZ = new float[numPointsH];  // The radius of each horizontal circle (that you will multiply with coorX and coorZ)

    for (int i = 0; i < numPointsW; i++) {  // For all the points around the width
      float thetaW = i * 2 * PI / (numPointsW - 1);
      coorX[i] = sin(thetaW);
      coorZ[i] = cos(thetaW);
    }

    for (int i = 0; i < numPointsH; i++) {  // For all points from top to bottom
      if (i == numPointsH - 1 && PApplet.parseInt(numPointsH_2pi / 2) != (float)numPointsH_2pi / 2) {  // If the numPointsH_2pi is odd and it is at the last pt
        float thetaH = (i - 1) * 2 * PI / numPointsH_2pi;
        coorY[i] = cos(PI + thetaH); 
        multXZ[i] = 0;
      } else {
        //The numPointsH_2pi and 2 below allows there to be a flat bottom if the numPointsH is odd
        float thetaH = i * 2 * PI / numPointsH_2pi;

        //PI+ below makes the top always the point instead of the bottom.
        coorY[i] = cos(PI + thetaH); 
        multXZ[i] = sin(thetaH);
      }
    }
  }
  
  /**
   * Create a textured sphere shape
   */
  public void textureSphere() {
    // simplify method call but preserve math
    float rx = radius;
    float ry = radius;
    float rz = radius;
    
    // These are so we can map certain parts of the image on to the shape 
    float changeU = texture.width/(float)(numPointsW-1); 
    float changeV = texture.height/(float)(numPointsH-1); 
    float u = 0;  // Width variable for the texture
    float v = 0;  // Height variable for the texture

    beginShape(TRIANGLE_STRIP);
    texture(texture);
    
    for (int i = 0; i < (numPointsH - 1); i++) {  // For all the rings but top and bottom
      // Goes into the array here instead of loop to save time
      float coory = coorY[i];
      float cooryPlus = coorY[i+1];

      float multxz = multXZ[i];
      float multxzPlus = multXZ[i+1];

      for (int j = 0; j < numPointsW; j++) {  // For all the pts in the ring
        normal(coorX[j] * multxz, coory, coorZ[j] * multxz);
        vertex(coorX[j] * multxz * rx, coory * ry, coorZ[j] * multxz * rz, u, v);
        normal(coorX[j] * multxzPlus, cooryPlus, coorZ[j] * multxzPlus);
        vertex(coorX[j] * multxzPlus * rx, cooryPlus * ry, coorZ[j] * multxzPlus * rz, u, v + changeV);
        u += changeU;
      }
      
      v += changeV;
      u = 0;
    }
    
    endShape();
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--hide-stop", "SolarSystem" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
