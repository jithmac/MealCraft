package com.mealcraft.controller;

import com.mealcraft.entity.AdminEntity;
import com.mealcraft.entity.FoodEntity;
import com.mealcraft.entity.OrderEntity;
import com.mealcraft.repository.AdminRepository;
import com.mealcraft.repository.FoodRepository;
import com.mealcraft.repository.OrderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/admin")
public class AdminController {

    @Autowired
    private AdminRepository adminRepository;

    @Autowired
    private FoodRepository foodRepository;

    @Autowired
    private OrderRepository orderRepository;

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> credentials) {
        String username = credentials.get("username");
        String password = credentials.get("password");

        Optional<AdminEntity> adminOpt = adminRepository.findByUsername(username);
        if (adminOpt.isPresent() && adminOpt.get().getPassword().equals(password)) {
            return ResponseEntity.ok(Map.of("success", true, "message", "Login successful"));
        }
        return ResponseEntity.status(401).body(Map.of("success", false, "message", "Invalid credentials"));
    }

    // --- FOOD CRUD ---

    @GetMapping("/foods")
    public List<FoodEntity> getAllFoods() {
        return foodRepository.findAll();
    }

    @PostMapping("/foods")
    public FoodEntity addFood(@RequestBody FoodEntity food) {
        return foodRepository.save(food);
    }

    @PutMapping("/foods/{id}")
    public ResponseEntity<FoodEntity> updateFood(@PathVariable Integer id, @RequestBody FoodEntity foodDetails) {
        Optional<FoodEntity> foodOpt = foodRepository.findById(id);
        if (foodOpt.isPresent()) {
            FoodEntity food = foodOpt.get();
            food.setFoodName(foodDetails.getFoodName());
            food.setOrigin(foodDetails.getOrigin());
            food.setCategory(foodDetails.getCategory());
            food.setServingSize(foodDetails.getServingSize());
            food.setCalories(foodDetails.getCalories());
            food.setCarbs(foodDetails.getCarbs());
            food.setProtein(foodDetails.getProtein());
            food.setFats(foodDetails.getFats());
            food.setMicronutrients(foodDetails.getMicronutrients());
            food.setAllergens(foodDetails.getAllergens());
            food.setStorageNote(foodDetails.getStorageNote());
            food.setMealTags(foodDetails.getMealTags());
            food.setDietaryTags(foodDetails.getDietaryTags());
            food.setCostLkr(foodDetails.getCostLkr());
            return ResponseEntity.ok(foodRepository.save(food));
        }
        return ResponseEntity.notFound().build();
    }

    @DeleteMapping("/foods/{id}")
    public ResponseEntity<?> deleteFood(@PathVariable Integer id) {
        if (foodRepository.existsById(id)) {
            foodRepository.deleteById(id);
            return ResponseEntity.ok(Map.of("success", true));
        }
        return ResponseEntity.notFound().build();
    }

    // --- ORDER CRUD ---

    @GetMapping("/orders")
    public List<OrderEntity> getAllOrders() {
        return orderRepository.findAll();
    }

    @DeleteMapping("/orders/{id}")
    public ResponseEntity<?> deleteOrder(@PathVariable Integer id) {
        if (orderRepository.existsById(id)) {
            orderRepository.deleteById(id);
            return ResponseEntity.ok(Map.of("success", true));
        }
        return ResponseEntity.notFound().build();
    }
}
