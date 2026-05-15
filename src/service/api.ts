const API_BASE_URL = "http://localhost:8080/api";

export interface MealRequest {
  mealType: string;
  targetCalories: number;
  budget: number;
  diet: string;
  health: string;
}

export interface MealResponse {
  mealType: string;
  foods: string[];
  calories: number;
  cost: number;
}

export const generateMeal = async (request: MealRequest): Promise<MealResponse> => {
  const response = await fetch(`${API_BASE_URL}/meals/generate`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(request),
  });

  if (!response.ok) {
    const errorData = await response.json().catch(() => ({}));
    throw new Error(errorData.message || "Failed to generate meal");
  }

  return response.json();
};

export const getAllFoods = async () => {
  const response = await fetch(`${API_BASE_URL}/foods`);
  if (!response.ok) {
    throw new Error("Failed to fetch foods");
  }
  return response.json();
};
