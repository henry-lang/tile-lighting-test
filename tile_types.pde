class TileTypes {
  public final byte AIR = 0;
  public final byte STONE = 1;
  public final byte RED_LIGHT = 2;
  public final byte GREEN_LIGHT = 3;
  public final byte BLUE_LIGHT = 4;
  
  public final color[] colors;
  public final boolean[] emits;
  public final color[] lightColor;
 
  public TileTypes() {
    colors = new color[256];
    colors[AIR] = color(10, 250, 255);
    colors[STONE] = color(48);
    colors[RED_LIGHT] = color(255, 0, 0);
    colors[GREEN_LIGHT] = color(0, 255, 0);
    colors[BLUE_LIGHT] = color(0, 0, 255);
    
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
