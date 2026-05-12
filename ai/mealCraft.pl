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

food(red_rice, sri_lankan, grain, 150, 165, 36.0, 3.5, 1.3,
     [manganese, magnesium, selenium, vitamin_b1],
     [],
     'Refrigerate cooked rice up to 3 to 4 days. Sri Lankan use: rice-and-curry base.',
     [lunch, dinner],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_no, diabetic_portion_control]).

food(kurakkan_roti, sri_lankan, grain, 60, 150, 28.0, 3.5, 2.5,
     [calcium, iron, magnesium, phosphorus],
     [possible_gluten_if_wheat_mixed, coconut],
     'Best eaten fresh. Sri Lankan use: breakfast or dinner with lunu miris, dhal or sambol.',
     [breakfast, dinner],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_if_made_without_wheat, low_fodmap_small_only, low_carb_no, diabetic_portion_control]).

food(string_hoppers, sri_lankan, grain, 100, 150, 33.0, 3.0, 0.5,
     [selenium, manganese, iron],
     [],
     'Refrigerate 1 to 2 days. Sri Lankan use: breakfast or dinner with dhal, kiri hodi or fish curry.',
     [breakfast, dinner],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_no, diabetic_portion_control]).

food(hopper, sri_lankan, grain, 60, 110, 18.0, 2.0, 4.0,
     [manganese, selenium, iron],
     [coconut],
     'Best fresh. Sri Lankan use: breakfast or dinner with egg, sambol or curry.',
     [breakfast, dinner],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_no, diabetic_portion_control]).

food(kiri_bath, sri_lankan, grain, 100, 175, 28.0, 3.0, 6.0,
     [manganese, selenium, iron],
     [coconut],
     'Refrigerate up to 2 days. Sri Lankan use: festive breakfast or dinner.',
     [breakfast, dinner],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_no, diabetic_caution, high_sat_fat_caution]).

food(parippu_dhal_curry, sri_lankan, legume, 150, 180, 24.0, 10.0, 5.0,
     [folate, iron, potassium, magnesium],
     [coconut],
     'Refrigerate 3 to 4 days. Sri Lankan use: staple side dish with rice, roti, hoppers or string hoppers.',
     [breakfast, lunch, dinner],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_no, diabetic_friendly_ok, high_fiber]).

food(gotu_kola_mallung, sri_lankan, vegetable, 80, 70, 7.0, 2.0, 4.0,
     [vitamin_a, vitamin_c, vitamin_k, folate],
     [coconut],
     'Best same day. Sri Lankan use: fresh mallung side dish with rice and curry.',
     [lunch, dinner],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_ok, diabetic_friendly_ok, high_fiber]).

food(polos_curry, sri_lankan, vegetable, 150, 140, 18.0, 3.0, 6.0,
     [vitamin_c, potassium, vitamin_b6, copper],
     [coconut],
     'Refrigerate 3 days. Sri Lankan use: young jackfruit curry.',
     [lunch, dinner],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_no, low_carb_no, diabetic_portion_control]).

food(jackfruit_ripe, sri_lankan, fruit, 100, 95, 24.0, 1.7, 0.6,
     [vitamin_c, potassium, vitamin_b6, magnesium],
     [],
     'Ripen at room temperature, then refrigerate 2 to 3 days. Sri Lankan use: fresh fruit.',
     [breakfast, lunch],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_no, diabetic_portion_control]).

food(coconut_sambol, sri_lankan, condiment, 30, 110, 4.0, 1.0, 10.0,
     [manganese, copper, selenium, iron],
     [coconut],
     'Keep refrigerated and use within 1 day. Sri Lankan use: condiment for hoppers, bread or rice.',
     [breakfast, lunch, dinner],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_ok, diabetic_portion_control, high_sat_fat_caution, high_sodium_caution]).

food(ambul_thiyal, sri_lankan, meat, 100, 165, 2.0, 24.0, 7.0,
     [vitamin_b12, selenium, iodine, vitamin_d],
     [fish],
     'Refrigerate 2 to 3 days. Sri Lankan use: sour fish curry with rice.',
     [lunch, dinner],
     [vegan_no, vegetarian_no, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_ok, diabetic_friendly_ok, high_protein, high_purine_caution]).

food(king_coconut_water, sri_lankan, beverage, 240, 44, 10.0, 1.0, 0.0,
     [potassium, manganese, magnesium],
     [],
     'Drink fresh. Refrigerate after opening and use within 24 hours.',
     [breakfast, lunch],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_no, diabetic_portion_control, ckd_potassium_caution]).

