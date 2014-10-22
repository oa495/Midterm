public class Planet {
  public static final float EARTH_SPEED = .007;
  
  // speed at which planet should go
  float speed = 1;
  
  float x = 0, y = 0, z = 0; // translation
  float rX = 0, rY = 0, rZ = 0; // rotation
  float rOffset = 0; //(float)Math.PI / 2; // starting rotation of the planet
  
  float r0; // radius of semi-major axial orbit
  float rE; // radius of planet
  float period; // length of orbit relative to earth's orbit
  float e; // eccentricity of elliptical orbit
  
  public Planet(float r0, float rE, float period, float e) {
    this.r0 = r0;
    this.rE = rE;
    this.period = period;
    this.e = e;
  }
  
  void draw() {
    pushMatrix();
      updatePosition();
      
      // position planet
      rotateY(rY + rOffset);
      translate(x, y, z);
      
      // draw planet
      noStroke();
      fill(255);
      sphere(rE);
    popMatrix();
  }
  
  float getRadius() {
    return r0 * (1 + e) / (1 + e * cos(rY));
  }
  
  void updatePosition() {
    rY += EARTH_SPEED / period * speed;
    if (abs(rY) > Math.PI * 2) rY = 0;
    x = getRadius(); 
  }
}
