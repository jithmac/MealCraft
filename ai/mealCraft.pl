% ============================================================
% MealCraft - Prolog Food Knowledge Base and Dynamic Meal Planner
% AI Based Smart Meal Planner
% Compatible with tuProlog (alice.tuprolog)
%
% Main queries:
%   ?- meal_plan(1800, omnivore, [], normal, Plan, Total).
%   ?- meal_plan(2500, vegetarian, [diabetes], normal, Plan, Total).
%   ?- backup_meal_plan(2200, omnivore, [], diet, Plan, Total).
%
% This engine DYNAMICALLY assembles meals by:
%   1. Filtering foods by meal type, diet, and health conditions
%   2. Picking different combinations of foods for each meal
%   3. Validating total calories fall within a target range
%   4. Producing many valid solutions for Java-side random selection
%
% NOTE:
% This is an educational prototype. It is not medical advice.
% Calories are estimated averages per serving.
% ============================================================



% ------------------------------------------------------------
% Food fact template
% ------------------------------------------------------------
% food(
%   Name,
%   Origin,
%   Category,
%   ServingSizeGramOrMl,
%   CaloriesPerServing,
%   CarbsGram,
%   ProteinGram,
%   FatGram,
%   MicronutrientsList,
%   AllergensList,
%   StorageAndUseNote,
%   MealTypesList,
%   DietaryTagsList
% ).

% ============================================================
% FOOD DATABASE
% ============================================================
% Foods are injected dynamically from the MySQL database
% via PrologService.java. The food/13 facts are prepended
% to this theory at runtime.
% ============================================================



% ============================================================
% LIST UTILITIES (required for tuProlog compatibility)
% ============================================================
% tuProlog may not include these as built-ins.

member(X, [X|_]).
member(X, [_|T]) :- member(X, T).

append([], L, L).
append([H|T], L, [H|R]) :- append(T, L, R).

% ============================================================
% BASIC ACCESS RULES
% ============================================================

food_name(Food) :-
    food(Food, _, _, _, _, _, _, _, _, _, _, _, _).

food_calories(Food, Calories) :-
    food(Food, _, _, _, Calories, _, _, _, _, _, _, _, _).

food_carbs(Food, Carbs) :-
    food(Food, _, _, _, _, Carbs, _, _, _, _, _, _, _).

food_protein(Food, Protein) :-
    food(Food, _, _, _, _, _, Protein, _, _, _, _, _, _).

food_fat(Food, Fat) :-
    food(Food, _, _, _, _, _, _, Fat, _, _, _, _, _).

food_serving_size(Food, ServingSize) :-
    food(Food, _, _, ServingSize, _, _, _, _, _, _, _, _, _).

food_meal(Food, MealType) :-
    food(Food, _, _, _, _, _, _, _, _, _, _, MealTags, _), member(MealType, MealTags).

has_tag(Food, Tag) :-
    food(Food, _, _, _, _, _, _, _, _, _, _, _, DietaryTags), member(Tag, DietaryTags).



% ============================================================
% DIETARY PREFERENCES
% ============================================================
% Supported diets:
%   omnivore, vegetarian, vegan, pescatarian, halal,
%   gluten_free, low_carb, diabetic_friendly, high_protein
%
% NOTE: low_carb and high_protein are "preference" diets, not
% exclusion diets. They are treated as omnivore here because:
%   - low_carb: Java reduces base serving quantities instead
%   - high_protein: Java increases protein serving quantities instead
% Forcing hard tag filters on these diets would eliminate all
% grains (low_carb) or all non-protein foods (high_protein).
%
% NOTE: diabetic_friendly accepts foods tagged either
% diabetic_friendly_ok OR diabetic_portion_control, since
% portion-controlled foods (rice, oats) are safe in limited servings.

diet_required_tag(vegetarian, vegetarian_ok).
diet_required_tag(vegan, vegan_ok).
diet_required_tag(pescatarian, pescatarian_ok).
diet_required_tag(halal, halal_ok).
diet_required_tag(gluten_free, gluten_free_ok).

diet_forbidden_tag(vegetarian, vegetarian_no).
diet_forbidden_tag(vegan, vegan_no).
diet_forbidden_tag(pescatarian, pescatarian_no).
diet_forbidden_tag(gluten_free, contains_gluten).
diet_forbidden_tag(gluten_free, gluten_free_only_if_certified).

