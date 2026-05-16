const API_BASE_URL = "http://localhost:8080/api";

export const getAllFoods = async () => {
  const response = await fetch(`${API_BASE_URL}/foods`);

  if (!response.ok) {
    throw new Error("Failed to fetch foods");
  }

  return response.json();
};