class Star
{
  // position in 3D space
  float x, y, z;
  
  Star(float _x, float _y, float _z)
  {
    // store values
    x = _x;
    y = _y;
    z = _z;
  }
  
  void display()
  {   
    // have to use pushMatrix and translate to move the origin point
    // when drawing in 3D
    pushMatrix();
    translate(x,y,z);
    
    // draw the star at the origin because 0,0 is really x,y,z
    image(star,0,0);
    
    // restore the coordinate system
    popMatrix();
  }
  
  void moveLeft()
  {
    x -= 10;
  }
  
  void moveRight()
  {
    x += 10;
  }
  
  void moveForward()
  {
    z += 10;
  }
  
  void moveBackward()
  {
    z -= 10;
  }
}
