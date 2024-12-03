import re

f = open("../inputs/day_3.txt", "r")
input = f.read().replace("\n", "")

def compute(instructions):
    pattern = re.compile("\([0-9]+,[0-9]+\).*")

    total = 0
    for instruction in instructions:
        if not pattern.match(instruction):
            continue

        end = instruction.find(")")
        nums = instruction[1:end].split(",")
        total += int(nums[0]) * int(nums[1])
    
    return total

def part_one():
    instructions = input.split("mul")
    print(compute(instructions))

def part_two():
    do_sections = input.split("do()")
    
    total = 0
    for do_section in do_sections:
        do = do_section.split("don't()")[0]
        instructions = do.split("mul")
        total += compute(instructions)
    
    print(total)

part_one()
part_two()