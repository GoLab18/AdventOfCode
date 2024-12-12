import 'dart:io';

Future<void> main(List<String> args) async {
  final filepath = args.isNotEmpty ? args[0] : "test.txt";
  
  List<int> seq = await readFile(filepath);

  // Part 1
  print("Stones count -> ${stonesNum(seq)}");
}

Future<List<int>> readFile(String filepath) async {
  File file = File(filepath);

  if (!await file.exists()) throw StateError("[ERROR] file does not exist");

  var str = await file.readAsString();

  List<int> seq = str.split(' ').map(int.parse).toList();

  return seq;
}

int stonesNum(List<int> seq) {
  for (var i = 0; i < 25; i++) seq = blink(seq);
  return seq.length;
}

List<int> blink(List<int> seq) {
  List<int> newSeq = [];

  for (int stone in seq) {
    if (stone == 0) newSeq.add(1);
    else if (stone.toString().length % 2 == 0) {
      String stoneStr = stone.toString();
      int mid = stoneStr.length ~/ 2;

      int left = int.parse(stoneStr.substring(0, mid));
      int right = int.parse(stoneStr.substring(mid));

      newSeq.add(left);
      newSeq.add(right);
    } else newSeq.add(stone * 2024);
  }

  return newSeq;
}