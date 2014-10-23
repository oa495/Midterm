public class Planet extends TextureSphere {
  public static final float EARTH_SPEED = .007;
  
  Information information;
  
  boolean clicked = false;
  
  float x = 0, y = 0, z = 0; // translation
  float rX = 0, rY = 0, rZ = 0; // rotation
  
  float orbitRadius; // radius of semi-major axial orbit
  float period; // length of orbit relative to earth's orbit
  float e; // eccentricity of elliptical orbit
  
  float centerX, centerY, d;
  
  public Planet(Information information, float orbitRadius, float planetRadius, float period, float e, String textureFile) {
    super(planetRadius, textureFile);
    this.information = information;
    this.orbitRadius = orbitRadius;
    this.period = period;
    this.e = e;
  }
  
  void draw() {
    updatePosition();
    
    pushMatrix();
      // position planet
      translate(x, y, z);
      
      // make planet spin on its axis
      // TO-DO: get rotation data from NASA and make planets spin at the right speed
      rotateY(rY * 20);
      
      // compute the screen position of the center point of this planet
      centerX = screenX(0,0,0);
      centerY = screenY(0,0,0);
      
      // compute the edge of the sphere
      // this code does not work
      float edgeX = screenX(radius, 0, 0);
      float edgeY = screenY(radius, 0, 0);
      
      // compute the distance between the center and the edge
      // this code does not work
      d = dist(centerX, centerY, edgeX, edgeY);
      
      // is the mouse over this planet?
      if (hovered()) {
        tint(0,255,0);
      }
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
