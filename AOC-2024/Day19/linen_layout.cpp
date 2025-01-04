#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <unordered_set>
#include <unordered_map>
#include <algorithm>

using namespace std;

pair<unordered_set<string>, vector<string>> readFile(string filepath) {
    ifstream f(filepath);

    if (!f) {
        cerr << "[ERROR] opening file: " << filepath << endl;
        exit(1);
    }

    string line;
    unordered_set<string> patterns;
    while (getline(f, line) && !line.empty()) {
        size_t i = 0;

        while ((i = line.find(", ")) != string::npos) {
            patterns.insert(line.substr(0, i));
            line.erase(0, i + 2);
        }

        patterns.insert(line);
    }

    vector<string> designs;
    while (getline(f, line)) {
        if (!line.empty()) designs.push_back(line);
    }
    
    f.close();

    return {patterns, designs};
}

bool canCreatePattern(const string& design, const unordered_set<string>& patterns, unordered_map<string, bool>& memo) {
    if (design.empty()) return true;

    if (memo.find(design) != memo.end()) return memo[design];

    for (const string& p : patterns) {
        if (design.substr(0, p.size()) == p) {
            if (canCreatePattern(design.substr(p.size()), patterns, memo)) return memo[design] = true;
        }
    }

    return memo[design] = false;
}

int getPossibleDesignsCount(unordered_set<string>& patterns, vector<string>& designs) {
    int c = 0;
    unordered_map<string, bool> memoized;

    for (const string& d : designs) if (canCreatePattern(d, patterns, memoized)) c++;

    return c;
}

int main(int argc, char* argv[]) {
    string filepath = "test.txt";

    if (argc == 2) filepath = argv[1];

    auto [patterns, designs] = readFile(filepath);

    // Part 1
    cout << "Possible designs count -> " << getPossibleDesignsCount(patterns, designs) << endl;
}
