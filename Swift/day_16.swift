import Foundation

func inBounds(r: Int, c: Int, maze: [[Character]]) -> Bool{
    return 0 <= r && r < maze.count &&
           0 <= c && c < maze[0].count;
}

var minScore = 109516
var bestPath: [[Bool]] = []
var numSpots = 0
func partOne(r: Int, c: Int, direc: Int, score: Int, maze: [[Character]], visited: inout [[Bool]]) -> Int {
    if !inBounds(r: r, c: c, maze: maze) || maze[r][c] == "#" || visited[r][c] {
        return Int.max;
    }
    visited[r][c] = true;

    if maze[r][c] == "E" {
        if score == minScore {
            for i in 0..<visited.count {
                for j in 0..<visited[i].count {
                    if maze[i][j] == "#" {
                        print("#", terminator: "")
                    } else {
                        print(visited[i][j] ? "O" : ".", terminator: "")
                    }
                    if visited[i][j] && !bestPath[i][j] {
                        bestPath[i][j] = true
                        numSpots += 1;
                    }
                }
                print()
            }
            print()
        }
        visited[r][c] = false;
        return score;
    }

    let directions: [[Int]] = [
        [-1, 0],
        [0, 1],
        [1, 0],
        [0, -1]
    ];

    var direction = directions[direc]
    let forward = partOne(r: r + direction[0], c: c + direction[1], direc: direc, score: score + 1, maze: maze, visited: &visited)
    
    var minClockwise = Int.max;
    for i in 1...2 {
        let newDirec = (direc + i) % directions.count;
        direction = directions[newDirec]

        let clockwise = partOne(r: r + direction[0], c: c + direction[1], direc: newDirec, score: score + i * 1000 + 1, maze: maze, visited: &visited)
        minClockwise = min(clockwise, minClockwise)
    }

    let newDirec = (direc - 1 + directions.count) % directions.count;
    direction = directions[newDirec]
    let counterCW = partOne(r: r + direction[0], c: c + direction[1], direc: newDirec, score: score + 1001, maze: maze, visited: &visited)
    
    visited[r][c] = false
    return min(forward, min(minClockwise, counterCW))
}

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
    var startR = -1, startC = -1;
    for r in 1..<maze.count {
        for c in 1..<maze[r].count {
            if maze[r][c] == "S" {
                startR = r
                startC = c
                break
            }
        }
        if startR != -1 || startC != -1 {
            break;
        }
    }
    print("\(startR), \(startC)")

    var visited = Array(repeating: Array(repeating: false, count: maze[0].count), count: maze.count)
    bestPath = Array(repeating: Array(repeating: false, count: maze[0].count), count: maze.count)
    minScore = partOne(r: startR, c: startC, direc: 1, score: 0, maze: maze, visited: &visited)
    print(minScore)
    print(numSpots)
} else {
    print("Failed to read lines from the file.")
}
