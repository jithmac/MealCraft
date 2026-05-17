package com.mealcraft.service;

import com.mealcraft.dto.FoodItemDto;
import com.mealcraft.dto.MealDto;
import com.mealcraft.dto.MealPlanResponseDto;
import com.mealcraft.dto.UserPreferencesDto;
import com.mealcraft.entity.FoodEntity;
import com.mealcraft.repository.FoodRepository;
import com.mealcraft.exception.MealPlanNotFoundException;
import com.mealcraft.exception.UnsafeCalorieException;
import alice.tuprolog.Prolog;
import alice.tuprolog.SolveInfo;
import alice.tuprolog.Theory;
import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Autowired;

import jakarta.annotation.PostConstruct;
import java.io.File;
import java.io.FileInputStream;
import java.nio.file.Files;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
public class PrologService {

    @Autowired
    private FoodRepository foodRepository;

    public void init() {
    }

    public synchronized MealPlanResponseDto generateMealPlan(UserPreferencesDto prefs) {
        int tdee;
        String goal;
        
        if (prefs.getExactCalories() != null && prefs.getExactCalories() > 0) {
            tdee = prefs.getExactCalories();
            goal = "normal";
        } else {
            tdee = calculateTDEE(prefs);
            goal = prefs.getGoal() != null && !prefs.getGoal().isEmpty() ? prefs.getGoal().toLowerCase() : "normal";
            if ("diet".equals(goal)) {
                tdee -= 300;
            } else if ("bulk".equals(goal)) {
                tdee += 300;
            }
        }
        
        if (tdee < 1500) {
            throw new UnsafeCalorieException("Calculated calories are below 1500 kcal (" + tdee + " kcal). Please consult a doctor.");
        }
        if (tdee > 4500) {
            throw new UnsafeCalorieException("Calculated calories are above 4500 kcal (" + tdee + " kcal). Please consult a nutritionist.");
        }

        String diet = prefs.getDiet() != null && !prefs.getDiet().isEmpty() ? prefs.getDiet().toLowerCase() : "omnivore";
        
        List<String> conditions = prefs.getHealthConditions() != null ? prefs.getHealthConditions() : new ArrayList<>();
        String conditionsStr = "[" + String.join(",", conditions) + "]";

        // Cap TDEE for practical meal generation — the food database
        // can't realistically produce plans above ~4000 kcal
        tdee = Math.min(tdee, 4000);

        Prolog engine = new Prolog();
        try {
            File prologFile = new File("../ai/mealCraft.pl");
            String baseTheory = new String(Files.readAllBytes(prologFile.toPath()));
            
            // Build dynamic theory from database
            List<FoodEntity> foods = foodRepository.findAll();
            StringBuilder dynamicTheory = new StringBuilder();
            Map<String, Double> costMap = new HashMap<>();
            for (FoodEntity food : foods) {
                costMap.put(food.getFoodName(), food.getCostLkr() != null ? food.getCostLkr() : 0.0);
                dynamicTheory.append(String.format("food(%s, %s, %s, %d, %s, %s, %s, %s, [%s], [%s], '%s', [%s], [%s]).\n",
                        food.getFoodName(),
                        food.getOrigin() != null && !food.getOrigin().isEmpty() ? food.getOrigin() : "international",
                        food.getCategory(),
                        food.getServingSize(),
                        food.getCalories(),
                        food.getCarbs(),
                        food.getProtein(),
                        food.getFats(),
                        food.getMicronutrients() != null ? food.getMicronutrients() : "",
                        food.getAllergens() != null ? food.getAllergens() : "",
                        food.getStorageNote() != null ? food.getStorageNote().replace("'", "''") : "",
                        food.getMealTags() != null ? food.getMealTags() : "",
                        food.getDietaryTags() != null ? food.getDietaryTags() : ""
                ));
            }

            Theory theory = new Theory(dynamicTheory.toString() + "\n" + baseTheory);
            engine.setTheory(theory);

            // =============================================================
            // PHASE 1: Use Prolog to collect all valid foods per role & meal
            // with progressive fallback when pools are empty
            // =============================================================
            String[][] fallbackConfigs = {
                { diet, conditionsStr },                     // Try 1: exact diet + conditions
                { diet, "[]" },                              // Try 2: diet only, drop conditions
                { "omnivore", conditionsStr },                // Try 3: omnivore + conditions
                { "omnivore", "[]" }                          // Try 4: omnivore, no conditions
            };

            List<String> bfBases = null, bfProteins = null, bfLights = null;
            List<String> luBases = null, luProteins = null, luSides = null;
            List<String> dnBases = null, dnProteins = null, dnSides = null, dnLights = null;

            for (String[] cfg : fallbackConfigs) {
                String d = cfg[0], c = cfg[1];

                bfBases    = collectFoods(engine, String.format("pick_base(F, breakfast, %s, %s).", d, c));
                bfProteins = collectFoods(engine, String.format("pick_protein(F, breakfast, %s, %s).", d, c));
                bfLights   = collectFoods(engine, String.format("pick_light(F, breakfast, %s, %s).", d, c));

                luBases    = collectFoods(engine, String.format("pick_base(F, lunch, %s, %s).", d, c));
                luProteins = collectFoods(engine, String.format("pick_protein(F, lunch, %s, %s).", d, c));
                luSides    = collectFoods(engine, String.format("pick_side(F, lunch, %s, %s).", d, c));

                dnBases    = collectFoods(engine, String.format("pick_base(F, dinner, %s, %s).", d, c));
                dnProteins = collectFoods(engine, String.format("pick_protein(F, dinner, %s, %s).", d, c));
                dnSides    = collectFoods(engine, String.format("pick_side(F, dinner, %s, %s).", d, c));
                dnLights   = collectFoods(engine, String.format("pick_light(F, dinner, %s, %s).", d, c));

                // Check all pools have at least 1 food
                boolean allPopulated = !bfBases.isEmpty() && !bfProteins.isEmpty() && !bfLights.isEmpty()
                        && !luBases.isEmpty() && !luProteins.isEmpty() && !luSides.isEmpty()
                        && !dnBases.isEmpty() && !dnProteins.isEmpty() && !dnSides.isEmpty() && !dnLights.isEmpty();


                if (allPopulated) break;
            }


            // =============================================================
            // PHASE 2: Determine serving sizes based on goal + TDEE
            // =============================================================
            // Scale servings proportionally to hit the calorie target.
            // Average food is ~130 kcal/serving. A plan has ~11 items total.
            // Target per-item average = tdee / 11
            double scaleFactor = tdee / 2200.0; // 2200 is the baseline
            int baseQty    = Math.max(1, (int) Math.round(2 * scaleFactor));
            int proteinQty = Math.max(1, (int) Math.round(1.5 * scaleFactor));
            int sideQty    = Math.max(1, (int) Math.round(1 * scaleFactor));
            int lightQty   = Math.max(1, (int) Math.round(1 * scaleFactor));

            if ("diet".equals(goal)) {
                baseQty = Math.max(1, baseQty - 1);
                proteinQty = Math.max(1, proteinQty);
            } else if ("bulk".equals(goal)) {
                baseQty = baseQty + 1;
                proteinQty = proteinQty + 1;
                lightQty = lightQty + 1;
            }


            // =============================================================
            // PHASE 3: Java-side random assembly + Prolog calorie validation
            // =============================================================
            Random rng = new Random();
            int tolerance = tdee >= 3500 ? 700 : 500;

            String bestPlanStr = null;
            String bestBreakfast = null, bestLunch = null, bestDinner = null;
            int bestTotalCals = 0;
            double minCostDiff = Double.MAX_VALUE;



            for (int attempt = 0; attempt < 500; attempt++) {
                // Vary quantities per attempt to explore calorie space
                int bqAdj = rng.nextInt(5) - 1; // -1 to +3
                int pqAdj = rng.nextInt(3) - 1; // -1 to +1
                int sqAdj = rng.nextInt(3) - 1; // -1 to +1
                int lqAdj = rng.nextInt(2);      // 0 or +1
                int curBaseQty    = Math.max(1, baseQty + bqAdj);
                int curProteinQty = Math.max(1, proteinQty + pqAdj);
                int curSideQty    = Math.max(1, sideQty + sqAdj);
                int curLightQty   = Math.max(1, lightQty + lqAdj);

                // Shuffle all lists for randomness
                Collections.shuffle(bfBases, rng);
                Collections.shuffle(bfProteins, rng);
                Collections.shuffle(bfLights, rng);
                Collections.shuffle(luBases, rng);
                Collections.shuffle(luProteins, rng);
                Collections.shuffle(luSides, rng);
                Collections.shuffle(dnBases, rng);
                Collections.shuffle(dnProteins, rng);
                Collections.shuffle(dnSides, rng);
                Collections.shuffle(dnLights, rng);

                Set<String> usedBreakfast = new HashSet<>();

                // ---- BREAKFAST: 1 base + 1 protein + 1 light ----
                String bBase = pickUnique(bfBases, usedBreakfast);
                if (bBase == null) continue;
                usedBreakfast.add(bBase);

                String bProtein = pickUnique(bfProteins, usedBreakfast);
                if (bProtein == null) continue;
                usedBreakfast.add(bProtein);

                String bLight = pickUnique(bfLights, usedBreakfast);
                if (bLight == null) continue;

                Set<String> usedLunch = new HashSet<>();

                // ---- LUNCH: 1 base + 1 protein + 2 sides ----
                String lBase = pickUnique(luBases, usedLunch);
                if (lBase == null) continue;
                usedLunch.add(lBase);

                String lProtein = pickUnique(luProteins, usedLunch);
                if (lProtein == null) continue;
                usedLunch.add(lProtein);

                String lSide1 = pickUnique(luSides, usedLunch);
                if (lSide1 == null) continue;
                usedLunch.add(lSide1);

                String lSide2 = pickUnique(luSides, usedLunch);
                if (lSide2 == null) continue;

                Set<String> usedDinner = new HashSet<>();

                // ---- DINNER: 1 base + 1 protein + 1 side + 1 light ----
                String dBase = pickUnique(dnBases, usedDinner);
                if (dBase == null) continue;
                usedDinner.add(dBase);

                String dProtein = pickUnique(dnProteins, usedDinner);
                if (dProtein == null) continue;
                usedDinner.add(dProtein);

                String dSide = pickUnique(dnSides, usedDinner);
                if (dSide == null) continue;
                usedDinner.add(dSide);

                String dLight = pickUnique(dnLights, usedDinner);
                if (dLight == null) continue;

                // Build Prolog plan term strings
                String breakfastItems = String.format("item(%s,%d),item(%s,%d),item(%s,%d)", bBase, curBaseQty, bProtein, curProteinQty, bLight, curLightQty);
                String lunchItems = String.format("item(%s,%d),item(%s,%d),item(%s,%d),item(%s,%d)", lBase, curBaseQty, lProtein, curProteinQty, lSide1, curSideQty, lSide2, curSideQty);
                String dinnerItems = String.format("item(%s,%d),item(%s,%d),item(%s,%d),item(%s,%d)", dBase, curBaseQty, dProtein, curProteinQty, dSide, curSideQty, dLight, 1);

                String planStr = String.format("plan([%s],[%s],[%s])", breakfastItems, lunchItems, dinnerItems);

                // ---- Validate total calories via Prolog ----
                SolveInfo calResult = engine.solve(String.format("plan_total(%s, Total).", planStr));
                if (!calResult.isSuccess()) continue;

                int totalCals = (int) Math.round(Double.parseDouble(calResult.getVarValue("Total").toString()));

                // ---- Validate budget ----
                double attemptCost = 0;
                attemptCost += costMap.getOrDefault(bBase, 0.0) * curBaseQty;
                attemptCost += costMap.getOrDefault(bProtein, 0.0) * curProteinQty;
                attemptCost += costMap.getOrDefault(bLight, 0.0) * curLightQty;
                
                attemptCost += costMap.getOrDefault(lBase, 0.0) * curBaseQty;
                attemptCost += costMap.getOrDefault(lProtein, 0.0) * curProteinQty;
                attemptCost += costMap.getOrDefault(lSide1, 0.0) * curSideQty;
                attemptCost += costMap.getOrDefault(lSide2, 0.0) * curSideQty;
                
                attemptCost += costMap.getOrDefault(dBase, 0.0) * curBaseQty;
                attemptCost += costMap.getOrDefault(dProtein, 0.0) * curProteinQty;
                attemptCost += costMap.getOrDefault(dSide, 0.0) * curSideQty;
                attemptCost += costMap.getOrDefault(dLight, 0.0) * 1;
                
                int userBudget = prefs.getBudget() > 0 ? prefs.getBudget() : 2000;

                if (Math.abs(totalCals - tdee) <= tolerance) {
                    // Check budget: ideally cost should be <= userBudget + 20%
                    double costDiff;
                    if (attemptCost <= userBudget * 1.2) {
                        costDiff = 0; 
                    } else {
                        costDiff = attemptCost - (userBudget * 1.2);
                    }
                    
                    if (costDiff < minCostDiff) {
                        minCostDiff = costDiff;
                        bestPlanStr = planStr;
                        bestBreakfast = breakfastItems;
                        bestLunch = lunchItems;
                        bestDinner = dinnerItems;
                        bestTotalCals = totalCals;
                        
                        if (costDiff == 0) {
                            break; // Perfect plan found!
                        }
                    }
                }
            }

            if (bestPlanStr != null) {
                // ========= BEST PLAN FOUND =========
                MealPlanResponseDto response = new MealPlanResponseDto();
                response.setTotalCals(bestTotalCals);

                // Get macro totals from Prolog
                SolveInfo macroRes = engine.solve(String.format("plan_macro_total(%s, Carbs, Protein, Fat).", bestPlanStr));
                if (macroRes.isSuccess()) {
                    response.setTotalCarbs((int) Math.round(Double.parseDouble(macroRes.getVarValue("Carbs").toString())));
                    response.setTotalProtein((int) Math.round(Double.parseDouble(macroRes.getVarValue("Protein").toString())));
                    response.setTotalFat((int) Math.round(Double.parseDouble(macroRes.getVarValue("Fat").toString())));
                }

                // Parse individual meals
                response.setBreakfast(parseMeal(engine, "Breakfast", bestBreakfast));
                response.setLunch(parseMeal(engine, "Lunch", bestLunch));
                response.setDinner(parseMeal(engine, "Dinner", bestDinner));

                return response;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        throw new MealPlanNotFoundException("No meal plan found for " + tdee + " kcal with the selected preferences.");
    }

    /**
     * Queries Prolog for all unique food names matching a pick_* query.
     * Returns a deduplicated list of food atom names.
     */
    private List<String> collectFoods(Prolog engine, String query) {
        Set<String> foods = new LinkedHashSet<>();
        try {
            SolveInfo result = engine.solve(query);
            while (result.isSuccess()) {
                foods.add(result.getVarValue("F").toString());
                if (!engine.hasOpenAlternatives()) break;
                result = engine.solveNext();
            }
        } catch (Exception e) {
            // Silently continue — empty list means no foods match
        }
        return new ArrayList<>(foods);
    }

    /**
     * Picks the first food from the shuffled list that is not in the excluded set.
     */
    private String pickUnique(List<String> candidates, Set<String> excluded) {
        for (String c : candidates) {
            if (!excluded.contains(c)) return c;
        }
        return null;
    }

    private MealDto parseMeal(Prolog engine, String name, String itemsStr) {
        MealDto meal = new MealDto();
        meal.setName(name);
        List<FoodItemDto> foodItems = new ArrayList<>();

        if (itemsStr == null || itemsStr.trim().isEmpty()) {
            return meal;
        }

        Matcher m = Pattern.compile("item\\(([a-zA-Z0-9_]+),\\s*([0-9]+)\\)").matcher(itemsStr);
        while (m.find()) {
            String food = m.group(1);
            int qty = Integer.parseInt(m.group(2));
            
            FoodItemDto item = new FoodItemDto();
            item.setName(formatName(food));
            item.setQuantity(qty);
            
            // Look up cost from database
            try {
                java.util.Optional<FoodEntity> foodOpt = foodRepository.findByFoodName(food);
                if (foodOpt.isPresent()) {
                    Double cost = foodOpt.get().getCostLkr();
                    item.setCostLkr(cost != null ? cost * qty : 0);
                }
            } catch (Exception ignored) {}

            try {
                SolveInfo amountRes = engine.solve(String.format("food_amount(%s, %d, Amount).", food, qty));
                if (amountRes.isSuccess()) {
                    item.setAmount((int) Math.round(Double.parseDouble(amountRes.getVarValue("Amount").toString())));
                }
                
                SolveInfo calRes = engine.solve(String.format("item_calories(item(%s, %d), Cals).", food, qty));
                if (calRes.isSuccess()) {
                    item.setCalories((int) Math.round(Double.parseDouble(calRes.getVarValue("Cals").toString())));
                }
            } catch (Exception e) {}
            
            foodItems.add(item);
        }
        
        meal.setItems(foodItems);
        
        try {
            SolveInfo macroRes = engine.solve(String.format("meal_macro_total([%s], Carbs, Protein, Fat).", itemsStr));
            if (macroRes.isSuccess()) {
                meal.setCarbs((int) Math.round(Double.parseDouble(macroRes.getVarValue("Carbs").toString())));
                meal.setProtein((int) Math.round(Double.parseDouble(macroRes.getVarValue("Protein").toString())));
                meal.setFat((int) Math.round(Double.parseDouble(macroRes.getVarValue("Fat").toString())));
            }
            
            SolveInfo calRes = engine.solve(String.format("meal_total([%s], Cals).", itemsStr));
            if (calRes.isSuccess()) {
                meal.setCalories((int) Math.round(Double.parseDouble(calRes.getVarValue("Cals").toString())));
            }
        } catch (Exception e) {}

        return meal;
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
