const input: string = `...#..#.
..##.##.
..#.....
....#...
#.##...#
####..##
...##.#.
#.#.#...`;

// Javascript is so darn stupid and doesn't work with different set key types (ie tuples)
function indexKey(a: number, b: number, c: number, d: number): string {
    return `${a} ${b} ${c} ${d}`;
}

function countNeighbours(grid: Set<string>, idx: number[], dimensions: Dimensions): number {
    let count = 0
    for (let dx = -1; dx <= 1; dx++) {
        for (let dy = -1; dy <= 1; dy++) {
            for (let dz = -1; dz <= 1; dz++) {
                let dmin = 0, dmax = 0;
                if (dimensions === Dimensions.Four) {
                    dmin = -1, dmax = 1;
                }
                for (let di = dmin; di <= dmax; di++) {
                    if (!dx && !dy && !dz && !di) {
                        // Current idx
                        continue;
                    }
                    if (grid.has(indexKey(idx[0] + dx, idx[1] + dy, idx[2] + dz, idx[3] + di)) == true) {
                        count += 1;
                    }
                }
            }
        }
    }
    return count;
}

const transition = (old: Set<string>, dimensions: number): Set<string> => {
    const newState: Set<string> = new Set();

    let min_maxes: number[][] = [
        [Number.MAX_VALUE, Number.MIN_VALUE],
        [Number.MAX_VALUE, Number.MIN_VALUE],
        [Number.MAX_VALUE, Number.MIN_VALUE],
        [Number.MAX_VALUE, Number.MIN_VALUE],
    ];
    old.forEach(keys => {
        let indices = keys.split(' ').map(Number);
        for (let j = 0; j < indices.length; j++) {
            if (min_maxes[j][0] > indices[j]) {
                min_maxes[j][0] = indices[j];
            }
            if (min_maxes[j][1] < indices[j]) {
                min_maxes[j][1] = indices[j];
            }
        }
    })

    for (let x = min_maxes[0][0] - 1; x <= min_maxes[0][1] + 1; x++) {
        for (let y = min_maxes[1][0] - 1; y <= min_maxes[1][1] + 1; y++) {
            for (let z = min_maxes[2][0] - 1; z <= min_maxes[2][1] + 1; z++) {
                for (let i = min_maxes[3][0] - 1; i <= min_maxes[3][1] + 1; i++) {
                    let set = old.has(indexKey(x, y, z, i));
                    let neighbours = countNeighbours(old, [x, y, z, i], dimensions);
                    if ((set && neighbours >= 2 && neighbours <= 3) || (!set && neighbours == 3)) {
                        newState.add(indexKey(x, y, z, i));
                    }
                }
            }
        }
    }

    return newState;
}

enum Dimensions {
    Three = 3,
    Four = 4,
}

interface ITransition {
    (old: Set<string>): Set<string>;
}
const part1: ITransition = (old) => {
    return transition(old, Dimensions.Three);
}

const part2: ITransition = (old) => {
    return transition(old, Dimensions.Four);
}


const runCycles = (tx: ITransition): number => {
    // Parsing could be done only once, idc it's small input and I don't trust JS cloning
    const lines: String[] = input.split("\n");

    let values: Set<string> = new Set();
    // const values: boolean[][][][] = [[lines.map(l => l.split("").map(s => s === '#'))]];
    for (let i = 0; i < lines.length; i++) {
        for (let j = 0; j < lines[i].length; j++) {
            if (lines[i][j] == "#") {
                values.add(indexKey(i, j, 0, 0));
            }
        }
    }

    for (let i = 0; i < 6; i++) {
        values = tx(values);
    }

    return values.size;
}

console.log("P1: ", runCycles(part1));
console.log("P2: ", runCycles(part2));
