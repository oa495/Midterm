/**
 * Night Sky 
 */
final static int R = 1000;
PMatrix3D cam;
float[][] stars;

boolean started = false;

PVector eye = new PVector(0,0,0);
PVector x;
PVector y;
PVector d;

void mousePressed() {
  started = true;
}

int WINDOW_WIDTH = 640;
int WINDOW_HEIGHT = 480;

void setup() {
  size(WINDOW_WIDTH, WINDOW_HEIGHT, P3D);
  frameRate(60);
  sphereDetail(1);
  stars = new float[1500][3];
  for (int i = 0; i < stars.length; i++) {
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

void draw() {
  if (started) {
    // all keyboard controls
    processInput();
     
    x = cam.mult(new PVector(1, 0, 0), new PVector(0, 0, 0));
    y = cam.mult(new PVector(0, 1, 0), new PVector(0, 0, 0));
    d = x.cross(y);
    d.normalize(); 
    d.mult(R);
    
    
    background(0);
    noStroke();
    camera(eye.x, eye.y, eye.z, d.x, d.y, d.z, y.x, y.y, y.z);
    
    
    for(int i = 0; i < stars.length; i++) {
      pushMatrix();
      translate(stars[i][0], stars[i][1], stars[i][2]);
      fill(255);
      sphere(random(1,4));
      popMatrix();
    }
  }
}

// keep track of multiple key presses
boolean[] keys = new boolean[526];
void keyPressed() { keys[keyCode] = true; }
void keyReleased() { keys[keyCode] = false; }
boolean pressed(int k) {
  return keys[(int)k];
}

// define all keyboard controls here
void processInput() {
  if (pressed('A'))
    cam.rotateY(-1);
  if (pressed('D'))
    cam.rotateY(1);
  if (pressed('W'))
    cam.rotateX(-1);
  if (pressed('S'))
    cam.rotateX(1); 
}
