f = open("./inputs/day_1.txt", "r")
input = f.read()

lines = input.split("\n")

left_list = []
right_list = []
for line in lines:
    left, right = line.split("   ")
    left_list.append(int(left))
    right_list.append(int(right))

def part_one():
    left_list.sort()
    right_list.sort()

    sum = sum(abs(left_list[i] - right_list[i]) for i in range(len(left_list)))
    print(sum)

def part_two():
    right_freq = {}
    for num in right_list:
        if num in right_freq:
            right_freq[num] += 1
        else:
            right_freq[num] = 1
    
    sum = 0
    for num in left_list:
        if num in right_freq:
            sum += num * right_freq[num]
    print(sum)

part_one()
part_two()