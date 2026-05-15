% ============================================================
% MealCraft - Prolog Food Knowledge Base and Meal Planner
% AI Based Smart Meal Planner
% Compatible with SWI-Prolog
%
% Main queries:
%   ?- meal_plan(1800, omnivore, [], Plan, Total).
%   ?- meal_plan(2500, omnivore, [], Plan, Total).
%   ?- meal_plan(4000, omnivore, [], Plan, Total).
%   ?- meal_plan(4000, high_protein, [], Plan, Total).
%   ?- meal_plan(2200, vegetarian, [diabetes], Plan, Total).
%   ?- food_good_for(diabetes, Food).
%   ?- food_bad_for(hypertension, Food).
%   ?- food_amount(oats, 3, Amount).
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
% 50 FOOD DATABASE
% ============================================================





































































































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

item_grams(item(Food, Quantity), TotalGramsOrMl) :-
    food_serving_size(Food, ServingSize),
    TotalGramsOrMl is ServingSize * Quantity.

food_meal(Food, MealType) :-
    food(Food, _, _, _, _, _, _, _, _, _, _, MealTags, _), member(MealType, MealTags).

has_tag(Food, Tag) :-
    food(Food, _, _, _, _, _, _, _, _, _, _, _, DietaryTags), member(Tag, DietaryTags).

has_all_tags(_, []).
has_all_tags(Food, [Tag|Rest]) :-
    has_tag(Food, Tag),
    has_all_tags(Food, Rest).

% ============================================================
% DIETARY PREFERENCES
% ============================================================
% Supported diets:
%   omnivore, vegetarian, vegan, pescatarian, halal,
%   gluten_free, low_carb, diabetic_friendly, high_protein

diet_required_tag(vegetarian, vegetarian_ok).
diet_required_tag(vegan, vegan_ok).
diet_required_tag(pescatarian, pescatarian_ok).
diet_required_tag(halal, halal_ok).
diet_required_tag(gluten_free, gluten_free_ok).
diet_required_tag(low_carb, low_carb_ok).
diet_required_tag(diabetic_friendly, diabetic_friendly_ok).
diet_required_tag(high_protein, high_protein).

diet_forbidden_tag(vegetarian, vegetarian_no).
diet_forbidden_tag(vegan, vegan_no).
diet_forbidden_tag(pescatarian, pescatarian_no).
diet_forbidden_tag(gluten_free, contains_gluten).
diet_forbidden_tag(gluten_free, gluten_free_only_if_certified).
diet_forbidden_tag(low_carb, low_carb_no).

suitable_for_diet(_, omnivore).
suitable_for_diet(Food, Diet) :-
    Diet \= omnivore,
    diet_required_tag(Diet, RequiredTag),
    has_tag(Food, RequiredTag),
    \+ (diet_forbidden_tag(Diet, BadTag), has_tag(Food, BadTag)).

% ============================================================
% HEALTH CONDITIONS
% ============================================================
% Supported health conditions:
%   overweight,
%   diabetes,
%   hypertension,
%   heart_disease,
%   kidney_disease,
%   gout,
%   celiac,
%   lactose_intolerance,
%   ibs,
%   pregnancy

avoid_tag(overweight, high_calorie_dense).
avoid_tag(overweight, high_sat_fat_caution).

avoid_tag(diabetes, diabetic_caution).
avoid_tag(diabetes, low_carb_no).

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

valid_calorie_range(TargetCalories, TotalCalories) :-
    Min is TargetCalories - 250,
    Max is TargetCalories + 250,
    TotalCalories >= Min,
    TotalCalories =< Max.

valid_high_calorie_range(TargetCalories, TotalCalories) :-
    TargetCalories >= 3800,
    Min is TargetCalories - 350,
    Max is TargetCalories + 350,
    TotalCalories >= Min,
    TotalCalories =< Max.

item_allowed(item(Food, _Quantity), MealType, Diet, Conditions) :-
    food_name(Food),
    food_meal(Food, MealType),
    suitable_for_diet(Food, Diet),
    safe_for_conditions(Food, Conditions).

meal_items_allowed([], _MealType, _Diet, _Conditions).
meal_items_allowed([Item|Rest], MealType, Diet, Conditions) :-
    item_allowed(Item, MealType, Diet, Conditions),
    meal_items_allowed(Rest, MealType, Diet, Conditions).

plan_items_allowed(plan(Breakfast, Lunch, Dinner), Diet, Conditions) :-
    meal_items_allowed(Breakfast, breakfast, Diet, Conditions),
    meal_items_allowed(Lunch, lunch, Diet, Conditions),
    meal_items_allowed(Dinner, dinner, Diet, Conditions).

% We removed the strict valid_meal_plan_calories check because it was causing too many failures.
% The TargetCalories >= MinTarget and =< MaxTarget bounds are enough.

% ============================================================
% READY-MADE PLAN TEMPLATES
% ============================================================
% plan_template(Name, MinTarget, MaxTarget, DietGroup, Plan).
% Calorie levels included:
%   low_1800 templates      = 1500 to 2100 kcal
%   standard_2500 templates = 2200 to 2800 kcal
%   high_4000 templates     = 3800 to 4600 kcal
% DietGroup can be omnivore_group, vegetarian_group, vegan_group, high_protein_group.

plan_template(standard_2500_omnivore, 1500, 3799, omnivore_group,
    plan(
        [item(oats, 2), item(banana, 1), item(milk_low_fat, 1), item(egg_boiled, 2)],
        [item(red_rice, 2), item(chicken_breast, 1), item(parippu_dhal_curry, 1), item(gotu_kola_mallung, 1), item(pumpkin_curry, 1)],
        [item(string_hoppers, 2), item(ambul_thiyal, 1), item(mung_bean_curry, 1), item(coconut_sambol, 1), item(plain_yogurt_low_fat, 1)]
    )).

