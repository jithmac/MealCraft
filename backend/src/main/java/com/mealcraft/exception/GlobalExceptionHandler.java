package com.mealcraft.exception;

import com.mealcraft.dto.ErrorResponseDto;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(MealPlanNotFoundException.class)
    public ResponseEntity<ErrorResponseDto> handleMealPlanNotFound(MealPlanNotFoundException ex) {
        return new ResponseEntity<>(new ErrorResponseDto(ex.getMessage(), HttpStatus.NOT_FOUND.value()), HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(UnsafeCalorieException.class)
    public ResponseEntity<ErrorResponseDto> handleUnsafeCalorieException(UnsafeCalorieException ex) {
        return new ResponseEntity<>(new ErrorResponseDto(ex.getMessage(), HttpStatus.BAD_REQUEST.value()), HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponseDto> handleGeneralException(Exception ex) {
        return new ResponseEntity<>(new ErrorResponseDto("An internal error occurred: " + ex.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR.value()), HttpStatus.INTERNAL_SERVER_ERROR);
    }
}
