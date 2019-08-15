class GameStateThread extends Thread {
  String state = "";

  GameStateThread() {
    state = "HOME";
  }

  void setGameState(String st) {
    this.state = st;
  }
}