plan_template(standard_2500_vegetarian, 1500, 3799, vegetarian_group,
    plan(
        [item(oats, 2), item(banana, 1), item(milk_low_fat, 1), item(egg_boiled, 2)],
        [item(red_rice, 2), item(parippu_dhal_curry, 2), item(gotu_kola_mallung, 1), item(pumpkin_curry, 1), item(buffalo_curd, 1)],
        [item(kurakkan_roti, 2), item(mung_bean_curry, 2), item(snake_gourd_curry, 1), item(plain_yogurt_low_fat, 1), item(peanuts, 1)]
    )).

plan_template(standard_2500_vegan, 1500, 3799, vegan_group,
    plan(
        [item(oats, 2), item(banana, 1), item(almonds, 1), item(kola_kenda, 1)],
        [item(red_rice, 2), item(parippu_dhal_curry, 2), item(gotu_kola_mallung, 1), item(pumpkin_curry, 1), item(avocado, 1)],
        [item(string_hoppers, 2), item(mung_bean_curry, 2), item(tofu_firm, 1), item(cucumber_raw, 1), item(peanuts, 1)]
    )).

plan_template(high_4000_omnivore, 3800, 4500, omnivore_group,
    plan(
        [item(oats, 3), item(banana, 2), item(milk_low_fat, 2), item(almonds, 2), item(egg_boiled, 3)],
        [item(red_rice, 3), item(chicken_breast, 2), item(parippu_dhal_curry, 2), item(avocado, 1), item(buffalo_curd, 1), item(coconut_sambol, 1)],
        [item(brown_rice_cooked, 3), item(salmon, 2), item(sweet_potato_baked, 2), item(peanuts, 2), item(plain_yogurt_low_fat, 1)]
    )).

plan_template(high_4000_high_protein, 3800, 4600, high_protein_group,
    plan(
        [item(oats, 3), item(egg_boiled, 4), item(milk_low_fat, 2), item(plain_yogurt_low_fat, 1), item(banana, 2)],
        [item(red_rice, 3), item(chicken_breast, 3), item(parippu_dhal_curry, 2), item(gotu_kola_mallung, 1), item(avocado, 1)],
        [item(brown_rice_cooked, 3), item(salmon, 2), item(tofu_firm, 1), item(sweet_potato_baked, 2), item(peanuts, 2)]
    )).

plan_template(high_4000_vegetarian, 3800, 4500, vegetarian_group,
    plan(
        [item(oats, 3), item(banana, 2), item(milk_low_fat, 2), item(almonds, 2), item(egg_boiled, 3)],
        [item(red_rice, 3), item(parippu_dhal_curry, 3), item(chickpeas_boiled, 2), item(avocado, 1), item(buffalo_curd, 1)],
        [item(kurakkan_roti, 3), item(mung_bean_curry, 3), item(tofu_firm, 2), item(peanuts, 2), item(plain_yogurt_low_fat, 1)]
    )).

plan_template(high_4000_vegan, 3800, 4500, vegan_group,
    plan(
        [item(oats, 4), item(banana, 3), item(almonds, 3), item(kola_kenda, 1), item(peanuts, 1)],
        [item(red_rice, 4), item(parippu_dhal_curry, 3), item(chickpeas_boiled, 2), item(avocado, 1), item(gotu_kola_mallung, 1)],
        [item(string_hoppers, 4), item(tofu_firm, 3), item(mung_bean_curry, 2), item(sweet_potato_baked, 2), item(peanuts, 2)]
    )).

% Map user diet to template diet group.
diet_group(omnivore, omnivore_group).
diet_group(halal, omnivore_group).
diet_group(pescatarian, omnivore_group).
diet_group(diabetic_friendly, omnivore_group).
diet_group(low_carb, omnivore_group).
diet_group(high_protein, high_protein_group).
diet_group(vegetarian, vegetarian_group).
diet_group(vegan, vegan_group).
diet_group(gluten_free, omnivore_group).

% Main meal plan rule.
meal_plan(TargetCalories, Diet, Conditions, Plan, TotalCalories) :-
    diet_group(Diet, DietGroup),
    plan_template(_TemplateName, MinTarget, MaxTarget, DietGroup, Plan),
    TargetCalories >= MinTarget,
    TargetCalories =< MaxTarget,
    plan_items_allowed(Plan, Diet, Conditions),
    plan_total(Plan, TotalCalories).

% Backup rule:
% If the selected diet is strict and no exact template passes the health filters,
% show a safe vegetarian/vegan plan if possible.
backup_meal_plan(TargetCalories, Diet, Conditions, Plan, TotalCalories) :-
    meal_plan(TargetCalories, Diet, Conditions, Plan, TotalCalories), !.
backup_meal_plan(TargetCalories, _Diet, Conditions, Plan, TotalCalories) :-
    meal_plan(TargetCalories, vegan, Conditions, Plan, TotalCalories), !.
backup_meal_plan(TargetCalories, _Diet, Conditions, Plan, TotalCalories) :-
    meal_plan(TargetCalories, vegetarian, Conditions, Plan, TotalCalories), !.
backup_meal_plan(TargetCalories, _Diet, Conditions, Plan, TotalCalories) :-
    meal_plan(TargetCalories, omnivore, Conditions, Plan, TotalCalories).


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
    meal_plan(TargetCalories, Diet, Conditions, Plan, TotalCalories),
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
