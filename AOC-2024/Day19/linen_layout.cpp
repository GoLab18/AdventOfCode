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

long long designWays(const string& design, const unordered_set<string>& patterns, unordered_map<string, long long>& memo) {
    if (design.empty()) return 1;

    if (memo.find(design) != memo.end()) return memo[design];

    long long possibleVariations = 0;

    for (const string& p : patterns) {
        if (design.substr(0, p.size()) == p) {
            possibleVariations += designWays(design.substr(p.size()), patterns, memo);
        }
    }

    return memo[design] = possibleVariations;
}

pair<int, long long> calcDesigns(unordered_set<string>& patterns, vector<string>& designs) {
    int possibleDesigns = 0;
    long long totalArrangements = 0;
    
    unordered_map<string, long long> memo;

    for (const string& d : designs) {
        long long w = designWays(d, patterns, memo);

        if (w > 0) possibleDesigns++;
        totalArrangements += w;
    }

    return {possibleDesigns, totalArrangements};
}

int main(int argc, char* argv[]) {
    string filepath = "test.txt";

    if (argc == 2) filepath = argv[1];

    auto [patterns, designs] = readFile(filepath);

    auto [possibleDesigns, possibleDesignsWays] = calcDesigns(patterns, designs);

    // Part 1
    cout << "Possible designs count -> " << possibleDesigns << endl;

    // Part 2
    cout << "Different possible ways for designs sum -> " << possibleDesignsWays << endl;
}
