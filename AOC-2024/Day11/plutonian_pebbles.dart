import 'dart:io';
import 'dart:math';

void main(List<String> args) async {
  final filepath = args.isNotEmpty ? args[0] : "test.txt";

  List<int> seq = await readFile(filepath);

  int Function(int) stonesCount = (blinks) {
    return seq
    .map((v) => blink(v, 0, blinks, {}))
    .reduce((a, b) => a + b);
  };

  // Part 1
  print("Stones count -> ${stonesCount(25)}");

  // Part 2
  print("Stones count -> ${stonesCount(75)}");
}

Future<List<int>> readFile(String filepath) async {
  final file = File(filepath);

  if (!await file.exists()) throw StateError("[ERROR] file does not exist");

  final lines = await file.readAsLines();

  var seq = <int>[];
  lines.forEach((line) {
    seq.addAll(line.split(' ').map(int.parse).toList());
  });

  return seq;
}

int blink(int stoneNum, int blinks, int end, Map<String, int> cache) {
  if (blinks >= end) return 1;

  String key = '$stoneNum,$blinks';

  if (cache.containsKey(key)) return cache[key]!;

  int result;
  if (stoneNum == 0) result = blink(1, blinks + 1, end, cache);

  else if (stoneNum.toString().length.isEven) {
    var split = splitEven(stoneNum);
    result = blink(split[0], blinks + 1, end, cache) + blink(split[1], blinks + 1, end, cache);
  }

  else result = blink(stoneNum * 2024, blinks + 1, end, cache);

  cache[key] = result;

  return result;
}

List<int> splitEven(int num) {
  int right = num.toString().length ~/ 2;
  int div = pow(10, right).toInt();

  int l = num ~/ div;
  int r = num % div;

  return [l, r];
}
