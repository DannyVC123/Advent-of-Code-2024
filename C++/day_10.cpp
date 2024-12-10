#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <map>

using namespace std;

bool inBounds(pair<int, int>& currPos, vector<vector<int>>& nums) {
  return 0 <= currPos.first  && currPos.first  < nums.size() &&
         0 <= currPos.second && currPos.second < nums[0].size();
}

int hike(pair<int, int> currPos, vector<vector<int>>& nums, vector<vector<bool>>& visited, bool partTwo) { //, map<string, vector<pair<int, int>>>& memoization) {
  int count = 0;
  visited[currPos.first][currPos.second] = true;
  
  if (nums[currPos.first][currPos.second] == 9) {
    if (partTwo) {
      visited[currPos.first][currPos.second] = false;
    }
    return 1;
  }
  
  vector<vector<int>> directions = {
    {-1, 0},
    {0, 1},
    {1, 0},
    {0, -1}
  };
  for (auto& direc : directions) {
    pair<int, int> newPos(currPos.first + direc[0], currPos.second + direc[1]);
    if (inBounds(newPos, nums) && !visited[newPos.first][newPos.second] &&
        nums[newPos.first][newPos.second] - nums[currPos.first][currPos.second] == 1) {
          count += hike(newPos, nums, visited, partTwo);
        }
  }

  if (partTwo) {
    visited[currPos.first][currPos.second] = false;
  }
  return count;
}

int solve(vector<vector<int>>& nums, bool partTwo) {
  int count = 0;
  for (int r = 0; r < nums.size(); r++) {
    for (int c = 0; c < nums[r].size(); c++) {
      if (nums[r][c] == 0) {
        vector<vector<bool>> visited(nums.size(), vector<bool>(nums[0].size(), false));
        pair<int, int> startPos(r, c);
        count += hike(startPos, nums, visited, partTwo);
      }
    }
  }
  return count;
}

int main() {
  string filename = "inputs/day_10.txt";
  ifstream inputFile(filename);

  if (!inputFile.is_open()) {
    cerr << "Error: Could not open the file " << filename << endl;
    return 1;
  }

  vector<vector<int>> nums;
  string line;
  int currLine = 0;
  while (getline(inputFile, line)) {
    vector<int> numsLine(line.length(), 0);
    for (int i = 0; i < line.length(); i++) {
      numsLine[i] = line[i] - '0';
    }
    nums.push_back(numsLine);
  }
  inputFile.close();
  
  cout << solve(nums, false) << endl;
  cout << solve(nums, true) << endl;
}