import java.io.File;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Scanner;

public class HoofIt {
    private static final int[][] DIRECTIONS = {
        {0, 1},
        {1, 0},
        {0, -1},
        {-1, 0}
    };

    public static void main(String[] args) throws Exception {
        String filepath = (args.length == 0 || args[0] == null) ? "test.txt" : args[0];

        ArrayList<int[]> grid = readFile(filepath);

        System.out.println();
        
        // Part 1
        System.out.println("Trailheads sum -> " + trailheadsSum(grid));
    }

    private static ArrayList<int[]> readFile(String filepath) throws Exception {
        try {
            File file = new File(filepath);
            Scanner sc = new Scanner(file);

            ArrayList<int[]> r = new ArrayList<>((int)file.length());

            while (sc.hasNextLine()) {
                String line = sc.nextLine();
                int[] row = new int[line.length()];

                for (int i = 0; i < line.length(); i++) {
                    row[i] = Character.getNumericValue(line.charAt(i));
                }

                r.add(row);
            }

            sc.close();

            return r;
        } catch (Exception e) {
            throw new Exception(e);
        }
    }
    
    private static int trailheadsSum(ArrayList<int[]> grid) {
        int sum = 0;

        for (int i = 0; i < grid.size(); i++) {
            for (int j = 0; j < grid.get(0).length; j++) {
                if (grid.get(i)[j] == 0) {
                    HashSet<String> trailTops = new HashSet<>();

                    for (int[] dir : DIRECTIONS) sum += checkNextTrail(0, i+dir[0], j+dir[1], 0, grid, trailTops);
                }
            }
        }

        return sum;
    }

    private static int checkNextTrail(int sum, int i, int j, int prevStep, ArrayList<int[]> grid, HashSet<String> trailTops) {
        if (!isInBounds(i, j, grid.size(), grid.get(0).length)) return sum;
        
        int currStep = grid.get(i)[j];

        if (currStep != prevStep + 1) return sum;

        if (prevStep == 8 && currStep == 9) return trailTops.add(i + "," + j) ? sum + 1 : sum;

        for (int[] dir : DIRECTIONS) sum = checkNextTrail(sum, i+dir[0], j+dir[1], currStep, grid, trailTops);

        return sum;
    }

    private static boolean isInBounds(int i, int j, int rows, int cols) {
        return i >= 0 && i < rows && j >= 0 && j < cols;
    } 
}
