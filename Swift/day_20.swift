import Foundation

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

let directions: [[Int]] = [
    [-1, 0], // Up
    [0, 1],  // Right
    [1, 0],  // Down
    [0, -1]  // Left
]

func inBounds(r: Int, c: Int, maze: [[Character]]) -> Bool {
    return 0 <= r && r < maze.count && 0 <= c && c < maze[0].count
}

func bfs(maze: [[Character]], distances: inout [[[Int]]], start: [Int], end: [Int], startToEnd: Bool) -> Int {
    var parents: [[[Int]?]] = Array(repeating: Array(repeating: nil, count: maze[0].count), count: maze.count)
    
    var queue: [[Int]] = [start]
    var visited: [[Bool]] = Array(repeating: Array(repeating: false, count: maze[0].count), count: maze.count)
    visited[start[0]][start[1]] = true
    while !queue.isEmpty {
        let currPos = queue.removeFirst()
        if currPos == end {
            break
        }
        
        for direc in directions {
            let newPos = [currPos[0] + direc[0], currPos[1] + direc[1]]
            if !inBounds(r: newPos[0], c: newPos[1], maze: maze) || visited[newPos[0]][newPos[1]] || maze[newPos[0]][newPos[1]] == "#" {
                continue
            }

            queue.append(newPos)
            visited[newPos[0]][newPos[1]] = true
            parents[newPos[0]][newPos[1]] = currPos
        }
    }
    
    var count = 0
    var currPos = end
    while let parent = parents[currPos[0]][currPos[1]] {
        count += 1
        distances[parent[0]][parent[1]][startToEnd ? 1 : 0] = count
        currPos = parent
    }

    return count
}

func bfsWithRemoval(maze: [[Character]], distances: [[[Int]]], start: [Int], end: [Int], removedWall: [Int]) -> Int {
    var parents: [[[Int]?]] = Array(repeating: Array(repeating: nil, count: maze[0].count), count: maze.count)

    var pq: [([Int], Int)] = [(start, distances[start[0]][start[1]][1])]
    var visited: [[Bool]] = Array(repeating: Array(repeating: false, count: maze[0].count), count: maze.count)
    visited[start[0]][start[1]] = true

    var encounterdRemoval = false
    var currPos: [Int] = []
    while !pq.isEmpty {
        currPos = pq.removeFirst().0
        if encounterdRemoval && distances[currPos[0]][currPos[1]][0] > distances[start[0]][start[1]][0] {
            break
        }

        if currPos == removedWall {
            encounterdRemoval = true
        }

        for direc in directions {
            let newPos = [currPos[0] + direc[0], currPos[1] + direc[1]]
            if !inBounds(r: newPos[0], c: newPos[1], maze: maze) || visited[newPos[0]][newPos[1]] || maze[newPos[0]][newPos[1]] == "#" {
                continue
            }
            pq.append((newPos, distances[newPos[0]][newPos[1]][1]))
            visited[newPos[0]][newPos[1]] = true
            parents[newPos[0]][newPos[1]] = currPos
        }
        pq.sort { $0.1 < $1.1 }
    }
    
    var count = distances[start[0]][start[1]][0] + distances[currPos[0]][currPos[1]][1]
    while let parent = parents[currPos[0]][currPos[1]] {
        count += 1
        currPos = parent
    }
    
    return count
}

func openSpot(maze: [[Character]], r: Int, c: Int) -> Bool {
    return maze[r][c] == "." || maze[r][c] == "S" || maze[r][c] == "E"
}

func partOne(maze: inout [[Character]], start: [Int], end: [Int]) -> Int {
    var distances = Array(repeating: Array(repeating: [-1, -1], count: maze[0].count), count: maze.count)
    let count = bfs(maze: maze, distances: &distances, start: start, end: end, startToEnd: true)
    let _ = bfs(maze: maze, distances: &distances, start: end, end: start, startToEnd: false)

    distances[start[0]][start[1]][0] = 0
    distances[start[0]][start[1]][1] = count
    distances[end[0]][end[1]][0] = count
    distances[end[0]][end[1]][1] = 0

    var total = 0
    for r in 1..<maze.count - 1 {
        for c in 1..<maze[r].count - 1 {
            if maze[r][c] == "#" {
                maze[r][c] = "."
                var minDist = count
                for direc in directions {
                    let newR = r + direc[0], newC = c + direc[1]
                    if openSpot(maze: maze, r: newR, c: newC) {
                        let newCount = bfsWithRemoval(maze: maze, distances: distances, start: [newR, newC], end: end, removedWall: [r, c])
                        minDist = min(minDist, newCount)
                    }
                }
                maze[r][c] = "#"
                //print(count - minDist)
                if count - minDist >= 100 {
                    total += 1
                }
            }
        }
    }

    return total
}

func manhattanDist(start: [Int], end: [Int]) -> Int {
    return abs(end[0] - start[0]) + abs(end[1] - start[1])
}

func solve(maze: inout [[Character]], start: [Int], end: [Int], maxDistance: Int) -> Int {
    var distances = Array(repeating: Array(repeating: [-1, -1], count: maze[0].count), count: maze.count)
    let count = bfs(maze: maze, distances: &distances, start: start, end: end, startToEnd: true)
    let _ = bfs(maze: maze, distances: &distances, start: end, end: start, startToEnd: false)

    distances[start[0]][start[1]][0] = 0
    distances[start[0]][start[1]][1] = count
    distances[end[0]][end[1]][0] = count
    distances[end[0]][end[1]][1] = 0

    var total = 0
    for r in 1..<maze.count - 1 {
        for c in 1..<maze[r].count - 1 {
            if maze[r][c] == "#" {
                continue
            }

            for r2 in (r - maxDistance)...(r + maxDistance) {
                for c2 in (c - maxDistance)...(c + maxDistance) {
                    let nanoseconds = manhattanDist(start: [r, c], end: [r2, c2])
                    if !inBounds(r: r2, c: c2, maze: maze) || !openSpot(maze: maze, r: r2, c: c2) || nanoseconds > maxDistance {
                        continue
                    }

                    let totalDist = distances[r][c][0] + distances[r2][c2][1] + nanoseconds
                    if count - totalDist >= 100 {
                        total += 1
                    }
                }
            }
        }
    }

    return total
}

let relativeFilePath = "inputs/day_20.txt"
let absolutePath = FileManager.default.currentDirectoryPath + "/" + relativeFilePath
var maze = readFile(from: absolutePath)!

var startR = -1, startC = -1, endR = -1, endC = -1
for r in 1..<maze.count - 1 {
    for c in 1..<maze[r].count - 1 {
        if startR == -1 && maze[r][c] == "S" {
            startR = r
            startC = c
        }

        if endR == -1 && maze[r][c] == "E" {
            endR = r
            endC = c
        }
    }

    if startR != -1 && endR != -1 {
        break
    }
}

print(solve(maze: &maze, start: [startR, startC], end: [endR, endC], maxDistance: 2))
print(solve(maze: &maze, start: [startR, startC], end: [endR, endC], maxDistance: 20))