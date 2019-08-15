class GradejudgeThread extends Thread {
  GradejudgeThread() {
  }

  void init() {
  }

  void judge() {
    whohasCrown();
  }

  void whohasCrown() {
    if (role1.level > role2.level) {
      role1.isFirst = true;
      role2.isFirst = false;
    } else if (role1.level < role2.level) {
      role1.isFirst = false;
      role2.isFirst = true;
    } else {
      role1.isFirst = false;
      role2.isFirst = false;
    }
  }
}
