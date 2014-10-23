public class Sun extends TextureSphere {
  private static final float SUN_SIZE = 50;
  
  boolean naturalLighting = true;
  
  Information information;
  
  float size;
  
  public Sun(Information information) {
    super(SUN_SIZE, "textures/0_sun.jpg");
    this.information = information;
  }
  
  public void draw() {
    
    // draw sun
    shader(texShader);
    noTint();
    textureSphere();
    
    if (naturalLighting) {
      // set sun lighting
       shader(texlightShader);
       pointLight(255,229,180,0,0,0);
    } else resetShader();
  }
  
  void toggleLighting() {
    naturalLighting = !naturalLighting;
  }
}