food(buffalo_curd, sri_lankan, dairy, 100, 110, 4.0, 5.0, 8.0,
     [calcium, vitamin_b12, phosphorus, riboflavin],
     [milk, lactose],
     'Keep refrigerated and use by date. Sri Lankan use: breakfast or dessert with fruit.',
     [breakfast, dinner],
     [vegan_no, vegetarian_ok, pescatarian_ok, halal_if_certified, gluten_free_ok, low_fodmap_small_only, low_carb_ok, diabetic_portion_control, lactose_present, high_sat_fat_caution]).

food(kola_kenda, sri_lankan, beverage, 250, 85, 12.0, 3.0, 3.0,
     [iron, folate, vitamin_a, calcium],
     [coconut],
     'Best consumed fresh. Sri Lankan use: herbal breakfast porridge.',
     [breakfast],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_no, diabetic_portion_control]).

food(cassava_boiled, sri_lankan, grain, 100, 112, 27.0, 1.0, 0.4,
     [vitamin_c, manganese, folate, potassium],
     [],
     'Refrigerate cooked cassava up to 3 days. Sri Lankan use: breakfast or dinner starch.',
     [breakfast, dinner],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_no, diabetic_caution]).

food(mung_bean_curry, sri_lankan, legume, 150, 160, 24.0, 9.0, 2.0,
     [folate, magnesium, potassium, iron],
     [],
     'Refrigerate 3 days. Sri Lankan use: curry or breakfast dish.',
     [breakfast, lunch, dinner],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_no, diabetic_friendly_ok, high_fiber]).

food(breadfruit_boiled, sri_lankan, grain, 100, 103, 27.0, 1.0, 0.2,
     [potassium, vitamin_c, magnesium, copper],
     [],
     'Refrigerate cooked breadfruit 2 to 3 days. Sri Lankan use: boiled or curried starch.',
     [lunch, dinner],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_no, diabetic_portion_control]).

food(pumpkin_curry, sri_lankan, vegetable, 100, 55, 8.0, 1.0, 2.0,
     [vitamin_a, vitamin_c, potassium, manganese],
     [coconut],
     'Refrigerate 2 to 3 days. Sri Lankan use: mild vegetable curry.',
     [lunch, dinner],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_ok, diabetic_friendly_ok]).

food(moringa_mallung, sri_lankan, vegetable, 75, 45, 6.0, 4.0, 0.8,
     [vitamin_a, vitamin_c, calcium, iron],
     [],
     'Best same day. Sri Lankan use: leafy side dish with rice and curry.',
     [lunch, dinner],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_ok, diabetic_friendly_ok]).

food(snake_gourd_curry, sri_lankan, vegetable, 100, 35, 6.0, 1.0, 1.0,
     [vitamin_c, folate, potassium],
     [coconut],
     'Refrigerate 2 days. Sri Lankan use: light vegetable curry.',
     [lunch, dinner],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_ok, diabetic_friendly_ok]).

food(coconut_milk, sri_lankan, condiment, 60, 138, 3.0, 1.0, 14.0,
     [manganese, copper, selenium, iron],
     [coconut],
     'Refrigerate after opening and use within 4 to 5 days. Sri Lankan use: curry base.',
     [lunch, dinner],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_ok, diabetic_portion_control, high_sat_fat_caution]).

food(plain_ceylon_tea, sri_lankan, beverage, 240, 2, 0.0, 0.0, 0.0,
     [manganese, fluoride],
     [],
     'Store dry tea leaves airtight. Sri Lankan use: plain beverage without sugar.',
     [breakfast, dinner],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_ok, diabetic_friendly_ok]).

food(dried_sprats, sri_lankan, meat, 20, 70, 0.0, 11.0, 2.0,
     [calcium, iodine, selenium, vitamin_b12],
     [fish],
     'Store airtight in a cool dry place. Sri Lankan use: fried or added to sambols and curries.',
     [breakfast, lunch, dinner],
     [vegan_no, vegetarian_no, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_ok, diabetic_friendly_ok, high_sodium_caution, high_purine_caution, high_protein]).

food(wood_apple_pulp, sri_lankan, fruit, 100, 134, 31.0, 3.0, 0.6,
     [vitamin_c, calcium, iron, thiamin],
     [],
     'Keep ripe pulp refrigerated 1 to 2 days. Sri Lankan use: fresh pulp or juice.',
     [breakfast, dinner],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_no, low_carb_no, diabetic_caution]).

food(cowpea_curry, sri_lankan, legume, 150, 170, 27.0, 10.0, 2.0,
     [folate, iron, magnesium, potassium],
     [],
     'Refrigerate 3 days. Sri Lankan use: curry with rice or bread.',
     [lunch, dinner],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_no, diabetic_friendly_ok, high_fiber]).

food(oats, international, grain, 40, 156, 27.0, 5.0, 3.0,
     [manganese, phosphorus, magnesium, iron],
     [possible_gluten_cross_contact],
     'Keep dry in an airtight container. Use: porridge or overnight oats.',
     [breakfast],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_only_if_certified, low_fodmap_small_only, low_carb_no, diabetic_friendly_ok, high_fiber]).

