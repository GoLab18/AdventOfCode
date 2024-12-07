import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Objects;
import java.util.Scanner;

public class GuardGallivant {
    private static final int[][] DIRECTIONS = {{0, -1}, {1, 0}, {0, 1}, {-1, 0}};
    private final ArrayList<char[]> charMatrix = new ArrayList<>();
    private final HashSet<Position> visited = new HashSet<>();
    private Position startPos;

    public static void main(String[] args) throws Exception {
        String filepath = (args.length == 0 || args[0] == null) ? "test.txt" : args[0];

        GuardGallivant gl = new GuardGallivant();

        gl.readFile(filepath);
        int loopCount = gl.detectLoops();

        // Part 1
        System.out.println("Distinct positions visited -> " + gl.visited.size());

        // Part 2
        System.out.println("Valid obstruction positions count -> " + loopCount);
    }

    private void readFile(String filepath) throws Exception {
        try {
            File file = new File(filepath);
            Scanner sc = new Scanner(file);

            ArrayList<char[]> r = new ArrayList<>((int)file.length());

            int row = 0;
            while (sc.hasNextLine()) {
                char[] lineChars = sc.nextLine().toCharArray();

                for (int col = 0; col < lineChars.length; col++) {
                    if (lineChars[col] == '^') {
                        startPos = new Position(col, row);
                    }                    
                }

                r.add(lineChars);
                row++;
            }

            sc.close();

            charMatrix.addAll(r);
        } catch (Exception e) {
            throw new Exception(e);
        }
    }

    private int detectLoops() {
        final HashMap<Position, Boolean> detectedLoops = new HashMap<>();
        Position currentPos = startPos;
        int currentDir = 0;

        while (true) {
            visited.add(currentPos);
            Position nextPos = getNextPosition(currentPos, currentDir);

            if (isOutOfBounds(nextPos)) {
                break;
            }

            if (isObstacle(nextPos)) {
                currentDir = turnRight(currentDir);
                continue;
            }

            if (!detectedLoops.containsKey(nextPos) && !visited.contains(nextPos) && !(charMatrix.get(nextPos.y)[nextPos.x] == '^')) {
                if (checkForLoop(currentPos, turnRight(currentDir), nextPos)) {
                    detectedLoops.put(nextPos, true);
                }
            }

            currentPos = nextPos;
        }

        return detectedLoops.size();
    }
    
    private boolean checkForLoop(Position startPos, int currDir, Position obstacle) {
        HashSet<PositionDirection> trace = new HashSet<>();
        Position currPos = startPos;

        while (true) {
            Position nextPos = getNextPosition(currPos, currDir);

            if (isOutOfBounds(nextPos)) {
                return false;
            }

            if (isObstacle(nextPos) || nextPos.equals(obstacle)) {
                currDir = turnRight(currDir);
                continue;
            }

            PositionDirection pd = new PositionDirection(nextPos, currDir);

            if (!trace.add(pd)) {
                return true;
            }

            currPos = nextPos;
        }
    }

    private Position getNextPosition(Position pos, int dir) {
        return new Position(pos.x + DIRECTIONS[dir][0], pos.y + DIRECTIONS[dir][1]);
    }

    private boolean isObstacle(Position pos) {
        return charMatrix.get(pos.y)[pos.x] == '#';
    }

    private boolean isOutOfBounds(Position pos) {
        return pos.x < 0 || pos.x >= charMatrix.get(0).length || pos.y < 0 || pos.y >= charMatrix.size();
    }

    private int turnRight(int dir) {
        return (dir + 1) % 4;
    }

    private static class Position {
        final int x, y;

        Position(int x, int y) {
            this.x = x;
            this.y = y;
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (!(o instanceof Position)) return false;

            Position position = (Position) o;
            return x == position.x && y == position.y;
        }

        @Override
        public int hashCode() {
            return Objects.hash(x, y);
        }
    }

    private static class PositionDirection {
        final Position position;
        final int direction;

        PositionDirection(Position position, int direction) {
            this.position = position;
            this.direction = direction;
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (!(o instanceof PositionDirection)) return false;

            PositionDirection that = (PositionDirection) o;
            return direction == that.direction && position.equals(that.position);
        }

        @Override
        public int hashCode() {
            return Objects.hash(position, direction);
        }
    }
}
