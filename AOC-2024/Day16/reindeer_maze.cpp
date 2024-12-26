#include <iostream>
#include <fstream>
#include <vector>
#include <queue>
#include <map>
#include <climits>
#include <string>

using namespace std;

const int DIRECTIONS[4][2] = {{0, 1}, {-1, 0}, {0, -1}, {1, 0}};

struct State {
    int y, x, dir, cost;
    map<pair<int, int>, int>* path;

    State(int y, int x, int dir, int cost, map<pair<int, int>, int>* path)
        : y(y), x(x), dir(dir), cost(cost), path(path) {}

    bool operator>(const State& other) const { return cost > other.cost; }
};

struct MazeGrid {
    vector<vector<char>> grid;
    int sy, sx;

    pair<int, int> findMinScore() {
        int n = grid.size();
        int m = grid[0].size();

        vector<vector<vector<int>>> dist(n, vector<vector<int>>(m, vector<int>(4, INT_MAX)));

        vector<vector<vector<map<pair<int, int>, int>>>> paths(
            n, vector<vector<map<pair<int, int>, int>>>(m, vector<map<pair<int, int>, int>>(4)));

        priority_queue<State, vector<State>, greater<State>> pq;

        int minCost = INT_MAX;
        map<pair<int, int>, int> uniqueTiles;

        for (int dir = 0; dir < 4; dir++) {
            int rotationCost = ((dir - 0) == 3 ? 1 : (dir - 0)) * 1000;
            dist[sy][sx][dir] = rotationCost;

            paths[sy][sx][dir][{sy, sx}] = rotationCost;

            pq.push(State(sy, sx, dir, rotationCost, &paths[sy][sx][dir]));
        }

        while (!pq.empty()) {
            auto [y, x, dir, cost, path] = pq.top();
            pq.pop();

            if (dist[y][x][dir] < cost) continue;

            if (grid[y][x] == 'E' && minCost >= cost) {
                for (const auto &[k, v] : *path) uniqueTiles[k] = v;

                minCost = min(minCost, cost);
                continue;
            }

            int ny = y + DIRECTIONS[dir][0];
            int nx = x + DIRECTIONS[dir][1];

            if (grid[ny][nx] != '#' && cost + 1 == dist[ny][nx][dir]) {
                for (const auto &[k, v] : *path) paths[ny][nx][dir][k] = v;

                pq.push(State(ny, nx, dir, cost + 1, &paths[ny][nx][dir]));
            }

            if (grid[ny][nx] != '#' && cost + 1 < dist[ny][nx][dir]) {
                dist[ny][nx][dir] = cost + 1;

                paths[ny][nx][dir] = *path;
                paths[ny][nx][dir][{ny, nx}] = cost + 1;

                pq.push(State(ny, nx, dir, cost + 1, &paths[ny][nx][dir]));
            }

            for (int newDir = 0; newDir < 4; newDir++) {
                if (newDir == dir) continue;

                int rotationCost = (abs(newDir - dir) == 3 ? 1 : abs(newDir - dir)) * 1000;

                if (cost + rotationCost < dist[y][x][newDir]) {
                    dist[y][x][newDir] = cost + rotationCost;

                    paths[y][x][newDir] = *path;
                    paths[y][x][newDir][{y, x}] = cost + rotationCost;

                    pq.push(State(y, x, newDir, cost + rotationCost, &paths[y][x][newDir]));
                }
            }
        }

        return {minCost, uniqueTiles.size()};
    }
};

MazeGrid readFile(string filepath) {
    ifstream f(filepath);

    if (!f) {
        cerr << "[ERROR] opening file: " << filepath << endl;
        exit(1);
    }

    MazeGrid mg;

    string line;
    int i = 0;
    while (getline(f, line)) {
        vector<char> row(line.begin(), line.end());
        mg.grid.push_back(row);

        for (int j = 0; j < line.size(); j++) {
            if (mg.grid[i][j] == 'S') {
                mg.sy = i;
                mg.sx = j;
            }
        }

        i++;
    }

    f.close();

    return mg;
}

int main(int argc, char* argv[]) {
    string filepath = "test.txt";

    if (argc == 2) filepath = argv[1];

    MazeGrid mg = readFile(filepath);

    // Part 1
    auto [minScore, tileCount] = mg.findMinScore();
    cout << "Lowest score -> " << minScore << endl;

    // Part 2
    cout << "Visited tiles count -> " << tileCount << endl;
}
