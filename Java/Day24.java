import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;
import java.util.Scanner;
import java.util.TreeSet;

public class Day24 {
    public static void print(String str) {
        System.out.println(str);
    }
    public static void print(long num) {
        System.out.println(num);
    }

    public static boolean finished(HashMap<String, Boolean> wires, TreeSet<String> zWires) {
        for (String zWire : zWires) {
            if (!wires.containsKey(zWire)) return false;
        }
        return true;
    }

    public static boolean computeGate(HashMap<String, Boolean> wires, String[] gate) {
        switch(gate[1]) {
            case "AND":
                return wires.get(gate[0]) && wires.get(gate[2]);
            case "OR":
                return wires.get(gate[0]) || wires.get(gate[2]);
            case "XOR":
                return wires.get(gate[0]) ^ wires.get(gate[2]);
        }
        return false;
    }

    public static long partOne(HashMap<String, Boolean> wires, TreeSet<String> zWires, Queue<String[]> gates) {
        while (!finished(wires, zWires)) {
            int size = gates.size();
            for (int i = 0; i < size; i++) {
                String[] currGate = gates.poll();
                if (!wires.containsKey(currGate[0]) || !wires.containsKey(currGate[2])) {
                    gates.offer(currGate);
                    continue;
                }

                boolean result = computeGate(wires, currGate);
                wires.put(currGate[3], result);
            }
        }
        
        StringBuilder sb = new StringBuilder();
        for (String zWire : zWires) {
            //print(zWire + ": " + wires.get(zWire));
            sb.append(wires.get(zWire) ? '1' : '0');
        }
        sb = sb.reverse();
        print(sb.toString());
        return Long.parseLong(sb.toString(), 2);
    }

    public static List<List<Integer>> combos = new ArrayList<>();
    public static void generateCombos(int n, int k, List<Integer> currCombo) {
        if (currCombo.size() == k) {
            combos.add(new ArrayList<>(currCombo));
            return;
        }

        for (int i = 0; i < n; i++) {
            if (currCombo.contains(i)) continue;
            currCombo.add(i);
            generateCombos(n, k, currCombo);
            currCombo.remove(currCombo.size() - 1);
        }
    }

    public static HashSet<String> seen = new HashSet<>();
    public static boolean validPairs(List<int[]> pairs, int i, int j, int k, int l) {
        int[] pair1 = pairs.get(i);
        int[] pair2 = pairs.get(j);
        int[] pair3 = pairs.get(k);
        int[] pair4 = pairs.get(l);
        
        HashSet<Integer> nums = new HashSet<>();
        nums.add(pair1[0]);
        nums.add(pair1[1]);
        nums.add(pair2[0]);
        nums.add(pair2[1]);
        nums.add(pair3[0]);
        nums.add(pair3[1]);
        nums.add(pair4[0]);
        nums.add(pair4[1]);
        if (nums.size() != 8) {
            return false;
        }

        String[] fourPairs = new String[4];
        fourPairs[0] = Arrays.toString(pair1);
        fourPairs[1] = Arrays.toString(pair2);
        fourPairs[2] = Arrays.toString(pair3);
        fourPairs[3] = Arrays.toString(pair4);
        Arrays.sort(fourPairs);
        if (seen.contains(String.join("", fourPairs))) {
            return false;
        }

        return true;
    }

    public static void swap(ArrayList<String[]> gates, int[] pair) {
        int i = pair[0], j = pair[1];
        String temp = gates.get(i)[3];
        gates.get(i)[3] = gates.get(j)[3];
        gates.get(j)[3] = temp;
    }

    public static boolean correct(HashMap<String, Boolean> wires, TreeSet<String> zWires, ArrayList<String[]> gates, long z,
                                  List<int[]> pairs, int i, int j, int k, int l) {
        swap(gates, pairs.get(i));
        swap(gates, pairs.get(j));
        swap(gates, pairs.get(k));
        swap(gates, pairs.get(l));
        
        Queue<String[]> gatesQueue = new LinkedList<>();
        for (String[] gate : gates) {
            gatesQueue.offer(gate);
        }

        long result = partOne(wires, zWires, gatesQueue);

        swap(gates, pairs.get(i));
        swap(gates, pairs.get(j));
        swap(gates, pairs.get(k));
        swap(gates, pairs.get(l));
        
        return result == z;
    }

    public static void partTwo(HashMap<String, Boolean> wires, TreeSet<String> zWires, ArrayList<String[]> gates, long z) {
        //generateCombos(gates.size(), 8, new ArrayList<Integer>());
        //print(combos.toString());
        
        List<int[]> pairs = new ArrayList<>();
        for (int i = 0; i < gates.size() - 1; i++) {
            for (int j = i + 1; j < gates.size(); j++) {
                pairs.add(new int[] {i, j});
            }
        }

        ArrayList<Integer> pairInds = new ArrayList<>();
        for (int i = 0; i < pairs.size() - 3; i++) {
            for (int j = i + 1; j < pairs.size() - 2; j++) {
                for (int k = j + 1; k < pairs.size() - 1; k++) {
                    for (int l = k + 1; l < pairs.size() - 0; l++) {
                        if (validPairs(pairs, i, j, k, l) &&
                            correct(wires, zWires, gates, z, pairs, i, j, k, l)) {
                            pairInds.add(i);
                            pairInds.add(j);
                            pairInds.add(k);
                            pairInds.add(l);
                        }
                    }
                }
            }
        }

        print(pairInds.toString());
    }

    public static void main(String[] args) {
        HashMap<String, Boolean> wires = new HashMap<>();
        TreeSet<String> zWires = new TreeSet<>();

        StringBuilder xSB = new StringBuilder();
        StringBuilder ySB = new StringBuilder();
        try {
            Scanner input = new Scanner(new File("../inputs/day_24_a.txt"));
            while (input.hasNextLine()) {
                String[] currWire = input.nextLine().split(": ");
                wires.put(currWire[0], currWire[1].charAt(0) == '1');

                if (currWire[0].charAt(0) == 'x') {
                    xSB.append(currWire[1]);
                }
                if (currWire[0].charAt(0) == 'y') {
                    ySB.append(currWire[1]);
                }
            }
            input.close();
        } catch (IOException e) {
            print("Error reading file");
        }
        xSB = xSB.reverse();
        ySB = ySB.reverse();

        long x = Long.parseLong(xSB.toString(), 2);
        long y = Long.parseLong(ySB.toString(), 2);
        long z = x + y;
        print(xSB.toString() + ": " + x);
        print(ySB.toString() + ": " + y);
        print(Long.toBinaryString(z) + ": " + z);

        //Queue<String[]> gates = new LinkedList<>();
        ArrayList<String[]> gates = new ArrayList<>();
        try {
            Scanner input = new Scanner(new File("../inputs/day_24_b.txt"));
            while (input.hasNextLine()) {
                String[] currGate = input.nextLine().split(" -> | ");
                gates.add(currGate);

                if (currGate[3].charAt(0) == 'z') {
                    zWires.add(currGate[3]);
                }
            }
            input.close();
        } catch (IOException e) {
            print("Error reading file");
        }
        
        //long partOne = partOne(wires, zWires, gates);
        partTwo(wires, zWires, gates, z);
    }
}