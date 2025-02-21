import java.util.Queue;
import java.util.LinkedList;
import java.util.Collections;
import java.util.ArrayList;

class Agent {
  int hunger = 30;
  int hydration = 20;
  int comfort = 20;
  ArrayList<String> inventory;
  int x, y;

  int tickCounter = 0;
  
  ArrayList<int[]> pathQueue = new ArrayList<>(); // Store the path
  
  Agent(int x, int y) {
    this.x = x;
    this.y = y;
    this.inventory = new ArrayList<String>();

    inventory.add("barley");
    inventory.add("barley");
    inventory.add("raddish");
    inventory.add("raddish");
  }

  void display() {
    imageMode(CENTER);
    image(agentSprite, x * RES + RES / 2, y * RES + RES / 2, RES, RES);
    fill(255, 0, 0);
    textAlign(CENTER, CENTER);
    textSize(12);
    text(hunger, x * RES + RES / 2, y * RES - 10);
    text(hydration, x * RES + RES / 2, y * RES - 2 * 10);
    text(comfort, x * RES + RES / 2, y * RES - 3 * 10);
  }

  void update() {
    tickCounter++;
    if (tickCounter % 30 == 0) hunger = max(0, hunger - 1);
    if (tickCounter % 20 == 0) hydration = max(0, hydration - 1);
    if (tickCounter % 50 == 0) comfort = max(0, comfort - 1);
    if (hunger == 0 || hydration == 0) {
      // agents.remove(this); // Uncomment if needed
    }

    if (world.tiles[x][y].hasCrop() && world.tiles[x][y].crop.isFullyGrown()) {
      ArrayList<String> harvested = world.tiles[x][y].harvestCrop();
      for (String item : harvested) {
        if (inventory.size() < 100) {
          inventory.add(item);
        }
      }
    }

    // Move towards target if pathQueue has steps
    if (!pathQueue.isEmpty()) {
      moveTowardsTarget();
    } else {
      // Evaluate needs and find resources
      String need = evaluateNeeds();
      if (need.equals("hunger")) {
        findNearestFood();
      } else if (need.equals("hydration")) {
        findNearestWater();
      }
    }

    plantCrop();
  }

  void findNearestFood() {
    int bestX = -1;
    int bestY = -1;
    int shortestDistance = Integer.MAX_VALUE;

    for (int i = 0; i < world.w; i++) {
      for (int j = 0; j < world.h; j++) {
        if (i == x && j == y) continue;

        if (world.tiles[i][j].hasFood()) {
          int distance = Math.abs(i - x) + Math.abs(j - y); // Manhattan Distance
          if (distance < shortestDistance) {
            shortestDistance = distance;
            bestX = i;
            bestY = j;
          }
        }
      }
    }

    if (bestX != -1 && bestY != -1) {
      println("Food found at: (" + bestX + ", " + bestY + ")");
      bfs(x, y, bestX, bestY);
    } else {
      println("No food found in the world.");
    }
  }

  void findNearestWater() {
    int bestX = -1, bestY = -1, shortestDistance = Integer.MAX_VALUE;

    for (int i = 0; i < world.w; i++) {
      for (int j = 0; j < world.h; j++) {
        if (i == x && j == y) continue;
        if (world.tiles[i][j].hasWater()) {
          int distance = Math.abs(i - x) + Math.abs(j - y);
          if (distance < shortestDistance) {
            shortestDistance = distance;
            bestX = i;
            bestY = j;
          }
        }
      }
    }

    if (bestX != -1 && bestY != -1) {
      println("Closest water found at: (" + bestX + ", " + bestY + ")");
      bfs(x, y, bestX, bestY);
    } else {
      println("No water found in the world.");
    }
  }

  String evaluateNeeds() {
    if (hunger < hydration && hunger < comfort) {
      return "hunger";
    } else if (hydration < comfort) {
      return "hydration";
    } else {
      return "comfort";
    }
  }

  void bfs(int startX, int startY, int goalX, int goalY) {
    println("Running BFS from (" + startX + ", " + startY + ") to (" + goalX + ", " + goalY + ")");
    Queue<int[]> queue = new LinkedList<>();
    boolean[][] visited = new boolean[world.w][world.h];
    int[][][] parent = new int[world.w][world.h][2]; // Store parent coordinates

    queue.offer(new int[]{startX, startY});
    visited[startX][startY] = true;
    parent[startX][startY] = new int[]{-1, -1}; // Start cell has no parent

    while (!queue.isEmpty()) {
      int[] current = queue.poll();
      int currentX = current[0];
      int currentY = current[1];

      if (currentX == goalX && currentY == goalY) {
        println("Path found!");
        tracePath(parent, startX, startY, goalX, goalY);
        return;
      }

      // Explore neighbors
      for (int[] dir : new int[][]{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}) {
        int newX = currentX + dir[0];
        int newY = currentY + dir[1];
        if (isValid(newX, newY) && !visited[newX][newY]) {
          visited[newX][newY] = true;
          parent[newX][newY] = new int[]{currentX, currentY};
          queue.offer(new int[]{newX, newY});
        }
      }
    }

    println("No path found.");
  }

  void tracePath(int[][][] parent, int startX, int startY, int goalX, int goalY) {
    ArrayList<int[]> path = new ArrayList<>();
    int[] current = {goalX, goalY};

    while (current[0] != startX || current[1] != startY) {
      path.add(0, current); // Add to the beginning of the path
      current = parent[current[0]][current[1]];
    }

    path.add(0, new int[]{startX, startY}); // Add start position
    pathQueue = path; // Set the pathQueue to the path
    println("Path generated with " + pathQueue.size() + " steps.");
  }

  boolean isOccupied(int newX, int newY) {
    for (Agent other : agents) {
      if (other != this && other.x == newX && other.y == newY) {
        return true;
      }
    }
    return false;
  }

  void plantCrop() {
    if (!isOccupied(x, y)) {
      if (inventory.contains("barley")) {
        world.tiles[x][y].plantCrop("barley");
        inventory.remove("barley");
      } else if (inventory.contains("raddish")) {
        world.tiles[x][y].plantCrop("raddish");
        inventory.remove("raddish");
      }
    }
  }

  void moveTowardsTarget() {
    if (!pathQueue.isEmpty()) {
      int[] nextMove = pathQueue.remove(0);
      x = nextMove[0];
      y = nextMove[1];

      if (world.tiles[x][y].hasWater()) {
        hydration = min(20, hydration + 10);
        println("Agent drank water. Hydration: " + hydration);
      }

      if (pathQueue.isEmpty()) {
        println("Reached target.");
      }
    }
  }

  boolean isValid(int x, int y) {
    if (x < 0 || x >= world.w || y < 0 || y >= world.h) {
      return false;
    }
    //if (world.tiles[x][y].type == 1) {
    //  return false;
    //}
    if (world.tiles[x][y].type == 2) {
      return false;
    }
    if (isOccupied(x, y)) {
      return false;
    }
    return true;
  }
}
