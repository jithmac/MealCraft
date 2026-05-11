package scratch;

import alice.tuprolog.Prolog;
import alice.tuprolog.SolveInfo;
import alice.tuprolog.Theory;
import java.io.FileInputStream;

public class TestTuprolog {
    public static void main(String[] args) {
        try {
            System.out.println("Init tuProlog...");
            Prolog engine = new Prolog();
            engine.setTheory(new Theory(new FileInputStream("../ai/mealCraft.pl")));
            System.out.println("Loaded.");
            
            String query = "generate_daily_plan(1400, 2500, none, none, Plan, DayCals, DayCost).";
            System.out.println("Executing: " + query);
            long start = System.currentTimeMillis();
            SolveInfo info = engine.solve(query);
            if (info.isSuccess()) {
                System.out.println("Found match in " + (System.currentTimeMillis() - start) + "ms");
                System.out.println(info.getVarValue("Plan").toString());
            } else {
                System.out.println("No match found in " + (System.currentTimeMillis() - start) + "ms");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