suitable_for_diet(_, omnivore).
suitable_for_diet(_, low_carb).
suitable_for_diet(_, high_protein).

% Diabetic-friendly: accept foods with EITHER diabetic_friendly_ok
% OR diabetic_portion_control (safe in controlled servings)
suitable_for_diet(Food, diabetic_friendly) :-
    (has_tag(Food, diabetic_friendly_ok) ; has_tag(Food, diabetic_portion_control)),
    \+ has_tag(Food, diabetic_caution).

suitable_for_diet(Food, Diet) :-
    Diet \= omnivore,
    Diet \= low_carb,
    Diet \= high_protein,
    Diet \= diabetic_friendly,
    diet_required_tag(Diet, RequiredTag),
    has_tag(Food, RequiredTag),
    \+ (diet_forbidden_tag(Diet, BadTag), has_tag(Food, BadTag)).

% ============================================================
% HEALTH CONDITIONS
% ============================================================
% Supported health conditions:
%   overweight, diabetes, hypertension, heart_disease,
%   kidney_disease, gout, celiac, lactose_intolerance,
%   ibs, pregnancy

avoid_tag(overweight, high_calorie_dense).
avoid_tag(overweight, high_sat_fat_caution).

avoid_tag(diabetes, diabetic_caution).
% NOTE: low_carb_no is NOT avoided for diabetes — diabetics can eat
% carbs in controlled portions. The diabetic_friendly diet handles
% carb-appropriate food selection via diet_required_tag.

avoid_tag(hypertension, high_sodium_caution).
avoid_tag(hypertension, high_sat_fat_caution).

avoid_tag(heart_disease, high_sat_fat_caution).
avoid_tag(heart_disease, high_sodium_caution).

avoid_tag(kidney_disease, ckd_potassium_caution).
avoid_tag(kidney_disease, high_sodium_caution).

avoid_tag(gout, high_purine_caution).

avoid_tag(celiac, contains_gluten).
avoid_tag(celiac, gluten_free_only_if_certified).
avoid_tag(celiac, gluten_free_if_made_without_wheat).

avoid_tag(lactose_intolerance, lactose_present).

avoid_tag(ibs, low_fodmap_no).

avoid_tag(pregnancy, high_sodium_caution).

prefer_tag(overweight, low_carb_ok).
prefer_tag(overweight, high_fiber).

prefer_tag(diabetes, diabetic_friendly_ok).
prefer_tag(diabetes, high_fiber).

prefer_tag(hypertension, low_carb_ok).
prefer_tag(hypertension, diabetic_friendly_ok).

prefer_tag(heart_disease, high_fiber).
prefer_tag(heart_disease, diabetic_friendly_ok).

prefer_tag(kidney_disease, low_sodium_ok).

prefer_tag(gout, low_purine_ok).

prefer_tag(celiac, gluten_free_ok).

prefer_tag(lactose_intolerance, vegan_ok).

prefer_tag(ibs, low_fodmap_ok).

prefer_tag(pregnancy, high_protein).

unsafe_for_condition(Food, Condition) :-
    avoid_tag(Condition, BadTag),
    has_tag(Food, BadTag).

safe_for_condition(Food, Condition) :-
    \+ unsafe_for_condition(Food, Condition).

safe_for_conditions(_, []).
safe_for_conditions(Food, [Condition|Rest]) :-
    safe_for_condition(Food, Condition),
    safe_for_conditions(Food, Rest).

food_good_for(Condition, Food) :-
    food_name(Food),
    safe_for_condition(Food, Condition),
    (
        prefer_tag(Condition, GoodTag),
        has_tag(Food, GoodTag)
    ;
        has_tag(Food, diabetic_friendly_ok),
        member(Condition, [diabetes, overweight, heart_disease])
    ).

food_bad_for(Condition, Food) :-
    food_name(Food),
    unsafe_for_condition(Food, Condition).


% ============================================================
% ITEM, MEAL AND PLAN CALCULATION
% ============================================================
% A meal item has this format:
%   item(Food, Quantity)
%
% Example:
%   item(oats, 3)
% means 3 servings of oats.

item_calories(item(Food, Quantity), TotalCalories) :-
    food_calories(Food, CaloriesPerServing),
    TotalCalories is CaloriesPerServing * Quantity.

