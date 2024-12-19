import 'dart:io';

typedef Point = (int, int);

const DIRECTIONS = [
  (-1, 0),
  (1, 0),
  (0, -1),
  (0, 1),
];

Future<void> main(List<String> args) async {
  final filepath = args.isNotEmpty ? args[0] : "test.txt";
  List<String> grid = await readFile(filepath);

  final (initialPrice, discountedPrice) = totalFencingPrice(grid);

  // Part 1
  print("Total fencing price -> ${initialPrice}");
  
  // Part 2
  print("Total bulk-discounted fencing price -> ${discountedPrice}");
}

Future<List<String>> readFile(String filepath) async {
  final file = File(filepath);
  if (!await file.exists()) throw StateError("[ERROR] file does not exist");
  return file.readAsLines();
}

(int, int) totalFencingPrice(List<String> grid) {
  int rows = grid.length;
  int cols = grid[0].length;

  int totalPrice = 0, discountedPrice = 0;
  List<List<bool>> visited = List.generate(rows, (_) => List.filled(cols, false));

  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      if (!visited[y][x]) {
        final region = grid[y][x].codeUnitAt(0);
        final (area, perimeter, sides) = dfs(y, x, region, visited, grid, rows, cols);

        totalPrice += area * perimeter;
        discountedPrice += area * sides;
      }
    }
  }

  return (totalPrice, discountedPrice);
}

(int, int, int) dfs(int y, x, int region, List<List<bool>> visited, List<String> grid, int rows, cols) {
  int area = 0;
  int perimeter = 0;
  int sides = 0;
  
  final isNotInsideBounds = (int y, int x) => y < 0 || y >= rows || x < 0 || x >= cols;
  final isNotInsideRegion = (int y, int x) => isNotInsideBounds(y, x) || grid[y][x].codeUnitAt(0) != region;
  
  final stack = <Point>[(y, x)];

  while (stack.isNotEmpty) {
    final (cy, cx) = stack.removeLast();

    if (visited[cy][cx]) continue;

    visited[cy][cx] = true;
    area++;

    dirsLoop:
    for (final (dy, dx) in DIRECTIONS) {
      final ny = cy + dy;
      final nx = cx + dx;

      if (isNotInsideRegion(ny, nx)) {
        perimeter++;

        var nby1 = cy + dx, nbx1 = cx + dy;
        while (!isNotInsideRegion(nby1, nbx1) && isNotInsideRegion(nby1 + dy, nbx1 + dx)) {
          if (visited[nby1][nbx1]) continue dirsLoop;
          
          nby1 += dx;
          nbx1 += dy;
        }

        var nby2 = cy - dx, nbx2 = cx - dy;
        while (!isNotInsideRegion(nby2, nbx2) && isNotInsideRegion(nby2 + dy, nbx2 + dx)) {
          if (visited[nby2][nbx2]) continue dirsLoop;
          
          nby2 -= dx;
          nbx2 -= dy;
        }

        sides++;
      } else if (!visited[ny][nx]) stack.add((ny, nx));
    }
  }

  return (area, perimeter, sides);
}
