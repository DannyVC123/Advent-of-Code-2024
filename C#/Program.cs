using System;
using System.IO;

class Program {
    static long[] splitNum(long num) {
        string str = num.ToString();
        if (str.Length % 2 == 0) {
            return new long[] {
                Convert.ToInt64(str.Substring(0, str.Length / 2)),
                Convert.ToInt64(str.Substring(str.Length / 2))
            };
        } else {
            return null;
        }
    }

    static int bruteForce(List<long> nums, int numBilnks) {
        for (int blinks = 0; blinks < numBilnks; blinks++) {
            int size = nums.Count;
            for (int i = 0; i < size; i++) {
                if (nums[i] < 0) {
                    Console.WriteLine("error");
                    break;
                }

                if (nums[i] == 0) {
                    nums[i] = 1;
                    continue;
                }

                long[] halves = splitNum(nums[i]);
                if (halves != null) {
                    nums[i] = halves[0];
                    nums.Add(halves[1]);
                    continue;
                }

                nums[i] *= 2024;
            }
        }

        return nums.Count;
    }

    static long optimized(List<long> nums, int numBilnks) {
        Dictionary<long, long> freq = new Dictionary<long, long>();
        foreach (long num in nums) {
            if (freq.ContainsKey(num)) {
                freq[num]++;
            } else {
                freq[num] = 1;
            }
        }

        for (int blinks = 0; blinks < numBilnks; blinks++) {
            Dictionary<long, long> newFreq = new Dictionary<long, long>();

            foreach(var pair in freq) {
                if (pair.Key == 0) {
                    if (newFreq.ContainsKey(1)) {
                        newFreq[1] += pair.Value;
                    } else {
                        newFreq[1] = pair.Value;
                    }
                    continue;
                }

                long[] halves = splitNum(pair.Key);
                if (halves != null) {
                    if (newFreq.ContainsKey(halves[0])) {
                        newFreq[halves[0]] += pair.Value;
                    } else {
                        newFreq[halves[0]] = pair.Value;
                    }

                    if (newFreq.ContainsKey(halves[1])) {
                        newFreq[halves[1]] += pair.Value;
                    } else {
                        newFreq[halves[1]] = pair.Value;
                    }

                    continue;
                }

                if (newFreq.ContainsKey(pair.Key * 2024)) {
                    newFreq[pair.Key * 2024] += pair.Value;
                } else {
                    newFreq[pair.Key * 2024] = pair.Value;
                }
            }

            freq = newFreq;
        }

        long count = 0;
        foreach(var pair in freq) {
            count += pair.Value;
        }

        return count;
    }

    static void Main(string[] args) {
        string filePath = "../inputs/day_11.txt";
        
        List<long> nums = new List<long>();
        try {
            string[] numStrings = File.ReadAllText(filePath).Split(" ");
            foreach (string str in numStrings) {
                nums.Add(Convert.ToInt64(str));
            }
        } catch {
            Console.WriteLine("Error reading file.");
        }

        Console.WriteLine(optimized(nums, 25));
        Console.WriteLine(optimized(nums, 75));
    }
}