import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Scanner;

public class ResonantCollinearity {
    public static void main(String[] args) throws Exception {
        String filepath = (args.length == 0 || args[0] == null) ? "test.txt" : args[0];

        ArrayList<String> map = readFile(filepath);
        
        // Part 1
        System.out.println("Unique antinodes count -> " + calculateAntinodes(map, false));

        // Part2
        System.out.println("Unique antinodes count with resonant harmonics -> " + calculateAntinodes(map, true));
    }

    private static ArrayList<String> readFile(String filepath) throws Exception {
        try {
            File file = new File(filepath);
            Scanner sc = new Scanner(file);

            ArrayList<String> r = new ArrayList<>((int)file.length());

            while (sc.hasNextLine()) {
                r.add(sc.nextLine());
            }

            sc.close();

            return r;
        } catch (Exception e) {
            throw new Exception(e);
        }
    }

    private static int calculateAntinodes(ArrayList<String> map, boolean areHarmonicsProcessed) {
        int rows = map.size();
        int cols = map.get(0).length();
        HashMap<Character, ArrayList<int[]>> antennas = new HashMap<>();

        for (int r = 0; r < rows; r++) {
            for (int c = 0; c < cols; c++) {
                char ch = map.get(r).charAt(c);

                if (ch != '.') {
                    antennas.computeIfAbsent(ch, k -> new ArrayList<>()).add(new int[]{r, c});
                }
            }
        }

        HashSet<String> antinodes = new HashSet<>();

        for (HashMap.Entry<Character, ArrayList<int[]>> e : antennas.entrySet()) {
            ArrayList<int[]> positions = e.getValue();

            if (areHarmonicsProcessed && positions.size() > 1) {
                for (int[] position : positions) {
                    antinodes.add(position[0] + "," + position[1]);
                }
            }

            for (int i = 0; i < positions.size(); i++) {
                for (int j = 0; j < positions.size(); j++) {
                    if (i == j) continue;

                    int[] ant1 = positions.get(i);
                    int[] ant2 = positions.get(j);

                    int r1 = ant1[0], c1 = ant1[1];
                    int r2 = ant2[0], c2 = ant2[1];

                    int dr = r2 - r1;
                    int dc = c2 - c1;
                    
                    int k = 1;
                    while (true) {
                        int anr1 = r1 - k*dr, anc1 = c1 - k*dc;
                        int anr2 = r2 + k*dr, anc2 = c2 + k*dc;

                        boolean pred1 = isWithinBounds(anr1, anc1, rows, cols);
                        boolean pred2 = isWithinBounds(anr2, anc2, rows, cols);
                        if (pred1) antinodes.add(anr1 + "," + anc1);
                        if (pred2) antinodes.add(anr2 + "," + anc2);

                        if ((!pred1 && !pred2) || !areHarmonicsProcessed) break;

                        k++;
                    }

                }
            }
        }

        return antinodes.size();
    }

    private static boolean isWithinBounds(int r, int c, int rows, int cols) {
        return r >= 0 && r < rows && c >= 0 && c < cols;
    }
}
