/**
 * Night Sky 
 * JavaScript version
 */
import processing.opengl.*;

final static int R = 1000;
PMatrix3D cam;
float[][] stars;
float inc = 100;

boolean started = false;

void mousePressed() {
	started = true;
}

int WINDOW_WIDTH = 640;
int WINDOW_HEIGHT = 480;

void setup()
{
  size(WINDOW_WIDTH, WINDOW_HEIGHT, P3D);
  frameRate(30);
  sphereDetail(1);
  stars = new float[1500][3];
  for(int i = 0; i < stars.length; i++)
  {
    float p = random(-PI, PI);
    float t = asin(random(-1, 1));
    stars[i] = new float[] {
      R * cos(t) * cos(p),
      R * cos(t) * sin(p),
      R * sin(t)
    };
  }
  cam = new PMatrix3D();
  
  textAlign(CENTER, CENTER);
  background(0);
  fill(255);
  text("Click to start 'Night Sky'. Use WASD to look around. Try to find the red star.", width / 2, height / 2);
}

void draw()
{
  if (started) {
	  processInput();
	  PVector x = cam.mult(new PVector(1, 0, 0), new PVector(0, 0, 0));
	  PVector y = cam.mult(new PVector(0, 1, 0), new PVector(0, 0, 0));
	  PVector d = x.cross(y); d.normalize(); d.mult(R);
	  background(0);
	  noStroke();
	  camera(0, 0, 0, d.x, d.y, d.z, y.x, y.y, y.z);
	  for(int i = 0; i < stars.length-1; i++)
	  {
	    pushMatrix();
	    translate(stars[i][0], stars[i][1], stars[i][2]);
	    fill(255);
	    sphere(5);
	    popMatrix();
	  }
	  pushMatrix();
	  translate(stars[1499][0], stars[1499][1], stars[1499][2]);
	  fill(255, 0, 0);
	  sphere(10);
	  popMatrix();
	  
	  camera();
	  stroke(255);
	  line(width / 2 - 9, height / 2 - 0, width / 2 + 8, height / 2 + 0);
	  line(width / 2 - 0, height / 2 - 9, width / 2 + 0, height / 2 + 8);
  }
}

// keep track of multiple key presses
boolean[] keys = new boolean[526];
void keyPressed() { keys[key] = true; }
void keyReleased() { keys[key] = false; }

// define all keyboard controls here
void processInput() {
  if (keys['a'])
    cam.rotateY(-(inc - height / 2.0) / height / 20);
  if (keys['d'])
    cam.rotateY((inc - height / 2.0) / height / 20);
  if (keys['w'])
    cam.rotateX(-(inc - height / 2.0) / height / 20);
  if (keys['s'])
    cam.rotateX((inc - height / 2.0) / height / 20); 
}
