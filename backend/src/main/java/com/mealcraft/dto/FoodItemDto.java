package com.mealcraft.dto;

public class FoodItemDto {
    private String name;
    private int quantity;
    private int amount; // in grams or ml
    private int calories;
    private double costLkr;

    public FoodItemDto() {}

    public FoodItemDto(String name, int quantity, int amount, int calories) {
        this.name = name;
        this.quantity = quantity;
        this.amount = amount;
        this.calories = calories;
    }

    public FoodItemDto(String name, int quantity, int amount, int calories, double costLkr) {
        this.name = name;
        this.quantity = quantity;
        this.amount = amount;
        this.calories = calories;
        this.costLkr = costLkr;
    }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public int getAmount() { return amount; }
    public void setAmount(int amount) { this.amount = amount; }

    public int getCalories() { return calories; }
    public void setCalories(int calories) { this.calories = calories; }

    public double getCostLkr() { return costLkr; }
    public void setCostLkr(double costLkr) { this.costLkr = costLkr; }
}
