import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;

public class DiskFragmenter {
    public static void main(String[] args) throws Exception {
        String filepath = (args.length == 0 || args[0] == null) ? "test.txt" : args[0];

        ArrayList<Integer> seq = readFile(filepath);
        
        // Part 1
        System.out.println("Filesystem checksum -> " + filesystemChecksum(seq));
    }

    private static ArrayList<Integer> readFile(String filepath) throws Exception {
        try {
            BufferedReader br = new BufferedReader(new FileReader(filepath));
            ArrayList<Integer> al = new ArrayList<>();

            int i = 0;
            boolean isFreeBlockNum = false;
            int c;
            while ((c = br.read()) != -1) {
                int chNum = (char) c - '0';
                
                if (isFreeBlockNum) for (int j = 0; j < chNum; j++) al.add(-1);
                else for (int j = 0; j < chNum; j++) al.add(i);

                isFreeBlockNum = !isFreeBlockNum;
                if (!isFreeBlockNum) i++;
            }
    
            br.close();

            return al;
        } catch (Exception e) {
            throw new Exception(e);
        }
    }

    private static long filesystemChecksum(ArrayList<Integer> seq) {
        int i = 0;
        int j = seq.size()-1;
        
        while (true) {
            if (i == j) break;

            int prev = seq.get(i);
            int next = seq.get(j);
            
            if (prev == -1) {
                if (next != -1) {
                    seq.set(i, next);
                    seq.set(j, -1);
                    i++;
                }
                
                j--;
                continue;
            }

            i++;
        }

        // Actual sum
        long sum = 0;
        for (int k = 0; k < seq.size(); k++) {
            int s = seq.get(k);
            if (s != -1) sum += k*s;
        }

        return sum;
    }
}
