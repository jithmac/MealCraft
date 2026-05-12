package scratch;

import org.projog.api.Projog;
import org.projog.api.QueryResult;
import java.io.File;

public class TestProjog {
    public static void main(String[] args) {
        try {
            System.out.println("Init Projog...");
            Projog projog = new Projog();
            File f = new File("../ai/mealCraft.pl");
            System.out.println("Loading " + f.getAbsolutePath());
            projog.consultFile(f);
            System.out.println("Loaded.");
            
            String query = "generate_daily_plan(1400, 2500, none, none, Plan, DayCals, DayCost).";
            System.out.println("Executing: " + query);
            long start = System.currentTimeMillis();
            QueryResult result = projog.executeQuery(query);
            if (result.next()) {
                System.out.println("Found match in " + (System.currentTimeMillis() - start) + "ms");
                System.out.println(result.getTerm("Plan").toString());
            } else {
                System.out.println("No match found in " + (System.currentTimeMillis() - start) + "ms");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
