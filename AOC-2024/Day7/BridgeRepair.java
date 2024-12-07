import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Scanner;

public class BridgeRepair {
    public static void main(String[] args) throws Exception {
        String filepath = (args.length == 0 || args[0] == null) ? "test.txt" : args[0];

        BridgeRepair br = new BridgeRepair();

        ArrayList<Equation> eqs = br.readFile(filepath);

        // Part 1
        System.out.println("Total calibration result -> " + br.calcCalibrationResult(eqs));
    }

    private long calcCalibrationResult(ArrayList<Equation> eqs) {
        long calRes = 0;

        for (Equation eq : eqs) {
            calRes += isCombinationFound(eq.nums[0], 1, eq) ? eq.value : 0;  
        }

        return calRes;
    }

    private boolean isCombinationFound(long currResult, int i, Equation eq) {
        if (currResult > eq.value) return false;
        if (i >= eq.nums.length) return currResult == eq.value;

        long addRes = currResult + eq.nums[i];
        if (isCombinationFound(addRes, i+1, eq)) return true;

        long mulRes = currResult * eq.nums[i];
        if (isCombinationFound(mulRes, i+1, eq)) return true;

        return false;
    }
    
    private ArrayList<Equation> readFile(String filepath) throws Exception {
        try {
            File file = new File(filepath);
            Scanner sc = new Scanner(file);

            ArrayList<Equation> equations = new ArrayList<>((int) file.length());

            while (sc.hasNextLine()) {
                String[] line = sc.nextLine().split(": ", 2);

                long testVal = Long.parseLong(line[0]);
                long[] nums = Arrays.stream(line[1].split(" ")).mapToLong(Long::parseLong).toArray();

                equations.add(new Equation(testVal, nums));
            }

            sc.close();

            return equations;
        } catch (Exception e) {
            throw new Exception(e);
        }
    }

    private static class Equation {
        private long value;
        private long[] nums;

        public Equation(long value, long[] nums) {
            this.value = value;
            this.nums = nums;
        }
    }
}