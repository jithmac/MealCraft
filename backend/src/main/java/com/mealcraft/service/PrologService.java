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
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.Random;

@Service
public class PrologService {

    @Autowired
    private FoodRepository foodRepository;

    public void init() {
    }

    public synchronized MealPlanResponseDto generateMealPlan(UserPreferencesDto prefs) {
        int tdee = calculateTDEE(prefs);
        if (tdee < 1500) {
            throw new UnsafeCalorieException("Calculated calories are below 1500 kcal (" + tdee + " kcal). Please consult a doctor.");
        }
        if (tdee > 4500) {
            throw new UnsafeCalorieException("Calculated calories are above 4500 kcal (" + tdee + " kcal). Please consult a nutritionist.");
        }

        String diet = prefs.getDiet() != null && !prefs.getDiet().isEmpty() ? prefs.getDiet().toLowerCase() : "omnivore";
        
        List<String> conditions = prefs.getHealthConditions() != null ? prefs.getHealthConditions() : new ArrayList<>();
        String conditionsStr = "[" + String.join(",", conditions) + "]";

        String goal = prefs.getGoal() != null && !prefs.getGoal().isEmpty() ? prefs.getGoal().toLowerCase() : "normal";
        if ("diet".equals(goal)) {
            tdee -= 300;
        } else if ("bulk".equals(goal)) {
            tdee += 300;
        }

        String query = String.format("backup_meal_plan(%d, %s, %s, %s, Plan, TotalCals).", tdee, diet, conditionsStr, goal);

        Prolog engine = new Prolog();
        try {
            File prologFile = new File("../ai/mealCraft.pl");
            String baseTheory = new String(Files.readAllBytes(prologFile.toPath()));
            
            // Build dynamic theory from database
            List<FoodEntity> foods = foodRepository.findAll();
            StringBuilder dynamicTheory = new StringBuilder();
            for (FoodEntity food : foods) {
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
            SolveInfo result = engine.solve(query);
            
            List<SolveInfo> validPlans = new ArrayList<>();
            while (result.isSuccess() && validPlans.size() < 10) {
                validPlans.add(result);
                if (!engine.hasOpenAlternatives()) break;
                result = engine.solveNext();
            }

            if (!validPlans.isEmpty()) {
                SolveInfo randomResult = validPlans.get(new Random().nextInt(validPlans.size()));
                String planStr = randomResult.getVarValue("Plan").toString();
                int totalCals = (int) Math.round(Double.parseDouble(randomResult.getVarValue("TotalCals").toString()));

                MealPlanResponseDto response = new MealPlanResponseDto();
                response.setTotalCals(totalCals);
                
                SolveInfo macroRes = engine.solve(String.format("plan_macro_total(%s, Carbs, Protein, Fat).", planStr));
                if (macroRes.isSuccess()) {
                    response.setTotalCarbs((int) Math.round(Double.parseDouble(macroRes.getVarValue("Carbs").toString())));
                    response.setTotalProtein((int) Math.round(Double.parseDouble(macroRes.getVarValue("Protein").toString())));
                    response.setTotalFat((int) Math.round(Double.parseDouble(macroRes.getVarValue("Fat").toString())));
                }

                Matcher m = Pattern.compile("plan\\(\\[(.*?)\\],\\s*\\[(.*?)\\],\\s*\\[(.*?)\\]\\)").matcher(planStr);
                if (m.find()) {
                    response.setBreakfast(parseMeal(engine, "Breakfast", m.group(1)));
                    response.setLunch(parseMeal(engine, "Lunch", m.group(2)));
                    response.setDinner(parseMeal(engine, "Dinner", m.group(3)));
                }

                return response;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        throw new MealPlanNotFoundException("No meal plan found for " + tdee + " kcal with the selected preferences.");
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

