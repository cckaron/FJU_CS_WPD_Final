import processing.serial.*;
import java.awt.Robot;
import java.awt.event.KeyEvent;
import java.io.IOException;

Serial arduino1;
Serial arduino2;
//6 ball -> 5 plus and 1 minus
RoleThread role1;
RoleThread role2;

BallThread ball_5;
BallThread ball_4;
BallThread ball_3;
BallThread ball_2;
BallThread ball_1;
BallThread ball_heal;

BulletThread bullet1;
BulletThread bullet2;

TimerThread timer;
RefreshThread refreshHelper;
GradejudgeThread gradeJudge;
OnEatScannerThread onEatHelper;
GameStateThread gameStateHelper;

float x = 0;
boolean isW, isA, isS, isD, is5, is1, is2, is3, isF, is6;

int val1, val2;  //from arduino
Robot robot;

PImage home;
PImage rule;
PImage gaming;

int test = 1;


void setup() {
  String portName = Serial.list()[1];
  String portName2 = Serial.list()[2];
  arduino1 = new Serial(this, portName, 38400);
  arduino2 = new Serial(this, portName2, 38400);
  println(portName);
  println(portName2);
  size(1560, 822);
  smooth();
  ball_5 = new BallThread(1);
  ball_4 = new BallThread(1);
  ball_3 = new BallThread(1);
  ball_2 = new BallThread(1);
  ball_1 = new BallThread(1);
  ball_heal = new BallThread(3);

  bullet1 = new BulletThread(100, role1);
  bullet2 = new BulletThread(100, role2);

  role1 = new RoleThread("Player A");
  role2 = new RoleThread("Player B");

  timer = new TimerThread();
  refreshHelper = new RefreshThread();

  gradeJudge = new GradejudgeThread();

  onEatHelper = new OnEatScannerThread();

  gameStateHelper = new GameStateThread();

  role1.start();
  role2.start();
  ball_5.start();
  ball_4.start();
  ball_3.start();
  ball_2.start();
  ball_1.start();
  ball_heal.start();
  bullet1.start();
  bullet2.start();
  timer.start();
  refreshHelper.start();
  gradeJudge.start();
  onEatHelper.start();
  gameStateHelper.start();

  //initialize ball position
  ball_5.init("img/ball/wake.png", 200, 200, 10, 30, 100, 0, 0);
  ball_4.init("img/ball/leave.png", 200, 200, 10, 10, -10, 40, 4);
  ball_3.init("img/ball/dark.png", 200, 200, 10, 100, 10, -20, 4);
  ball_2.init("img/ball/sun.png", 200, 200, 10, 30, 10, 40, 4);
  ball_1.init("img/ball/thunder.png", 200, 200, 10, 30, 1000, 0, 4);
  ball_heal.init("img/ball/ball_heal.png", 200, 200, 50, 0, 0, 0, 2);

  //initialize bullet
  bullet1.init("img/ball/score1.png");
  bullet2.init("img/ball/score2.png");

  //initialize role
  role1.init("img/role/role1-right.png", 150, 150, width/2 - 250, height/2 - 50);
  role2.init("img/role/role2-left.png", 150, 150, width/2 + 50, height/2 - 50);

  gradeJudge.init();

  try {
    robot = new Robot();
    robot.delay(1000);
  }
  catch (Exception e) {
    e.printStackTrace();
  }
}

