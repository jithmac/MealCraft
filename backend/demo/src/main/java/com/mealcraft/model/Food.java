package com.mealcraft.model;

import jakarta.persistence.*;

@Entity
@Table(name = "foods")
public class Food {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer food_id;

    private String food_name;
    private Integer calories;
    private Integer protein;
    private Integer carbs;
    private Integer fats;
    private Double cost_lkr;

    @Enumerated(EnumType.STRING)
    private Category category;

    private String dietary_tags;
    private String meal_tags;

    public enum Category {
        base, protein, vegetable
    }

    // Getters and Setters
    public Integer getFood_id() { return food_id; }
    public void setFood_id(Integer food_id) { this.food_id = food_id; }

    public String getFood_name() { return food_name; }
    public void setFood_name(String food_name) { this.food_name = food_name; }

    public Integer getCalories() { return calories; }
    public void setCalories(Integer calories) { this.calories = calories; }

    public Integer getProtein() { return protein; }
    public void setProtein(Integer protein) { this.protein = protein; }

    public Integer getCarbs() { return carbs; }
    public void setCarbs(Integer carbs) { this.carbs = carbs; }

    public Integer getFats() { return fats; }
    public void setFats(Integer fats) { this.fats = fats; }

    public Double getCost_lkr() { return cost_lkr; }
    public void setCost_lkr(Double cost_lkr) { this.cost_lkr = cost_lkr; }

    public Category getCategory() { return category; }
    public void setCategory(Category category) { this.category = category; }

    public String getDietary_tags() { return dietary_tags; }
    public void setDietary_tags(String dietary_tags) { this.dietary_tags = dietary_tags; }

    public String getMeal_tags() { return meal_tags; }
    public void setMeal_tags(String meal_tags) { this.meal_tags = meal_tags; }
}
