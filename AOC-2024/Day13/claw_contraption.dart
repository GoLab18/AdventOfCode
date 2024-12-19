import 'dart:io';
import 'dart:math';

Future<void> main(List<String> args) async {
  final filepath = args.isNotEmpty ? args[0] : "test.txt";
  List<ClawMachine> clawMachs = await readFile(filepath);
  
  int r = minimumTokensToWin(clawMachs);

  // Part 1
  print("Minimum tokens required -> $r");
}

Future<List<ClawMachine>> readFile(String filepath) async {
  final file = File(filepath);
  if (!await file.exists()) throw StateError("[ERROR] file does not exist");
  final lines = await file.readAsLines();

  var cm = <ClawMachine>[];
  for (int i = 0; i < lines.length; i += 4) {
    String lineA = lines[i];
    String lineB = lines[i+1];
    String linePrize = lines[i+2];

    final (ax, ay) = extractVals(lineA);
    final (bx, by) = extractVals(lineB);
    final (px, py) = extractVals(linePrize);
    
    cm.add(ClawMachine(ax, ay, bx, by, px, py));
  }

  return cm;
}

(int, int) extractVals(String line) {
  int ix = line.indexOf('X');
  int iy = line.indexOf('Y', ix);

  int x = int.parse(line.substring(ix + 2, line.indexOf(',', ix)));
  int y = int.parse(line.substring(iy+2, line.length));

  return (x, y);
}

class ClawMachine {
  final int ax, ay, bx, by, px, py;

  ClawMachine(this.ax, this.ay, this.bx, this.by, this.px, this.py);
}

bool isSolvable(int ax, int bx, int px) => px % gcd(ax, bx) == 0;

// Euclid's algo
int gcd(int a, int b) => b == 0 ? a : gcd(b, a % b);

int minimumTokensToWin(List<ClawMachine> machines) {
  int maxPresses = 100;
  int totalTokens = 0;

  for (var mch in machines) {
    int ax = mch.ax, ay = mch.ay, bx = mch.bx, by = mch.by;
    int px = mch.px, py = mch.py;

    if (!isSolvable(ax, bx, px) || !isSolvable(ay, by, py)) continue;

    int? minCost;
    for (int a = 0; a <= maxPresses; a++) {
      for (int b = 0; b <= maxPresses; b++) {
        if (a * ax + b * bx == px && a * ay + b * by == py) {
          int cost = 3 * a + 1 * b;

          minCost ??= cost;
          minCost = min(minCost, cost);
        }
      }
    }

    if (minCost != null) totalTokens += minCost;
  }

  return totalTokens;
}
