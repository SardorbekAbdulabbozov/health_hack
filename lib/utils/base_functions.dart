class BaseFunctions {
  static String getTimeBasedGreetings() {
    return DateTime.now().hour > 12
        ? DateTime.now().hour > 18
            ? "evening"
            : "afternoon"
        : "morning";
  }

  static String getWorkoutCoverImage(String id) {
    switch (id) {
      case '1':
        return 'abs';
      case '2':
        return 'arms';
      case '3':
        return 'legs';
      case '4':
        return 'back';
      case '5':
        return 'yoga';
      default:
        return 'gym';
    }
  }
}
