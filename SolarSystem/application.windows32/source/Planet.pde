public class Planet extends TextureSphere {
  public static final float EARTH_SPEED = .007;
  public static final float EARTH_YEAR = 365.25 / 10; // decrease value to slow down axial rotation
  
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
  
  void draw() {
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
      // this code does not work
      float edgeX = screenX(radius, radius, radius);
      float edgeY = screenY(radius, radius, radius);
      
      // compute the distance between the center and the edge
      // this code does not work
      d = dist(centerX, centerY, edgeX, edgeY);
      
      // is the mouse over this planet?
      if (hovered()) tint(255, 155);
      else noTint(); 
      
      // draw planet
      textureSphere();
    popMatrix();
  }
  
  void updatePosition() {
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
  
  boolean hovered() {
    if (dist(mouseX, mouseY, centerX, centerY) < d) return true;
    return false;
  }
  
  boolean clicked() {
    if (mousePressed && hovered()) return true;
    return false;
  }
}
