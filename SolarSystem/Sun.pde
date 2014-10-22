public class Sun extends TextureSphere {
  private static final float SUN_SIZE = 50;
  
  float size;
  
  public Sun() {
    super(SUN_SIZE, "textures/0_sun.jpg");
  }
  
  public void draw() {
    
    // draw sun
    shader(texShader);
    textureSphere();
    
    // set sun lighting
    shader(texlightShader);
    pointLight(255,229,180,0,0,0);
    
    //lightFalloff and ambientLight are not working with the custom shaders
//    resetShader();
//    lightFalloff(1.0, 0.001, 0);
//    ambientLight(155, 129, 80, 0, 0, 0);
  }
}
