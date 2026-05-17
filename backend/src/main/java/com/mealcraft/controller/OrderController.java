package com.mealcraft.controller;

import com.mealcraft.dto.OrderRequestDto;
import com.mealcraft.entity.OrderEntity;
import com.mealcraft.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/orders")
public class OrderController {

    @Autowired
    private OrderService orderService;

    @PostMapping
    public ResponseEntity<?> createOrder(@RequestBody OrderRequestDto orderRequest) {
        try {
            OrderEntity savedOrder = orderService.createOrder(orderRequest);
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Order saved successfully!",
                "orderId", savedOrder.getOrderId()
            ));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "message", "Failed to save order: " + e.getMessage()
            ));
        }
    }
}
