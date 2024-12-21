import 'dart:io';
import 'dart:math';

Future<void> main(List<String> args) async {
  final filepath = args.isNotEmpty ? args[0] : "test.txt";
  final areaWidth = args.length > 1 ? int.parse(args[1]) : 11;
  final areaHeight = args.length > 2 ? int.parse(args[2]) : 7;

  List<Robot> robots = await readFile(filepath);

  int safetyFactor = calcSafetyFactor(robots, areaWidth, areaHeight, 100);
  print("Safety factor after 100 seconds -> $safetyFactor");

  int fewestSeconds = fewestSecondsEasterEgg(robots, areaWidth, areaHeight);
  print("First easter egg occurance -> $fewestSeconds");
}

Future<List<Robot>> readFile(String filepath) async {
  final file = File(filepath);
  if (!await file.exists()) throw StateError("[ERROR] file does not exist");
  final lines = await file.readAsLines();

  return lines.map((line) => Robot.fromInput(line)).toList();
}

int calcSafetyFactor(List<Robot> robots, int width, int height, int seconds) {
  List<List<int>> grid = List.generate(height, (_) => List.filled(width, 0));

  for (var r in robots) {
    r.updatePosition(seconds, width, height);
    grid[r.y][r.x]++;
  }

  int midX = width ~/ 2, midY = height ~/ 2;
  int q1 = 0, q2 = 0, q3 = 0, q4 = 0;

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      if (x == midX || y == midY) continue;

      if (x > midX && y < midY) q1 += grid[y][x];
      else if (x < midX && y < midY) q2 += grid[y][x];
      else if (x < midX && y > midY) q3 += grid[y][x];
      else if (x > midX && y > midY) q4 += grid[y][x];
    }
  }

  return q1 * q2 * q3 * q4;
}

int fewestSecondsEasterEgg(List<Robot> robots, int width, int height) {
  int bestTimeX = 0, bestTimeY = 0;
  double minVarianceX = double.infinity, minVarianceY = double.infinity;

  for (int t = 0; t < max(width, height); t++) {
    List<Point> positions = move(robots, t, width, height);
    List<int> xs = positions.map((p) => p.x).toList();
    List<int> ys = positions.map((p) => p.y).toList();

    double varianceX = calcVariance(xs);
    double varianceY = calcVariance(ys);

    if (varianceX < minVarianceX) {
      minVarianceX = varianceX;
      bestTimeX = t;
    }

    if (varianceY < minVarianceY) {
      minVarianceY = varianceY;
      bestTimeY = t;
    }
  }

  // Chinese Reminder Theorem

  int t = bestTimeX;
  int diff = bestTimeY - bestTimeX;
  int invW = modInverse(width, height);

  t += (invW * diff % height) * width;
  t %= (width * height);
  if (t < 0) t += (width * height);

  return t;
}

List<Point> move(List<Robot> robots, int t, int width, int height) {
  return robots.map((r) {
    int x = (r.sx + t * r.vx) % width;
    int y = (r.sy + t * r.vy) % height;

    if (x < 0) x += width;
    if (y < 0) y += height;

    return Point(x, y);
  }).toList();
}

double calcVariance(List<int> vals) {
  double mean = vals.reduce((a, b) => a + b) / vals.length;

  return vals.map((v) => pow(v - mean, 2)).reduce((a, b) => a + b) / vals.length;
}

// Extended Euclidean Algorithm for modular inverse
int modInverse(int a, int m) {
  int m0 = m, x0 = 0, x1 = 1;

  if (m == 1) return 0;

  while (a > 1) {
    int q = a ~/ m;
    int t = m;

    m = a % m;
    a = t;
    t = x0;

    x0 = x1 - q * x0;
    x1 = t;
  }

  if (x1 < 0) x1 += m0;

  return x1;
}

class Robot {
  final int sx, sy, vx, vy;
  int x, y;

  Robot(this.sx, this.sy, this.vx, this.vy) : x = sx, y = sy;

  factory Robot.fromInput(String input) {
    final p = RegExp(r"(-?\d+)").allMatches(input).map((m) => int.parse(m.group(0)!)).toList();
    return Robot(p[0], p[1], p[2], p[3]);
  }

  void updatePosition(int t, int width, int height) {
    x = (sx + t * vx) % width;
    y = (sy + t * vy) % height;

    if (x < 0) x += width;
    if (y < 0) y += height;
  }
}

class Point {
  final int x, y;

  Point(this.x, this.y);
}
