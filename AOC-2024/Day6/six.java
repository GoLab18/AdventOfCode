import java.io.File;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Map;
import java.util.Scanner;

public class six {
    private static int[] currentDirection = new int[2];
    private static int[] currentPosition = new int[2];
    private static HashSet<String> visitedPositions = new HashSet<>();

    private static final Map<Character, int[]> directions = Map.of(
        '^', new int[]{-1, 0},
        '<', new int[]{0, -1},
        'v', new int[]{1, 0},
        '>', new int[]{0, 1}
    );

    public static void main(String[] args) throws Exception {
        String filepath = (args.length == 0 || args[0] == null) ? "test.txt" : args[0];

        ArrayList<char[]> charMatrix = readFile(filepath);

        simulateGuardMovement(charMatrix);
        
        System.out.println("Distinct positions visited -> " + visitedPositions.size());
    }

    private static void simulateGuardMovement(ArrayList<char[]> charMatrix) {
        while (true) {
            visitedPositions.add(currentPosition[0] + "," + currentPosition[1]);
            
            int nextRow = currentPosition[0] + currentDirection[0];
            int nextCol = currentPosition[1] + currentDirection[1];

            if (nextRow < 0 || nextRow >= charMatrix.size() || nextCol < 0 || nextCol >= charMatrix.get(nextRow).length) {
                break;
            }

            if (charMatrix.get(nextRow)[nextCol] == '#') turnRight();
            else {
                currentPosition[0] = nextRow;
                currentPosition[1] = nextCol;
            }
        }
    }
    
    private static ArrayList<char[]> readFile(String filepath) throws Exception {
        try {
            File file = new File(filepath);
            Scanner sc = new Scanner(file);

            ArrayList<char[]> r = new ArrayList<>((int)file.length());

            int row = 0;
            while (sc.hasNextLine()) {
                char[] lineChars = sc.nextLine().toCharArray();

                for (int col = 0; col < lineChars.length; col++) {
                    int[] dir = directions.get(lineChars[col]);

                    if (dir != null) {
                        currentDirection = dir;
                        currentPosition[0] = row;
                        currentPosition[1] = col;
                    }                    
                }

                r.add(lineChars);

                row++;
            }

            sc.close();

            return r;
        } catch (Exception e) {
            throw new Exception(e);
        }
    }

    private static void turnRight() {
        if (currentDirection == directions.get('^')) {
            currentDirection = directions.get('>');
        } else if (currentDirection == directions.get('>')) {
            currentDirection = directions.get('v');
        } else if (currentDirection == directions.get('v')) {
            currentDirection = directions.get('<');
        } else if (currentDirection == directions.get('<')) {
            currentDirection = directions.get('^');
        }
    }
}