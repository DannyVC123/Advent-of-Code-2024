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

func runProgram(a: Int64, b: Int64, c: Int64, program: [Int]) -> String {
    var a = a, b = b, c = c
    var ip = 0
    var ret = ""

    var currPrintInd = 0

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
            //if value != program[currPrintInd] {
                //return "none"
            //}
            ret = "\(ret)\(value),"
            currPrintInd += 1
        case 6:
            b = b >> getValue(a: a, b: b, c: c, operand: program[ip + 1])
        case 7:
            c = c >> getValue(a: a, b: b, c: c, operand: program[ip + 1])
        default:
            print("Error: Unknown instruction \(program[ip]) at \(ip).")
        }

        ip += 2
    }

    return String(ret.prefix(ret.count - 1))
}

var a: Int64 = 7
var b: Int64 = 0
var c: Int64 = 0

let programString = "2,4,1,2,7,5,1,7,4,4,0,3,5,5,3,0"
let programStringSplit = programString.components(separatedBy: ",")
var program = Array(repeating: 0, count: programStringSplit.count)
for i in 0..<program.count {
    program[i] = Int(programStringSplit[i])!
}

var a0: Int64 = Int64(Int64(140737488355328) + (8 - (Int64(140737488355328) % 8)) + 7)
var j: Int = 0;
while j < 100 {
    let ret = runProgram(a: a0, b: b, c: c, program: program)
    //print("a = \(a0)")
    //print(ret)
    if ret == programString {
        print("a = \(a0)")
    }
    a0 += 8
    j += 1
}
