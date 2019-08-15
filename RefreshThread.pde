class RefreshThread extends Thread {

  RefreshThread () {
  }

  void refreshEvent() {
    refresh(ball_1);
    refresh(ball_2);
    refresh(ball_3);
    refresh(ball_4);
    refresh(ball_5);
    refresh(ball_heal);
  }

  void refresh(BallThread ball) {
    for (int i=0; i<ball.count; i++) {
      ball.live[i] = false;
      ball.ball_position_x[i] = int(random(100, 1400));
      ball.ball_position_y[i] = int(random(200, 700));
    } 



    for (int i=0; i<ball.count; i++) {
      ball.live[i] = true;
    }
  }
}
