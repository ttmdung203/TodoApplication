enum Status {
  incomplete,
  completed
}

extension StatusExtension on Status {
  static Status? fromValue(int value) {
    switch (value) {
      case 0:
        return Status.incomplete;
      case 1:
        return Status.completed;
      default:
        return null;
    }
  }
}