import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Queue;
import java.util.Scanner;
import java.util.Set;
import java.util.TreeSet;

public class Day23 {
    public static void print(String str) {
        System.out.println(str);
    }
    public static void print(int num) {
        System.out.println(num);
    }

    public static int partOne(Graph graph) {
        HashSet<String> sets = graph.bfs();
        //print(sets.toString());
        return sets.size();
    }

    public static String partTwo(Graph graph) {
        TreeSet<String> maxClique = new TreeSet<>();
        graph.bkMaxCliques(new HashSet<String>(), graph.getNodes(), new HashSet<String>(), maxClique);

        ArrayList<String> sortedList = new ArrayList<>(maxClique);
        String password = String.join(",", sortedList);
        return password;
    }

    public static void main(String[] args) {
        Graph graph = new Graph();
        try {
            Scanner input = new Scanner(new File("../inputs/day_23.txt"));
            while (input.hasNextLine()) {
                String[] nodes = input.nextLine().split("-");
                graph.addEdge(nodes[0], nodes[1]);
            }
            input.close();
        } catch (IOException e) {
            print("Error reading file");
        }
        
        print(partOne(graph));
        print(partTwo(graph));
    }
}

class Graph {
    Map<String, ArrayList<String>> adjList = new HashMap<>();
    
    public void addEdge(String node1, String node2) {
        if (!adjList.containsKey(node1)) {
            adjList.put(node1, new ArrayList<String>());
        }
        adjList.get(node1).add(node2);

        if (!adjList.containsKey(node2)) {
            adjList.put(node2, new ArrayList<String>());
        }
        adjList.get(node2).add(node1);
    }

    public HashSet<String> bfs() {
        HashSet<String> sets = new HashSet<>();

        for (String start : adjList.keySet()) {
            if (start.charAt(0) != 't') continue;

            Queue<List<String>> queue = new LinkedList<>();
            queue.offer(Collections.singletonList(start));

            while (!queue.isEmpty()) {
                List<String> currPath = queue.poll();
                String lastVisited = currPath.get(currPath.size() - 1);

                if (currPath.size() > 3) {
                    continue;
                }

                for (String neighbor : adjList.get(lastVisited)) {
                    if (neighbor.equals(start) && currPath.size() == 3) {
                        Collections.sort(currPath);
                        sets.add(currPath.toString());
                    }

                    if (!currPath.contains(neighbor)) {
                        List<String> newPath = new ArrayList<>(currPath);
                        newPath.add(neighbor);
                        queue.add(newPath);
                    }
                }
            }
        }

        return sets;
    }

    /*
    public String bstTwo() {
        HashSet<String> masterVisited = new HashSet<>();
        String longestPassword = "";

        for (String start : adjList.keySet()) {
            if (masterVisited.contains(start)) continue;

            Queue<String> queue = new LinkedList<>();
            queue.offer(start);

            TreeSet<String> visited = new TreeSet<String>();
            visited.add(start);

            while (!queue.isEmpty()) {
                String currNode = queue.poll();

                for (String neighbor : adjList.get(currNode)) {
                    if (!visited.contains(neighbor)) {
                        queue.offer(neighbor);
                        visited.add(neighbor);
                    }
                }
            }

            //System.err.println(visited);
            ArrayList<String> sortedList = new ArrayList<>(visited);
            String password = String.join(",", sortedList);
            masterVisited.addAll(visited);

            if (password.length() > longestPassword.length()) {
                longestPassword = password;
            }
        }

        return longestPassword;
    }
    */

    public HashSet<String> getNodes() {
        Set<String> nodes = adjList.keySet();
        HashSet<String> nodesHashSet = new HashSet<>();
        nodesHashSet.addAll(nodes);
        return nodesHashSet;
    }
    
    @SuppressWarnings("unchecked")
    public void bkMaxCliques(HashSet<String> possibleClique, HashSet<String> availableVertices, HashSet<String> excludedVertices, TreeSet<String> maxClique) {
        if (availableVertices.size() == 0 && excludedVertices.size() == 0) {
            if (possibleClique.size() > maxClique.size()) {
                maxClique.clear();
                maxClique.addAll(possibleClique);
            }
            return;
        }

        for (String node : (HashSet<String>) availableVertices.clone()) {
            HashSet<String> newPossibleClique = (HashSet<String>) possibleClique.clone();
            newPossibleClique.add(node);

            HashSet<String> newAvailableVertices = new HashSet<>();
            HashSet<String> newExcludedVertices = new HashSet<>();
            for (String neighbor : adjList.get(node)) {
                if (availableVertices.contains(neighbor)) {
                    newAvailableVertices.add(neighbor);
                }
                if (excludedVertices.contains(neighbor)) {
                    newExcludedVertices.add(neighbor);
                }
            }

            bkMaxCliques(newPossibleClique, newAvailableVertices, newExcludedVertices, maxClique);

            availableVertices.remove(node);
            excludedVertices.add(node);
        }
    }
}