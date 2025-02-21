class Tile{
  float x, y;
  int type;
  Crop crop;
  Tile(float x, float y, int type) {
    this.x = x;
    this.y = y;
    this.type = type;
    this.crop = null;
  }
  
  boolean hasCrop() {
    return crop != null;
  }
  
  boolean hasFood() {
    return crop != null && crop.isFullyGrown();
  }
  void plantCrop(String cropType) {
    if(type == 0 && !hasCrop()) {
      crop = new Crop(cropType);
    }
  }
  
  void growCrop() {
    if (hasCrop()) {
      crop.grow();
    }
  }
  
  ArrayList <String> harvestCrop() {
    ArrayList<String> harvestedItems = new ArrayList<String>();
    if(hasCrop() && crop.isFullyGrown()) {
     if(crop.type.equals("barley")) {
       harvestedItems.add("barley");
       harvestedItems.add("barley");
       harvestedItems.add("barley");
       harvestedItems.add("seed");
       harvestedItems.add("seed");
     } else if (crop.type.equals("raddish")) {
       for (int i = 0; i < 7; i++) {
         harvestedItems.add("raddish");
       }
     }
     else if (crop.type.equals("tree")) {
       if (crop.stage == 2) {
         harvestedItems.add("log");
         harvestedItems.add("loh");
         harvestedItems.add("sappling");
       } else {
       for(int i = 0; i < 6; i++) {
         harvestedItems.add("log");
       }
       harvestedItems.add("sapling");
       harvestedItems.add("sapling");
       } 
     }
      crop = null;
    }
    return harvestedItems;
  }
  
  void display() {
    noStroke();
    if (type==0)fill(0,255,0);
    if(type==1)fill(0,0,255);
    if(type==2)fill(128, 128,128);
    rect(x*RES, y*RES,RES,RES);
    
  if (hasCrop()) {
    int stage = crop.getStage();
    
    if (crop.type.equals("raddish")) {
      fill (255, 0, 0);
    } else if (crop.type.equals("barley")) {
      fill (240,230,140);
    } 
    ellipse(x * RES + RES / 2, y * RES + RES / 2, RES / 2, RES / 2);
    
    fill(255, 0, 0);
    textAlign(CENTER, CENTER);
    textSize(12);
    text(stage, x * RES + RES/2, y * RES + 25);
    }
  }
    
    boolean hasWater() {
        return type == 1;
    }
}
