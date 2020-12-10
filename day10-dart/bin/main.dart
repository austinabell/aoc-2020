import 'dart:io';
import 'dart:collection';

int partOne(List<int> lines) {
  List jumps = [0, 0, 1];
  for (int i = 1; i < lines.length; i++) {
    int l = lines[i];
    jumps[l - lines[i - 1] - 1]++;
  }
  return jumps[0] * jumps[2];
}

int partTwo(List<int> lines, HashMap<int, int> memo) {
  int total = 0;
  if (lines.length == 1) {
    return 1;
  }

  for (int i = 1; i <= 3; i++) {
    if (lines.length >= i + 1 && lines[i] - lines[0] <= 3) {
      if (memo.containsKey(lines[i])) {
        total += memo[lines[i]];
      } else {
        int val = partTwo(lines.sublist(i), memo);
        memo.putIfAbsent(lines[i], () => val);
        total += val;
      }
    }
  }
  return total;
}

void main(List<String> arguments) {
  File file = new File('input.txt');

  List<String> slines = file.readAsLinesSync();
  List<int> lines = slines.map(int.parse).toList();
  lines.insert(0, 0);
  lines.sort();

  print(partOne(lines));
  HashMap<int, int> memo = HashMap();
  print(partTwo(lines, memo));
}
