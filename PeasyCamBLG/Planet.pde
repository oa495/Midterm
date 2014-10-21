public class Planet {
  float x = 0, y = 0, z = 0;
  float rX = 0, rY = 0, rZ = 0;
  
  private static final float EARTH_SPEED = .007;
  
  float e = 0.1;
  float r0 = 100;
  float rE = 1;
  float period = EARTH_SPEED;
  float rOffset = (float)Math.PI / 2;
  
  public Planet(float r0, float rE, float period, float e) {
    this.r0 = r0;
    this.rE = rE;
    this.period = period;
    this.e = e;
  }
  
  void draw() {
    pushMatrix();
      // calculate planet's position
      rY += EARTH_SPEED / period;
      if (abs(rY) > Math.PI * 2) rY = 0;
      rotateY(rY + rOffset);
      translate(getRadius(), y, z);
      
      // draw planet
      noStroke();
      fill(255);
      sphere(rE);
    popMatrix();
  }
  
  float getRadius() {
    return r0 * (1 + e) / (1 + e * cos(rY));
  }
}
