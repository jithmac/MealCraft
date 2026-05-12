% ==========================================
% MEALCRAFT AI ENGINE - CORE LOGIC
% ==========================================

% --- KNOWLEDGE BASE (FOOD FACTS) ---
% Format: food(Name, Calories, Protein, Carbs, Fats, Cost_LKR, Category, [DietaryTags]).
% Every entry MUST have exactly 8 arguments.

% Bases (Carbs)
food(red_rice, 210, 5, 45, 1, 80, base, [vegan, vegetarian, gluten_free]).
food(white_rice, 240, 4, 53, 0, 70, base, [vegan, vegetarian, gluten_free]).
food(string_hoppers, 180, 4, 40, 1, 100, base, [vegan, vegetarian]).
food(kurakkan_roti, 150, 4, 30, 2, 90, base, [vegan, vegetarian]).

% Proteins
food(chicken_curry, 220, 25, 5, 10, 250, protein, [none]).
food(dhal_curry, 120, 9, 17, 3, 80, protein, [vegan, vegetarian, gluten_free]).
food(fish_ambul_thiyal, 140, 20, 2, 5, 200, protein, [none]).
food(egg_curry, 160, 12, 6, 10, 120, protein, [vegetarian, gluten_free]).
food(soya_meat_curry, 130, 15, 10, 3, 90, protein, [vegan, vegetarian]).

% Vegetables
food(gotukola_sambol, 50, 2, 8, 2, 60, vegetable, [vegan, vegetarian, gluten_free]).
food(brinjal_moju, 190, 2, 22, 12, 150, vegetable, [vegan, vegetarian]).
food(beans_curry, 70, 3, 10, 2, 80, vegetable, [vegan, vegetarian, gluten_free]).
food(pumpkin_curry, 90, 2, 15, 3, 70, vegetable, [vegan, vegetarian, gluten_free]).


% --- DIETARY & HEALTH RULES ---

% Diet Check: Passes if user has no preference or if the food contains the required tag.
meets_diet(_, none).
meets_diet(FoodName, DietType) :-
    food(FoodName, _, _, _, _, _, _, Tags),
    member(DietType, Tags).

% Health Check: General placeholder for 'none' condition.
meets_health(_, none).

% Diabetes: Restrict based on carb content and specific foods.
meets_health(FoodName, diabetes) :-
    food(FoodName, _, _, Carbs, _, _, _, _),
    Carbs =< 40,
    FoodName \= white_rice,
    FoodName \= brinjal_moju.

% Obesity: Focus on calorie density per serving.
meets_health(FoodName, obesity) :-
    food(FoodName, Calories, _, _, _, _, _, _),
    Calories =< 180.


% --- MEAL ASSEMBLY LOGIC ---

% Builds a single meal (Base + Protein + Vegetable)
build_meal(_MealType, Diet, Health, [Base, Protein, Veg], TotalCals, TotalCost) :-
    food(Base, BCals, _, _, _, BCost, base, _),
    meets_diet(Base, Diet),
    meets_health(Base, Health),

    food(Protein, PCals, _, _, _, PCost, protein, _),
    meets_diet(Protein, Diet),
    meets_health(Protein, Health),

    food(Veg, VCals, _, _, _, VCost, vegetable, _),
    meets_diet(Veg, Diet),
    meets_health(Veg, Health),

    TotalCals is BCals + PCals + VCals,
    TotalCost is BCost + PCost + VCost.


% --- DAILY PLAN GENERATOR ---

generate_daily_plan(TargetCals, MaxBudget, Diet, Health, Plan, DayCals, DayCost) :-
    % Generate three distinct meals
    build_meal(breakfast, Diet, Health, Breakfast, C1, Cost1),
    build_meal(lunch, Diet, Health, Lunch, C2, Cost2),
    build_meal(dinner, Diet, Health, Dinner, C3, Cost3),

    % Ensure meal variety (optional)
    Breakfast \= Lunch,
    Lunch \= Dinner,

    % Calculate daily totals
    DayCals is C1 + C2 + C3,
    DayCost is Cost1 + Cost2 + Cost3,

    % Apply Constraints
    DayCost =< MaxBudget,
    MinBuffer is TargetCals - 200,
    MaxBuffer is TargetCals + 200,
    DayCals >= MinBuffer,
    DayCals =< MaxBuffer,

    % Construct Final Plan
    Plan = [breakfast(Breakfast), lunch(Lunch), dinner(Dinner)].