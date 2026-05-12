package com.mealcraft.dto;

import java.util.List;

public class MealResponse {
    private String mealType;
    private List<String> foods;
    private int calories;
    private int cost;

    public MealResponse(String mealType, List<String> foods, int calories, int cost) {
        this.mealType = mealType;
        this.foods = foods;
        this.calories = calories;
        this.cost = cost;
    }

    public String getMealType() {
        return mealType;
    }

    public List<String> getFoods() {
        return foods;
    }

    public int getCalories() {
        return calories;
    }

    public int getCost() {
        return cost;
    }
}