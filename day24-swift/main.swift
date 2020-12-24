import Foundation

let contents = try! String(contentsOfFile: "input.txt")
let lines = contents.components(separatedBy: CharacterSet.newlines).filter { !$0.isEmpty }
var s = Set<Coordinate>()

func visit(_ coords: inout Set<Coordinate>, _ coordinate: Coordinate) {
    if coords.contains(coordinate) {
        coords.remove(coordinate)
    } else {
        coords.insert(coordinate)
    }
}

var directions = [
    "se": Coordinate(0, -1, 1),
    "sw": Coordinate(-1, 0, 1),
    "nw": Coordinate(0, 1, -1),
    "ne": Coordinate(1, 0, -1),
    "e": Coordinate(1, -1, 0),
    "w": Coordinate(-1, 1, 0),
]

struct Coordinate: Hashable {
    var x: Int
    var y: Int
    var z: Int

    init(_ x: Int, _ y: Int, _ z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }

    static func += (lhs: inout Self, rhs: Self) {
        lhs.x += rhs.x
        lhs.y += rhs.y
        lhs.z += rhs.z
    }

    static func + (lhs: Self, rhs: Self) -> Self {
        var new = lhs
        new.x += rhs.x
        new.y += rhs.y
        new.z += rhs.z
        return new
    }
}

// Part 1:
for line in lines {
    var i = 0
    var pos = Coordinate(0, 0, 0)
    while i < line.count {
        if let coord = directions[String(line[line.index(line.startIndex, offsetBy: i)])] {
            pos += coord
            i += 1
        } else {
            let si = line.index(line.startIndex, offsetBy: i)
            let ei = line.index(line.startIndex, offsetBy: i + 2)
            let coord = directions[String(line[si ..< ei])]!
            pos += coord
            i += 2
        }
    }
    visit(&s, pos)
}

print(s.count)

// Part 2:
for _ in 0 ..< 100 {
    var newSet = Set<Coordinate>()

    let visitCoord = { (coord: Coordinate) in
        var count = 0
        for (_, vector) in directions {
            if s.contains(coord + vector) {
                count += 1
            }
        }
        let contains = s.contains(coord)
        if contains, count == 1 || count == 2 {
            newSet.insert(coord)
        }
        if !contains, count == 2 {
            newSet.insert(coord)
        }
    }

    for coord in s {
        visitCoord(coord)
        for (_, vector) in directions {
            visitCoord(coord + vector)
        }
    }

    s = newSet
}

print(s.count)
