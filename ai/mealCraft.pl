% ==========================================
% MEALCRAFT AI ENGINE - CORE LOGIC
% Updated Version: 50 Foods + Meal Type Classification
% ==========================================

% --- KNOWLEDGE BASE (FOOD FACTS) ---
% Format:
% food(Name, Calories, Protein, Carbs, Fats, Cost_LKR, Category, [DietaryTags], [MealTags]).
%
% Category:
% base, protein, vegetable
%
% Dietary Tags:
% vegan, vegetarian, gluten_free, high_protein, low_carb
%
% Meal Tags:
% breakfast, lunch, dinner


% ==========================================
% BASES
% ==========================================

food(red_rice, 210, 5, 44, 1, 40, base,
     [vegan, vegetarian, gluten_free],
     [lunch, dinner]).

food(white_rice, 215, 4, 47, 0, 35, base,
     [vegan, vegetarian, gluten_free],
     [lunch, dinner]).

food(nadu_rice, 212, 5, 45, 1, 38, base,
     [vegan, vegetarian, gluten_free],
     [lunch, dinner]).

food(string_hoppers, 180, 4, 40, 1, 45, base,
     [vegan, vegetarian, gluten_free],
     [breakfast, dinner]).

food(kurakkan_roti, 170, 5, 32, 3, 35, base,
     [vegan, vegetarian, gluten_free],
     [breakfast, dinner]).

food(oats_porridge, 170, 6, 27, 3, 56, base,
     [vegan, vegetarian, high_protein],
     [breakfast]).

food(wholemeal_bread, 160, 8, 30, 2, 62, base,
     [vegan, vegetarian, high_protein],
     [breakfast]).

food(whole_wheat_pasta, 220, 8, 43, 1, 98, base,
     [vegan, vegetarian],
     [lunch, dinner]).

food(tortilla_wrap, 150, 4, 27, 3, 107, base,
     [vegan, vegetarian],
     [breakfast, lunch, dinner]).

food(cauliflower_rice, 30, 2, 5, 0, 45, base,
     [vegan, vegetarian, gluten_free, low_carb],
     [lunch, dinner]).

food(sweet_potato, 108, 1, 25, 0, 25, base,
     [vegan, vegetarian, gluten_free],
     [breakfast, lunch, dinner]).

food(manioc, 78, 1, 19, 0, 18, base,
     [vegan, vegetarian, gluten_free],
     [breakfast, lunch]).

food(ash_plantain, 114, 4, 24, 1, 22, base,
     [vegan, vegetarian, gluten_free],
     [lunch, dinner]).


% ==========================================
% PROTEINS
% ==========================================

food(dhal_curry, 180, 12, 27, 3, 35, protein,
     [vegan, vegetarian, gluten_free, high_protein],
     [breakfast, lunch, dinner]).

food(green_gram_curry, 170, 11, 25, 2, 45, protein,
     [vegan, vegetarian, gluten_free, high_protein],
     [breakfast, lunch]).

food(red_cowpea_curry, 185, 11, 28, 2, 40, protein,
     [vegan, vegetarian, gluten_free, high_protein],
     [breakfast, lunch, dinner]).

food(chickpea_curry, 190, 10, 31, 3, 44, protein,
     [vegan, vegetarian, gluten_free, high_protein],
     [breakfast, lunch]).

food(kidney_bean_curry, 170, 9, 23, 1, 70, protein,
     [vegan, vegetarian, gluten_free, high_protein],
     [lunch, dinner]).

food(soya_meat_curry, 130, 15, 10, 3, 35, protein,
     [vegan, vegetarian, high_protein, low_carb],
     [lunch, dinner]).

food(tofu, 145, 16, 4, 9, 116, protein,
     [vegan, vegetarian, gluten_free, high_protein, low_carb],
     [lunch, dinner]).

food(plain_yoghurt, 63, 5, 7, 2, 80, protein,
     [vegetarian, gluten_free],
     [breakfast, dinner]).

food(greek_yoghurt, 92, 10, 6, 4, 272, protein,
     [vegetarian, gluten_free, high_protein, low_carb],
     [breakfast, dinner]).

food(egg_omelette, 140, 14, 1, 9, 74, protein,
     [vegetarian, gluten_free, high_protein, low_carb],
     [breakfast, dinner]).

food(chicken_curry, 210, 23, 4, 10, 160, protein,
     [gluten_free, high_protein, low_carb],
     [lunch, dinner]).

food(grilled_chicken, 180, 28, 0, 7, 160, protein,
     [gluten_free, high_protein, low_carb],
     [lunch, dinner]).

