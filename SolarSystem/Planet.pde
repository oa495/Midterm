public class Planet extends TextureSphere {
  public static final float EARTH_SPEED = .007;
  
  Information information;
  
  boolean hovered = false;
  boolean clicked = false;
  
  float x = 0, y = 0, z = 0; // translation
  float rX = 0, rY = 0, rZ = 0; // rotation
  
  float orbitRadius; // radius of semi-major axial orbit
  float period; // length of orbit relative to earth's orbit
  float e; // eccentricity of elliptical orbit
  
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
      float centerX = screenX(0,0);
      float centerY = screenY(0,0);
      
      // compute the edge of the sphere
      // FYI - not sure if this is right ... (but it seems to work)
      // (Braden) Ya I don't think this is entirely right
      float edgeX = screenX(radius * 2, 0);
      float edgeY = screenY(radius * 2, 0);
      
      // compute the distance between the center and the edge
      float d = dist(centerX, centerY, edgeX, edgeY);
      
      // is the mouse over this planet?
      if (dist(mouseX, mouseY, centerX, centerY) < d) {
        tint(0,255,0);
        hovered = true;
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
}
