#include <fstream>
#include <iostream>
#include <sstream>
#include <vector>
#include <string>
#include <cstdint>

using namespace std;

struct Computer {
    int A, B, C;
    vector<int> input;

    Computer(int A, int B, int C) : A(A), B(B), C(C) {}

    int comboOperand(int op) {
        if (op >= 0 && op <= 3) return op;
        if (op == 4) return A;
        if (op == 5) return B;
        
        return C;
    }

    string processInput() {
        vector<int> output;

        for (size_t i = 0; i < input.size(); i += 2) {
            int op = input[i + 1];

            switch (input[i]) {
            case 0:
                A = A / (1 << comboOperand(op));
                break;
            case 1:
                B = B ^ op;
                break;
            case 2:
                B = comboOperand(op) % 8;
                break;
            case 3:
                if (A != 0) i = op - 2;
                break;
            case 4:
                B = B ^ C;
                break;
            case 5:
                output.push_back(comboOperand(op) % 8);
                break;
            case 6:
                B = A / (1 << comboOperand(op));
                break;
            case 7:
                C = A / (1 << comboOperand(op));
                break;
            }
        }
        
        string o;
        for (size_t j = 0; j < output.size(); ++j) {
            o += to_string(output[j]);
            if (j < output.size() - 1) o += ",";
        }
        
        return o;
    }
};

Computer readFile(string filepath) {
    ifstream f(filepath);

    if (!f) {
        cerr << "[ERROR] opening file: " << filepath << endl;
        exit(1);
    }

    vector<int> regs;
    regs.reserve(3);

    string line;
    while (getline(f, line)) {
        if (line.empty()) break;
        
        string numStr(line.begin() + 12, line.end());
        regs.push_back(stoi(numStr));
    }

    Computer cp(regs[0], regs[1], regs[2]);
    
    getline(f, line);

    line.erase(0, 9);
    stringstream ss(line);
    string token;
    while (getline(ss, token, ',')) cp.input.push_back(stoi(token));

    f.close();

    return cp;
}

int main(int argc, char* argv[]) {
    string filepath = "test.txt";

    if (argc == 2) filepath = argv[1];

    Computer cp = readFile(filepath);

    // Part 1
    string output = cp.processInput();
    cout << "Program output -> " << output << endl;
}