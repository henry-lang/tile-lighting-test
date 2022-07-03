class TileTypes {
  public final byte AIR = 0;
  public final byte STONE = 1;
  public final byte RED_LIGHT = 2;
  public final byte GREEN_LIGHT = 3;
  public final byte BLUE_LIGHT = 4;
  
  public final PImage[] textures;
  public final boolean[] emits;
  public final color[] lightColor;
 
  public TileTypes() {
    textures = new PImage[256];
    textures[AIR] = loadImage("air.png");
    textures[STONE] = loadImage("stone.png");
    textures[RED_LIGHT] = loadImage("red_light.png");
    textures[GREEN_LIGHT] = loadImage("green_light.png");
    textures[BLUE_LIGHT] = loadImage("blue_light.png");
    
    emits = new boolean[256];
    emits[AIR] = true;
    emits[STONE] = false;
    emits[RED_LIGHT] = true;
    emits[GREEN_LIGHT] = true;
    emits[BLUE_LIGHT] = true;
    
    lightColor = new color[256];
    lightColor[AIR] = color(255);
    lightColor[RED_LIGHT] = color(255, 0, 0);
    lightColor[GREEN_LIGHT] = color(0, 255, 0);
    lightColor[BLUE_LIGHT] = color(0, 0, 255);
  }
}
