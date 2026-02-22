enum Direction {
  up,
  down,
  left,
  right;

  int get dRow {
    switch (this) {
      case Direction.up:
        return -1;
      case Direction.down:
        return 1;
      default:
        return 0;
    }
  }

  int get dCol {
    switch (this) {
      case Direction.left:
        return -1;
      case Direction.right:
        return 1;
      default:
        return 0;
    }
  }

  bool isOpposite(Direction other) {
    switch (this) {
      case Direction.up:
        return other == Direction.down;
      case Direction.down:
        return other == Direction.up;
      case Direction.left:
        return other == Direction.right;
      case Direction.right:
        return other == Direction.left;
    }
  }

  Direction get opposite {
    switch (this) {
      case Direction.up:
        return Direction.down;
      case Direction.down:
        return Direction.up;
      case Direction.left:
        return Direction.right;
      case Direction.right:
        return Direction.left;
    }
  }
}
