#include <string>
#include <fstream>
#include <iostream>
#include <sstream>
#include <vector>
#include <queue>

using namespace std;

constexpr int DIRECTIONS[4][2] = {{0, 1}, {-1, 0}, {0, -1}, {1, 0}};

int bfs(vector<vector<bool>> memBlock, int n) {
    queue<pair<size_t, size_t>> q;
    int steps = 0;
    vector<vector<int>> dist(n, vector<int>(n, INT_MAX));

    q.push(pair<size_t, size_t>{0, 0});
    dist[0][0] = 0;

    while (!q.empty()) {
        auto [y, x] = q.front();
        q.pop();
        
        for (size_t i = 0; i < 4; i++) {
            size_t ny = y + DIRECTIONS[i][0], nx = x + DIRECTIONS[i][1];
            int nd = dist[y][x] + 1;

            if (ny < n && nx < n && ny >= 0 && nx >= 0 && !memBlock[ny][nx] && nd < dist[ny][nx]) {
                dist[ny][nx] = nd;
                q.push(pair<size_t, size_t>{ny, nx});
            }
        }
    }

    return dist[n-1][n-1];
}

pair<int, string> readAndSolve(string filepath, int n, int bytes) {
    vector<vector<bool>> memBlock(n, vector<bool>(n, false));
    ifstream f(filepath);
    
    int minStep = -1;
    string blockCoordsStr = "doesn't exist";
    
    if (!f) {
        cerr << "[ERROR] opening file: " << filepath << endl;
        exit(1);
    }

    string line;
    while (getline(f, line)) {
        stringstream ss(line);
        size_t x, y;
        char comma;

        ss >> x >> comma >> y;

        memBlock[y][x] = true;


        int step = bfs(memBlock, n);

        if (bytes == 0) minStep = step;

        if (step == INT_MAX) {
            blockCoordsStr = to_string(x) + "," + to_string(y);
            break;
        }

        bytes--;
    }

    f.close();
    
    return {minStep, blockCoordsStr};
}

int main(int argc, char* argv[]) {
    string filepath = "test.txt";
    int n = 7;
    int bytes = 12;

    if (argc == 4) {
        filepath = argv[1];
        n = stoi(argv[2]);
        bytes = stoi(argv[3]);
    }

    pair<int, string> ans = readAndSolve(filepath, n, bytes);

    // Part 1
    cout << "Min steps to exit -> " << ans.first << endl;

    // Part 2
    cout << "First blocking byte -> " << ans.second << endl;
}
