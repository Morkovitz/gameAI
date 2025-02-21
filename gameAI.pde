World world;
PImage agentSprite;
final int RES = 50;
ArrayList<Agent> agents = new ArrayList();
void setup(){
size(800,800);
agentSprite = loadImage("agent.png");
agentSprite.resize(RES, RES);
world = new World(width/RES, height/RES);
for(int i = 0; i < 10; i++) {
  while (true) {
  int rndx = (int)random(0, world.w);
  int rndy = (int)random(0, world.h);
  if (world.tiles[rndx][rndy].type == 0) {
    boolean can_spawn = true;
    for (int j = 0; j < agents.size();j++) {
      if(agents.get(j).x==rndx && agents.get(j).y == rndy) {
        can_spawn = false;
        break;
}
  }
  if(can_spawn) {
    agents.add(new Agent(rndx, rndy));
    break;
       }  
      }
    }
}
  frameRate(5);
}

void draw() {
  background(255);
  world.display();
  for (int i = 0; i < world.w; i++) {
    for (int j = 0; j < world.h; j++) {
      world.tiles[i][j].growCrop();
    }
  }
  
  for (Agent a : agents) {
    a.display();
    a.update();
}
}