void draw() {

  if (gameStateHelper.state == "GAME") {
    //game timer
    if (timer.startTimeInit == false) {
      timer.init();
      timer.startTimeInit = true;
    };

    if (timer.getCountDownTime() == 0) {
      gameStateHelper.setGameState("END");
    };

    //background(255);
    gaming = loadImage("img/background/gaming.png");
    background(gaming);
    ball_5.show();
    ball_4.show();
    ball_3.show();
    ball_2.show();
    ball_1.show();
    ball_heal.show();

    bullet1.show(role2);
    bullet2.show(role1);

    gradeJudge.judge();

    role1.show();
    role2.show();

    fill(255, 0, 0);
    textSize(40);
    text(role1.id + "  Blood:" + role1.score + "/300", 120, 70);
    text(role2.id + " Blood" + role2.score + "/300", 950, 70);
    textSize(80);
    fill(0);
    text(timer.getCountDownTime(), width/2 - 45, 85);

    if (timer.isRefreshTime()) {
      refreshHelper.refreshEvent();
    };
    
    if (timer.startBullet1AttributeCountDown && timer.isbullet1AttributeCountDownEnd()) {
      println("fucking resume");
      bullet1.resumeAttribute();
    } 
    
    if (timer.startBullet2AttributeCountDown && timer.isbullet2AttributeCountDownEnd()) {
      bullet2.resumeAttribute();
    }
    
    if (timer.startRole1AttributeCountDown && timer.isrole1AttributeCountDownEnd()) {
      println("fucking resume");
      role1.resumeAttribute();
    } 
    
    if (timer.startRole2AttributeCountDown && timer.isrole2AttributeCountDownEnd()) {
      role2.resumeAttribute();
    } 


    if (arduino1.available() > 0) { // If data is available,
      val1 = arduino1.read(); // read it and store it in val
      println("val1:"+ val1);
    }

    if (arduino2.available() > 0) { // If data is available,
      val2 = arduino2.read(); // read it and store it in val
      println("val2:"+ val2);
    }

    //arduino1
    if (val1 == 1){
      role1.UP();
    } else if (val1 == 2){
      role1.DOWN();
    } else if (val1 == 3){
      role1.LEFT("img/role/role1-left.png");
    } else if (val1 == 4){
      role1.RIGHT("img/role/role1-right.png");
    } else if (val1 == 5){
      if (role1.canIShoot()) {
        bullet1.shoot(role1.getDirection(), role1.getPositionX(), role1.getPositionY());
        role1.canIShoot = false;
      }
    }

    ////arduino2
    if (val2 == 1){
      role2.UP();
    } else if (val2 == 2){
      role2.DOWN();
    } else if (val2 == 3){
      role2.LEFT("img/role/role2-left.png");
    } else if (val2 == 4){
      role2.RIGHT("img/role/role2-left.png");
    } else if (val2 == 5){
      if (role2.canIShoot()) {
        bullet2.shoot(role2.getDirection(), role2.getPositionX(), role2.getPositionY());
        role2.canIShoot = false;
      }
    }

    //control
    if (isW) role1.UP();
    if (isA) role1.LEFT("img/role/role1-left.png");
    if (isS) role1.DOWN();
    if (isD) role1.RIGHT("img/role/role1-right.png");
    if (is5) role2.UP();
    if (isF) {
      if (role1.canIShoot()) {
        bullet1.shoot(role1.getDirection(), role1.getPositionX(), role1.getPositionY());
        role1.canIShoot = false;
      }
    }
    if (is1) role2.LEFT("img/role/role2-left.png");
    if (is2) role2.DOWN();
    if (is3) role2.RIGHT("img/role/role2-right.png");
    if (is6) {      
      if (role2.canIShoot()) {
        bullet2.shoot(role2.getDirection(), role2.getPositionX(), role2.getPositionY());
        role2.canIShoot = false;
      }
    }
    onEatHelper.onEatBallScanner();
    onEatHelper.onEatRoleScanner();

    if (role1.survive == false) role1.reviveHelper();
    if (role2.survive == false) role2.reviveHelper();
  } else if (gameStateHelper.state == "HOME") {
    home = loadImage("img/background/home.png");
    background(home);
    if (keyPressed) {
      if (key == 'z') {
        gameStateHelper.setGameState("COUNTDOWN");
      }
      if (key =='x') {
        gameStateHelper.setGameState("RULE");
      }
    }
  } else if (gameStateHelper.state == "RULE") {
    rule = loadImage("img/background/rule.png");
    background(rule);
    if (keyPressed) {
      if (key == 'z') {
        gameStateHelper.setGameState("COUNTDOWN");
      }
    }
  } else if (gameStateHelper.state == "COUNTDOWN") {
    if (timer.startBeforeGameCountDown == false) {
      timer.beforegameCounDownStart();
    }

    if (timer.isBeforeGameCountDownEnd()) {
      gameStateHelper.setGameState("GAME");
    } else {
      background(255);
      fill(0);
      textSize(300);
      text(timer.getBeforeGameCountdownTime(), width/2 - 100, height/2 + 100);
    }
  } else if (gameStateHelper.state == "END") {
    //background(255);
    gaming = loadImage("img/background/gaming.png");
    background(gaming);
    fill(0, 0, 255);
    textSize(50);
    text("Player A's Remaining Blood:"+ role1.score, width/2-500, height/2);
    text("You eat your friend " + role1.eatRoleTime + " Time!!", width/2-500, height/2+100);
    fill(255,165,0);
    text("Player B's Remaining Blood:"+ role2.score, width/2-500, height/2+200);
    text("You eat your friend " + role2.eatRoleTime + " Time!!", width/2-500, height/2+300);
    textSize(100);
    fill(255, 0, 0);
    if (role1.score > role2.score) {
      text("Winner is Player A!!!", width/2-400, height/2-100);
    } else if (role1.score < role2.score) {
      text("Winner is Player B!!!", width/2-4600, height/2-100);
    } else if (role1.score == role2.score) {
      text("Flat!!!", width/2-400, height/2-100);
    }
  };
}

void keyPressed() {
  setMove(key, true);
  println("You press "+ key);
}

void keyReleased() {
  setMove(key, false);
  println("You release "+ key);
}

boolean setMove(char k, boolean b) {
  switch(k) {
  case 'w':
    return isW = b;
  case 'a':
    return isA = b;
  case 's':
    return isS = b;
  case 'd':
    return isD = b;
  case 'f':
    return isF = b;
  case '5':
    return is5 = b;
  case '1':
    return is1 = b;
  case '2':
    return is2 = b;
  case '3':
    return is3 = b;
  case '6':
    return is6 = b;
  default:
    return b;
  }
}
