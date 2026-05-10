package com.mealcraft.controller;

import com.mealcraft.dto.MealPlanResponseDto;
import com.mealcraft.dto.UserPreferencesDto;
import com.mealcraft.service.PrologService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/mealplan")
public class MealController {

    @Autowired
    private PrologService prologService;

    @PostMapping("/generate")
    public MealPlanResponseDto generatePlan(@RequestBody UserPreferencesDto preferences) {
        return prologService.generateMealPlan(preferences);
    }
}