item_carbs(item(Food, Quantity), TotalCarbs) :-
    food_carbs(Food, CarbsPerServing),
    TotalCarbs is CarbsPerServing * Quantity.

item_protein(item(Food, Quantity), TotalProtein) :-
    food_protein(Food, ProteinPerServing),
    TotalProtein is ProteinPerServing * Quantity.

item_fat(item(Food, Quantity), TotalFat) :-
    food_fat(Food, FatPerServing),
    TotalFat is FatPerServing * Quantity.

meal_total([], 0).
meal_total([Item|Rest], Total) :-
    item_calories(Item, ItemCalories),
    meal_total(Rest, RestCalories),
    Total is ItemCalories + RestCalories.

meal_macro_total([], 0, 0, 0).
meal_macro_total([Item|Rest], Carbs, Protein, Fat) :-
    item_carbs(Item, ItemCarbs),
    item_protein(Item, ItemProtein),
    item_fat(Item, ItemFat),
    meal_macro_total(Rest, RestCarbs, RestProtein, RestFat),
    Carbs is ItemCarbs + RestCarbs,
    Protein is ItemProtein + RestProtein,
    Fat is ItemFat + RestFat.

plan_total(plan(Breakfast, Lunch, Dinner), TotalCalories) :-
    meal_total(Breakfast, BreakfastCalories),
    meal_total(Lunch, LunchCalories),
    meal_total(Dinner, DinnerCalories),
    TotalCalories is BreakfastCalories + LunchCalories + DinnerCalories.

plan_macro_total(plan(Breakfast, Lunch, Dinner), Carbs, Protein, Fat) :-
    meal_macro_total(Breakfast, BCarbs, BProtein, BFat),
    meal_macro_total(Lunch, LCarbs, LProtein, LFat),
    meal_macro_total(Dinner, DCarbs, DProtein, DFat),
    Carbs is BCarbs + LCarbs + DCarbs,
    Protein is BProtein + LProtein + DProtein,
    Fat is BFat + LFat + DFat.

% ============================================================
% FOOD CATEGORIES FOR MEAL ASSEMBLY
% ============================================================
% Foods are classified into roles for building balanced meals.

food_category(Food, Category) :-
    food(Food, _, Category, _, _, _, _, _, _, _, _, _, _).

% A food is a "base" (starch/carb) if its category is grain, tuber, or cereal.
is_base(Food) :- food_category(Food, grain).
is_base(Food) :- food_category(Food, tuber).
is_base(Food) :- food_category(Food, cereal).
is_base(Food) :- food_category(Food, bread).

% A food is a "protein source" if its category is protein, legume, fish, dairy, or meat.
is_protein_source(Food) :- food_category(Food, protein).
is_protein_source(Food) :- food_category(Food, meat).
is_protein_source(Food) :- food_category(Food, legume).
is_protein_source(Food) :- food_category(Food, fish).
is_protein_source(Food) :- food_category(Food, dairy).
is_protein_source(Food) :- food_category(Food, egg).

% A food is a "side" (vegetable/accompaniment).
is_side(Food) :- food_category(Food, vegetable).
is_side(Food) :- food_category(Food, curry).
is_side(Food) :- food_category(Food, mallung).
is_side(Food) :- food_category(Food, condiment).
is_side(Food) :- food_category(Food, salad).

% A food is a "light item" (fruit, drink, snack, dairy).
is_light(Food) :- food_category(Food, fruit).
is_light(Food) :- food_category(Food, beverage).
is_light(Food) :- food_category(Food, snack).
is_light(Food) :- food_category(Food, nut).

% ============================================================
% DYNAMIC FOOD SELECTION
% ============================================================
% Pick a food that is suitable for a given meal type, diet,
% and set of health conditions.

pick_food(Food, MealType, Diet, Conditions) :-
    food_name(Food),
    food_meal(Food, MealType),
    suitable_for_diet(Food, Diet),
    safe_for_conditions(Food, Conditions).

% Pick a base food for a meal.
pick_base(Food, MealType, Diet, Conditions) :-
    pick_food(Food, MealType, Diet, Conditions),
    is_base(Food).

% Pick a protein food for a meal.
pick_protein(Food, MealType, Diet, Conditions) :-
    pick_food(Food, MealType, Diet, Conditions),
    is_protein_source(Food).

