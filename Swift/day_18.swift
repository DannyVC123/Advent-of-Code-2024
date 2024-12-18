import Foundation

// Function to read all lines of a file into an array
func readLines(from filePath: String, numLines: Int) -> [[Bool]]? {
    do {
        // Read the entire file content
        let fileContent = try String(contentsOfFile: filePath, encoding: .utf8)
        // Split the content into lines
        let lines = fileContent.components(separatedBy: .newlines)

        var maze = Array(repeating: Array(repeating: false, count: 71), count: 71)
        for i in 0..<numLines {
            let numStrings = lines[i].components(separatedBy: ",")
            let r = Int(numStrings[0])!, c = Int(numStrings[1])!
            //print("\(r), \(c)")
            maze[r][c] = true
        }
        return maze
    } catch {
        print("Error reading file: \(error)")
        return nil
    }
}

let directions: [[Int]] = [
    [-1, 0], // Up
    [0, 1],  // Right
    [1, 0],  // Down
    [0, -1]  // Left
]

func inBounds(r: Int, c: Int, maze: [[Bool]]) -> Bool {
    return 0 <= r && r < maze.count && 0 <= c && c < maze[0].count
}

func bfs(maze: [[Bool]]) -> Int {
    var parents: [[[Int]?]] = Array(repeating: Array(repeating: nil, count: 71), count: 71)

    var queue: [[Int]] = [[0, 0]]
    var visited: [[Bool]] = Array(repeating: Array(repeating: false, count: 71), count: 71)
    visited[0][0] = true
    while !queue.isEmpty {
        let currPos = queue.removeFirst()
        //print(currPos)
        if (currPos[0] == maze.count - 1 && currPos[1] == maze[0].count - 1) {
            break
        }

        for direc in directions {
            let newPos = [currPos[0] + direc[0], currPos[1] + direc[1]]
            if !inBounds(r: newPos[0], c: newPos[1], maze: maze) || visited[newPos[0]][newPos[1]] || maze[newPos[0]][newPos[1]] {
                continue
            }

            queue.append(newPos)
            visited[newPos[0]][newPos[1]] = true
            parents[newPos[0]][newPos[1]] = currPos
        }
    }

    var count = 0
    var currPos = [maze.count - 1, maze[0].count - 1]
    while let parent = parents[currPos[0]][currPos[1]] {
        count += 1
        currPos = parent
    }

    return count
}

let relativeFilePath = "inputs/day_18.txt" // Adjust the relative path as needed
let absolutePath = FileManager.default.currentDirectoryPath + "/" + relativeFilePath
if let maze = readLines(from: absolutePath, numLines: 1024) {
    print(bfs(maze: maze))
} else {
    // Handle the error
    print("Failed to read the file")
}

for i in 1025...3450 {
    if let maze = readLines(from: absolutePath, numLines: i) {
        let length = bfs(maze: maze)
        if length == 0 {
            print("Line Number \(i)")
            break
        }
    } else {
        // Handle the error
        print("Failed to read the file")
    }
}