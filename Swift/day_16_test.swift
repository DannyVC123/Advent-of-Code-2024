import Foundation

// Define the inBounds function
func inBounds(r: Int, c: Int, maze: [[Character]]) -> Bool {
    return 0 <= r && r < maze.count && 0 <= c && c < maze[0].count
}

// Define the directions and costs
let directions: [[Int]] = [
    [-1, 0], // Up
    [0, 1],  // Right
    [1, 0],  // Down
    [0, -1]  // Left
]

let directionCosts: [Int] = [1, 1000, 1000] // Moving straight, clockwise, counter-clockwise costs

class Node {
    var r: Int
    var c: Int
    var cost: Int
    var direction: Int

    init(r: Int, c: Int, cost: Int, direction: Int) {
        self.r = r
        self.c = c
        self.cost = cost
        self.direction = direction
    }
}

func markBestPath(node: Node, bestSpots: inout [[Bool]]) {
    //
}

// Dijkstra's algorithm implementation
func dijkstra(maze: [[Character]], startR: Int, startC: Int) -> (Int, [[Bool]]) {
    // Create nodes with initial cost set to max
    let mazeNodes: [[Node]] = (0..<maze.count).map { r in
        (0..<maze[r].count).map { c in
            Node(r: r, c: c, cost: Int.max, direction: 1)
        }
    }

    var minScore = Int.max
    var shortestPaths: [[Node]] = []
    var pq: [(node: Node, path: [Node])] = []
    
    // Initialize start node
    let startNode = mazeNodes[startR][startC]
    startNode.cost = 0
    pq.append((node: startNode, path: [startNode]))
    pq.sort { $0.0.cost < $1.0.cost }
    
    while !pq.isEmpty {
        // Sort only when necessary, preferably use a heap
        pq.sort { $0.node.cost < $1.node.cost }
        
        let (currentNode, currentPath) = pq.removeFirst()
        
        // Skip if we've already found a cheaper path
        if currentNode.cost > minScore {
            continue
        }
        
        // Check if endpoint is reached
        if maze[currentNode.r][currentNode.c] == "E" {
            if currentNode.cost < minScore {
                minScore = currentNode.cost
                shortestPaths = [currentPath]
            } else if currentNode.cost == minScore {
                shortestPaths.append(currentPath)
            }
            continue
        }
        
        // Explore neighboring cells
        var inds = Array(0..<4)
        inds.shuffle();
        for direction in inds {
            let newR = currentNode.r + directions[direction][0]
            let newC = currentNode.c + directions[direction][1]
            
            // Validate new position
            guard inBounds(r: newR, c: newC, maze: maze),
                  maze[newR][newC] != "#" else {
                continue
            }
            
            // Calculate turn cost
            let turnCost = (direction == currentNode.direction) ? 1 : 1001
            let newCost = currentNode.cost + turnCost
            
            // Get next node
            let nextNode = mazeNodes[newR][newC]
            
            // Update if new path is cheaper
            if newCost < nextNode.cost {
                nextNode.cost = newCost
                nextNode.direction = direction
                
                // Create new path
                var newPath = currentPath
                newPath.append(nextNode)
                
                // Add to priority queue
                pq.append((node: nextNode, path: newPath))
                pq.sort { $0.0.cost < $1.0.cost }
            }
        }
    }
    
    // Mark best spots
    var bestSpots = Array(repeating: Array(repeating: false, count: maze[0].count), count: maze.count)
    for path in shortestPaths {
        for node in path {
            bestSpots[node.r][node.c] = true
        }
    }
    
    // Count unique spots
    let _ = bestSpots.reduce(0) { $0 + $1.filter { $0 }.count }
    
    return (minScore, bestSpots)
}

// Read the maze from the file
func readFile(from filePath: String) -> [[Character]]? {
    do {
        let fileContent = try String(contentsOfFile: filePath, encoding: .utf8)
        let lines = fileContent.components(separatedBy: .newlines)
        let char2DArray = lines.filter { !$0.isEmpty }.map { Array($0) }
        return char2DArray
    } catch {
        print("Error reading file: \(error)")
        return nil
    }
}

let relativeFilePath = "inputs/day_16.txt" // Adjust the relative path as needed
let absolutePath = FileManager.default.currentDirectoryPath + "/" + relativeFilePath
if let maze = readFile(from: absolutePath) {
    var startR = -1, startC = -1
    for r in 0..<maze.count {
        for c in 0..<maze[r].count {
            if maze[r][c] == "S" {
                startR = r
                startC = c
                break
            }
        }
        if startR != -1 || startC != -1 {
            break
        }
    }
    
    var allSpots: [[Bool]] = Array(repeating: Array(repeating: false, count: maze[0].count), count: maze.count)
    for _ in 0..<10 {
        let (_, bestSpots) = dijkstra(maze: maze, startR: startR, startC: startC)
        for r in 0..<bestSpots.count {
            for c in 0..<bestSpots[r].count {
                if (bestSpots[r][c]) {
                    allSpots[r][c] = true
                }
            }
        }
    }
    print("Spots: \(allSpots.reduce(0) { $0 + $1.filter { $0 }.count })")

} else {
    print("Failed to read lines from the file.")
}
