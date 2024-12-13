import 'dart:io';

typedef Point = (int, int); // y and x values
typedef Plot = (int, int); // Area and perimeter respectively

const DIRECTIONS = [
  (-1, 0),
  (1, 0),
  (0, -1),
  (0, 1),
];

Future<void> main(List<String> args) async {
  final filepath = args.isNotEmpty ? args[0] : "test.txt";
  List<String> grid = await readFile(filepath);

  // Part 1
  print("Total fencing price -> ${totalFencingPrice(grid)}");
}

Future<List<String>> readFile(String filepath) async {
  final file = File(filepath);
  if (!await file.exists()) throw StateError("[ERROR] file does not exist");
  return file.readAsLines();
}

int totalFencingPrice(List<String> grid) {
  int rows = grid.length;
  int cols = grid[0].length;

  int totalPrice = 0;
  List<List<bool>> visited = List.generate(rows, (_) => List.filled(cols, false));

  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      if (!visited[y][x]) {
        final region = grid[y][x];
        final (area, perimeter) = dfs(y, x, region, visited, grid, rows, cols);

        totalPrice += area * perimeter;
      }
    }
  }

  return totalPrice;
}

  Plot dfs(int y, x, String region, List<List<bool>> visited, List<String> grid, int rows, cols) {
    int area = 0;
    int perimeter = 0;
    
    final stack = <Point>[(y, x)];

    while (stack.isNotEmpty) {
      final (cy, cx) = stack.removeLast();

      if (visited[cy][cx]) continue;

      visited[cy][cx] = true;
      area++;

      for (final (dy, dx) in DIRECTIONS) {
        final ny = cy + dy;
        final nx = cx + dx;

        if (ny < 0 || ny >= rows || nx < 0 || nx >= cols || grid[ny][nx] != region) perimeter++;
        else if (!visited[ny][nx]) stack.add((ny, nx));
      }
    }

    return (area, perimeter);
  }
