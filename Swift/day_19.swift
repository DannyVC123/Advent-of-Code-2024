import Foundation

// Function to read all lines of a file into an array
func readLines(from filePath: String, separator: String) -> [String]? {
    do {
        // Read the entire file content
        let fileContent = try String(contentsOfFile: filePath, encoding: .utf8)
        // Split the content into lines
        let lines = fileContent.components(separatedBy: separator)
        return lines
    } catch {
        print("Error reading file: \(error)")
        return nil
    }
}

var memo: [String: Bool] = [:]
func validPattern(pattern: String, towels: [String]) -> Bool {
    if let cachedResult = memo[pattern] {
        return cachedResult
    }

    if pattern.isEmpty {
        return true
    }

    for towel in towels {
        if towel.count > pattern.count {
            continue
        }

        let prefix = String(pattern.prefix(towel.count))
        if prefix == towel {
            let rest = String(pattern.dropFirst(towel.count))
            if validPattern(pattern: rest, towels: towels) {
                memo[pattern] = true
                return true
            }
        }
    }

    memo[pattern] = false
    return false
}

var memo2: [String: Int] = [:]
func countPatterns(pattern: String, towels: [String]) -> Int {
    if let cachedResult = memo2[pattern] {
        return cachedResult
    }

    if pattern.isEmpty {
        return 1
    }
    
    var numWays = 0
    for towel in towels {
        if towel.count > pattern.count {
            continue
        }

        let prefix = String(pattern.prefix(towel.count))
        if prefix == towel {
            let rest = String(pattern.dropFirst(towel.count))
            numWays += countPatterns(pattern: rest, towels: towels)
        }
    }

    memo2[pattern] = numWays
    return numWays
}

func solve(patterns: [String], towels: [String], partOne: Bool) -> (Int, [String]) {
    var count = 0
    var validPatterns: [String] = []
    for pattern in patterns {
        if partOne {
            if validPattern(pattern: pattern, towels: towels) {
                count += 1
                validPatterns.append(pattern)
            }
        } else {
            count += countPatterns(pattern: pattern, towels: towels)
        }
    }
    return (count, validPatterns)
}

var relativeFilePath = "inputs/day_19_a.txt"
var absolutePath = FileManager.default.currentDirectoryPath + "/" + relativeFilePath
let towels = readLines(from: absolutePath, separator: ", ")!

relativeFilePath = "inputs/day_19_b.txt"
absolutePath = FileManager.default.currentDirectoryPath + "/" + relativeFilePath
let patterns = readLines(from: absolutePath, separator: "\n")!

var (count, validPatterns) = solve(patterns: patterns, towels: towels, partOne: true)
print(count)

(count, validPatterns) = solve(patterns: validPatterns, towels: towels, partOne: false)
print(count)