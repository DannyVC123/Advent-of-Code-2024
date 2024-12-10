#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <utility>
#include <map>
#include <cmath>

using namespace std;

long partOne(vector<int> nums) {
  long total = 0;

  int left = 0, right = nums.size() - 1;
  int position = 0, leftIndex = 0, rightIndex = nums.size() / 2;
  while (left < right) {
    while (nums[left] > 0) {
      total += position++ * leftIndex;
      nums[left]--;
    }
    left++;
    leftIndex++;

    while (nums[left] > 0) {
      total += position++ * rightIndex;
      nums[right]--;
      nums[left]--;

      if (nums[right] == 0) {
        right -= 2;
        rightIndex--;
      }
    }
    left++;
  }

  while (nums[right] > 0) {
    total += position++ * rightIndex;
    nums[right]--;
  }

  return total;
}

long partTwo(vector<int> nums) {
  vector<int> free;
  for (int i = 0, tempInd = 0; i < nums.size(); i++) {
    if (i % 2 == 0) {
      free.push_back(tempInd);
      tempInd++;
    } else {
      free.push_back(-1);
    }
  }

  int rightIndex = nums.size() / 2;
  int right = nums.size() - 1;
  while (rightIndex > 0) {
    bool moved = false;

    for (int i = 1; i < right && i <= nums.size(); i++) {
      if (free[i] == -1 && nums[right] <= nums[i]) {
        moved = true;
        free[right] = -1;

        if (nums[right] < nums[i]) {
          int remaining = nums[i] - nums[right];
          nums[i] = nums[right];
          nums.insert(nums.begin() + i + 1, remaining);

          free[i] = rightIndex;
          free.insert(free.begin() + i + 1, -1);

          right--;
          break;
        } else {
          free[i] = rightIndex;
          right -= 2;
          break;
        }
      }
    }

    while (free[right] >= rightIndex || free[right] == -1) {
      right--;
    }
    rightIndex--;
  }
  
  int position = 0;
  long total = 0;
  for (int i = 0; i < nums.size(); i++) {
    if (free[i] != -1) {
      for (int j = 0; j < nums[i]; j++) {
        total += position++ * free[i];
      }
    } else {
      position += nums[i];
    }
  }
  return total;
}

int main() {
  string filename = "inputs/day_9.txt";
  ifstream inputFile(filename);

  if (!inputFile.is_open()) {
    cerr << "Error: Could not open the file " << filename << endl;
    return 1;
  }

  string line;
  getline(inputFile, line);
  inputFile.close();

  vector<int> nums(line.length(), 0);
  for (int i = 0; i < line.length(); i++) {
    nums[i] = line[i] - '0';
  }
  
  cout << partOne(nums) << endl;
  cout << partTwo(nums) << endl;
}