food(balaya_fish, 120, 21, 0, 2, 190, protein,
     [gluten_free, high_protein, low_carb],
     [lunch, dinner]).

food(seer_fish, 150, 22, 0, 5, 260, protein,
     [gluten_free, high_protein, low_carb],
     [lunch, dinner]).

food(salaya_fish, 110, 20, 0, 2, 80, protein,
     [gluten_free, high_protein, low_carb],
     [lunch, dinner]).

food(prawns, 90, 15, 1, 1, 280, protein,
     [gluten_free, high_protein, low_carb],
     [lunch, dinner]).


% ==========================================
% VEGETABLES
% ==========================================

food(gotukola_sambol, 25, 1, 4, 1, 25, vegetable,
     [vegan, vegetarian, gluten_free, low_carb],
     [lunch, dinner]).

food(mukunuwenna_mallung, 40, 3, 4, 1, 20, vegetable,
     [vegan, vegetarian, gluten_free, low_carb],
     [lunch, dinner]).

food(kankun_mallung, 35, 2, 4, 1, 20, vegetable,
     [vegan, vegetarian, gluten_free, low_carb],
     [lunch, dinner]).

food(nivithi_mallung, 35, 2, 4, 1, 22, vegetable,
     [vegan, vegetarian, gluten_free, low_carb],
     [lunch, dinner]).

food(thampala_mallung, 45, 4, 5, 1, 24, vegetable,
     [vegan, vegetarian, gluten_free, low_carb],
     [lunch, dinner]).

food(beans_curry, 60, 4, 8, 1, 72, vegetable,
     [vegan, vegetarian, gluten_free, low_carb],
     [lunch, dinner]).

food(long_beans_curry, 50, 3, 7, 1, 33, vegetable,
     [vegan, vegetarian, gluten_free, low_carb],
     [lunch, dinner]).

food(pumpkin_curry, 45, 1, 8, 1, 12, vegetable,
     [vegan, vegetarian, gluten_free],
     [lunch, dinner]).

food(cabbage_stir_fry, 40, 2, 6, 1, 28, vegetable,
     [vegan, vegetarian, gluten_free, low_carb],
     [lunch, dinner]).

food(carrot_salad, 35, 1, 7, 0, 50, vegetable,
     [vegan, vegetarian, gluten_free],
     [breakfast, lunch, dinner]).

food(beetroot_curry, 45, 2, 9, 0, 45, vegetable,
     [vegan, vegetarian, gluten_free],
     [lunch, dinner]).

food(cucumber_salad, 20, 1, 4, 0, 26, vegetable,
     [vegan, vegetarian, gluten_free, low_carb],
     [breakfast, lunch, dinner]).

food(tomato_salad, 20, 1, 4, 1, 29, vegetable,
     [vegan, vegetarian, gluten_free, low_carb],
     [breakfast, lunch, dinner]).

food(brinjal_curry, 40, 1, 6, 1, 40, vegetable,
     [vegan, vegetarian, gluten_free, low_carb],
     [lunch, dinner]).

food(brinjal_moju, 90, 1, 8, 6, 55, vegetable,
     [vegan, vegetarian, gluten_free],
     [lunch, dinner]).

food(ladies_fingers_curry, 40, 2, 7, 1, 20, vegetable,
     [vegan, vegetarian, gluten_free, low_carb],
     [lunch, dinner]).

food(snake_gourd_curry, 25, 1, 5, 0, 18, vegetable,
     [vegan, vegetarian, gluten_free, low_carb],
     [lunch, dinner]).

food(bitter_gourd_stir_fry, 35, 2, 6, 1, 30, vegetable,
     [vegan, vegetarian, gluten_free, low_carb],
     [lunch, dinner]).

food(drumstick_curry, 40, 2, 7, 1, 25, vegetable,
     [vegan, vegetarian, gluten_free, low_carb],
     [lunch, dinner]).

food(cauliflower_stir_fry, 35, 2, 5, 1, 35, vegetable,
     [vegan, vegetarian, gluten_free, low_carb],
     [lunch, dinner]).

food(mushroom_stir_fry, 45, 3, 5, 1, 95, vegetable,
     [vegan, vegetarian, gluten_free, low_carb],
     [lunch, dinner]).


% ==========================================
% DIETARY RULES
% ==========================================

% If user has no diet preference, any food is accepted.
meets_diet(_, none).

% Food is accepted if its dietary tag list contains the user's diet type.
meets_diet(FoodName, DietType) :-
    food(FoodName, _, _, _, _, _, _, DietaryTags, _),
    member(DietType, DietaryTags).


