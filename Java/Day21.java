import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Scanner;

public class Day21 {
    public static void print(String str) {
        System.out.println(str);
    }
    public static void print(int num) {
        System.out.println(num);
    }

    public static char[][] keypad = {
        {'7', '8', '9'},
        {'4', '5', '6'},
        {'1', '2', '3'},
        {'#', '0', 'A'}
    };
    public static int[][][] controls = {
        {{},      {-1, 0}, {'A'}},
        {{0, -1}, { 1, 0}, {0,  1}}
    };

    public static boolean inBounds(int[] pos, int r, int c) {
        return 0 <= pos[0] && pos[0] < r &&
               0 <= pos[1] && pos[1] < c;
    }

    public static char press(int[] direc, int[] keypadRobot, int[] robot2, int[] robot1) {
        int[] robot1Press = {}, robot2Press = {};
        char keypadRobotPress = '#';

        if (direc[0] == 'A') {
            //print("1");
            robot1Press = controls[robot1[0]][robot1[1]];
        } else {
            //print("2");
            robot1[0] += direc[0];
            robot1[1] += direc[1];
            return '#';
        }

        if (robot1Press[0] == 'A') {
            //print("3");
            robot2Press = controls[robot2[0]][robot2[1]];
        } else {
            //print("4");
            robot2[0] += robot1Press[0];
            robot2[1] += robot1Press[1];
            return '#';
        }

        if (robot2Press[0] == 'A') {
            //print("5");
            keypadRobotPress = keypad[keypadRobot[0]][keypadRobot[1]];
            return keypadRobotPress;
        } else {
            //print("6");
            keypadRobot[0] += robot2Press[0];
            keypadRobot[1] += robot2Press[1];
            return '#';
        }
    }

    public static int recur(String code, int[] keypadRobot, int[] robot2, int[] robot1, HashSet<String> visited, Map<String, Integer> memo) {
        String key = code + Arrays.toString(keypadRobot) + Arrays.toString(robot2) + Arrays.toString(robot1);
        if (memo.containsKey(key)) {
            return memo.get(key);
        }

        if (code.length() == 0) {
            //print("here");
            memo.put(key, 0);
            return 0;
        }
        if (!inBounds(keypadRobot, keypad.length, keypad[0].length) || keypad[keypadRobot[0]][keypadRobot[1]] == '#') {
            return 9999;
        }
        if (!inBounds(robot1, controls.length, controls[0].length) || (robot1[0] == 0 && robot1[1] == 0)) {
            return 9999;
        }
        if (!inBounds(robot2, controls.length, controls[0].length) || (robot2[0] == 0 && robot2[1] == 0)) {
            return 9999;
        }

        if (visited.contains(key)) {
            return 9999;
        }
        visited.add(key);

        int minCount = Integer.MAX_VALUE;
        for (int r = 0; r < controls.length; r++) {
            for (int c = 0; c < controls[r].length; c++) {
                if (r == 0 && c == 0) continue;
                
                int[] kR = {keypadRobot[0], keypadRobot[1]};
                int[] r2 = {robot2[0], robot2[1]};
                int[] r1 = {robot1[0], robot1[1]};
                char pressed = press(controls[r][c], kR, r2, r1);
                
                int newCount = 0;
                if (pressed == code.charAt(0)) {
                    newCount = 1 + recur(code.substring(1), kR, r2, r1, visited, memo);
                } else {
                    newCount = 1 + recur(code, kR, r2, r1, visited, memo);
                }
                minCount = Math.min(newCount, minCount);
            }
        }

        memo.put(key, minCount);
        visited.remove(key);
        return minCount;
    }

    public static int partOne(ArrayList<String> codes) {
        int total = 0;
        for (String code : codes) {
            int count = recur(code,
                              new int[] {3, 2},
                              new int[] {0, 2},
                              new int[] {0, 2},
                              new HashSet<String>(),
                              new HashMap<String, Integer>());
            int intPart = Integer.parseInt(code.substring(0, code.length() - 1));
            int complexity = intPart * count;
            total += complexity;

            print(count);
        }
        return total;
    }

    public static void main(String[] args) {
        ArrayList<String> codes = new ArrayList<>();
        try {
            Scanner input = new Scanner(new File("../inputs/day_21.txt"));
            while (input.hasNextLine()) {
                codes.add(input.nextLine());
            }
            input.close();
        } catch (IOException e) {
            print("Error reading file");
        }

        for (String line : codes) {
            print(line);
        }
        print(partOne(codes));
    }
}
