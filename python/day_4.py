f = open("../inputs/day_4.txt", "r")
lines = f.read().split("\n")

def part_one():
    count = 0

    for i in range(len(lines)):
        for j in range(len(lines[i])):
            if lines[i][j] != 'X':
                continue

            right = j + 3 < len(lines[i])
            if right and lines[i][j:j+4] == 'XMAS':
                count += 1
            left = j - 3 >= 0
            if left and lines[i][j:j-4:-1] == 'XMAS':
                count += 1
            down = i + 3 < len(lines)
            if down and ''.join([lines[i+k][j] for k in range(4)]) == 'XMAS':
                count += 1
            up = i - 3 >= 0
            if up and ''.join([lines[i-k][j] for k in range(4)]) == 'XMAS':
                count += 1
            
            # right, down
            if right and down and ''.join([lines[i+k][j+k] for k in range(4)]) == 'XMAS':
                count += 1
            # right, up
            if right and up and ''.join([lines[i-k][j+k] for k in range(4)]) == 'XMAS':
                count += 1
            # left, down
            if left and down and ''.join([lines[i+k][j-k] for k in range(4)]) == 'XMAS':
                count += 1
            # left, up
            if left and up and ''.join([lines[i-k][j-k] for k in range(4)]) == 'XMAS':
                count += 1
    
    print(count)

def part_two():
    count = 0

    for i in range(len(lines)):
        for j in range(len(lines[i])):
            if lines[i][j] != 'A':
                continue

            left = j - 1 >= 0
            right = j + 1 < len(lines[i])
            up = i - 1 >= 0
            down = i + 1 < len(lines)
            if left and right and up and down:
                if lines[i-1][j-1] == 'M' and lines[i-1][j+1] == 'M' and lines[i+1][j+1] == 'S' and lines[i+1][j-1] == 'S':
                    count += 1
                if lines[i-1][j-1] == 'S' and lines[i-1][j+1] == 'M' and lines[i+1][j+1] == 'M' and lines[i+1][j-1] == 'S':
                    count += 1
                if lines[i-1][j-1] == 'S' and lines[i-1][j+1] == 'S' and lines[i+1][j+1] == 'M' and lines[i+1][j-1] == 'M':
                    count += 1
                if lines[i-1][j-1] == 'M' and lines[i-1][j+1] == 'S' and lines[i+1][j+1] == 'S' and lines[i+1][j-1] == 'M':
                    count += 1
    
    print(count)

part_one()
part_two()