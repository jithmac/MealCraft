import alice.tuprolog.*;
import java.nio.file.Files;
import java.io.File;

public class TestProlog {
    public static void main(String[] args) throws Exception {
        Prolog engine = new Prolog();
        String baseTheory = new String(Files.readAllBytes(new File("../ai/mealCraft.pl").toPath()));
        
        // Add food facts for testing
        String dynamicTheory = "food(egg_boiled, intl, p, 100, 78, 1.1, 6.3, 5.3, [], [], '', [breakfast, lunch, dinner], []).\n" +
            "food(red_rice, sl, c, 100, 100, 20, 2, 0, [], [], '', [lunch, dinner], []).\n" +
            "food(oats, intl, c, 100, 300, 50, 10, 5, [], [], '', [breakfast], []).\n" +
            "food(banana, intl, c, 100, 90, 20, 1, 0, [], [], '', [breakfast, lunch], []).\n" +
            "food(milk_low_fat, intl, p, 100, 40, 5, 3, 1, [], [], '', [breakfast, dinner], []).\n" +
            "food(chicken_breast, intl, p, 100, 165, 0, 31, 3, [], [], '', [lunch, dinner], []).\n" +
            "food(parippu_dhal_curry, sl, p, 100, 100, 15, 8, 1, [], [], '', [breakfast, lunch, dinner], []).\n" +
            "food(gotu_kola_mallung, sl, v, 100, 70, 5, 2, 5, [], [], '', [lunch, dinner], []).\n" +
            "food(pumpkin_curry, sl, v, 100, 50, 10, 1, 1, [], [], '', [lunch, dinner], []).\n" +
            "food(string_hoppers, sl, c, 100, 150, 30, 3, 1, [], [], '', [breakfast, dinner], []).\n" +
            "food(ambul_thiyal, sl, p, 100, 120, 5, 20, 2, [], [], '', [lunch, dinner], []).\n" +
            "food(mung_bean_curry, sl, p, 100, 110, 20, 7, 1, [], [], '', [breakfast, lunch, dinner], []).\n" +
            "food(coconut_sambol, sl, v, 100, 150, 10, 2, 12, [], [], '', [breakfast, lunch, dinner], []).\n" +
            "food(plain_yogurt_low_fat, intl, p, 100, 60, 5, 5, 1, [], [], '', [breakfast, dinner], []).\n" +
            "food(breadfruit_boiled, sl, c, 100, 110, 25, 2, 0, [], [], '', [lunch, dinner], []).\n" +
            "food(plain_ceylon_tea, sl, v, 100, 2, 0, 0, 0, [], [], '', [breakfast, dinner], []).\n" +
            "food(brown_rice_cooked, intl, c, 100, 166, 35, 3, 1, [], [], '', [lunch, dinner], []).\n" +
            "food(salmon, intl, p, 100, 206, 0, 22, 13, [], [], '', [lunch, dinner], []).\n" +
            "food(kurakkan_roti, sl, c, 100, 200, 40, 5, 2, [], [], '', [breakfast, dinner], []).\n" +
            "food(snake_gourd_curry, sl, v, 100, 40, 8, 1, 1, [], [], '', [lunch, dinner], []).\n" +
            "food(apple, intl, v, 100, 52, 14, 0.3, 0.2, [], [], '', [breakfast, lunch], []).\n" +
            "food(quinoa_cooked, intl, c, 100, 120, 21, 4, 2, [], [], '', [lunch, dinner], []).\n" +
            "food(tuna_canned, intl, p, 100, 132, 0, 28, 2, [], [], '', [lunch, dinner], []).\n" +
            "food(cucumber_raw, intl, v, 100, 15, 4, 1, 0, [], [], '', [breakfast, lunch, dinner], []).\n" +
            "food(tomato_raw, intl, v, 100, 22, 5, 1, 0, [], [], '', [breakfast, lunch, dinner], []).\n" +
            "food(broccoli_steamed, intl, v, 100, 31, 6, 3, 0, [], [], '', [lunch, dinner], []).\n" +
            "food(spinach_cooked, intl, v, 100, 41, 7, 5, 0, [], [], '', [lunch, dinner], []).\n" +
            "food(sweet_potato_baked, intl, c, 100, 90, 21, 2, 0, [], [], '', [lunch, dinner], []).\n" +
            "food(tofu_firm, intl, p, 100, 144, 3, 16, 9, [], [], '', [lunch, dinner], []).\n" +
            "food(kola_kenda, sl, v, 100, 50, 10, 1, 0, [], [], '', [breakfast], []).\n" +
            "food(almonds, intl, f, 100, 579, 22, 21, 50, [], [], '', [breakfast], []).\n" +
            "food(cowpea_curry, sl, p, 100, 120, 20, 8, 1, [], [], '', [lunch, dinner], []).\n" +
            "food(chickpeas_boiled, intl, p, 100, 164, 27, 9, 3, [], [], '', [lunch, dinner], []).\n" +
            "food(cassava_boiled, sl, c, 100, 160, 38, 1, 0, [], [], '', [breakfast, dinner], []).\n";

        Theory theory = new Theory(dynamicTheory + baseTheory);
        engine.setTheory(theory);
        SolveInfo result = engine.solve("backup_meal_plan(2335, omnivore, [], diet, Plan, TotalCals).");
        int count = 0;
        while (result.isSuccess()) {
            count++;
            System.out.println("Plan " + count + ": " + result.getVarValue("Plan"));
            if (engine.hasOpenAlternatives()) {
                result = engine.solveNext();
            } else {
                break;
            }
        }
        System.out.println("Total plans: " + count);
    }
}
