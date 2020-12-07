import strutils, re, tables, hashes, sets

proc part1(col: string, containedIn: Table[string, HashSet[string]]): int = 
  var hasGold = initHashSet[string]()
  proc checkIncludes(colour: string) =
    for c in containedIn.getOrDefault(colour):
      hasGold.incl(c)
      checkIncludes(c)

  checkIncludes(col)
  len(hasGold)

proc part2(col: string, contains: Table[string, seq[(int, string)]]): int =
  proc subTotal(colour: string): int =
    var t = 0
    for (num, c) in contains.getOrDefault(colour):
      let subT = subTotal(c)
      t += subT * num
      t += num
    t
  subTotal(col)

var containedIn = initTable[string, HashSet[string]]()
var contains = initTable[string, seq[(int, string)]]()
for line in lines "input.txt":
  var cd, cn: string
  (cd, cn) = split(findAll(line, re"(.+?) bags contain")[0], ' ')
  let colour = cd & ' ' & cn

  for inner in findAll(line, re"(\d+) (.+?) bags?[,.]"):
    var count, icd, icn: string
    (count, icd, icn) = split(inner, ' ')
    let innerColour = icd & ' ' & icn

    # Insert each colour into contained set
    containedIn.mgetOrPut(innerColour, initHashSet[string]()).incl(colour)

    # Also insert the colours and the number of bags this one contains
    contains.mgetOrPut(colour, newSeq[(int, string)]()).add((parseInt(count), innerColour))

echo "PART 1: " & $part1("shiny gold", containedIn)

echo "PART 2: " & $part2("shiny gold", contains)
