package com.mealcraft.service;

import com.mealcraft.dto.MealDto;
import com.mealcraft.dto.MealPlanResponseDto;
import com.mealcraft.dto.UserPreferencesDto;
import com.mealcraft.exception.MealPlanNotFoundException;
import alice.tuprolog.Prolog;
import alice.tuprolog.SolveInfo;
import alice.tuprolog.Theory;
import org.springframework.stereotype.Service;

import jakarta.annotation.PostConstruct;
import java.io.File;
import java.io.FileInputStream;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
public class PrologService {
    private Theory cachedTheory;

    @PostConstruct
    public void init() {
        try {
            File prologFile = new File("../ai/mealCraft.pl");
            if (!prologFile.exists()) {
                throw new RuntimeException("Prolog file not found at " + prologFile.getAbsolutePath());
            }
            cachedTheory = new Theory(new FileInputStream(prologFile));
        } catch (Exception e) {
            throw new RuntimeException("Failed to load Prolog file", e);
        }
    }

    public MealPlanResponseDto generateMealPlan(UserPreferencesDto prefs) {
        String diet = "none";
        if (prefs.getDietaryRestrictions() != null && !prefs.getDietaryRestrictions().isEmpty()) {
            diet = prefs.getDietaryRestrictions().get(0).toLowerCase();
        }

        String health = "none"; 
        
        int tdee = calculateTDEE(prefs);
        int targetCals = Math.min(Math.max(tdee, 800), 1400);
        int maxBudget = Math.max(prefs.getBudget(), 500);

        String query = String.format("generate_daily_plan(%d, %d, %s, %s, Plan, DayCals, DayCost).",
                targetCals, maxBudget, diet, health);

        // Create a new engine for every request to ensure thread-safety and clean state
        Prolog engine = new Prolog();
        try {
            engine.setTheory(cachedTheory);
            SolveInfo result = engine.solve(query);
            
            // Collect up to 10 valid combinations
            java.util.List<SolveInfo> validPlans = new java.util.ArrayList<>();
            while (result.isSuccess() && validPlans.size() < 10) {
                validPlans.add(result);
                if (!engine.hasOpenAlternatives()) break;
                result = engine.solveNext();
            }

            if (!validPlans.isEmpty()) {
                // Pick a random plan from the valid ones
                SolveInfo randomResult = validPlans.get(new java.util.Random().nextInt(validPlans.size()));
                String planStr = randomResult.getVarValue("Plan").toString();

                MealPlanResponseDto response = new MealPlanResponseDto();
                response.setBreakfast(parseMeal(engine, planStr, "breakfast"));
                response.setLunch(parseMeal(engine, planStr, "lunch"));
                response.setDinner(parseMeal(engine, planStr, "dinner"));
                
                response.setTotalCals(Integer.parseInt(randomResult.getVarValue("DayCals").toString()));
                response.setTotalCost(Integer.parseInt(randomResult.getVarValue("DayCost").toString()));

                return response;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        throw new MealPlanNotFoundException("No meal plan found for " + targetCals + " kcal and budget Rs. " + maxBudget);
    }

    private MealDto parseMeal(Prolog engine, String planStr, String mealType) {
        Pattern p = Pattern.compile(mealType + "\\(\\[(.*?)\\]\\)");
        Matcher m = p.matcher(planStr);
        if (m.find()) {
            String itemsStr = m.group(1); 
            String[] items = itemsStr.split(",");
            String name = formatName(items[0].trim()) + " with " + formatName(items[1].trim()) + " & " + formatName(items[2].trim());

            String nutritionQuery = String.format("meal_nutrition([%s], Cals, Prot, Carbs, Fats, Cost).", itemsStr);
            try {
                SolveInfo nRes = engine.solve(nutritionQuery);
                if (nRes.isSuccess()) {
                    int cals = Integer.parseInt(nRes.getVarValue("Cals").toString());
                    int cost = Integer.parseInt(nRes.getVarValue("Cost").toString());
                    return new MealDto(name, cals, cost);
                }
            } catch (Exception e) {}
        }
        return new MealDto("Unknown Meal", 0, 0);
    }

    private String formatName(String atom) {
        String[] parts = atom.split("_");
        StringBuilder sb = new StringBuilder();
        for(String p : parts) {
            if (p.length() > 0) {
                sb.append(Character.toUpperCase(p.charAt(0))).append(p.substring(1)).append(" ");
            }
        }
        return sb.toString().trim();
    }

    private int calculateTDEE(UserPreferencesDto prefs) {
        double bmr;
        if ("male".equalsIgnoreCase(prefs.getGender())) {
            bmr = 88.362 + (13.397 * prefs.getWeight()) + (4.799 * prefs.getHeight()) - (5.677 * prefs.getAge());
        } else {
            bmr = 447.593 + (9.247 * prefs.getWeight()) + (3.098 * prefs.getHeight()) - (4.330 * prefs.getAge());
        }
        double multiplier = 1.55;
        if (prefs.getActivityLevel() != null) {
            switch (prefs.getActivityLevel().toLowerCase()) {
                case "sedentary": multiplier = 1.2; break;
                case "light": multiplier = 1.375; break;
                case "moderate": multiplier = 1.55; break;
                case "active": multiplier = 1.725; break;
                case "very-active": multiplier = 1.9; break;
            }
        }
        return (int) Math.round(bmr * multiplier);
    }
}
