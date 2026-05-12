package com.mealcraft.dto;

public class MealDto {
    private String name;
    private int calories;
    private int cost;

    public MealDto() {}

    public MealDto(String name, int calories, int cost) {
        this.name = name;
        this.calories = calories;
        this.cost = cost;
    }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public int getCalories() { return calories; }
    public void setCalories(int calories) { this.calories = calories; }

    public int getCost() { return cost; }
    public void setCost(int cost) { this.cost = cost; }
}
