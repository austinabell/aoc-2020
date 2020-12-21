using System;
using System.IO;
using System.Collections.Generic;
using System.Text;
using System.Linq;

namespace Day20
{
    class Day20Part1 {
        class Tile {
            public long id;
            public List<int> edges;
            public bool[,] data;

            public Tile(string tile) {
                string[] lines = tile.Split('\n');
                this.id = long.Parse(lines[0].Split(' ')[1].Replace(":", string.Empty));
                int width = 10;

                this.data = new bool[width, width];
                for (int i = 0; i < width; i++) {
                    string line = lines[i+1];
                    for (int j = 0; j < width; j++) {
                        this.data[i, j] = line[j] == '#';
                    }
                }

                this.edges = new List<int>();
                bool[] edge = new bool[width];
                for (int i = 0; i < width; i++) {
                    edge[i] = data[i, 0];
                }
                this.edges.AddRange(ValsToIntegers(edge));
                for (int i = 0; i < width; i++) {
                    edge[i] = data[i, width-1];
                }
                this.edges.AddRange(ValsToIntegers(edge));
                for (int i = 0; i < width; i++) {
                    edge[i] = data[0, i];
                }
                this.edges.AddRange(ValsToIntegers(edge));
                for (int i = 0; i < width; i++) {
                    edge[i] = data[width-1, i];
                }
                this.edges.AddRange(ValsToIntegers(edge));
            }

            private List<int> ValsToIntegers(bool[] vals) {
                StringBuilder sb = new StringBuilder();
                foreach (bool val in vals) {
                    if (val) {
                        sb.Append("1");
                    } else {
                        sb.Append("0");
                    }
                }
                string s = sb.ToString();

                char[] sArr = s.ToCharArray();
                Array.Reverse(sArr);

                return new List<int> {int.Parse(s), int.Parse(new string(sArr))};
            }
        }

        static void Main(string[] args)
        {
            string fileName = "input.txt";
            
            string contents = File.ReadAllText(fileName);
            string[] chunks = contents.Split("\n\n");

            List<Tile> tiles = new List<Tile>();
            foreach (string chunk in chunks) {
                tiles.Add(new Tile(chunk));
            }

            Dictionary<int, int> counts = new Dictionary<int, int>();
            foreach (Tile t in tiles) {
                foreach (int i in t.edges) {
                    int currentCount;
                    counts.TryGetValue(i, out currentCount); 
                    counts[i] = currentCount + 1;
                }
            }

            long answer = 1;
            foreach (Tile t in tiles) {
                int count = 0;
                foreach (int i in t.edges) {
                    int v;
                    counts.TryGetValue(i, out v); 
                    if (v == 1) {
                        count ++;
                    }
                }
                if (count > 2) {
                    answer *= t.id;
                }
            }

            Console.WriteLine(answer);
        }
    }
}