import { useEffect, useState } from "react";
import { getAllFoods } from "../services/api";

type Food = {
  foodId: number;
  foodName: string;
  calories: number;
  protein: number;
  carbs: number;
  fats: number;
  costLkr: number;
  category: string;
  dietaryTags: string;
  mealTags: string;
};

function Foods() {
  const [foods, setFoods] = useState<Food[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string>("");

  useEffect(() => {
    loadFoods();
  }, []);

  const loadFoods = async () => {
    try {
      const data = await getAllFoods();
      setFoods(data);
    } catch (err) {
      setError("Cannot load food data");
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  if (loading) return <h2>Loading foods...</h2>;
  if (error) return <h2>{error}</h2>;

  return (
    <div style={{ padding: "20px" }}>
      <h1>MealCraft Foods</h1>

      <table border={1} cellPadding={10} cellSpacing={0}>
        <thead>
          <tr>
            <th>ID</th>
            <th>Food Name</th>
            <th>Calories</th>
            <th>Protein</th>
            <th>Carbs</th>
            <th>Fats</th>
            <th>Cost LKR</th>
            <th>Category</th>
            <th>Dietary Tags</th>
            <th>Meal Tags</th>
          </tr>
        </thead>

        <tbody>
          {foods.map((food) => (
            <tr key={food.foodId}>
              <td>{food.foodId}</td>
              <td>{food.foodName}</td>
              <td>{food.calories}</td>
              <td>{food.protein}</td>
              <td>{food.carbs}</td>
              <td>{food.fats}</td>
              <td>{food.costLkr}</td>
              <td>{food.category}</td>
              <td>{food.dietaryTags}</td>
              <td>{food.mealTags}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

export default Foods;