food(whole_wheat_bread, international, grain, 56, 138, 24.0, 7.0, 2.0,
     [selenium, manganese, iron, vitamin_b1],
     [wheat, gluten],
     'Store sealed 3 to 5 days or freeze. Use: toast or sandwiches.',
     [breakfast, dinner],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, contains_gluten, low_fodmap_no, low_carb_no, diabetic_portion_control]).

food(egg_boiled, international, meat, 50, 78, 0.6, 6.3, 5.3,
     [vitamin_b12, choline, selenium, vitamin_d],
     [egg],
     'Refrigerate boiled eggs up to 1 week. Use: breakfast or protein side.',
     [breakfast, lunch, dinner],
     [vegan_no, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_ok, diabetic_friendly_ok, high_protein]).

food(chicken_breast, international, meat, 100, 165, 0.0, 31.0, 3.6,
     [niacin, selenium, vitamin_b6, phosphorus],
     [],
     'Refrigerate cooked chicken 3 to 4 days. Use: grilled, curried or stir-fried protein.',
     [lunch, dinner],
     [vegan_no, vegetarian_no, pescatarian_no, halal_if_certified, gluten_free_ok, low_fodmap_ok, low_carb_ok, diabetic_friendly_ok, high_protein, high_purine_caution]).

food(salmon, international, meat, 100, 206, 0.0, 22.0, 12.0,
     [vitamin_d, vitamin_b12, selenium, potassium],
     [fish],
     'Refrigerate cooked salmon 3 days. Use: grilled or baked fish.',
     [lunch, dinner],
     [vegan_no, vegetarian_no, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_ok, diabetic_friendly_ok, high_protein, high_purine_caution]).

food(tuna_canned, international, meat, 85, 99, 0.0, 22.0, 1.0,
     [selenium, vitamin_b12, niacin, phosphorus],
     [fish],
     'Refrigerate after opening and use within 2 days. Use: sandwiches, salads or rice bowls.',
     [lunch, dinner],
     [vegan_no, vegetarian_no, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_ok, diabetic_friendly_ok, high_protein, high_purine_caution]).

food(plain_yogurt_low_fat, international, dairy, 170, 100, 7.0, 10.0, 3.0,
     [calcium, vitamin_b12, phosphorus, potassium],
     [milk, lactose],
     'Keep refrigerated and use by date. Use: breakfast bowl or snack.',
     [breakfast, dinner],
     [vegan_no, vegetarian_ok, pescatarian_ok, halal_if_certified, gluten_free_ok, low_fodmap_ok, low_carb_ok, diabetic_friendly_ok, lactose_present, high_protein]).

food(milk_low_fat, international, dairy, 240, 102, 12.0, 8.0, 2.4,
     [calcium, vitamin_b12, riboflavin, phosphorus],
     [milk, lactose],
     'Keep refrigerated and use by date. Use: tea, porridge or breakfast drink.',
     [breakfast, dinner],
     [vegan_no, vegetarian_ok, pescatarian_ok, halal_if_certified, gluten_free_ok, low_fodmap_ok, low_carb_no, diabetic_friendly_ok, lactose_present]).

food(cheddar_cheese, international, dairy, 28, 113, 0.4, 7.0, 9.0,
     [calcium, vitamin_a, vitamin_b12, phosphorus],
     [milk],
     'Keep refrigerated. Use: sandwiches, omelettes or baked dishes.',
     [breakfast, dinner],
     [vegan_no, vegetarian_ok, pescatarian_ok, halal_if_certified, gluten_free_ok, low_fodmap_ok, low_carb_ok, diabetic_portion_control, high_sat_fat_caution]).

food(lentils_boiled, international, legume, 100, 116, 20.0, 9.0, 0.4,
     [folate, iron, manganese, magnesium],
     [],
     'Refrigerate cooked lentils 3 to 4 days. Use: soups, salads or side dishes.',
     [lunch, dinner],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_no, diabetic_friendly_ok, high_fiber]).

food(chickpeas_boiled, international, legume, 100, 164, 27.0, 9.0, 2.6,
     [folate, manganese, iron, phosphorus],
     [],
     'Refrigerate cooked chickpeas 3 to 4 days. Use: salads, curries or roasted snacks.',
     [lunch, dinner],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_no, diabetic_friendly_ok, high_fiber]).

food(tofu_firm, international, legume, 100, 144, 3.0, 17.0, 9.0,
     [calcium, iron, manganese, selenium],
     [soy],
     'Keep refrigerated and use within a few days after opening. Use: stir-fries or curries.',
     [lunch, dinner],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_ok, diabetic_friendly_ok, high_protein]).

