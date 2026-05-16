import alice.tuprolog.*;
import java.nio.file.Files;
import java.io.File;

public class TestConditions {
    public static void main(String[] args) throws Exception {
        Prolog engine = new Prolog();
        String baseTheory = new String(Files.readAllBytes(new File("../ai/mealCraft.pl").toPath()));
        
        Theory theory = new Theory(baseTheory); 
        engine.setTheory(theory);
        SolveInfo result = engine.solve("backup_meal_plan(2635, omnivore, [hypertension], normal, Plan, TotalCals).");
        if (result.isSuccess()) {
            System.out.println("Success");
        } else {
            System.out.println("Failed");
        }
    }
}
