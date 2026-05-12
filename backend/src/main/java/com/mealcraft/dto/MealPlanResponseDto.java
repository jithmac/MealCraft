package com.mealcraft.dto;

public class MealPlanResponseDto {
    private MealDto breakfast;
    private MealDto lunch;
    private MealDto dinner;
    private int totalCals;
    private int totalCarbs;
    private int totalProtein;
    private int totalFat;

    public MealPlanResponseDto() {}

    public MealDto getBreakfast() { return breakfast; }
    public void setBreakfast(MealDto breakfast) { this.breakfast = breakfast; }

    public MealDto getLunch() { return lunch; }
    public void setLunch(MealDto lunch) { this.lunch = lunch; }

    public MealDto getDinner() { return dinner; }
    public void setDinner(MealDto dinner) { this.dinner = dinner; }

    public int getTotalCals() { return totalCals; }
    public void setTotalCals(int totalCals) { this.totalCals = totalCals; }

    public int getTotalCarbs() { return totalCarbs; }
    public void setTotalCarbs(int totalCarbs) { this.totalCarbs = totalCarbs; }

    public int getTotalProtein() { return totalProtein; }
    public void setTotalProtein(int totalProtein) { this.totalProtein = totalProtein; }

    public int getTotalFat() { return totalFat; }
    public void setTotalFat(int totalFat) { this.totalFat = totalFat; }
}
