class BaseFunctions {
  static String getTimeBasedGreetings() {
    return DateTime.now().hour > 12
        ? DateTime.now().hour > 18
            ? "evening"
            : "afternoon"
        : "morning";
  }
}
