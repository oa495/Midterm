class Asteriod {
  float ySpeed;
  float xSpeed;
  float xPos = 0;
  float yPos = 0;
  float zPos = 0;
  opening thisOne;
  PImage[] asteriods;
  int rand;
  boolean hit;

  Asteriod(float sy, float sx, float x, float y, opening main) {
    this.ySpeed = sy;
    this.xSpeed = sx;
    this.xPos = x;
    this.yPos = y;
    this.thisOne = main;
    asteriods = new PImage[4];
    for (int i = 0; i < asteriods.length; i++) {
      asteriods[i] = loadImage("asteriod" + i + ".png");
    }
  }
  Asteriod(float x, float y, float z) {
//    this.ySpeed = sy;
 //   this.xSpeed = sx;
    this.xPos = x;
    this.yPos = y;
    this.zPos = z;
 //   this.thisOne = main;
    asteriods = new PImage[3];
    for (int i = 0; i < asteriods.length; i++) {
      asteriods[i] = loadImage("Asteroid" + i + ".png");
      int rand = (int) random(0, 3);
    }
  }
  void move() {
  }
  void display() {
    image(asteriods[rand], xPos, yPos);
  }
  float returnXLocation() {
    return this.xPos;
  }
  float returnYLocation() {
    return this.yPos;
  }
  void checkHit() {
  }
}

