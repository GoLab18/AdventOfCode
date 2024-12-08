import java.io.File;
import java.util.*;

public class ResonantCollinearity {
    public static void main(String[] args) throws Exception {
        String filepath = (args.length == 0 || args[0] == null) ? "test.txt" : args[0];

        ArrayList<String> map = readFile(filepath);
        
        // Part 1
        System.out.println("Unique antinodes count-> " + calculateAntinodes(map));
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

    public static int calculateAntinodes(ArrayList<String> map) {
        int rows = map.size();
        int cols = map.get(0).length();
        Map<Character, List<int[]>> antennas = new HashMap<>();

        // Collecting antenna positions
        for (int r = 0; r < rows; r++) {
            for (int c = 0; c < cols; c++) {
                char ch = map.get(r).charAt(c);

                if (ch != '.') {
                    antennas.computeIfAbsent(ch, k -> new ArrayList<>()).add(new int[]{r, c});
                }
            }
        }

        Set<String> antinodes = new HashSet<>();

        // Computing antinodes
        for (Map.Entry<Character, List<int[]>> e : antennas.entrySet()) {
            List<int[]> positions = e.getValue();

            // Processing each antennas permutations
            for (int i = 0; i < positions.size(); i++) {
                for (int j = 0; j < positions.size(); j++) {
                    if (i == j) continue;

                    int[] ant1 = positions.get(i);
                    int[] ant2 = positions.get(j);

                    int r1 = ant1[0], c1 = ant1[1];
                    int r2 = ant2[0], c2 = ant2[1];

                    int dr = r2 - r1;
                    int dc = c2 - c1;

                    int anr1 = r1 - dr, anc1 = c1 - dc;
                    int anr2 = r2 + dr, anc2 = c2 + dc;

                    if (isWithinBounds(anr1, anc1, rows, cols)) antinodes.add(anr1 + "," + anc1);
                    if (isWithinBounds(anr2, anc2, rows, cols)) antinodes.add(anr2 + "," + anc2);
                }
            }
        }

        return antinodes.size();
    }

    private static boolean isWithinBounds(int r, int c, int rows, int cols) {
        return r >= 0 && r < rows && c >= 0 && c < cols;
    }
}
