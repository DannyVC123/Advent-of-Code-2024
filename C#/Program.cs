using System;
using System.IO;
using System.Numerics;

class Program {
    static bool inBounds(int r, int c, char[][] garden) {
        return 0 <= r && r < garden.Length && 0 <= c && c < garden[0].Length;
    }

    static int winPrize(long x, long y, int numTokens, HashSet<string> visited, long[] buttonA, long[] buttonB, long[] prize) {
        string key = x + "," + y;
        if (visited.Contains(key) || x > prize[0] || y > prize[1]) {
            return Int32.MaxValue;
        }

        visited.Add(key);
        if (x == prize[0] && y == prize[1]) {
            visited.Remove(key);
            return numTokens;
        }
        
        int pressA = winPrize(x + buttonA[0], y + buttonA[1], numTokens + 3, visited, buttonA, buttonB, prize);
        int pressB = winPrize(x + buttonB[0], y + buttonB[1], numTokens + 1, visited, buttonA, buttonB, prize);

        //visited.Remove(key);
        return Math.Min(pressA, pressB);
    }

    static bool valid(long numA, long numB, long[] buttonA, long[] buttonB, long[] prize) {
        bool eq1 = numA * buttonA[0] + numB * buttonB[0] == prize[0];
        bool eq2 = numA * buttonA[1] + numB * buttonB[1] == prize[1];
        return eq1 && eq2;
    }

    static long systemOfEquations(long[] buttonA, long[] buttonB, long[] prize) {
        double[][] A = {
            new double[] {(double) buttonA[0], (double) buttonB[0]},
            new double[] {(double) buttonA[1], (double) buttonB[1]}
        };

        double factor = 1.0 / (double) (A[0][0] * A[1][1] - A[0][1] * A[1][0]);
        double[][] AInv = {
            new double[] {factor *  A[1][1], factor * -A[0][1]},
            new double[] {factor * -A[1][0], factor *  A[0][0]}
        };

        double[] b = new double[] {(double) prize[0], (double) prize[1]};

        double numA = AInv[0][0] * b[0] + AInv[0][1] * b[1];
        double numB = AInv[1][0] * b[0] + AInv[1][1] * b[1];

        if (!valid((long) Math.Round(numA), (long) Math.Round(numB), buttonA, buttonB, prize)) {
            return -1;
        }
        return (long) (Math.Round(numA) * 3 + Math.Round(numB));
    }

    static long solve(List<long[]> buttonA, List<long[]> buttonB, List<long[]> prizes, bool partTwo) {
        if (partTwo) {
            for (int i = 0; i < prizes.Count; i++) {
                prizes[i][0] += 10000000000000;
                prizes[i][1] += 10000000000000;
            }
        }

        long numTokens = 0;
        for (int i = 0; i < prizes.Count; i++) {
            HashSet<string> visited = new HashSet<string>();

            /*
            int minTokens = winPrize(0, 0, 0, visited, buttonA[i], buttonB[i], prizes[i]);
            if (minTokens < Int32.MaxValue) {
                numTokens += minTokens;
            }
            */

            long tokens = systemOfEquations(buttonA[i], buttonB[i], prizes[i]);
            if (tokens != -1) {
                numTokens += tokens;
            }
        }
        return numTokens;
    }

    static void Main(string[] args) {
        string filePath = "../inputs/day_13.txt";

        string[] lines = null;
        try {
            lines = File.ReadAllLines(filePath);
        } catch {
            Console.WriteLine("Error reading file.");
        }

        List<long[]> buttonA = new List<long[]>();
        List<long[]> buttonB = new List<long[]>();
        List<long[]> prizes = new List<long[]>();

        for (int i = 0; i < lines.Length; i += 4) {
            int commaInd = lines[i].IndexOf(',');
            string x = lines[i].Substring(12, commaInd - 12);
            string y = lines[i].Substring(commaInd + 4);
            buttonA.Add(new long[] {
                Convert.ToInt64(x),
                Convert.ToInt64(y)
            });

            commaInd = lines[i + 1].IndexOf(',');
            x = lines[i + 1].Substring(12, commaInd - 12);
            y = lines[i + 1].Substring(commaInd + 4);
            buttonB.Add(new long[] {
                Convert.ToInt64(x),
                Convert.ToInt64(y)
            });

            commaInd = lines[i + 2].IndexOf(',');
            x = lines[i + 2].Substring(9, commaInd - 9);
            y = lines[i + 2].Substring(commaInd + 4);
            prizes.Add(new long[] {
                Convert.ToInt64(x),
                Convert.ToInt64(y)
            });
        }

        Console.WriteLine(solve(buttonA, buttonB, prizes, false));
        Console.WriteLine(solve(buttonA, buttonB, prizes, true));
    }
}