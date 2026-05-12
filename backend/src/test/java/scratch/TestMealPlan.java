package scratch;

import alice.tuprolog.Prolog;
import alice.tuprolog.SolveInfo;
import alice.tuprolog.Theory;

import java.io.File;
import java.io.FileInputStream;

public class TestMealPlan {
    public static void main(String[] args) {
        try {
            File f = new File("../ai/mealCraft.pl");
            Theory t = new Theory(new FileInputStream(f));
            Prolog engine = new Prolog();
            engine.setTheory(t);

            String[] queries = {
                "backup_meal_plan(2635, omnivore, [], Plan, TotalCals)."
            };

            for (String q : queries) {
                System.out.println("Query: " + q);
                SolveInfo info = engine.solve(q);
                if (info.isSuccess()) {
                    System.out.println("Success!");
                    System.out.println("Plan: " + info.getVarValue("Plan"));
                    System.out.println("TotalCals: " + info.getVarValue("TotalCals"));
                } else {
                    System.out.println("Failed.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
