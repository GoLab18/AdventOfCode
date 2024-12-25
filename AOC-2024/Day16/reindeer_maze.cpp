#include <iostream>
#include <fstream>
#include <vector>
#include <queue>
#include <string>
#include <climits>

using namespace std;

const int DIRECTIONS[4][2] = {{0, 1}, {-1, 0}, {0, -1}, {1, 0}};

struct State {
    int y, x, dir, cost;

    State(int y, int x, int dir, int cost) : y(y), x(x), dir(dir), cost(cost) {}

    bool operator>(const State& other) const { return cost > other.cost; }
};

struct MazeGrid {
    vector<vector<char>> grid;
    int sy, sx;

    int findMinScore() {
        int n = grid.size();
        int m = grid[0].size();

        vector<vector<vector<int>>> dist(n, vector<vector<int>>(m, vector<int>(4, INT_MAX)));

        priority_queue<State, vector<State>, greater<State>> pq;

        for (int dir = 0; dir < 4; dir++) {
            int rotationCost = ((dir - 0) == 3 ? 1 : (dir - 0)) * 1000;

            dist[sy][sx][dir] = rotationCost;
            pq.push(State(sy, sx, dir, rotationCost));
        }
        
        while (!pq.empty()) {
            auto [y, x, dir, cost] = pq.top();

            pq.pop();

            if (dist[y][x][dir] < cost) continue;

            if (grid[y][x] == 'E') {
                return cost;
            }

            int ny = y + DIRECTIONS[dir][0];
            int nx = x + DIRECTIONS[dir][1];

            if (isValid(ny, nx) && cost + 1 < dist[ny][nx][dir]) {
                dist[ny][nx][dir] = cost + 1;
                pq.push(State(ny, nx, dir, cost + 1));
            }

            for (int newDir = 0; newDir < 4; newDir++) {
                if (newDir == dir) continue;

                int rotationCost = (abs(newDir - dir) == 3 ? 1 : abs(newDir - dir)) * 1000;
                
                if (cost + rotationCost < dist[y][x][newDir]) {
                    dist[y][x][newDir] = cost + rotationCost;
                    pq.push(State(y, x, newDir, cost + rotationCost));
                }
            }
        }

        return INT_MAX;
    }

    bool isValid(int y, int x) {
        return y >= 0 && y < grid.size() && x >= 0 && x < grid[0].size() && grid[y][x] != '#';
    }
};

MazeGrid readFile(string filepath) {
    ifstream f(filepath);

    if (!f) {
        std::cerr << "[ERROR] opening file: " << filepath << std::endl;
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

int main(int argc, char *argv[]) {
    string filepath = "test.txt";

    if (argc == 2) filepath = argv[1];

    MazeGrid mg = readFile(filepath);

    cout << "Lowest score -> " << mg.findMinScore() << endl;
}
