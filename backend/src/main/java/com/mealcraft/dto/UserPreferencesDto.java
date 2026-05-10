package com.mealcraft.dto;

import java.util.List;

public class UserPreferencesDto {
    private int age;
    private double weight;
    private double height;
    private String gender;
    private String activityLevel;
    private int budget;
    private List<String> dietaryRestrictions;

    // Getters and Setters
    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }

    public double getWeight() { return weight; }
    public void setWeight(double weight) { this.weight = weight; }

    public double getHeight() { return height; }
    public void setHeight(double height) { this.height = height; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getActivityLevel() { return activityLevel; }
    public void setActivityLevel(String activityLevel) { this.activityLevel = activityLevel; }

    public int getBudget() { return budget; }
    public void setBudget(int budget) { this.budget = budget; }

    public List<String> getDietaryRestrictions() { return dietaryRestrictions; }
    public void setDietaryRestrictions(List<String> dietaryRestrictions) { this.dietaryRestrictions = dietaryRestrictions; }
}
