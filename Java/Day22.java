import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Scanner;

public class Day22 {
    public static void print(String str) {
        System.out.println(str);
    }
    public static void print(long num) {
        System.out.println(num);
    }

    public static ArrayList<int[]> partOne(ArrayList<Long> nums) {
        //long total = 0;

        ArrayList<int[]> prices = new ArrayList<>();
        for (long num : nums) {
            long tempNum = num;
            
            int[] currPrices = new int[2001];
            currPrices[0] = (int) (tempNum % 10);

            for (int i = 1; i <= 2000; i++) {
                long stepOne = ((tempNum * 64) ^ tempNum) % 16777216;
                long stepTwo = ((stepOne / 32) ^ stepOne) % 16777216;
                long stepThree = ((stepTwo * 2048) ^ stepTwo) % 16777216;

                tempNum = stepThree;
                currPrices[i] = (int) (tempNum % 10);
            }

            //total += tempNum;
            prices.add(currPrices);
        }

        //return total;
        return prices;
    }

    public static int partTwo(ArrayList<int[]> prices) {
        ArrayList<int[]> changes = new ArrayList<>();
        Map<String, Integer> sequenceTotals = new HashMap<>();

        for (int[] currPrices : prices) {
            int[] currChanges = new int[2001];

            HashSet<String> seen = new HashSet<>();
            for (int i = 1; i < currPrices.length - 1; i++) {
                currChanges[i] = currPrices[i] - currPrices[i - 1];

                if (i >= 4) {
                    String key = currChanges[i-3] + "," + currChanges[i-2] + "," + currChanges[i-1] + "," + currChanges[i];
                    if (!seen.contains(key)) {
                        sequenceTotals.put(key, sequenceTotals.getOrDefault(key, 0) + currPrices[i]);
                        seen.add(key);
                    }
                }
            }
            changes.add(currChanges);
            //print(Arrays.toString(currChanges));
        }

        int max = Integer.MIN_VALUE;
        for (String sequence : sequenceTotals.keySet()) {
            if (sequenceTotals.get(sequence) > max) {
                print(sequence);
                max = sequenceTotals.get(sequence);
            }
        }
        return max;
    }

    public static void main(String[] args) {
        ArrayList<Long> nums = new ArrayList<>();
        try {
            Scanner input = new Scanner(new File("../inputs/day_22.txt"));
            while (input.hasNextLine()) {
                nums.add(input.nextLong());
            }
            input.close();
        } catch (IOException e) {
            print("Error reading file");
        }
        
        /*
        for (long num : nums) {
            print(num);
        }
        */
        ArrayList<int[]> prices = partOne(nums);
        print(partTwo(prices));
    }
}
