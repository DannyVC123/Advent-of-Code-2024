#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <utility>
#include <map>
#include <cmath>

using namespace std;

bool inBounds(pair<int, int>& ind, int r, int c) {
  return 0 <= ind.first && ind.first < r && 0 <= ind.second && ind.second < c;
}

int antinode(pair<int, int>& pairOne, pair<int, int>& pairTwo, vector<vector<bool>>& visited) {
  int r1 = pairOne.first, c1 = pairOne.second;
  int r2 = pairTwo.first, c2 = pairTwo.second;
  int dr = r2 - r1, dc = c2 - c1;

  pair<int, int> vecPos(r1 + dr * 2, c1 + dc * 2);
  pair<int, int> vecNeg(r1 - dr, c1 - dc);

  int count = 0;
  if (inBounds(vecPos, visited.size(), visited[0].size())) {
    if (!visited[vecPos.first][vecPos.second]) {
      count++;
      visited[vecPos.first][vecPos.second] = true;
    }
  }
  if (inBounds(vecNeg, visited.size(), visited[0].size())) {
    if (!visited[vecNeg.first][vecNeg.second]) {
      count++;
      visited[vecNeg.first][vecNeg.second] = true;
    }
  }
  return count;
}

int antinodeTwo(pair<int, int>& pairOne, pair<int, int>& pairTwo, vector<vector<bool>>& visited) {
  int r1 = pairOne.first, c1 = pairOne.second;
  int r2 = pairTwo.first, c2 = pairTwo.second;
  int dr = r2 - r1, dc = c2 - c1;

  int count = 0;
  pair<int, int> vecPos(r1 + dr, c1 + dc);
  while (inBounds(vecPos, visited.size(), visited[0].size())) {
    if (!visited[vecPos.first][vecPos.second]) {
      count++;
      visited[vecPos.first][vecPos.second] = true;
    }
    vecPos.first += dr;
    vecPos.second += dc;
  }
  pair<int, int> vecNeg(r2 - dr, c2 - dc);
  while (inBounds(vecNeg, visited.size(), visited[0].size())) {
    if (!visited[vecNeg.first][vecNeg.second]) {
      count++;
      visited[vecNeg.first][vecNeg.second] = true;
    }
    vecNeg.first -= dr;
    vecNeg.second -= dc;
  }
  return count;
}

int solve(map<char, vector<pair<int, int>>>& antennas, vector<vector<bool>> visited, bool partOne) {
  int count = 0;
  for (auto& pair : antennas) {
    for (int i = 0; i < pair.second.size() - 1; i++) {
      for (int j = i + 1; j < pair.second.size(); j++) {
        if (partOne) {
          count += antinode(pair.second[i], pair.second[j], visited);
        } else {
          count += antinodeTwo(pair.second[i], pair.second[j], visited);
        }
      }
    }
  }
  return count;
}

int main() {
  string filename = "inputs/day_8.txt";
  ifstream inputFile(filename);

  if (!inputFile.is_open()) {
      cerr << "Error: Could not open the file " << filename << endl;
      return 1;
  }
  
  map<char, vector<pair<int, int>>> antennas;
  vector<vector<bool>> visited;

  string line;
  int currLine = 0;
  while (getline(inputFile, line)) {
    //cout << line << endl;
    for (int i = 0; i < line.length(); i++) {
      if (line[i] != '.') {
        pair<int, int> ind(currLine, i);
        if (antennas.count(line[i])) {
          antennas[line[i]].push_back(ind);
        } else {
          vector<pair<int, int>> antennaInds;
          antennaInds.push_back(ind);
          antennas[line[i]] = antennaInds;
        }
      }
    }

    vector<bool> visitedLine(line.length(), false);
    visited.push_back(visitedLine);
    currLine++;
  }

  inputFile.close();
  
  cout << solve(antennas, visited, true) << endl;
  cout << solve(antennas, visited, false) << endl;
}