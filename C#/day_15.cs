using System;
using System.IO;
using System.Numerics;

class Program {
    static void swap(int r1, int c1, int r2, int c2, char[][] map) {
        char temp = map[r1][c1];
        map[r1][c1] = map[r2][c2];
        map[r2][c2] = temp;
    }

    static int[] move(int currR, int currC, char direc, char[][] map) {
        Dictionary<char, int[]> directions = new Dictionary<char, int[]>
        {
            ['^'] = new int[] {-1, 0},
            ['>'] = new int[] {0, 1},
            ['v'] = new int[] {1, 0},
            ['<'] = new int[] {0, -1}
        };
        int[] direction = directions[direc];
        
        if (direction[0] != 0) {
            int newR = currR + direction[0];

            if (map[newR][currC] == '.') {
                swap(currR, currC, newR, currC, map);
                return new int[] {newR, currC};
            }

            for (int r = newR; 0 <= r && r < map.Length; r += direction[0]) {
                if (map[r][currC] == '.') {
                    swap(newR, currC, r, currC, map);
                    swap(currR, currC, newR, currC, map);
                    return new int[] {newR, currC};
                }

                if (map[r][currC] == '#') {
                    return new int[] {currR, currC};
                }
            }

            return new int[] {currR, currC};
        } else {
            int newC = currC + direction[1];

            if (map[currR][newC] == '.') {
                swap(currR, currC, currR, newC, map);
                return new int[] {currR, newC};
            }

            for (int c = newC; 0 <= c && c < map[currR].Length; c += direction[1]) {
                //Console.WriteLine(currR + " " + c);
                if (map[currR][c] == '.') {
                    //Console.WriteLine(currR + " " + c);
                    swap(currR, newC, currR, c, map);
                    swap(currR, currC, currR, newC, map);
                    return new int[] {currR, newC};
                }

                if (map[currR][c] == '#') {
                    return new int[] {currR, currC};
                }
            }

            return new int[] {currR, currC};
        }
    }

    static bool invalidMove(int r, int c, int[] direc, char[][] map, ref bool[][] visited) {
        if (visited[r][c]) {
            return false;
        }

        if (map[r][c] == '[') {
            visited[r][c] = true;
            visited[r][c + 1] = true;
            return invalidMove(r + direc[0], c + direc[1], direc, map, ref visited) ||
                   invalidMove(r + direc[0], c + 1 + direc[1], direc, map, ref visited);
        }

        if (map[r][c] == ']') {
            visited[r][c] = true;
            visited[r][c - 1] = true;
            return invalidMove(r + direc[0], c + direc[1], direc, map, ref visited) ||
                   invalidMove(r + direc[0], c - 1 + direc[1], direc, map, ref visited);
        }

        if (map[r][c] == '#') {
            return true;
        }

        return false;
    }

    static int[] moveTwo(int currR, int currC, char direc, ref char[][] map) {
        Dictionary<char, int[]> directions = new Dictionary<char, int[]>
        {
            ['^'] = new int[] {-1, 0},
            ['>'] = new int[] {0, 1},
            ['v'] = new int[] {1, 0},
            ['<'] = new int[] {0, -1}
        };
        int[] direction = directions[direc];

        bool[][] visited = new bool[map.Length][];
        for (int i = 0; i < map.Length; i++) {
            visited[i] = new bool[map[i].Length];
        }

        bool invalid = invalidMove(currR + direction[0], currC + direction[1], direction, map, ref visited);
        if (invalid) {
            return new int[] {currR, currC};
        }

        char[][] newMap = new char[map.Length][];
        for (int i = 0; i < map.Length; i++) {
            newMap[i] = new string('.', map[i].Length).ToCharArray();
        }
        for (int r = 0; r < visited.Length; r++) {
            for (int c = 0; c < visited[r].Length; c++) {
                if (visited[r][c]) {
                    newMap[r + direction[0]][c + direction[1]] = map[r][c];
                } else {
                    if (map[r][c] == '[' || map[r][c] == ']' || map[r][c] == '#') {
                        newMap[r][c] = map[r][c];
                    }
                }
            }
        }

        newMap[currR + direction[0]][currC + direction[1]] = '@';
        map = newMap;
        return new int[] {currR + direction[0], currC + direction[1]};
    }

    static int solve(int currR, int currC, char[][] map, char[] moves, bool partTwo) {
        if (partTwo) {
            int[] newPos = doubleMap(ref map);
            currR = newPos[0];
            currC = newPos[1];
        }

        for (int i = 0; i < moves.Length; i++) {
            int[] newPos = null;
            if (partTwo) {
                newPos = moveTwo(currR, currC, moves[i], ref map);
            } else {
                newPos = move(currR, currC, moves[i], map);
            }
            currR = newPos[0];
            currC = newPos[1];
        }
        
        char obstacle = partTwo ? '[' : 'O';
        int total = 0;
        for (int r = 0; r < map.Length; r++) {
            for (int c = 0; c < map[r].Length; c++) {
                if (map[r][c] == obstacle) {
                    total += r * 100 + c;
                }
            }
        }

        return total;
    }

    static int[] doubleMap(ref char[][] map) {
        char[][] newMap = new char[map.Length][];
        int[] newPos = new int[2];

        for (int r = 0; r < map.Length; r++) {
            newMap[r] = new char[map[r].Length * 2];
            for (int c0 = 0, c = 0; c0 < map[r].Length; c0++, c += 2) {
                //Console.WriteLine(map[r][c0]);
                switch (map[r][c0]) {
                    case '.':
                        newMap[r][c] = '.';
                        newMap[r][c+1] = '.';
                        break;
                    case '#':
                        newMap[r][c] = '#';
                        newMap[r][c+1] = '#';
                        break;
                    case 'O':
                        newMap[r][c] = '[';
                        newMap[r][c+1] = ']';
                        break;
                    case '@':
                        newMap[r][c] = '@';
                        newMap[r][c+1] = '.';
                        newPos = new int[] {r, c};
                        break;
                }
            }
        }
        
        map = newMap;
        return newPos;
    }

    static void Main(string[] args) {
        string filePath = "../inputs/day_15_a.txt";
        string[] lines = null;
        try {
            lines = File.ReadAllLines(filePath);
        } catch {
            Console.WriteLine("Error reading file.");
        }

        char[][] map = new char[lines.Length][];
        int r = -1, c = -1;
        for (int i = 0; i < lines.Length; i++) {
            map[i] = lines[i].ToCharArray();
            
            if (r == -1 && c == -1) {
                int robotInd = lines[i].IndexOf('@');
                if (robotInd != -1) {
                    r = i;
                    c = robotInd;
                }
            }
        }

        filePath = "../inputs/day_15_b.txt";
        string text = null;
        try {
            text = File.ReadAllText(filePath);
        } catch {
            Console.WriteLine("Error reading file.");
        }
        char[] moves = text.Replace("\n", "").ToCharArray();

        char[][] mapCopy = map.Select(row => (char[])row.Clone()).ToArray();
        Console.WriteLine(solve(r, c, map, moves, false));
        Console.WriteLine(solve(r, c, mapCopy, moves, true));
    }
}