using System;
using System.IO;
using System.Numerics;

class Program {
    static void move(int[] position, int[] velocity, int width, int height) {
        position[0] = (position[0] + velocity[0] + width) % width;
        position[1] = (position[1] + velocity[1] + height) % height;
    }

    static bool inQuad(int[] position, int[][] quadBounds) {
        return quadBounds[0][0] <= position[0] && position[0] <= quadBounds[0][1] &&
               quadBounds[1][0] <= position[1] && position[1] <= quadBounds[1][1];
    }

    static int countGuards(List<int[]> positions, int width, int height) {
        int midX = width / 2;
        int midY = height / 2;
        int[][][] quads = {
            new int[][] {
                new int[] {0, midX - 1},
                new int[] {0, midY - 1}
            },
            new int[][] {
                new int[] {midX + 1, width - 1},
                new int[] {0, midY - 1}
            },
            new int[][] {
                new int[] {0, midX - 1},
                new int[] {midY + 1, height - 1}
            },
            new int[][] {
                new int[] {midX + 1, width - 1},
                new int[] {midY + 1, height - 1}
            }
        };

        int[] counts = {0, 0, 0, 0};
        for (int i = 0; i < positions.Count; i++) {
            for (int j = 0; j < quads.Length; j++) {
                if (inQuad(positions[i], quads[j])) {
                    counts[j]++;
                }
            }
        }

        return counts[0] * counts[1] * counts[2] * counts[3];
    }

    static bool countCircle(int t, int x, int y, List<int[]> positions, int width, int height) {
        int radius = 10;
        int count = 0;

        for (int i = 0; i < positions.Count; i++) {
            int dx = positions[i][0] - x, dy = positions[i][1] - y;
            int distSq = dx * dx + dy * dy;

            if (distSq < radius * radius) {
                count++;
            }
        }

        double area = (Math.PI * radius * radius);
        if (count / area > 0.25) {
            bool[][] visited = new bool[height][];
            for (int i = 0; i < height; i++) {
                visited[i] = new bool[width];
            }
            for (int i = 0; i < positions.Count; i++) {
                visited[positions[i][1]][positions[i][0]] = true;
            }

            Console.WriteLine("t = " + (t + 1));
            for (int r = 0; r < visited.Length; r++) {
                for (int c = 0; c < visited[r].Length; c++) {
                    Console.Write(visited[r][c] ? '#' : '.');
                }
                Console.WriteLine();
            }
            Console.WriteLine();

            return true;
        }

        return false;
    }

    static int solve(List<int[]> positions, List<int[]> velocities, bool partTwo) {
        int width = 101, height = 103;

        int upperLimit = partTwo ? 1_000_000 : 100;
        for (int t = 0; t < upperLimit; t++) {
            for (int i = 0; i < positions.Count; i++) {
                move(positions[i], velocities[i], width, height);
            }

            if (partTwo) {
                bool printed = false;
                for (int i = 0; i < positions.Count; i++) {
                    printed = countCircle(t, positions[i][0], positions[i][1], positions, width, height);
                    if (printed) {
                        break;
                    }
                }
                if (printed) {
                    break;
                }
            }
        }

        return countGuards(positions, width, height);
    }

    static void Main(string[] args) {
        string filePath = "../inputs/day_14.txt";

        string[] lines = null;
        try {
            lines = File.ReadAllLines(filePath);
        } catch {
            Console.WriteLine("Error reading file.");
        }

        List<int[]> positions = new List<int[]>();
        List<int[]> velocities = new List<int[]>();

        for (int i = 0; i < lines.Length; i++) {
            int commaInd = lines[i].IndexOf(','), spaceInd = lines[i].IndexOf(' ');
            string x = lines[i].Substring(2, commaInd - 2);
            string y = lines[i].Substring(commaInd + 1, spaceInd - (commaInd + 1));
            positions.Add(new int[] {
                Convert.ToInt32(x),
                Convert.ToInt32(y)
            });

            commaInd = lines[i].LastIndexOf(',');
            x = lines[i].Substring(spaceInd + 3, commaInd - (spaceInd + 3));
            y = lines[i].Substring(commaInd + 1);
            velocities.Add(new int[] {
                Convert.ToInt32(x),
                Convert.ToInt32(y)
            });
        }
        List<int[]> positionsCopy = positions.Select(arr => (int[])arr.Clone()).ToList();

        Console.WriteLine(solve(positions, velocities, false));
        solve(positionsCopy, velocities, true);
    }
}