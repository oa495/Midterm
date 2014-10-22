PImage star;

// a bunch of stars!
Star[] theStars = new Star[500];

void setup()
{
  // have to set up the sketch to work in 3D mode
  size(500, 500, P3D);

  // set the "depth test" for 3D objects to off -- this helps prevent
  // weird display issues from happening in 3D
  hint(DISABLE_DEPTH_TEST);

  // load in the star
  star = loadImage("star.png");

  // create the stars
  for (int i = 0; i < theStars.length; i++)
  {
    // create a star
    theStars[i] = new Star( random(-1000, 1000), random(-1000, 1000), random(-10000, -2000) );
  }
}

void draw()
{
  background(0);

  // draw the stars
  for (int i = 0; i < theStars.length; i++)
  {
    // is the player moving?  if so we need to move all the stars
    // (in this sketch when the player moves we don't actually move the player -
    // instead we move the entire world around them!)
    if (keyPressed)
    {
      // player is moving left, move the stars to the right
      if (key == 'a') {
        theStars[i].moveRight();
      }
      // player is moving right, move the stars to the left
      if (key == 'd') {
        theStars[i].moveLeft();
      }
      // player is moving forward, move the stars toward the player
      if (key == 'w') {
        theStars[i].moveForward();
      }
      // player is moving backward, move the stars away from the player
      if (key == 's') {
        theStars[i].moveBackward();
      }
    }


    theStars[i].display();
  }
}

