using System;
using System.IO;

class Program {
    static bool inBounds(int r, int c, char[][] garden) {
        return 0 <= r && r < garden.Length && 0 <= c && c < garden[0].Length;
    }

    static int area = 0;
    static int perimeter = 0;
    static void getCost(int r, int c, char plant, char[][] garden, bool[][] visited) {
        if (!inBounds(r, c, garden) || visited[r][c] || garden[r][c] != plant) {
            return;
        }
        visited[r][c] = true;
        area++;

        int[][] directions = {
            new int[] {-1, 0},
            new int[] {0, 1},
            new int[] {1, 0},
            new int[] {0, -1}
        };
        foreach (int[] direction in directions) {
            int newR = r + direction[0], newC = c + direction[1];
            if (!inBounds(newR, newC, garden) || garden[newR][newC] != plant) {
                perimeter++;
            }
            getCost(newR, newC, plant, garden, visited);
        }
    }

    static Dictionary<string, List<int>> rSides = new Dictionary<string, List<int>>();
    static Dictionary<string, List<int>> cSides = new Dictionary<string, List<int>>();
    static void getCostTwo(int r, int c, char plant, char[][] garden, bool[][] visited) {
        if (!inBounds(r, c, garden) || visited[r][c] || garden[r][c] != plant) {
            return;
        }
        visited[r][c] = true;
        area++;

        int[][] directions = {
            new int[] {-1, 0},
            new int[] {0, 1},
            new int[] {1, 0},
            new int[] {0, -1}
        };
        foreach (int[] direction in directions) {
            int newR = r + direction[0], newC = c + direction[1];
            if (!inBounds(newR, newC, garden) || garden[newR][newC] != plant) {
                if (direction[0] != 0) {
                    string key = r + "," + direction[0];
                    if (!rSides.ContainsKey(key)) {
                        rSides[key] = new List<int>();
                    }
                    rSides[key].Add(newC);
                } else {
                    string key = c + "," + direction[1];
                    if (!cSides.ContainsKey(key)) {
                        cSides[key] = new List<int>();
                    }
                    cSides[key].Add(newR);
                }
                perimeter++;
            }
            getCostTwo(newR, newC, plant, garden, visited);
        }
    }

    static int determineSides(Dictionary<string, List<int>> potentialsides) {
        int sides = 0;

        foreach (var pair in potentialsides) {
            List<int> inds = pair.Value;
            inds.Sort();

            int disparities = 0;
            for (int i = 1; i < inds.Count; i++) {
                if (inds[i - 1] + 1 != inds[i]) {
                    disparities++;
                }
            }
            sides += disparities + 1;
        }

        return sides;
    }

    static int solve(char[][] garden, bool partOne) {
        int totalCost = 0;
        bool[][] visited = new bool[garden.Length][];
        for (int i = 0; i < garden.Length; i++) {
            visited[i] = new bool[garden[i].Length];
        }

        for (int r = 0; r < garden.Length; r++) {
            for (int c = 0; c < garden[r].Length; c++) {
                if (visited[r][c]) {
                    continue;
                }

                area = 0;

                if (partOne) {
                    perimeter = 0;

                    getCost(r, c, garden[r][c], garden, visited);             
                    totalCost += area * perimeter;
                } else {
                    rSides.Clear();
                    cSides.Clear();

                    getCostTwo(r, c, garden[r][c], garden, visited); 

                    int sides = 0;
                    sides += determineSides(rSides);
                    sides += determineSides(cSides);

                    totalCost += area * sides;
                }
            }
        }

        return totalCost;
    }

    static void Main(string[] args) {
        string filePath = "../inputs/day_12.txt";
        
        char[][] garden = null;
        try {
            string[] lines = File.ReadAllLines(filePath);
            garden = new char[lines.Length][];
            for (int i = 0; i < lines.Length; i++) {
                garden[i] = lines[i].ToCharArray();
            }
        } catch {
            Console.WriteLine("Error reading file.");
        }

        Console.WriteLine(solve(garden, true));
        Console.WriteLine(solve(garden, false));
    }
}