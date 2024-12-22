import 'dart:io';

const DIRECTIONS = <int, (int, int)>{
  94: (-1, 0),
  118: (1, 0),
  60: (0, -1),
  62: (0, 1)
};

const PROPAGATIONS = <int, int>{
  91: 62, // '[' bound to the right direction
  93: 60 // ']' bound to the left direction
};

Future<void> main(List<String> args) async {
  final filepath = args.isNotEmpty ? args[0] : "test.txt";
  var (map, scaledMap, moves, startPoint, spScaled) = await readFile(filepath);

  // Part 1
  print("Boxes coordinates sum -> ${boxesCoordSum(map, moves, startPoint)}");

  // Part 2
  print("Scaled boxes coordinates sum -> ${boxesCoordSumScaled(scaledMap, moves, spScaled)}");
}

Future<(List<List<int>>, List<List<int>>, List<int>, Point, Point)> readFile(String filepath) async {
  final file = File(filepath);
  if (!await file.exists()) throw StateError("[ERROR] file does not exist");

  var lines = await file.readAsLines();
  var linesCodes = lines.map((l) => List<int>.from(l.codeUnits)).toList();

  int robotY = -1, robotX = -1, j = 0;
  List<List<int>> scaledGrid = List.empty(growable: true);
  var grid = linesCodes.takeWhile((l) {
    List<int> sc = [];

    for (var i = 0; i < l.length; i++) {
      if (l[i] == 64) {
        l[i] = 46;
        
        robotY = j;
        robotX = i;
      }
      
      sc.addAll((l[i] != 79) ? [l[i], l[i]] : [91, 93]);
    }

    scaledGrid.add(sc);

    j++;
    return l.isNotEmpty;
  }).toList();

  final moves = linesCodes.sublist(grid.length+1).reduce((s1, s2) => s1 + s2);
  
  return (grid, scaledGrid.takeWhile((l) => l.isNotEmpty).toList(), moves, Point(robotY, robotX), Point(robotY, robotX*2));
}

int boxesCoordSum(List<List<int>> grid, List<int> moves, Point currPos) {
  for (var mv in moves) {
    var nextPos = currPos.getNextPosition(mv);

    if (grid[nextPos.y][nextPos.x] == 35) continue;

    if (grid[nextPos.y][nextPos.x] == 46) currPos.move(mv); 
    else if (grid[nextPos.y][nextPos.x] == 79) {
      var np = nextPos.getNextPosition(mv);

      if (np.y < grid.length && np.x < grid[0].length && grid[np.y][np.x] == 35) continue;

      if (moveBoxes(grid, nextPos, np, mv)) currPos.move(mv);
    }
  }

  return sum(grid);
}

bool moveBoxes(List<List<int>> grid, Point currPos, Point np, int mv) {
  if (grid[np.y][np.x] == 35) return false;

  if (grid[np.y][np.x] == 79) {
    if (!moveBoxes(grid, np, np.getNextPosition(mv), mv)) return false;
  }

  grid[currPos.y][currPos.x] = 46;
  grid[np.y][np.x] = 79;

  return true;
}

int boxesCoordSumScaled(List<List<int>> grid, List<int> moves, Point currPos) {
  for (var mv in moves) {
    var nextPos = currPos.getNextPosition(mv);

    if (grid[nextPos.y][nextPos.x] == 35) continue;

    if (grid[nextPos.y][nextPos.x] == 46) currPos.move(mv); 
    else if (grid[nextPos.y][nextPos.x] == 91 || grid[nextPos.y][nextPos.x] == 93) {
      var np = nextPos.getNextPosition(mv);

      if (np.y < grid.length && np.x < grid[0].length && grid[np.y][np.x] == 35) continue;

      if ((mv == 60 || mv == 62) && moveBoxesScaledHorizontal(grid, nextPos, np, mv)) currPos.move(mv);
      
      else if (canMoveBoxesScaledVertical(grid, nextPos, np, mv)) {
        rearrangeBoxesVertical(grid, nextPos, np, mv);

        currPos.move(mv);
      }
    }
  }
  
  return sum(grid);
}

bool moveBoxesScaledHorizontal(List<List<int>> grid, Point cp, Point np, int mv) {  
  if (grid[np.y][np.x] == 35) return false;

  if (grid[np.y][np.x] == 91 || grid[np.y][np.x] == 93) {
    if (!moveBoxesScaledHorizontal(grid, np, np.getNextPosition(mv), mv)) return false;
  }

  var tmp = grid[cp.y][cp.x];
  grid[cp.y][cp.x] = grid[np.y][np.x];
  grid[np.y][np.x] = tmp;

  return true;
}

bool canMoveBoxesScaledVertical(List<List<int>> grid, Point cp, Point np, int mv) {
  if (grid[np.y][np.x] == 35) return false;

  if ((grid[np.y][np.x] != 46) && !canMoveBoxesScaledVertical(grid, np, np.getNextPosition(mv), mv)) return false;

  Point sp = cp.getNextPosition(PROPAGATIONS[grid[cp.y][cp.x]]!);
  Point nsp = sp.getNextPosition(mv);

  if (grid[nsp.y][nsp.x] == 35) return false;

  if ((grid[nsp.y][nsp.x] != 46) && !canMoveBoxesScaledVertical(grid, nsp, nsp.getNextPosition(mv), mv)) return false;

  return true;
}

void rearrangeBoxesVertical(List<List<int>> grid, Point cp, Point np, int mv) {
  Point sp = cp.getNextPosition(PROPAGATIONS[grid[cp.y][cp.x]]!);
  Point nsp = sp.getNextPosition(mv);

  if (grid[np.y][np.x] == 91 || grid[np.y][np.x] == 93) {
    rearrangeBoxesVertical(grid, np, np.getNextPosition(mv), mv);
  }

  if (grid[nsp.y][nsp.x] == 91 || grid[nsp.y][nsp.x] == 93) {
    rearrangeBoxesVertical(grid, nsp, nsp.getNextPosition(mv), mv);
  }

  grid[np.y][np.x] = grid[cp.y][cp.x];
  grid[cp.y][cp.x] = 46;

  grid[nsp.y][nsp.x] = grid[sp.y][sp.x];
  grid[sp.y][sp.x] = 46;
}

int sum(List<List<int>> grid) {
  var sum = 0;
  for (var i = 1; i < grid.length-1; i++) {
    for (var j = 1; j < grid[i].length-1; j++) {
      if (grid[i][j] == 79 || grid[i][j] == 91) sum += i * 100 + j;
    }
  }

  return sum;
}

class Point {
  int y, x;

  Point(this.y, this.x);

  Point getNextPosition(int dir) {
    var d = DIRECTIONS[dir]!;

    return Point(this.y+d.$1, this.x+d.$2);
  }

  void move(int dir) {
    var d = DIRECTIONS[dir]!;
    
    this.y += d.$1;
    this.x += d.$2;
  }
}
