#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <set>

using namespace std;

bool inBounds(pair<int, int> &guardPos, vector<vector<char>> &map) {
  return 0 <= guardPos.first  && guardPos.first  < map.size() &&
         0 <= guardPos.second && guardPos.second < map[0].size();
}

int part_one(pair<int, int> guardPos, vector<vector<char>> &map, vector<vector<bool>> &visited) {
  vector<vector<int>> directions = {
    {-1, 0},
    {0, 1},
    {1, 0},
    {0, -1}
  };
  int direc = 0;

  visited[guardPos.first][guardPos.second] = true;
  int count = 1;
  while (true) {
    pair<int, int> newPos(guardPos.first + directions[direc][0], guardPos.second + directions[direc][1]);

    if (!inBounds(newPos, map)) {
      return count;
    } else if (map[newPos.first][newPos.second] == '#') {
      direc = (direc + 1) % directions.size();
    } else {
      guardPos = newPos;
      if (!visited[newPos.first][newPos.second]) {
        count++;
      }
      visited[newPos.first][newPos.second] = true;
    }
  }

  return -1;
}

bool move(pair<int, int> &guardPos, vector<vector<int>> &directions, int &direc, vector<vector<char>> &map) {
  while (true) {
    pair<int, int> newPos(guardPos.first + directions[direc][0], guardPos.second + directions[direc][1]);
    if (!inBounds(newPos, map)) {
      return false;
    }

    if (map[newPos.first][newPos.second] == '#') {
      direc = (direc + 1) % directions.size();
    } else {
      guardPos = newPos;
      return true;
    }
  }

  return false;
}

bool detect_loop(pair<int, int> guardPos, vector<vector<char>> &map) {
  vector<vector<int>> directions = {
    {-1, 0},
    {0, 1},
    {1, 0},
    {0, -1}
  };
  pair<int, int> tortoise = guardPos;
  pair<int, int> hare = guardPos;
  int tDirec = 0, hDirec = 0;

  do {
    bool tInBounds = move(tortoise, directions, tDirec, map);

    bool hInBounds = move(hare, directions, hDirec, map);
    if (!hInBounds) {
      return false;
    }
    hInBounds = move(hare, directions, hDirec, map);
    if (!hInBounds) {
      return false;
    }
  } while (tortoise != hare || tDirec != hDirec);

  return true;
}

int part_two(pair<int, int> guardPos, vector<vector<char>> &map, vector<vector<bool>> &validPoses) {
  int count = 0;
  for (int r = 0; r < validPoses.size(); r++) {
    for (int c = 0; c < validPoses[r].size(); c++) {
      if (!validPoses[r][c]) {
        continue;
      }
      map[r][c] = '#';
      if (detect_loop(guardPos, map)) {
        count++;
      }
      map[r][c] = '.';
    }
  }
  return count - 1;
}

int main() {
  string filename = "inputs/day_6.txt";
  ifstream inputFile(filename);
  vector<vector<char>> map;

  if (!inputFile.is_open()) {
      cerr << "Error: Could not open the file " << filename << endl;
      return 1;
  }

  pair<int, int> guardPos(-1, -1);
  string line;
  while (getline(inputFile, line)) {
    vector<char> symbols(line.begin(), line.end());
    
    for (int i = 0; guardPos.first == -1 && i < symbols.size(); i++) {
      if (symbols[i] == '^') {
        guardPos.first = map.size() - 1;
        guardPos.second = i;
        break;
      }
    }

    map.push_back(symbols);
  }

  inputFile.close();

  vector<vector<bool>> visited(map.size(), vector<bool>(map[0].size(), false));
  cout << part_one(guardPos, map, visited) << endl;
  cout << part_two(guardPos, map, visited) << endl;
}