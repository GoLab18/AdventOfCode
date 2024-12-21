import 'dart:io';

const DIRECTIONS = <int, (int, int)>{
  94: (-1, 0),
  118: (1, 0),
  60: (0, -1),
  62: (0, 1)
};

Future<void> main(List<String> args) async {
  final filepath = args.isNotEmpty ? args[0] : "test.txt";
  var (map, moves, startPoint) = await readFile(filepath);

  // Part 1
  print("Boxes coordinates sum -> ${boxesCoordSum(map, moves, startPoint)}");
}

Future<(List<List<int>>, List<int>, Point)> readFile(String filepath) async {
  final file = File(filepath);
  if (!await file.exists()) throw StateError("[ERROR] file does not exist");

  var lines = await file.readAsLines();
  var linesCodes = lines.map((l) => List<int>.from(l.codeUnits)).toList();

  int robotY = -1, robotX = -1, j = 0;
  var grid = linesCodes.takeWhile((l) {
    for (var i = 0; robotY == -1 && i < l.length; i++) {
      if (l[i] == 64) {
        l[i] = 46;
        
        robotY = j;
        robotX = i;
      }
    }

    j++;
    return l.isNotEmpty;
  }).toList();

  

  var moves = linesCodes.sublist(grid.length+1).reduce((s1, s2) => s1 + s2);
  
  return (grid, moves, Point(robotY, robotX));
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

int sum(List<List<int>> grid) {
  var sum = 0;
  for (var i = 1; i < grid.length-1; i++) {
    for (var j = 1; j < grid[i].length-1; j++) {
      if (grid[i][j] == 79) sum += i * 100 + j;
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
