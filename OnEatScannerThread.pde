class OnEatScannerThread extends Thread {
  OnEatScannerThread() {
  }

  void onEatBallScanner() {
    // ball_1 scanner
    scan(ball_1, role1);
    scan(ball_2, role1);
    scan(ball_3, role1);
    scan(ball_4, role1);
    scan(ball_5, role1);
    scan(ball_heal, role1);
    scan(ball_1, role2);
    scan(ball_2, role2);
    scan(ball_3, role2);
    scan(ball_4, role2);
    scan(ball_5, role2);
    scan(ball_heal, role2);
  }

  void scan(BallThread ball, RoleThread role) {
    int ball_index = 0;
    for (int i=0; i< ball.count; i++) {
      if (( abs(role.getPositionX() - ball.getPositionX(i)) < role.eatingParameter) &&
        ( abs(role.getPositionY() - ball.getPositionY(i)) < role.eatingParameter) &&
        ball.getLive(i) == true)
      {
        ball_index = i;
        ball.setLive(ball_index, false);
        role.addScore(ball.score);
        role.addExperience();
        
        if (role.id == "Player A"){
          println("player a");
          println("attributecountdown:"+timer.startBullet1AttributeCountDown);
          if (timer.startBullet1AttributeCountDown){
            bullet1.resumeAttribute();
            bullet1.setAttribute(ball.damage, ball.enemyMoveSpeed, ball.shootSpeed, ball.effectTime);  
          } else {
            bullet1.setAttribute(ball.damage, ball.enemyMoveSpeed, ball.shootSpeed, ball.effectTime);  
          }
          timer.bullet1AttributeCountDownStart();
          
        } else if (role.id == "Player B"){
          if (timer.startBullet2AttributeCountDown){
            bullet2.resumeAttribute();
            bullet2.setAttribute(ball.damage, ball.enemyMoveSpeed, ball.shootSpeed, ball.effectTime);  
          } else {
            bullet2.setAttribute(ball.damage, ball.enemyMoveSpeed, ball.shootSpeed, ball.effectTime);  
          }
          timer.bullet2AttributeCountDownStart();
        }

        if (role.levelUP()) {
          if (role.level < 10) {
            role.moveSpeed -= 0.2;
            role.addRoleSize(1.1);
            role.addEatingParameter(1.2);
          }
        };
      }
    }
  }

  void onEatRoleScanner() {
    scanRole(role1, role2);
  }

  void scanRole(RoleThread role1, RoleThread role2) {
    boolean gotCha1 = false;
    boolean gotCha2 = false;
    if (( abs(role1.getPositionX() - role2.getPositionX()) < role2.eatingParameter) &&
      ( abs(role1.getPositionY() - role2.getPositionY()) < role1.eatingParameter))
    {
      if (role1.level < role2.level && role1.survive) gotCha1 = true;
      if (role1.level > role2.level && role2.survive) gotCha2 = true;
    } 

    if (gotCha1) {
      print("gotCha1");
      role1.onDeath();
      role1.addScore(-50);
      role2.eatRoleTime += 1;
    }
    if (gotCha2) {
      print("gotCha2");
      role2.onDeath();
      role2.addScore(-50);
      role1.eatRoleTime += 1;
    }
  }
}
