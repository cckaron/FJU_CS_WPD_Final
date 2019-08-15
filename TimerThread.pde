class TimerThread extends Thread {

  //used in beforegame coundown
  int countdownTime;
  int start_countdownTime;
  int end_countdownTime;
  boolean startBeforeGameCountDown;

  int startTime;
  int elapsedTime;
  int gameTime = 120;
  int start_refresh_time;
  int timegap;
  int timegap_accumulator;
  boolean startTimeInit;
  
  //use for bullet;
  int bullet1_attribute_startCountDownTime;
  int bullet1_attribute_timegap = 3000;
  int bullet1_attribute_countDown_end;
  boolean startBullet1AttributeCountDown = false;
  
  int bullet2_attribute_startCountDownTime;
  int bullet2_attribute_timegap = 3000;
  int bullet2_attribute_countDown_end;
  boolean startBullet2AttributeCountDown = false;
  
  //use for role;
  int role1_attribute_startCountDownTime;
  int role1_attribute_timegap = 1000;
  int role1_attribute_countDown_end;
  boolean startRole1AttributeCountDown = false;
  
  int role2_attribute_startCountDownTime;
  int role2_attribute_timegap = 2000;
  int role2_attribute_countDown_end;
  boolean startRole2AttributeCountDown = false;

  TimerThread() {
  }

  void init() {
    startTime = millis();
    timegap = 20000;
    timegap_accumulator = 0;
    countdownTime = 5;
  }

  int getCountDownTime() {
    return gameTime+int(startTime/1000)-int(millis()/1000);
  }

  boolean isRefreshTime() {
    if (millis() - startTime > timegap_accumulator) { 
      timegap_accumulator += timegap;
      return true;
    }
    return false;
  }

  void beforegameCounDownStart() {
    startBeforeGameCountDown = true;
    start_countdownTime = int(millis()/1000);
    end_countdownTime = start_countdownTime + 6;
    println("before count down start!");
  }

  int getBeforeGameCountdownTime() {
    return end_countdownTime - int(millis()/1000);
  }

  boolean isBeforeGameCountDownEnd() {
    if (end_countdownTime - int(millis()/1000) < 0) {
      startBeforeGameCountDown = false;
      return true;
    }
    return false;
  }
  
  
  void bullet1AttributeCountDownStart(){
    startBullet1AttributeCountDown = true;
    bullet1_attribute_startCountDownTime = millis();
    bullet1_attribute_countDown_end = bullet1_attribute_startCountDownTime + bullet1_attribute_timegap;
  }
  
  void bullet2AttributeCountDownStart(){
    startBullet2AttributeCountDown = true;
    bullet2_attribute_startCountDownTime = millis();
    bullet2_attribute_countDown_end = bullet2_attribute_startCountDownTime + bullet2_attribute_timegap;
  }
  
  boolean isbullet1AttributeCountDownEnd() {
    if (bullet1_attribute_countDown_end - millis() < 0) {
      startBullet1AttributeCountDown = false;
      return true;
    }
    return false;
  }
  
  boolean isbullet2AttributeCountDownEnd() {
    if (bullet2_attribute_countDown_end - millis() < 0) {
      startBullet2AttributeCountDown = false;
      return true;
    }
    return false;
  }
  
  
  void role1AttributeCountDownStart(){
    startRole1AttributeCountDown = true;
    role1_attribute_startCountDownTime = millis();
    role1_attribute_countDown_end = role1_attribute_startCountDownTime + role1_attribute_timegap;
  }
  
  void role2AttributeCountDownStart(){
    startRole2AttributeCountDown = true;
    role2_attribute_startCountDownTime = millis();
    role2_attribute_countDown_end = role2_attribute_startCountDownTime + role2_attribute_timegap;
  }
  
  boolean isrole1AttributeCountDownEnd() {
    if (role1_attribute_countDown_end - millis() < 0) {
      startRole1AttributeCountDown = false;
      return true;
    }
    return false;
  }
  
  boolean isrole2AttributeCountDownEnd() {
    if (role2_attribute_countDown_end - millis() < 0) {
      startRole2AttributeCountDown = false;
      return true;
    }
    return false;
  }
}