% Pick a side food for a meal.
pick_side(Food, MealType, Diet, Conditions) :-
    pick_food(Food, MealType, Diet, Conditions),
    is_side(Food).

% Pick a light food for a meal.
pick_light(Food, MealType, Diet, Conditions) :-
    pick_food(Food, MealType, Diet, Conditions),
    is_light(Food).

% ============================================================
% NOTE: Meal assembly is handled by Java (PrologService.java).
% Java queries pick_base/pick_protein/pick_side/pick_light
% to get lists of valid foods, then randomly assembles meals
% and validates calories using plan_total and plan_macro_total.
% ============================================================



% ============================================================
% UTILITY PREDICATES
% ============================================================

% Check the amount of one selected food item.
% Example:
% ?- food_amount(oats, 3, Amount).
food_amount(Food, Quantity, AmountGramsOrMl) :-
    food_serving_size(Food, ServingSize),
    AmountGramsOrMl is ServingSize * Quantity.

% ============================================================
% DISPLAY HELPERS
% ============================================================

print_item(item(Food, Quantity)) :-
    food_calories(Food, Calories),
    food_serving_size(Food, ServingSize),
    ItemCalories is Calories * Quantity,
    TotalGramsOrMl is ServingSize * Quantity,
    write('- '), write(Food),
    write(' x '), write(Quantity),
    write(' serving(s)'),
    write(' | serving size: '), write(ServingSize), write(' g/ml'),
    write(' | total amount: '), write(TotalGramsOrMl), write(' g/ml'),
    write(' | calories: '), write(ItemCalories), write(' kcal'), nl.

print_meal([]).
print_meal([Item|Rest]) :-
    print_item(Item),
    print_meal(Rest).

print_plan(plan(Breakfast, Lunch, Dinner)) :-
    meal_total(Breakfast, BCal),
    meal_total(Lunch, LCal),
    meal_total(Dinner, DCal),
    write('BREAKFAST ('), write(BCal), write(' kcal)'), nl,
    print_meal(Breakfast), nl,
    write('LUNCH ('), write(LCal), write(' kcal)'), nl,
    print_meal(Lunch), nl,
    write('DINNER ('), write(DCal), write(' kcal)'), nl,
    print_meal(Dinner), nl,
    plan_total(plan(Breakfast, Lunch, Dinner), Total),
    write('TOTAL = '), write(Total), write(' kcal'), nl.

suggest(TargetCalories, Diet, Conditions) :-
    meal_plan(TargetCalories, Diet, Conditions, normal, Plan, TotalCalories),
    print_plan(Plan),
    plan_macro_total(Plan, Carbs, Protein, Fat),
    nl,
    write('Estimated macros:'), nl,
    write('Carbs: '), write(Carbs), write(' g'), nl,
    write('Protein: '), write(Protein), write(' g'), nl,
    write('Fat: '), write(Fat), write(' g'), nl,
    write('Matched total calories: '), write(TotalCalories), write(' kcal'), nl.

% ============================================================
% HARRIS-BENEDICT CALORIE ESTIMATION
% ============================================================
% Gender: male or female
% Activity level:
%   sedentary, light, moderate, active, very_active

activity_factor(sedentary, 1.2).
activity_factor(light, 1.375).
activity_factor(moderate, 1.55).
activity_factor(active, 1.725).
activity_factor(very_active, 1.9).

bmr(male, WeightKg, HeightCm, AgeYears, BMR) :-
    BMR is 88.362 + (13.397 * WeightKg) + (4.799 * HeightCm) - (5.677 * AgeYears).

bmr(female, WeightKg, HeightCm, AgeYears, BMR) :-
    BMR is 447.593 + (9.247 * WeightKg) + (3.098 * HeightCm) - (4.330 * AgeYears).

daily_calorie_need(Gender, WeightKg, HeightCm, AgeYears, ActivityLevel, Calories) :-
    bmr(Gender, WeightKg, HeightCm, AgeYears, BMR),
    activity_factor(ActivityLevel, Factor),
    CaloriesFloat is BMR * Factor,
    Calories is round(CaloriesFloat).

% Example:
% ?- daily_calorie_need(male, 75, 175, 22, very_active, Calories).
% ?- daily_calorie_need(male, 75, 175, 22, very_active, Calories),
%    suggest(Calories, omnivore, []).
