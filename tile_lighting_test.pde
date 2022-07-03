import java.util.LinkedList;

final int LIGHT_RADIUS = 20;
final float LIGHT_CUTOFF = 0.02;
final float NORMAL_DROPOFF = 0.9;
final float DIAGONAL_DROPOFF = (float) pow(NORMAL_DROPOFF, sqrt(2));

TileTypes tileTypes = new TileTypes();
byte[][] tiles = new byte[40][40];
color[][] lighting = new color[40][40];
color[][] singleLightEmission = new color[LIGHT_RADIUS * 2 + 1][LIGHT_RADIUS * 2 + 1];
LinkedList<int[]> lightQueue = new LinkedList<>();
byte selectedTile = 0;

void setup() {
  size(800, 800);
  noStroke();
  frameRate(280);
  
  for(var x = 0; x < tiles.length; x++) {
    for(var y = 0; y < tiles[x].length; y++) {
      tiles[x][y] = tileTypes.STONE;
    }
  }
}

void draw() {
  background(0);
  
  if(mousePressed) {
    var x = mouseX / 20;
    var y = mouseY / 20;
    
    if(x >= 0 && x < lighting.length && y >= 0 && y < lighting.length) {
      tiles[x][y] = selectedTile;
    }
    
    calculateLighting();
  }
  
  drawTiles();
  drawLighting();
  drawUi();
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  
  if(e < 0) {
    selectedTile -= 1;
  } else if(e > 0) {
    selectedTile += 1;
  }
}

void drawTiles() {
  blendMode(BLEND);
  
  for(var x = 0; x < tiles.length; x++) {
    for(var y = 0; y < tiles[x].length; y++) {
      fill(tileTypes.colors[tiles[x][y]]);
      rect(x * 20, y * 20, 20, 20);
    }
  }
}

void calculateLighting() {
  long start = System.currentTimeMillis();
  for(var x = 0; x < lighting.length; x++) {
    for(var y = 0; y < lighting[x].length; y++) {
      lighting[x][y] = color(0);
    }
  }
  for(var x = 0; x < tiles.length; x++) {
    for(var y = 0; y < tiles[x].length; y++) {
      var type = tiles[x][y];
      if(tileTypes.emits[type]) {
        emitLight(x, y, tileTypes.lightColor[type]);
      }
    }
  }
  long end = System.currentTimeMillis();
  System.out.println("Lighting update took: " + (end - start));
}

void emitLight(int sourceX, int sourceY, color c) {
  for(var x = 0; x < singleLightEmission.length; x++) {
    for(var y = 0; y < singleLightEmission[x].length; y++) {
      singleLightEmission[x][y] = color(0);
    }
  }
  lightQueue.clear();
  
  singleLightEmission[LIGHT_RADIUS][LIGHT_RADIUS] = c;
  lightQueue.add(new int[] {sourceX, sourceY});
  
  while(!lightQueue.isEmpty()) {
    var current = lightQueue.remove();
    var x = current[0];
    var y = current[1];
    
    var layer = max(abs(x - sourceX), abs(y - sourceY));
    
    var passOn = false;
    var currentColor = lighting[clamp(x, 0, lighting.length - 1)][clamp(y, 0, lighting.length - 1)];
    var targetColor = singleLightEmission[LIGHT_RADIUS + x - sourceX][LIGHT_RADIUS + y - sourceY];
    
    if((((float) red(targetColor) > LIGHT_CUTOFF) || ((float) green(targetColor) > LIGHT_CUTOFF) || ((float) blue(targetColor) > LIGHT_CUTOFF)) 
      && (red(targetColor) > red(currentColor) || green(targetColor) > green(currentColor) || blue(targetColor) > blue(currentColor))) {
      if(x >= 0 && x < lighting.length && y >= 0 && y < lighting.length) {
        lighting[x][y] = color(max(red(currentColor), red(targetColor)), max(green(currentColor), green(targetColor)), max(blue(currentColor), blue(targetColor)));
      }
      passOn = true;
    }
    
    if(!(x == sourceX && y == sourceY) && !passOn) { continue; }
    
    for(var nx = x - 1; nx <= x + 1; nx++) {
      for(var ny = y - 1; ny <= y + 1; ny++) {
        var nLayer = max(abs(nx - sourceX), abs(ny - sourceY));
        if(nLayer <= LIGHT_RADIUS && nLayer == layer + 1) {
          float dropOff = (nx != x & ny != y) ? DIAGONAL_DROPOFF : NORMAL_DROPOFF;
          int emitX = LIGHT_RADIUS + nx - sourceX;
          int emitY = LIGHT_RADIUS + ny - sourceY;
          
          if(red(singleLightEmission[emitX][emitY]) + green(singleLightEmission[emitX][emitY]) + blue(singleLightEmission[emitX][emitY]) == 0) {
            lightQueue.add(new int[] {nx, ny});
          }
          
          var r = max(((float) red(targetColor)) * dropOff, red(singleLightEmission[emitX][emitY]));
          var g = max(((float) green(targetColor)) * dropOff, green(singleLightEmission[emitX][emitY]));
          var b = max(((float) blue(targetColor)) * dropOff, blue(singleLightEmission[emitX][emitY]));
          
          singleLightEmission[emitX][emitY] = color(r, g, b);
        }
      }
    }
  }
}

void drawLighting() {
  blendMode(OVERLAY);
  
  for(var x = 0; x < lighting.length; x++) {
    for(var y = 0; y < lighting[x].length; y++) {
      fill(lighting[x][y]);
      rect(x * 20, y * 20, 20, 20);
    }
  }
}

void drawUi() {
  blendMode(BLEND);
  fill(255);
  text("Selected: " + selectedTile, 200, 200);
}

int clamp(int val, int min, int max) {
    return max(min, min(max, val));
}
