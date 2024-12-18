import Foundation

func getValue(a: Int64, b: Int64, c: Int64, operand: Int) -> Int64 {
    switch operand {
        case 0, 1, 2, 3:
            return Int64(operand)
        case 4:
            return a
        case 5:
            return b
        case 6:
            return c
        default:
            return -1
    }
}

func runProgram(a: Int64, b: Int64, c: Int64, program: [Int]) -> [Int64] {
    var a = a, b = b, c = c
    var ip = 0
    var ret: [Int64] = []

    while 0 <= ip && ip < program.count && 0 <= ip + 1 && ip + 1 < program.count {
        switch program[ip] {
        case 0:
            a = a >> getValue(a: a, b: b, c: c, operand: program[ip + 1])
        case 1:
            b = b ^ Int64(program[ip + 1])
        case 2:
            b = getValue(a: a, b: b, c: c, operand: program[ip + 1]) % 8
        case 3:
            if a == 0 {
                break
            }
            ip = program[ip + 1]
            continue
        case 4:
            b = b ^ c
        case 5:
            let value = getValue(a: a, b: b, c: c, operand: program[ip + 1]) % 8
            ret.append(value)
        case 6:
            b = a >> getValue(a: a, b: b, c: c, operand: program[ip + 1])
        case 7:
            c = a >> getValue(a: a, b: b, c: c, operand: program[ip + 1])
        default:
            print("Error: Unknown instruction \(program[ip]) at \(ip).")
        }

        ip += 2
    }

    return ret
}

func recur(i: Int, a: Int64, program: [Int]) -> Int64 {
    if (i < 0) {
        return a
    }

    var minA = Int64.max
    for j: Int64 in 0...7 {
        let newA = (a << 3) + j
        let ret = runProgram(a: newA, b: 0, c: 0, program: program)
        if ret[0] != program[i] {
            continue
        }

        minA = min(recur(i: i - 1, a: newA, program: program), minA)
    }

    return minA
}

var a: Int64 = 41644071
var b: Int64 = 0
var c: Int64 = 0

let programString = "2,4,1,2,7,5,1,7,4,4,0,3,5,5,3,0"
let programStringSplit = programString.components(separatedBy: ",")
var program = Array(repeating: 0, count: programStringSplit.count)
for i in 0..<program.count {
    program[i] = Int(programStringSplit[i])!
}

print(runProgram(a: a, b: b, c: c, program: program))

let minA = recur(i: program.count - 1, a: 0, program: program)
print(minA)
