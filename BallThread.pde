
class BallThread extends Thread {
  boolean running;
  int count;
  int score;
  int restart_time = 5;
  int ball_position_x[];
  int ball_position_y[];
  int ball_size_x;
  int ball_size_y;
  int attribute;
  int damage;
  int enemyMoveSpeed;
  int shootSpeed;
  int effectTime;
  boolean live[];
  PImage image;

  BallThread (int ct) {
    running = false;
    count = ct;
    ball_position_x = new int[count];
    ball_position_y = new int[count];
    live = new boolean[count];
  }

  void start() {
    // Set running true
    running = true;

    // Print messages
    System.out.println("Starting Ball thread");

    // start the thread
    super.start();
  }

  void init(String img, int xsize, int ysize, int sc, int damg, int mvspd, int shootspd, int time) {
    image = loadImage(img);
    ball_size_x = xsize;
    ball_size_y = ysize;
    score = sc;
    damage = damg;
    enemyMoveSpeed = mvspd;
    shootSpeed = shootspd;
    effectTime = time;
    for (int i=0; i< this.count; i++) {
      this.ball_position_x[i] = int(random(100, 1400));
      this.ball_position_y[i] = int(random(200, 700));
      this.live[i] = true;
    }
  }

  void show() {
    for (int i=0; i<this.count; i++) {
      if (live[i]) {
        image(this.image, this.ball_position_x[i], this.ball_position_y[i], 
          this.ball_size_x, this.ball_size_y);
      };
    }
  } 

  int getCount() {
    return this.count;
  }

  float getRadius() {
    return (this.ball_size_x)/2;
  }

  void addPoint(int pt) {
    score += pt;
  }

  int getPositionX(int index) {
    return ball_position_x[index];
  }

  int getPositionY(int index) {
    return ball_position_y[index];
  }

  void setLive(int index, boolean b) {
    this.live[index] = b;
  }

  boolean getLive(int index) {
    return this.live[index];
  }
}
