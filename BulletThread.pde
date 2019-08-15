
class BulletThread extends Thread {
  boolean running;
  int count;
  int shooted;
  float bullet_position_x[];
  float bullet_position_y[];
  float bullet_size_x[];
  float bullet_size_y[];
  int direction[];
  boolean live[];
  int attribute; // 0->nothing; 1->freeze; 2->slow; 3->damage;
  int damage;
  int enemyMoveSpeed;
  int shootSpeed;
  int effectTime;
  
  int old_damage;
  int old_enemyMoveSpeed;
  int old_shootSpeed;
  int old_effectTime;
  PImage image;
  RoleThread role;



  BulletThread(int ct, RoleThread ro) {
    running = false;
    count = ct;
    shooted = 0;
    bullet_position_x = new float[ct];
    bullet_position_y = new float[ct];
    live = new boolean[ct];
    bullet_size_x = new float[ct];
    bullet_size_y = new float[ct];
    direction = new int[ct];
    shootSpeed = 30;
    damage = 20;
    role = ro;
  }

  void start() {
    // Set running true
    running = true;
    // Print messages
    System.out.println("Starting Bullet thread");
    // Do whatever start does in Thread,
    super.start();
  }

  void init(String img) {
    image = loadImage(img);
    for (int i=0; i< this.count; i++) {
      live[i] = false;
      bullet_size_x[i] = 100;
      bullet_size_y[i] = 100;
    }
  }

  void shoot(int direct, int position_x, int position_y) {
    this.live[shooted] = true;
    this.bullet_position_x[shooted] = position_x;
    this.bullet_position_y[shooted] = position_y;
    this.direction[shooted] = direct;
    this.shooted += 1;
    println("call shooted:"+shooted);
  }

  void show(RoleThread role) {
    for (int i=0; i<this.count; i++) {
      if (live[i]) {
        image(this.image, this.bullet_position_x[i], this.bullet_position_y[i], 
          this.bullet_size_x[i], this.bullet_size_y[i]);
        if (this.direction[i] == 0) {
          if (this.bullet_position_x[i] <= 0) {
            this.live[i] = false;
          } else if (this.bullet_position_x[i] > 0) {
            this.bullet_position_x[i] -= shootSpeed;
          }
        } else if (this.direction[i] == 1) {
          if (this.bullet_position_x[i] >= 1650) {
            this.live[i] = false;
          } else if (this.bullet_position_x[i] < 1650) {
            this.bullet_position_x[i] += shootSpeed;
          }
        };

        //add score
        if ( abs(int(this.bullet_position_x[i]- role.getPositionX()))  < role.getSizeX()/2
          && ( abs(int(this.bullet_position_y[i]- role.getPositionY()))  < role.getSizeY()/2 )) {   
          role.addScore(-damage);
          this.live[i] = false;
          
          if (role.id == "Player A"){
            if (timer.startRole1AttributeCountDown){
              role.resumeAttribute();
              role.setAttribute(enemyMoveSpeed);  
            } else {
              role.setAttribute(enemyMoveSpeed);  
            }
            timer.role1AttributeCountDownStart();
            
          } else if (role.id == "Player B"){
            if (timer.startRole2AttributeCountDown){
              role.resumeAttribute();
              role.setAttribute(enemyMoveSpeed);  
            } else {
              role.setAttribute(enemyMoveSpeed);  
            }
            timer.role2AttributeCountDownStart();
          }
        }
      }
    }
  }

  void setAttribute(int damg, int mvspd, int shootspd, int time) {
    old_damage = damage;
    old_enemyMoveSpeed = enemyMoveSpeed;
    old_shootSpeed = shootSpeed;
    old_effectTime = time;
    
    damage = damg;
    enemyMoveSpeed = mvspd;
    shootSpeed += shootspd;
    effectTime = time;
  }
  
  void resumeAttribute(){
    damage = old_damage;
    enemyMoveSpeed = old_enemyMoveSpeed;
    shootSpeed = old_shootSpeed;
    effectTime = old_effectTime;
  }
}
