package com.mealcraft.repository;

import com.mealcraft.entity.FoodEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface FoodRepository extends JpaRepository<FoodEntity, Integer> {
    Optional<FoodEntity> findByFoodName(String foodName);
}
