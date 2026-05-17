package com.mealcraft.service;

import com.mealcraft.dto.OrderItemRequestDto;
import com.mealcraft.dto.OrderRequestDto;
import com.mealcraft.entity.FoodEntity;
import com.mealcraft.entity.OrderEntity;
import com.mealcraft.entity.OrderItemEntity;
import com.mealcraft.repository.FoodRepository;
import com.mealcraft.repository.OrderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class OrderService {

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private FoodRepository foodRepository;

    @Transactional
    public OrderEntity createOrder(OrderRequestDto dto) {
        OrderEntity order = new OrderEntity();
        order.setCustomerName(dto.getCustomerName());
        order.setPhone(dto.getPhone());
        order.setAddress(dto.getAddress());
        order.setMealType(dto.getMealType());
        order.setTotalAmount(dto.getTotalAmount());
        order.setOrderStatus(dto.getOrderStatus() != null ? dto.getOrderStatus() : "PENDING");

        List<OrderItemEntity> orderItems = new ArrayList<>();

        if (dto.getItems() != null) {
            for (OrderItemRequestDto itemDto : dto.getItems()) {
                OrderItemEntity orderItem = new OrderItemEntity();
                orderItem.setOrder(order);
                orderItem.setQuantity(itemDto.getQuantity());
                orderItem.setPrice(itemDto.getPrice());

                // Try to find matching food by name
                Optional<FoodEntity> foodOpt = foodRepository.findByFoodName(itemDto.getFoodName());
                foodOpt.ifPresent(orderItem::setFood);

                orderItems.add(orderItem);
            }
        }

        order.setOrderItems(orderItems);
        return orderRepository.save(order);
    }
}
