from functools import total_ordering

f = open("../inputs/day_5_a.txt", "r")
rules = f.read().split("\n")

f = open("../inputs/day_5_b.txt", "r")
updates = f.read().split("\n")

nums_before = {}
for rule in rules:
    first, second = [int(num) for num in rule.split("|")]
    if second in nums_before:
        nums_before[second].append(first)
    else:
        nums_before[second] = [first]

def part_one():
    total = 0
    invalid = []
    for update in updates:
        nums = [int(num) for num in update.split(",")]

        valid = True
        for i in range(len(nums)):
            for j in range(i+1, len(nums)):
                if nums[j] in nums_before[nums[i]]:
                    valid = False
                    break
            if not valid:
                break
        
        if valid:
            total += nums[len(nums) // 2]
        else:
            invalid.append(update)
    
    print(total)
    return invalid


@total_ordering
class Numbers:
    def __init__(self, num):
        self.num = num

    def __eq__(self, obj):
        return self.num == obj.num

    def __gt__(self, obj):
        return self.num in nums_before and obj.num in nums_before[self.num]

    def __gte__(self, obj):
        return self.__gt__(obj) or self.__eq__(obj)

def part_two(invalid):
    total = 0
    for update in invalid:
        numbers = [Numbers(int(num)) for num in update.split(",")]
        numbers.sort()

        total += numbers[len(numbers) // 2].num
    
    print(total)

invalid = part_one()
part_two(invalid)