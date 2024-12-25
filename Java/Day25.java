import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Scanner;

public class Day25 {
    public static void print(String str) {
        System.out.println(str);
    }
    public static void print(int num) {
        System.out.println(num);
    }

    public static boolean validKey(int[] lock, int[] key) {
        for (int i = 0; i < key.length; i++) {
            if (key[i] + lock[i] > 7) return false;
        }
        //print(Arrays.toString(lock) + ", " + Arrays.toString(key));
        return true;
    }

    public static int partOne(ArrayList<int[]> locks, ArrayList<int[]> keys) {
        int count = 0;
        for (int[] lock : locks) {
            for (int [] key : keys) {
                if (validKey(lock, key)) count++;
            }
        }
        return count;
    }

    public static void main(String[] args) {
        ArrayList<int[]> locks = new ArrayList<>();
        ArrayList<int[]> keys = new ArrayList<>();
        try {
            Scanner input = new Scanner(new File("../inputs/day_25.txt"));
            while (input.hasNextLine()) {
                String[] lines = {
                    input.nextLine(),
                    input.nextLine(),
                    input.nextLine(),
                    input.nextLine(),
                    input.nextLine(),
                    input.nextLine(),
                    input.nextLine()
                };
                boolean isKey = lines[0].charAt(0) == '.';
                print(isKey + ":\t" + Arrays.toString(lines));
                
                int[] arr = new int[5];
                for (String line : lines) {
                    for (int i = 0; i < line.length(); i++) {
                        if (line.charAt(i) == '#') {
                            arr[i]++;
                        }
                    }
                }

                (isKey ? keys : locks).add(arr);
                if (input.hasNextLine()) input.nextLine();
            }
            input.close();
        } catch (IOException e) {
            print("Error reading file");
        }

        /*
        for (int[] key : keys) {
            print(Arrays.toString(key));
        }
        */
        //print(locks.size() + " " + keys.size());
        print(partOne(locks, keys));
    }
}