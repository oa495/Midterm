Planet[] planets = new Planet[10];
int state = 0;
PImage back;
PFont f;
//work on using 2d image as 3d background
//also so squares around images won't show

void setup() {
  size(1000, 1000, P3D);
  stroke(0);
  textSize(50);
  f = loadFont("SquareFont-48.vlw");
  for (int i = 0; i < planets.length; i++ ) {
    float x = random(1, 1000);
    float y = random(1, 1000);
    float z = random(1, 1000);
    int xy = int (x*1);
    int yx= int (y*1);
    int zz= int ((z*1)-500);
    back = loadImage("background.png");
    float diameter = random(6, 45);
    float velx1 = random(-2.5, 2.5);
    float vely1 = random(-2.5, 2.5);
    float velz1 = random(-2.5, 2.5);
    // float vely1 = -velx1;
    if (i == 9) {
      xy = width/2- 85;
      yx = height/2-100;
      zz = 0;
      velz1 = 0;
      diameter = 125;
      velx1 = 0;
      vely1 = 0;
    }
    planets[i] = new Planet(diameter, xy, yx, zz, i, velx1, vely1, velz1);
  }
}
void stuff() {
  float cameraZ = ((height/2.0) / tan(PI*60.0/360.0));
  camera(width/2.0, height/2.0, (height/2) / tan(PI*60.0 / 360.0), width/2.0, height/2.0, 500, 0, 1, 0);
  perspective(mouseX/float(width)*PI/2, 1, cameraZ/10, cameraZ*10);
  float dirY = (mouseY / float(height) - 0.5) * 2;
  float dirX = (mouseX / float(width) - 0.5) * 2;
  directionalLight(222, 244, 255, -dirX, -dirY, -1);
}

void draw() {
  if (state == 0) {
    background(0);
    if (((keyPressed) && (key != 's')) || (!keyPressed)) {
      stuff();
    } 
    for (int i = 0; i < planets.length; i++ ) {
      planets[i].display(i);
      planets[i].update();
    }
    /* hint(DISABLE_DEPTH_TEST);
     camera();
     noLights();
     image(back, 0, 0, displayWidth, displayHeight);
     hint(ENABLE_DEPTH_TEST);
     **/
    hint(DISABLE_DEPTH_TEST);
    camera();
    noLights();
    fill(255, 0, 0);
    stroke(255, 0, 0);
    textFont(f, 100);
    fill(255);
    text("START", 320, 100);
    textSize(16);
    fill(237, 28, 36);
    text("Press 's' to stop zoom.", 410, 200);
    strokeWeight(9);
    stroke(0, 0, 168);
    fill(0, 0, 168, 40);
    rectMode(CENTER);
    rect(470, 70, 400, 178);
    if ((mouseX > 250 && mouseX < 650) && (mouseY > 70 && mouseY < 170)) {
      rect(470, 70, 400, 178);
      fill(237, 28, 36);
      text("START", 320, 100);
      textSize(16);
      text("Press 's' to stop zoom.", 410, 200);
      if (mousePressed) {
        state = 1;
      }
    }
  } else if (state == 1) {
    background(0);
  }
}
class Planet {
  PImage[] solar;
  int t;
  float xcc = 0;
  float ycc = 0;
  float zcc = 0;
  float xpos;
  float ypos;
  float zpos;
  float diameter;
  int curplanet;
  int num;
  int i = 1;

  Planet(float diameter_, float xpos_, float ypos_, float zpos_, int planet, float velx, float vely, float velz) {
    diameter =  diameter_;
    this.xpos = (xpos_);
    this.ypos = (ypos_);
    this.zpos = (zpos_);
    curplanet = planet;
    xcc = velx;
    ycc= vely;
    zcc = velz;
    solar = new PImage[10];
    for (int i = 0; i < solar.length; i++) {
      solar[i] = loadImage("planet" + i + ".png");
    }
  }
  void update() {
    for (int i = 0; i < planets.length; i++) {
      if (i == curplanet) {
        continue;
      }
      if (planets.length-1 ==curplanet) {
        continue;
      }
      float area1 = ((((planets[i].diameter/2))*(planets[i].diameter/2)*(planets[i].diameter/2))*3.1415);
      float disty = (planets[i].ypos-ypos);
      float distx = (planets[i].xpos-xpos);
      float distz = (planets[i].zpos-zpos);
      float distfull = sqrt((distz*distz)+(distx*distx+disty*disty));
      if (distfull < (planets[i].diameter/2)) {
        continue;
      }
      float acc = (.01) *(area1/(distfull*distfull));
      zcc = zcc +  (acc*distz/distfull);
      xcc = xcc +  (acc*distx/distfull); 
      ycc = ycc +  (acc*disty/distfull);
    }
    zpos = zpos + zcc;
    xpos = xpos + xcc;
    ypos = ypos + ycc;
  }
  void display(int ti) {
    t = ti;
    if (curplanet == 1) {
      image(solar[t], 0, 0);
      background(0);
    }
    noStroke();
    pushMatrix();
    translate(this.xpos, this.ypos, this.zpos);
    image(solar[t], 0, 0);
    popMatrix();
  }
}
void stop()
{
  // Do stuff
  // ...
  super.stop();
}

