enum Priority {
  low,
  medium,
  high
}

extension PriorityExtension on Priority {
  static Priority? fromValue(int value) {
    switch (value) {
      case 0:
        return Priority.low;
      case 1:
        return Priority.medium;
      case 2:
        return Priority.high;
      default:
        return null;
    }
  }

  String stringValue() {
    switch (this) {
      case Priority.low:
        return "Low";
      case Priority.medium:
        return "Medium";
      case Priority.high:
        return "High";
    }
  }
}