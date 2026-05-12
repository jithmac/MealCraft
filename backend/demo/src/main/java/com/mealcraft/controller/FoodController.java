package com.mealcraft.controller;

import com.mealcraft.model.Food;
import com.mealcraft.service.FoodService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/foods")
@CrossOrigin(origins = "http://localhost:5173")
public class FoodController {

    private final FoodService foodService;

    public FoodController(FoodService foodService) {
        this.foodService = foodService;
    }

    @GetMapping
    public List<Food> getAllFoods() {
        return foodService.getAllFoods();
    }

    @PostMapping
    public Food addFood(@RequestBody Food food) {
        return foodService.addFood(food);
    }

    @DeleteMapping("/{id}")
    public String deleteFood(@PathVariable int id) {
        foodService.deleteFood(id);
        return "Food deleted successfully";
    }
}
