class Crop {
  String type;
  int stage;
  int maxStages;
  int[] growthTimes;
  int stageCounter;
  
  
  Crop(String type) {
    this.type = type;
    this.stage = 0;
    this.maxStages = 4;
    this.stageCounter = 0;
    
    if (type.equals("barley")) {
      this.growthTimes = new int[]{40,30, (int)random(20, 70), 0};
    }
    else if (type.equals("raddish")) {
      this.growthTimes = new int[]{10, 60, (int)random(40, 50), 0};
    }
    else if (type.equals("tree")) {
      this.growthTimes = new int[]{45, 45, (int)random(90, 180), 0}; 
    }
  }
  
  public int getStage() {
    return stage;
  }
    
  
  void grow() {
    if (stage < maxStages) {
      stageCounter++;
      if (stageCounter >= growthTimes[stage]) {
        stage++;
        stageCounter = 0;
      }
    }
  }
  
  boolean isFullyGrown() {
    return stage >= maxStages;
  }
}
