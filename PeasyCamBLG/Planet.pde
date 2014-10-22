public class Planet {
  PImage mercury;
  float temp;
  PImage theSun;
  PImage venus;
  PImage earth;
  PImage mars;
  PImage jupiter;
  PImage saturn;
  PImage uranus;
  PImage neptune;
  int ptsW, ptsH;
  PImage img;
  int numPointsW;
  int numPointsH_2pi; 
  int numPointsH;

  float[] coorX;
  float[] coorY;
  float[] coorZ;
  float[] multXZ;
  public static final float EARTH_SPEED = .007;
  int current = 10;
  // speed at which planet should go
  float speed = 1;

  float x = 0, y = 0, z = 0; // translation
  float rX = 0, rY = 0, rZ = 0; // rotation
  float rOffset = (float)Math.PI / 2; // starting rotation of the planet

  float r0; // radius of semi-major axial orbit
  float rE; // radius of planet
  float period; // length of orbit relative to earth's orbit
  float e; // eccentricity of elliptical orbit

  public Planet(float r0, float rE, float period, float e) {
    this.r0 = r0;
    this.rE = rE;
    this.period = period;
    this.e = e;
    ptsW=30;
    ptsH=30;
    mercury = loadImage("mercurymap.jpg");
    venus = loadImage("venusmap.jpg");
    earth = loadImage("world32k.jpg");
    mars= loadImage("mars_1k_color.jpg");
    jupiter = loadImage("jupitermap.jpg");
    saturn = loadImage("saturnmap.jpg");
    uranus = loadImage("uranusmap.jpg");
    neptune = loadImage("neptunemap.jpg");
    theSun = loadImage("sunmap.jpg");
    initializeSphere(30, 30);
  }

  void draw() {
    pushMatrix();
    updatePosition();

    // position planet
    rotateY(rY + rOffset);
    translate(x, y, z);


    // compute the screen position of the center
    // point of this planet
    float centerX = screenX(0, 0);
    float centerY = screenY(0, 0);

    // compute the edge of the sphere
    // FYI - not sure if this is right ... (but it seems to work)
    float edgeX = screenX(rE*4, 0);
    float edgeY = screenY(rE*4, 0);

    // compute the distance between the center and the edge
    float d = dist(centerX, centerY, edgeX, edgeY);
    temp = this.rE;
    // is the mouse over this planet?
    if (dist(mouseX, mouseY, centerX, centerY) < d)
    {
      //stores size of planet
      displayText();
    }/* else
     {
     rE = temp;
     } */

    //   this.rE = temp; //sets it back
    if (current == 0) {
      noStroke();
      textureSphere(rE, rE, rE, mercury);
    } else if (current == 1) {
      noStroke();
      textureSphere(rE, rE, rE, venus);
    } else if (current == 2) {
      noStroke();
      textureSphere(rE, rE, rE, earth);
    } else if (current == 3) {
      noStroke();
      textureSphere(rE, rE, rE, mars);
    } else if (current == 4) {
      noStroke();
      textureSphere(rE, rE, rE, jupiter);
    } else if (current == 5) {
      noStroke();
      textureSphere(rE, rE, rE, saturn);
    } else if (current == 6) {
      noStroke();
      textureSphere(rE, rE, rE, uranus);
    } else if (current == 7) {
      noStroke();
      textureSphere(rE, rE, rE, neptune);
    } 
    reset();
    //  sphere(rE);

    popMatrix();
    noStroke();
    textureSphere(50, 50, 50, theSun);
    //   stroke(0, 255, 0);
    //  line(centerX, centerY, edgeX, edgeY);
  }
  void reset() {
    rE = temp;
  }
  void displayText() {
    rE = 100;
    //store previous location of the mouse so text stays on screen when
    //user clicks and moves away 
    //make planets increase in size
    //text for sun?
    textSize(40);
    if (current == 0) {
      camera();
      //if you comment this, text  follows planet around
      noLights();
      text("Mercury", 200, 100);
    } else if (current == 1) {
      camera();
      noLights();
      text("Venus", 200, 100);
    } else if (current == 2) {
      hint(DISABLE_DEPTH_TEST);
      camera();
      noLights();
      text("Earth", 200, 100);
      hint(ENABLE_DEPTH_TEST);
    } else if (current == 3) {
      camera();
      noLights();
      text("Mars", 200, 100);
    } else if (current == 4) {
      camera();
      noLights();
      text("Jupiter", 200, 100);
    } else if (current == 5) {
      camera();
      noLights();
      text("Saturn", 200, 100);
    } else if (current == 6) {
      camera();
      noLights();
      text("Uranus", 200, 100);
    } else if (current == 7) {
      camera();
      noLights();
      text("Neptune", 200, 100);
    }
  }
  float getRadius() {
    return r0 * (1 + e) / (1 + e * cos(rY));
  }
  void current(int w) {
    current = w;
  }

  void updatePosition() {
    rY += EARTH_SPEED / period * speed;
    if (abs(rY) > Math.PI * 2) rY = 0;
    x = getRadius();
  }
  void initializeSphere(int numPtsW, int numPtsH_2pi) {

    // The number of points around the width and height
    numPointsW=numPtsW+1;
    numPointsH_2pi=numPtsH_2pi;  // How many actual pts around the sphere (not just from top to bottom)
    numPointsH=ceil((float)numPointsH_2pi/2)+1;  // How many pts from top to bottom (abs(....) b/c of the possibility of an odd numPointsH_2pi)

    coorX=new float[numPointsW];   // All the x-coor in a horizontal circle radius 1
    coorY=new float[numPointsH];   // All the y-coor in a vertical circle radius 1
    coorZ=new float[numPointsW];   // All the z-coor in a horizontal circle radius 1
    multXZ=new float[numPointsH];  // The radius of each horizontal circle (that you will multiply with coorX and coorZ)

    for (int i=0; i<numPointsW; i++) {  // For all the points around the width
      float thetaW=i*2*PI/(numPointsW-1);
      coorX[i]=sin(thetaW);
      coorZ[i]=cos(thetaW);
    }

    for (int i=0; i<numPointsH; i++) {  // For all points from top to bottom
      if (int(numPointsH_2pi/2) != (float)numPointsH_2pi/2 && i==numPointsH-1) {  // If the numPointsH_2pi is odd and it is at the last pt
        float thetaH=(i-1)*2*PI/(numPointsH_2pi);
        coorY[i]=cos(PI+thetaH); 
        multXZ[i]=0;
      } else {
        //The numPointsH_2pi and 2 below allows there to be a flat bottom if the numPointsH is odd
        float thetaH=i*2*PI/(numPointsH_2pi);

        //PI+ below makes the top always the point instead of the bottom.
        coorY[i]=cos(PI+thetaH); 
        multXZ[i]=sin(thetaH);
      }
    }
  }

  void textureSphere(float rx, float ry, float rz, PImage t) { 
    // These are so we can map certain parts of the image on to the shape 
    float changeU=t.width/(float)(numPointsW-1); 
    float changeV=t.height/(float)(numPointsH-1); 
    float u=0;  // Width variable for the texture
    float v=0;  // Height variable for the texture

    beginShape(TRIANGLE_STRIP);
    texture(t);
    for (int i=0; i< (numPointsH-1); i++) {  // For all the rings but top and bottom
      // Goes into the array here instead of loop to save time
      float coory=coorY[i];
      float cooryPlus=coorY[i+1];

      float multxz=multXZ[i];
      float multxzPlus=multXZ[i+1];

      for (int j=0; j<numPointsW; j++) {  // For all the pts in the ring
        normal(coorX[j]*multxz, coory, coorZ[j]*multxz);
        vertex(coorX[j]*multxz*rx, coory*ry, coorZ[j]*multxz*rz, u, v);
        normal(coorX[j]*multxzPlus, cooryPlus, coorZ[j]*multxzPlus);
        vertex(coorX[j]*multxzPlus*rx, cooryPlus*ry, coorZ[j]*multxzPlus*rz, u, v+changeV);
        u+=changeU;
      }
      v+=changeV;
      u=0;
    }
    endShape();
  }
}

