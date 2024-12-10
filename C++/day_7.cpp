#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <stack>
#include <cmath>
#include <sstream>

#include <boost/multiprecision/cpp_int.hpp> // Include Boost Multiprecision
#include <boost/lexical_cast.hpp>
using namespace boost::multiprecision;

using namespace std;

cpp_int part_one(vector<cpp_int> totals, vector<vector<cpp_int>> cases) {
  cpp_int sum = 0;

  for (int i = 0; i < totals.size(); i++) {
    cpp_int total = totals[i];
    vector<cpp_int> nums = cases[i];

    for (int combo = 0; combo < (1 << (nums.size() - 1)); combo++) {
      int tempCombo = combo;
      cpp_int testTotal = nums[0];
      for (int j = 1; j < nums.size(); j++) {
        int bit = tempCombo & 1;
        tempCombo = tempCombo >> 1;

        if (bit == 0) {
          testTotal += nums[j];
        } else {
          testTotal *= nums[j];
        }
      }

      if (testTotal == total) {
        sum += total;
        break;
      }
    }
  }

  return sum;
}

string toBase3(int num) {
  string base3Num = "";
  while (num > 0) {
    base3Num = to_string(num % 3) + base3Num;
    num /= 3;
  }
  return base3Num;
}

cpp_int part_two(vector<cpp_int> totals, vector<vector<cpp_int>> cases) {
  cpp_int sum = 0;

  for (int i = 0; i < totals.size(); i++) {
    cpp_int total = totals[i];
    vector<cpp_int> nums = cases[i];

    for (int combo = 0; combo < pow(3, nums.size() - 1); combo++) {
      int tempCombo = combo;
      cpp_int testTotal = nums[0];
      
      for (int j = 1; j < nums.size(); j++) {
        int option = tempCombo % 3;
        tempCombo /= 3;

        if (option == 0) {
          testTotal += nums[j];
        } else if (option == 1) {
          testTotal *= nums[j];
        } else {
          testTotal = cpp_int(testTotal.str() + nums[j].str());
        }
      }

      if (testTotal == total) {
        sum += total;
        break;
      }
    }
  }

  return sum;
}

int main() {
  string filename = "inputs/day_7.txt";
  ifstream inputFile(filename);

  if (!inputFile.is_open()) {
      cerr << "Error: Could not open the file " << filename << endl;
      return 1;
  }

  vector<cpp_int> totals;
  vector<vector<cpp_int>> cases;
  string line;
  while (getline(inputFile, line)) {
    int colonInd = line.find(":");
    // cout << line.substr(0, colonInd) << endl;
    totals.push_back(cpp_int(line.substr(0, colonInd)));

    vector<cpp_int> nums;
    // cout << line.substr(colonInd + 2) << endl;
    stringstream ss(line.substr(colonInd + 2));
    string num;
    while (std::getline(ss, num, ' ')) {
      nums.push_back(cpp_int(num));
    }
    cases.push_back(nums);
  }

  inputFile.close();

  /*
  for (cpp_int i : totals) {
    cout << i << endl;
  }
  */
  cout << part_one(totals, cases) << endl;
  cout << part_two(totals, cases) << endl;
}