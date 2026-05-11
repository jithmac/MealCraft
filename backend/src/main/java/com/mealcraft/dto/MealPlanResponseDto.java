package com.mealcraft.dto;

public class MealPlanResponseDto {
    private MealDto breakfast;
    private MealDto lunch;
    private MealDto dinner;
    private int totalCals;
    private int totalCost;

    public MealPlanResponseDto() {}

    public MealDto getBreakfast() { return breakfast; }
    public void setBreakfast(MealDto breakfast) { this.breakfast = breakfast; }

    public MealDto getLunch() { return lunch; }
    public void setLunch(MealDto lunch) { this.lunch = lunch; }

    public MealDto getDinner() { return dinner; }
    public void setDinner(MealDto dinner) { this.dinner = dinner; }

    public int getTotalCals() { return totalCals; }
    public void setTotalCals(int totalCals) { this.totalCals = totalCals; }

    public int getTotalCost() { return totalCost; }
    public void setTotalCost(int totalCost) { this.totalCost = totalCost; }
}