% ==========================================
% MEAL TYPE RULES
% ==========================================

% Checks whether food is suitable for breakfast, lunch, or dinner.
meets_meal_type(FoodName, MealType) :-
    food(FoodName, _, _, _, _, _, _, _, MealTags),
    member(MealType, MealTags).


% ==========================================
% HEALTH CONDITION RULES
% ==========================================

% No health condition.
meets_health(_, none).

% Diabetes rule:
% - Limit foods with high carbohydrates.
% - Avoid white rice because it is high-carb and high GI compared to better options.
% - Avoid brinjal moju because it is often oily/sugary.
meets_health(FoodName, diabetes) :-
    food(FoodName, _, _, Carbs, _, _, _, _, _),
    Carbs =< 40,
    FoodName \= white_rice,
    FoodName \= brinjal_moju,
    FoodName \= whole_wheat_pasta.

% Obesity rule:
% - Select lower-calorie foods.
% - Avoid oily foods manually.
meets_health(FoodName, obesity) :-
    food(FoodName, Calories, _, _, Fats, _, _, _, _),
    Calories =< 180,
    Fats =< 9,
    FoodName \= brinjal_moju.

% Hypertension rule:
% - Since sodium is not included in your food facts,
%   manually restrict foods that are commonly salty/oily/processed.
meets_health(FoodName, hypertension) :-
    FoodName \= brinjal_moju,
    FoodName \= seer_fish,
    FoodName \= prawns.


% ==========================================
% MEAL ASSEMBLY LOGIC
% ==========================================

% Builds one meal according to the meal type.
% Structure:
% 1 Base + 1 Protein + 1 Vegetable

build_meal(MealType, Diet, Health, [Base, Protein, Veg], TotalCals, TotalCost) :-

    food(Base, BCals, _, _, _, BCost, base, _, _),
    meets_meal_type(Base, MealType),
    meets_diet(Base, Diet),
    meets_health(Base, Health),

    food(Protein, PCals, _, _, _, PCost, protein, _, _),
    meets_meal_type(Protein, MealType),
    meets_diet(Protein, Diet),
    meets_health(Protein, Health),

    food(Veg, VCals, _, _, _, VCost, vegetable, _, _),
    meets_meal_type(Veg, MealType),
    meets_diet(Veg, Diet),
    meets_health(Veg, Health),

    TotalCals is BCals + PCals + VCals,
    TotalCost is BCost + PCost + VCost.


% ==========================================
% DAILY PLAN GENERATOR
% ==========================================

generate_daily_plan(TargetCals, MaxBudget, Diet, Health, Plan, DayCals, DayCost) :-

    build_meal(breakfast, Diet, Health, Breakfast, C1, Cost1),
    build_meal(lunch, Diet, Health, Lunch, C2, Cost2),
    build_meal(dinner, Diet, Health, Dinner, C3, Cost3),

    % Ensure variety.
    Breakfast \= Lunch,
    Lunch \= Dinner,
    Breakfast \= Dinner,

    DayCals is C1 + C2 + C3,
    DayCost is Cost1 + Cost2 + Cost3,

    % Budget constraint.
    DayCost =< MaxBudget,

    % Calorie range.
    MinBuffer is TargetCals - 200,
    MaxBuffer is TargetCals + 200,
    DayCals >= MinBuffer,
    DayCals =< MaxBuffer,

    Plan = [
        breakfast(Breakfast),
        lunch(Lunch),
        dinner(Dinner)
    ].


% ==========================================
% OPTIONAL: NUTRITION BREAKDOWN RULE
% ==========================================

% This gives detailed nutrition for a selected food.
food_details(FoodName, Calories, Protein, Carbs, Fats, Cost, Category, DietaryTags, MealTags) :-
    food(FoodName, Calories, Protein, Carbs, Fats, Cost, Category, DietaryTags, MealTags).


% This gives total nutrition for one generated meal.
meal_nutrition([Base, Protein, Veg], TotalCalories, TotalProtein, TotalCarbs, TotalFats, TotalCost) :-
    food(Base, C1, P1, Carb1, F1, Cost1, _, _, _),
    food(Protein, C2, P2, Carb2, F2, Cost2, _, _, _),
    food(Veg, C3, P3, Carb3, F3, Cost3, _, _, _),

    TotalCalories is C1 + C2 + C3,
    TotalProtein is P1 + P2 + P3,
    TotalCarbs is Carb1 + Carb2 + Carb3,
    TotalFats is F1 + F2 + F3,
    TotalCost is Cost1 + Cost2 + Cost3.