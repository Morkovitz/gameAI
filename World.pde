class World{
  int w;
  int h;
  Tile tiles [][];
  World(int w, int h) {
    this.w = w;
    this.h = h;
    tiles = new Tile[w][h];
    for(int i = 0;i < w; i++) {
      for (int j = 0; j < h; j++) {
        float r = random(1);
        int terrainType;
        if (r < 0.8) {
          terrainType = 0;
        } else if (r < 0.95) {
          terrainType = 1;
        } else {
          terrainType = 2;
        }
        
        tiles[i][j] = new Tile(i, j, terrainType);
      }
    }
  }
  void display() {
    for (int i = 0; i < w; i++) {
      for (int j = 0; j < h; j++) {
        tiles[i][j].display();
      }
    }
  }
}

    
  
