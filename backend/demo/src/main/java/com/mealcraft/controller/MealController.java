package com.mealcraft.controller;

import com.mealcraft.dto.MealRequest;
import com.mealcraft.dto.MealResponse;
import com.mealcraft.service.PrologService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/meals")
@CrossOrigin(origins = "http://localhost:5173")
public class MealController {

    private final PrologService prologService;

    public MealController(PrologService prologService) {
        this.prologService = prologService;
    }

    @PostMapping("/generate")
    public MealResponse generateMeal(@RequestBody MealRequest request) {
        return prologService.generateMeal(request);
    }
}