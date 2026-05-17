package com.mealcraft.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "foods")
public class FoodEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "food_id")
    private Integer foodId;

    @Column(name = "food_name", nullable = false, unique = true)
    private String foodName;

    @Column(name = "origin")
    private String origin;

    @Column(name = "category", nullable = false)
    private String category;

    @Column(name = "serving_size", nullable = false)
    private Integer servingSize;

    @Column(name = "calories", nullable = false)
    private Double calories;

    @Column(name = "carbs", nullable = false)
    private Double carbs;

    @Column(name = "protein", nullable = false)
    private Double protein;

    @Column(name = "fats", nullable = false)
    private Double fats;

    @Column(name = "micronutrients", columnDefinition = "TEXT")
    private String micronutrients;

    @Column(name = "allergens", columnDefinition = "TEXT")
    private String allergens;

    @Column(name = "storage_note", columnDefinition = "TEXT")
    private String storageNote;

    @Column(name = "meal_tags")
    private String mealTags;

    @Column(name = "dietary_tags", columnDefinition = "TEXT")
    private String dietaryTags;

    @Column(name = "cost_lkr")
    private Double costLkr;

    // Getters and Setters
    public Integer getFoodId() { return foodId; }
    public void setFoodId(Integer foodId) { this.foodId = foodId; }

    public String getFoodName() { return foodName; }
    public void setFoodName(String foodName) { this.foodName = foodName; }

    public String getOrigin() { return origin; }
    public void setOrigin(String origin) { this.origin = origin; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public Integer getServingSize() { return servingSize; }
    public void setServingSize(Integer servingSize) { this.servingSize = servingSize; }

    public Double getCalories() { return calories; }
    public void setCalories(Double calories) { this.calories = calories; }

    public Double getCarbs() { return carbs; }
    public void setCarbs(Double carbs) { this.carbs = carbs; }

    public Double getProtein() { return protein; }
    public void setProtein(Double protein) { this.protein = protein; }

    public Double getFats() { return fats; }
    public void setFats(Double fats) { this.fats = fats; }

    public String getMicronutrients() { return micronutrients; }
    public void setMicronutrients(String micronutrients) { this.micronutrients = micronutrients; }

    public String getAllergens() { return allergens; }
    public void setAllergens(String allergens) { this.allergens = allergens; }

    public String getStorageNote() { return storageNote; }
    public void setStorageNote(String storageNote) { this.storageNote = storageNote; }

    public String getMealTags() { return mealTags; }
    public void setMealTags(String mealTags) { this.mealTags = mealTags; }

    public String getDietaryTags() { return dietaryTags; }
    public void setDietaryTags(String dietaryTags) { this.dietaryTags = dietaryTags; }

    public Double getCostLkr() { return costLkr; }
    public void setCostLkr(Double costLkr) { this.costLkr = costLkr; }
}
