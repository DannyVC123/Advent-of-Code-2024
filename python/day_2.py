f = open("../inputs/day_2.txt", "r")
input = f.read()

lines = input.split("\n")

reports = [line.split(" ") for line in lines]

def is_valid(report):
    report_nums = [int(str) for str in report]

    increasing = report_nums[1] > report_nums[0]
    valid = True
    for i in range(len(report_nums) - 1):
        difference = report_nums[i+1] - report_nums[i]

        if increasing and (1 > difference or difference > 3):
            valid = False
            break

        if not increasing and (-3 > difference or difference > -1):
            valid = False
            break
    
    return valid

def part_one():
    count = 0

    for report in reports:
        if is_valid(report):
            count += 1
    
    print(count)

def part_two():
    count = 0

    for report in reports:
        if is_valid(report):
            count += 1
            continue

        for i in range(len(report)):
            report_copy = report.copy()
            del report_copy[i]

            if is_valid(report_copy):
                count += 1
                break
    
    print(count)

part_one()
part_two()