package com.mealcraft.dto;

import java.util.List;

public class MealDto {
    private String name;
    private int calories;
    private int carbs;
    private int protein;
    private int fat;
    private List<FoodItemDto> items;

    public MealDto() {}

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public int getCalories() { return calories; }
    public void setCalories(int calories) { this.calories = calories; }

    public int getCarbs() { return carbs; }
    public void setCarbs(int carbs) { this.carbs = carbs; }

    public int getProtein() { return protein; }
    public void setProtein(int protein) { this.protein = protein; }

    public int getFat() { return fat; }
    public void setFat(int fat) { this.fat = fat; }

    public List<FoodItemDto> getItems() { return items; }
    public void setItems(List<FoodItemDto> items) { this.items = items; }
}
