package com.mealcraft.dto;

import java.util.List;

public class UserPreferencesDto {
    private int age;
    private double weight;
    private double height;
    private String gender;
    private String activityLevel;
    private int budget;
    private String diet;
    private List<String> healthConditions;
    private String goal;
    private Integer exactCalories;

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

    public String getDiet() { return diet; }
    public void setDiet(String diet) { this.diet = diet; }

    public List<String> getHealthConditions() { return healthConditions; }
    public void setHealthConditions(List<String> healthConditions) { this.healthConditions = healthConditions; }

    public String getGoal() { return goal; }
    public void setGoal(String goal) { this.goal = goal; }

    public Integer getExactCalories() { return exactCalories; }
    public void setExactCalories(Integer exactCalories) { this.exactCalories = exactCalories; }
}
