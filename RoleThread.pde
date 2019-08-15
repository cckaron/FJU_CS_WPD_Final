
class RoleThread extends Thread {
  boolean running;
  boolean isFirst;
  String id;
  int score;
  int total_experience;
  int experience_counter;
  int experience_gap = 10;
  int moveSpeed;
  int old_moveSpeed;
  int eatingParameter;
  int invincibleTimeGap;
  int invincibleStartTime;
  int invincibleEndTime;

  int level;
  int eatRoleTime;
  int role_position_x;
  int role_position_y;
  int role_size_x;
  int role_size_y;
  int textParameter;
  int MaximumScore;
  int direction; // left->0; right->1;
  int shootedTime;
  boolean canIShoot;
  PImage image;
  PImage crown;
  PImage ghost;
  boolean survive;

  RoleThread (String s) {

    running = false;
    id = s;
    score = 200;
    survive = true;
    isFirst = false;
    experience_counter = 0;
    level = 1;
    moveSpeed = 15;
    eatingParameter = 80;
    textParameter = 15;
    invincibleTimeGap = 3000;
    eatRoleTime = 0;
    MaximumScore = 300;
  }

  void start() {
    // Set running true
    running = true;
    // Print messages
    System.out.println("Starting Role thread");
    // Do whatever start does in Thread,
    super.start();
  }

  void init(String img, int xsize, int ysize, int xposition, int yposition) {
    image = loadImage(img);
    role_size_x = xsize;
    role_size_y = ysize;
    role_position_x = xposition;
    role_position_y = yposition;
    canIShoot = true;
  }

  void show() {
    if (survive) {
      image(image, role_position_x, role_position_y, 
        role_size_x, role_size_y);

      fill(255, 0, 255);
      textSize(30);
      if (level == 10) {
        text("Level Max!", role_position_x + 1.2*textParameter, role_position_y - 10);
      } else {
        text("Level" + level, role_position_x + 1.2*textParameter, role_position_y - 10);
      }

      fill(0);
      text(id, role_position_x + 15, role_position_y - 40);
      text("Blood:"+score+"/200", role_position_x + 5, role_position_y - 75);
    } else {
      ghost = loadImage("img/role/ghost.png");
      image(ghost, role_position_x, role_position_y, 
        role_size_x, role_size_y);
      textSize(20);
      fill(255, 0, 255);
      text("Level" + level, role_position_x + 1.2*textParameter, role_position_y - 10);
      text(id, role_position_x + 1.2*textParameter, role_position_y - 30);
      text("Blood:"+score+"/200", role_position_x + 5, role_position_y - 75);
    }

    if (isFirst) {
      crown = loadImage("img/item/crown.png");
      image(crown, role_position_x + 1.2*textParameter, role_position_y - 180, 
        100, 100);
    }
  } 

  void addScore(int s) {
    int afterAdded = this.score += s;
    println("afterAdded:"+afterAdded);

    if (afterAdded >= MaximumScore) {
      this.score = MaximumScore;
    } else if (afterAdded < MaximumScore && afterAdded > 0) {
      this.score = afterAdded;
    } else if  (afterAdded <= 0) {
      this.score = 0;
      gameStateHelper.setGameState("END");
      println(gameStateHelper.state);
    }
  }

  float getRadius() {
    return (this.role_size_x)/2;
  }

  void UP() {
    if (this.role_position_y > 0) {
      this.role_position_y = role_position_y - moveSpeed;
    }
  }

  void DOWN() {
    if (this.role_position_y < 822 - role_size_y) {
      this.role_position_y = role_position_y + moveSpeed;
    }
  }

  void LEFT(String img) {
    if (this.role_position_x > 0) {
      this.role_position_x = role_position_x - moveSpeed;
    }
    this.direction = 0;
    this.image = loadImage(img);
  }

  void RIGHT(String img) {
    if (this.role_position_x < 1560 - role_size_x) {
      this.role_position_x = role_position_x + moveSpeed;
    }
    this.direction = 1;
    this.image = loadImage(img);
  }

  int getPositionX() {
    return this.role_position_x;
  }

  int getPositionY() {
    return this.role_position_y;
  }

  int getDirection() {
    return this.direction;
  }

  int getSizeX() {
    return this.role_size_x;
  }

  int getSizeY() {
    return this.role_size_y;
  }

  void addExperience() {
    this.total_experience += 1;
    this.experience_counter += 1;
  }

  int getExperience() {
    return this.total_experience;
  }

  void setLevel(int lev) {
    this.level = lev;
  }

  int getLevel() {
    return this.level;
  }

  boolean levelUP() {
    if (experience_counter ==3 && level < 10) {
      level += 1;
      experience_counter = 0;
      return true;
    }
    return false;
  }

  void addRoleSize(float parameter) {
    this.role_size_x *= parameter;
    this.role_size_y *= parameter;
  }

  void addEatingParameter(float parameter) {
    this.eatingParameter *= parameter;
  }

  void onDeath() {
    this.survive = false;
    role_position_x = width/2;
    role_position_y = height/2;

    invincibleStartTime = millis();

    invincibleEndTime = invincibleStartTime + invincibleTimeGap;
  }

  void reviveHelper() {
    println(invincibleEndTime);
    println(invincibleStartTime);
    if (millis() > invincibleEndTime) {
      survive = true;
    } else {
      println("still invincible");
    };
  }

  boolean canIShoot() {
    if (millis()-shootedTime > 300) {
      this.canIShoot = true;
      shootedTime = millis();
      return canIShoot;
    }
    return canIShoot;
  }
  
  void setAttribute(int mvspd){
    old_moveSpeed = moveSpeed;
    if (mvspd == 1000){
      moveSpeed = 0;
    } else {
      moveSpeed += mvspd;
    }
    
  }
  
  void resumeAttribute(){
    moveSpeed = old_moveSpeed;
  }
}