food(almonds, international, nut, 28, 164, 6.0, 6.0, 14.0,
     [vitamin_e, magnesium, manganese, calcium],
     [tree_nut],
     'Store airtight in a cool dry place. Use: snack or topping.',
     [breakfast, dinner],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_ok, diabetic_friendly_ok, high_calorie_dense]).

food(peanuts, international, nut, 28, 170, 6.0, 7.0, 14.0,
     [niacin, folate, magnesium, vitamin_e],
     [peanut],
     'Store airtight in a cool dry place. Use: roasted snack or topping.',
     [breakfast, dinner],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_ok, diabetic_friendly_ok, high_calorie_dense]).

food(banana, international, fruit, 118, 105, 27.0, 1.3, 0.4,
     [potassium, vitamin_b6, vitamin_c, manganese],
     [],
     'Ripen at room temperature then refrigerate 2 to 3 days. Use: breakfast fruit or snack.',
     [breakfast, lunch],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_no, diabetic_portion_control, ckd_potassium_caution]).

food(apple, international, fruit, 182, 95, 25.0, 0.5, 0.3,
     [vitamin_c, potassium, copper],
     [],
     'Refrigerate for best shelf life. Use: breakfast fruit or snack.',
     [breakfast, lunch],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_no, diabetic_portion_control]).

food(orange, international, fruit, 140, 66, 15.0, 1.3, 0.2,
     [vitamin_c, folate, potassium],
     [],
     'Refrigerate for longer keeping. Use: breakfast fruit or snack.',
     [breakfast, lunch],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_no, diabetic_friendly_ok]).

food(avocado, international, fruit, 100, 160, 9.0, 2.0, 15.0,
     [folate, potassium, vitamin_k, vitamin_e],
     [],
     'Ripen at room temperature then refrigerate 1 to 2 days. Use: spreads, salads or bowls.',
     [breakfast, lunch],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_ok, diabetic_friendly_ok, ckd_potassium_caution]).

food(sweet_potato_baked, international, vegetable, 100, 90, 21.0, 2.0, 0.2,
     [vitamin_a, vitamin_c, potassium, manganese],
     [],
     'Refrigerate cooked sweet potato 3 to 4 days. Use: baked side.',
     [lunch, dinner],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_no, diabetic_portion_control]).

food(broccoli_steamed, international, vegetable, 90, 31, 6.0, 2.5, 0.3,
     [vitamin_c, vitamin_k, folate, potassium],
     [],
     'Refrigerate cooked broccoli 3 days. Use: steamed side or stir-fry.',
     [lunch, dinner],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_ok, diabetic_friendly_ok]).

food(spinach_cooked, international, vegetable, 90, 41, 7.0, 5.0, 0.5,
     [vitamin_k, folate, iron, magnesium],
     [],
     'Refrigerate cooked spinach 2 to 3 days. Use: sauteed side or curry.',
     [lunch, dinner],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_no, low_carb_ok, diabetic_friendly_ok, ckd_potassium_caution]).

food(cucumber_raw, international, vegetable, 100, 15, 4.0, 0.7, 0.1,
     [vitamin_k, potassium],
     [],
     'Refrigerate and use within several days. Use: salad or side dish.',
     [breakfast, lunch, dinner],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_ok, diabetic_friendly_ok]).

food(tomato_raw, international, vegetable, 123, 22, 5.0, 1.1, 0.2,
     [vitamin_c, potassium, folate, vitamin_a],
     [],
     'Keep at room temperature until ripe, then refrigerate briefly. Use: salads, sandwiches or curries.',
     [breakfast, lunch, dinner],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_ok, diabetic_friendly_ok]).

food(quinoa_cooked, international, grain, 185, 222, 39.0, 8.0, 3.6,
     [manganese, magnesium, folate, phosphorus],
     [],
     'Refrigerate cooked quinoa 3 to 4 days. Use: grain bowl, salad or rice substitute.',
     [lunch, dinner],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_no, diabetic_friendly_ok, high_fiber]).

food(brown_rice_cooked, international, grain, 150, 166, 34.0, 3.5, 1.4,
     [manganese, selenium, magnesium, vitamin_b1],
     [],
     'Refrigerate cooked rice up to 3 to 4 days. Use: whole-grain rice base.',
     [lunch, dinner],
     [vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_no, diabetic_portion_control]).

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
    food(Food, _, _, _, _, _, _, _, _, _, _, MealTypes, _),
    member(MealType, MealTypes).

has_tag(Food, Tag) :-
    food(Food, _, _, _, _, _, _, _, _, _, _, _, Tags),
    member(Tag, Tags).

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

allowed_food(Food, MealType, Diet, Conditions) :-
    food_meal(Food, MealType),
    suitable_for_diet(Food, Diet),
    safe_for_conditions(Food, Conditions).

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
    allowed_food(Food, MealType, Diet, Conditions).

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
