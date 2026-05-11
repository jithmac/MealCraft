-- MealCraft MySQL Database
-- Generated specifically from mealcraft_full_prolog_code_v2.pl
-- Run this full script in MySQL Workbench

DROP DATABASE IF EXISTS mealcraft_db;
CREATE DATABASE mealcraft_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE mealcraft_db;

CREATE TABLE foods (
    food_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    origin ENUM('sri_lankan','international') NOT NULL,
    category VARCHAR(50) NOT NULL,
    serving_size DECIMAL(8,2) NOT NULL,
    calories INT NOT NULL,
    carbs_g DECIMAL(8,2) NOT NULL,
    protein_g DECIMAL(8,2) NOT NULL,
    fat_g DECIMAL(8,2) NOT NULL,
    storage_note TEXT
);

CREATE TABLE meal_types (
    meal_type_id INT AUTO_INCREMENT PRIMARY KEY,
    name ENUM('breakfast','lunch','dinner') NOT NULL UNIQUE
);

CREATE TABLE food_meal_types (
    food_id INT NOT NULL,
    meal_type_id INT NOT NULL,
    PRIMARY KEY (food_id, meal_type_id),
    FOREIGN KEY (food_id) REFERENCES foods(food_id) ON DELETE CASCADE,
    FOREIGN KEY (meal_type_id) REFERENCES meal_types(meal_type_id) ON DELETE CASCADE
);

CREATE TABLE micronutrients (
    micronutrient_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE food_micronutrients (
    food_id INT NOT NULL,
    micronutrient_id INT NOT NULL,
    PRIMARY KEY (food_id, micronutrient_id),
    FOREIGN KEY (food_id) REFERENCES foods(food_id) ON DELETE CASCADE,
    FOREIGN KEY (micronutrient_id) REFERENCES micronutrients(micronutrient_id) ON DELETE CASCADE
);

CREATE TABLE allergens (
    allergen_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE food_allergens (
    food_id INT NOT NULL,
    allergen_id INT NOT NULL,
    PRIMARY KEY (food_id, allergen_id),
    FOREIGN KEY (food_id) REFERENCES foods(food_id) ON DELETE CASCADE,
    FOREIGN KEY (allergen_id) REFERENCES allergens(allergen_id) ON DELETE CASCADE
);

CREATE TABLE diet_tags (
    tag_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE food_diet_tags (
    food_id INT NOT NULL,
    tag_id INT NOT NULL,
    PRIMARY KEY (food_id, tag_id),
    FOREIGN KEY (food_id) REFERENCES foods(food_id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES diet_tags(tag_id) ON DELETE CASCADE
);

CREATE TABLE dietary_preferences (
    preference_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE dietary_preference_required_tags (
    preference_id INT NOT NULL,
    tag_id INT NOT NULL,
    PRIMARY KEY (preference_id, tag_id),
    FOREIGN KEY (preference_id) REFERENCES dietary_preferences(preference_id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES diet_tags(tag_id) ON DELETE CASCADE
);

CREATE TABLE dietary_preference_forbidden_tags (
    preference_id INT NOT NULL,
    tag_id INT NOT NULL,
    PRIMARY KEY (preference_id, tag_id),
    FOREIGN KEY (preference_id) REFERENCES dietary_preferences(preference_id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES diet_tags(tag_id) ON DELETE CASCADE
);

CREATE TABLE health_conditions (
    condition_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE condition_avoid_tags (
    condition_id INT NOT NULL,
    tag_id INT NOT NULL,
    PRIMARY KEY (condition_id, tag_id),
    FOREIGN KEY (condition_id) REFERENCES health_conditions(condition_id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES diet_tags(tag_id) ON DELETE CASCADE
);

CREATE TABLE condition_prefer_tags (
    condition_id INT NOT NULL,
    tag_id INT NOT NULL,
    PRIMARY KEY (condition_id, tag_id),
    FOREIGN KEY (condition_id) REFERENCES health_conditions(condition_id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES diet_tags(tag_id) ON DELETE CASCADE
);

CREATE TABLE meal_plans (
    plan_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    calorie_level ENUM('low_1800','standard_2500','high_4000') NOT NULL,
    min_target_calories INT NOT NULL,
    max_target_calories INT NOT NULL,
    diet_group VARCHAR(50) NOT NULL
);

CREATE TABLE meal_plan_items (
    plan_item_id INT AUTO_INCREMENT PRIMARY KEY,
    plan_id INT NOT NULL,
    meal_type ENUM('breakfast','lunch','dinner') NOT NULL,
    food_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (plan_id) REFERENCES meal_plans(plan_id) ON DELETE CASCADE,
    FOREIGN KEY (food_id) REFERENCES foods(food_id) ON DELETE CASCADE
);

INSERT INTO meal_types (name) VALUES ('breakfast'), ('lunch'), ('dinner');

INSERT INTO foods (name, origin, category, serving_size, calories, carbs_g, protein_g, fat_g, storage_note) VALUES
('red_rice', 'sri_lankan', 'grain', 150, 165, 36.0, 3.5, 1.3, 'Refrigerate cooked rice up to 3 to 4 days. Sri Lankan use: rice-and-curry base.'),
('kurakkan_roti', 'sri_lankan', 'grain', 60, 150, 28.0, 3.5, 2.5, 'Best eaten fresh. Sri Lankan use: breakfast or dinner with lunu miris, dhal or sambol.'),
('string_hoppers', 'sri_lankan', 'grain', 100, 150, 33.0, 3.0, 0.5, 'Refrigerate 1 to 2 days. Sri Lankan use: breakfast or dinner with dhal, kiri hodi or fish curry.'),
('hopper', 'sri_lankan', 'grain', 60, 110, 18.0, 2.0, 4.0, 'Best fresh. Sri Lankan use: breakfast or dinner with egg, sambol or curry.'),
('kiri_bath', 'sri_lankan', 'grain', 100, 175, 28.0, 3.0, 6.0, 'Refrigerate up to 2 days. Sri Lankan use: festive breakfast or dinner.'),
('parippu_dhal_curry', 'sri_lankan', 'legume', 150, 180, 24.0, 10.0, 5.0, 'Refrigerate 3 to 4 days. Sri Lankan use: staple side dish with rice, roti, hoppers or string hoppers.'),
('gotu_kola_mallung', 'sri_lankan', 'vegetable', 80, 70, 7.0, 2.0, 4.0, 'Best same day. Sri Lankan use: fresh mallung side dish with rice and curry.'),
('polos_curry', 'sri_lankan', 'vegetable', 150, 140, 18.0, 3.0, 6.0, 'Refrigerate 3 days. Sri Lankan use: young jackfruit curry.'),
('jackfruit_ripe', 'sri_lankan', 'fruit', 100, 95, 24.0, 1.7, 0.6, 'Ripen at room temperature, then refrigerate 2 to 3 days. Sri Lankan use: fresh fruit.'),
('coconut_sambol', 'sri_lankan', 'condiment', 30, 110, 4.0, 1.0, 10.0, 'Keep refrigerated and use within 1 day. Sri Lankan use: condiment for hoppers, bread or rice.'),
('ambul_thiyal', 'sri_lankan', 'meat', 100, 165, 2.0, 24.0, 7.0, 'Refrigerate 2 to 3 days. Sri Lankan use: sour fish curry with rice.'),
('king_coconut_water', 'sri_lankan', 'beverage', 240, 44, 10.0, 1.0, 0.0, 'Drink fresh. Refrigerate after opening and use within 24 hours.'),
('buffalo_curd', 'sri_lankan', 'dairy', 100, 110, 4.0, 5.0, 8.0, 'Keep refrigerated and use by date. Sri Lankan use: breakfast or dessert with fruit.'),
('kola_kenda', 'sri_lankan', 'beverage', 250, 85, 12.0, 3.0, 3.0, 'Best consumed fresh. Sri Lankan use: herbal breakfast porridge.'),
('cassava_boiled', 'sri_lankan', 'grain', 100, 112, 27.0, 1.0, 0.4, 'Refrigerate cooked cassava up to 3 days. Sri Lankan use: breakfast or dinner starch.'),
('mung_bean_curry', 'sri_lankan', 'legume', 150, 160, 24.0, 9.0, 2.0, 'Refrigerate 3 days. Sri Lankan use: curry or breakfast dish.'),
('breadfruit_boiled', 'sri_lankan', 'grain', 100, 103, 27.0, 1.0, 0.2, 'Refrigerate cooked breadfruit 2 to 3 days. Sri Lankan use: boiled or curried starch.'),
('pumpkin_curry', 'sri_lankan', 'vegetable', 100, 55, 8.0, 1.0, 2.0, 'Refrigerate 2 to 3 days. Sri Lankan use: mild vegetable curry.'),
('moringa_mallung', 'sri_lankan', 'vegetable', 75, 45, 6.0, 4.0, 0.8, 'Best same day. Sri Lankan use: leafy side dish with rice and curry.'),
('snake_gourd_curry', 'sri_lankan', 'vegetable', 100, 35, 6.0, 1.0, 1.0, 'Refrigerate 2 days. Sri Lankan use: light vegetable curry.'),
('coconut_milk', 'sri_lankan', 'condiment', 60, 138, 3.0, 1.0, 14.0, 'Refrigerate after opening and use within 4 to 5 days. Sri Lankan use: curry base.'),
('plain_ceylon_tea', 'sri_lankan', 'beverage', 240, 2, 0.0, 0.0, 0.0, 'Store dry tea leaves airtight. Sri Lankan use: plain beverage without sugar.'),
('dried_sprats', 'sri_lankan', 'meat', 20, 70, 0.0, 11.0, 2.0, 'Store airtight in a cool dry place. Sri Lankan use: fried or added to sambols and curries.'),
('wood_apple_pulp', 'sri_lankan', 'fruit', 100, 134, 31.0, 3.0, 0.6, 'Keep ripe pulp refrigerated 1 to 2 days. Sri Lankan use: fresh pulp or juice.'),
('cowpea_curry', 'sri_lankan', 'legume', 150, 170, 27.0, 10.0, 2.0, 'Refrigerate 3 days. Sri Lankan use: curry with rice or bread.'),
('oats', 'international', 'grain', 40, 156, 27.0, 5.0, 3.0, 'Keep dry in an airtight container. Use: porridge or overnight oats.'),
('whole_wheat_bread', 'international', 'grain', 56, 138, 24.0, 7.0, 2.0, 'Store sealed 3 to 5 days or freeze. Use: toast or sandwiches.'),
('egg_boiled', 'international', 'meat', 50, 78, 0.6, 6.3, 5.3, 'Refrigerate boiled eggs up to 1 week. Use: breakfast or protein side.'),
('chicken_breast', 'international', 'meat', 100, 165, 0.0, 31.0, 3.6, 'Refrigerate cooked chicken 3 to 4 days. Use: grilled, curried or stir-fried protein.'),
('salmon', 'international', 'meat', 100, 206, 0.0, 22.0, 12.0, 'Refrigerate cooked salmon 3 days. Use: grilled or baked fish.'),
('tuna_canned', 'international', 'meat', 85, 99, 0.0, 22.0, 1.0, 'Refrigerate after opening and use within 2 days. Use: sandwiches, salads or rice bowls.'),
('plain_yogurt_low_fat', 'international', 'dairy', 170, 100, 7.0, 10.0, 3.0, 'Keep refrigerated and use by date. Use: breakfast bowl or snack.'),
('milk_low_fat', 'international', 'dairy', 240, 102, 12.0, 8.0, 2.4, 'Keep refrigerated and use by date. Use: tea, porridge or breakfast drink.'),
('cheddar_cheese', 'international', 'dairy', 28, 113, 0.4, 7.0, 9.0, 'Keep refrigerated. Use: sandwiches, omelettes or baked dishes.'),
('lentils_boiled', 'international', 'legume', 100, 116, 20.0, 9.0, 0.4, 'Refrigerate cooked lentils 3 to 4 days. Use: soups, salads or side dishes.'),
('chickpeas_boiled', 'international', 'legume', 100, 164, 27.0, 9.0, 2.6, 'Refrigerate cooked chickpeas 3 to 4 days. Use: salads, curries or roasted snacks.'),
('tofu_firm', 'international', 'legume', 100, 144, 3.0, 17.0, 9.0, 'Keep refrigerated and use within a few days after opening. Use: stir-fries or curries.'),
('almonds', 'international', 'nut', 28, 164, 6.0, 6.0, 14.0, 'Store airtight in a cool dry place. Use: snack or topping.'),
('peanuts', 'international', 'nut', 28, 170, 6.0, 7.0, 14.0, 'Store airtight in a cool dry place. Use: roasted snack or topping.'),
('banana', 'international', 'fruit', 118, 105, 27.0, 1.3, 0.4, 'Ripen at room temperature then refrigerate 2 to 3 days. Use: breakfast fruit or snack.'),
('apple', 'international', 'fruit', 182, 95, 25.0, 0.5, 0.3, 'Refrigerate for best shelf life. Use: breakfast fruit or snack.'),
('orange', 'international', 'fruit', 140, 66, 15.0, 1.3, 0.2, 'Refrigerate for longer keeping. Use: breakfast fruit or snack.'),
('avocado', 'international', 'fruit', 100, 160, 9.0, 2.0, 15.0, 'Ripen at room temperature then refrigerate 1 to 2 days. Use: spreads, salads or bowls.'),
('sweet_potato_baked', 'international', 'vegetable', 100, 90, 21.0, 2.0, 0.2, 'Refrigerate cooked sweet potato 3 to 4 days. Use: baked side.'),
('broccoli_steamed', 'international', 'vegetable', 90, 31, 6.0, 2.5, 0.3, 'Refrigerate cooked broccoli 3 days. Use: steamed side or stir-fry.'),
('spinach_cooked', 'international', 'vegetable', 90, 41, 7.0, 5.0, 0.5, 'Refrigerate cooked spinach 2 to 3 days. Use: sauteed side or curry.'),
('cucumber_raw', 'international', 'vegetable', 100, 15, 4.0, 0.7, 0.1, 'Refrigerate and use within several days. Use: salad or side dish.'),
('tomato_raw', 'international', 'vegetable', 123, 22, 5.0, 1.1, 0.2, 'Keep at room temperature until ripe, then refrigerate briefly. Use: salads, sandwiches or curries.'),
('quinoa_cooked', 'international', 'grain', 185, 222, 39.0, 8.0, 3.6, 'Refrigerate cooked quinoa 3 to 4 days. Use: grain bowl, salad or rice substitute.'),
('brown_rice_cooked', 'international', 'grain', 150, 166, 34.0, 3.5, 1.4, 'Refrigerate cooked rice up to 3 to 4 days. Use: whole-grain rice base.');

INSERT INTO micronutrients (name) VALUES
('calcium'),
('choline'),
('copper'),
('fluoride'),
('folate'),
('iodine'),
('iron'),
('magnesium'),
('manganese'),
('niacin'),
('phosphorus'),
('potassium'),
('riboflavin'),
('selenium'),
('thiamin'),
('vitamin_a'),
('vitamin_b1'),
('vitamin_b12'),
('vitamin_b6'),
('vitamin_c'),
('vitamin_d'),
('vitamin_e'),
('vitamin_k');

INSERT INTO allergens (name) VALUES
('coconut'),
('egg'),
('fish'),
('gluten'),
('lactose'),
('milk'),
('peanut'),
('possible_gluten_cross_contact'),
('possible_gluten_if_wheat_mixed'),
('soy'),
('tree_nut'),
('wheat');

INSERT INTO diet_tags (name) VALUES
('ckd_potassium_caution'),
('contains_gluten'),
('diabetic_caution'),
('diabetic_friendly_ok'),
('diabetic_portion_control'),
('gluten_free_if_made_without_wheat'),
('gluten_free_ok'),
('gluten_free_only_if_certified'),
('halal_if_certified'),
('halal_ok'),
('high_calorie_dense'),
('high_fiber'),
('high_protein'),
('high_purine_caution'),
('high_sat_fat_caution'),
('high_sodium_caution'),
('lactose_present'),
('low_carb_no'),
('low_carb_ok'),
('low_fodmap_no'),
('low_fodmap_ok'),
('low_fodmap_small_only'),
('low_purine_ok'),
('low_sodium_ok'),
('pescatarian_no'),
('pescatarian_ok'),
('vegan_no'),
('vegan_ok'),
('vegetarian_no'),
('vegetarian_ok');

INSERT INTO health_conditions (name) VALUES
('celiac'),
('diabetes'),
('gout'),
('heart_disease'),
('hypertension'),
('ibs'),
('kidney_disease'),
('lactose_intolerance'),
('overweight'),
('pregnancy');

INSERT INTO dietary_preferences (name) VALUES
('diabetic_friendly'),
('gluten_free'),
('halal'),
('high_protein'),
('low_carb'),
('pescatarian'),
('vegan'),
('vegetarian');

INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='red_rice' AND m.name='manganese';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='red_rice' AND m.name='magnesium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='red_rice' AND m.name='selenium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='red_rice' AND m.name='vitamin_b1';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='red_rice' AND mt.name='lunch';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='red_rice' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='red_rice' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='red_rice' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='red_rice' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='red_rice' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='red_rice' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='red_rice' AND dt.name='low_fodmap_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='red_rice' AND dt.name='low_carb_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='red_rice' AND dt.name='diabetic_portion_control';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='kurakkan_roti' AND m.name='calcium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='kurakkan_roti' AND m.name='iron';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='kurakkan_roti' AND m.name='magnesium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='kurakkan_roti' AND m.name='phosphorus';
INSERT INTO food_allergens (food_id, allergen_id) SELECT f.food_id, a.allergen_id FROM foods f, allergens a WHERE f.name='kurakkan_roti' AND a.name='possible_gluten_if_wheat_mixed';
INSERT INTO food_allergens (food_id, allergen_id) SELECT f.food_id, a.allergen_id FROM foods f, allergens a WHERE f.name='kurakkan_roti' AND a.name='coconut';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='kurakkan_roti' AND mt.name='breakfast';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='kurakkan_roti' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='kurakkan_roti' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='kurakkan_roti' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='kurakkan_roti' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='kurakkan_roti' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='kurakkan_roti' AND dt.name='gluten_free_if_made_without_wheat';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='kurakkan_roti' AND dt.name='low_fodmap_small_only';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='kurakkan_roti' AND dt.name='low_carb_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='kurakkan_roti' AND dt.name='diabetic_portion_control';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='string_hoppers' AND m.name='selenium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='string_hoppers' AND m.name='manganese';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='string_hoppers' AND m.name='iron';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='string_hoppers' AND mt.name='breakfast';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='string_hoppers' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='string_hoppers' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='string_hoppers' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='string_hoppers' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='string_hoppers' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='string_hoppers' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='string_hoppers' AND dt.name='low_fodmap_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='string_hoppers' AND dt.name='low_carb_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='string_hoppers' AND dt.name='diabetic_portion_control';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='hopper' AND m.name='manganese';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='hopper' AND m.name='selenium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='hopper' AND m.name='iron';
INSERT INTO food_allergens (food_id, allergen_id) SELECT f.food_id, a.allergen_id FROM foods f, allergens a WHERE f.name='hopper' AND a.name='coconut';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='hopper' AND mt.name='breakfast';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='hopper' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='hopper' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='hopper' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='hopper' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='hopper' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='hopper' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='hopper' AND dt.name='low_fodmap_small_only';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='hopper' AND dt.name='low_carb_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='hopper' AND dt.name='diabetic_portion_control';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='kiri_bath' AND m.name='manganese';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='kiri_bath' AND m.name='selenium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='kiri_bath' AND m.name='iron';
INSERT INTO food_allergens (food_id, allergen_id) SELECT f.food_id, a.allergen_id FROM foods f, allergens a WHERE f.name='kiri_bath' AND a.name='coconut';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='kiri_bath' AND mt.name='breakfast';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='kiri_bath' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='kiri_bath' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='kiri_bath' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='kiri_bath' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='kiri_bath' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='kiri_bath' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='kiri_bath' AND dt.name='low_fodmap_small_only';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='kiri_bath' AND dt.name='low_carb_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='kiri_bath' AND dt.name='diabetic_caution';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='kiri_bath' AND dt.name='high_sat_fat_caution';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='parippu_dhal_curry' AND m.name='folate';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='parippu_dhal_curry' AND m.name='iron';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='parippu_dhal_curry' AND m.name='potassium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='parippu_dhal_curry' AND m.name='magnesium';
INSERT INTO food_allergens (food_id, allergen_id) SELECT f.food_id, a.allergen_id FROM foods f, allergens a WHERE f.name='parippu_dhal_curry' AND a.name='coconut';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='parippu_dhal_curry' AND mt.name='breakfast';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='parippu_dhal_curry' AND mt.name='lunch';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='parippu_dhal_curry' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='parippu_dhal_curry' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='parippu_dhal_curry' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='parippu_dhal_curry' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='parippu_dhal_curry' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='parippu_dhal_curry' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='parippu_dhal_curry' AND dt.name='low_fodmap_small_only';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='parippu_dhal_curry' AND dt.name='low_carb_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='parippu_dhal_curry' AND dt.name='diabetic_friendly_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='parippu_dhal_curry' AND dt.name='high_fiber';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='gotu_kola_mallung' AND m.name='vitamin_a';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='gotu_kola_mallung' AND m.name='vitamin_c';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='gotu_kola_mallung' AND m.name='vitamin_k';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='gotu_kola_mallung' AND m.name='folate';
INSERT INTO food_allergens (food_id, allergen_id) SELECT f.food_id, a.allergen_id FROM foods f, allergens a WHERE f.name='gotu_kola_mallung' AND a.name='coconut';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='gotu_kola_mallung' AND mt.name='lunch';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='gotu_kola_mallung' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='gotu_kola_mallung' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='gotu_kola_mallung' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='gotu_kola_mallung' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='gotu_kola_mallung' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='gotu_kola_mallung' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='gotu_kola_mallung' AND dt.name='low_fodmap_small_only';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='gotu_kola_mallung' AND dt.name='low_carb_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='gotu_kola_mallung' AND dt.name='diabetic_friendly_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='gotu_kola_mallung' AND dt.name='high_fiber';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='polos_curry' AND m.name='vitamin_c';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='polos_curry' AND m.name='potassium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='polos_curry' AND m.name='vitamin_b6';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='polos_curry' AND m.name='copper';
INSERT INTO food_allergens (food_id, allergen_id) SELECT f.food_id, a.allergen_id FROM foods f, allergens a WHERE f.name='polos_curry' AND a.name='coconut';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='polos_curry' AND mt.name='lunch';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='polos_curry' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='polos_curry' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='polos_curry' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='polos_curry' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='polos_curry' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='polos_curry' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='polos_curry' AND dt.name='low_fodmap_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='polos_curry' AND dt.name='low_carb_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='polos_curry' AND dt.name='diabetic_portion_control';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='jackfruit_ripe' AND m.name='vitamin_c';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='jackfruit_ripe' AND m.name='potassium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='jackfruit_ripe' AND m.name='vitamin_b6';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='jackfruit_ripe' AND m.name='magnesium';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='jackfruit_ripe' AND mt.name='breakfast';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='jackfruit_ripe' AND mt.name='lunch';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='jackfruit_ripe' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='jackfruit_ripe' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='jackfruit_ripe' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='jackfruit_ripe' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='jackfruit_ripe' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='jackfruit_ripe' AND dt.name='low_fodmap_small_only';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='jackfruit_ripe' AND dt.name='low_carb_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='jackfruit_ripe' AND dt.name='diabetic_portion_control';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='coconut_sambol' AND m.name='manganese';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='coconut_sambol' AND m.name='copper';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='coconut_sambol' AND m.name='selenium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='coconut_sambol' AND m.name='iron';
INSERT INTO food_allergens (food_id, allergen_id) SELECT f.food_id, a.allergen_id FROM foods f, allergens a WHERE f.name='coconut_sambol' AND a.name='coconut';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='coconut_sambol' AND mt.name='breakfast';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='coconut_sambol' AND mt.name='lunch';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='coconut_sambol' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='coconut_sambol' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='coconut_sambol' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='coconut_sambol' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='coconut_sambol' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='coconut_sambol' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='coconut_sambol' AND dt.name='low_fodmap_small_only';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='coconut_sambol' AND dt.name='low_carb_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='coconut_sambol' AND dt.name='diabetic_portion_control';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='coconut_sambol' AND dt.name='high_sat_fat_caution';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='coconut_sambol' AND dt.name='high_sodium_caution';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='ambul_thiyal' AND m.name='vitamin_b12';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='ambul_thiyal' AND m.name='selenium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='ambul_thiyal' AND m.name='iodine';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='ambul_thiyal' AND m.name='vitamin_d';
INSERT INTO food_allergens (food_id, allergen_id) SELECT f.food_id, a.allergen_id FROM foods f, allergens a WHERE f.name='ambul_thiyal' AND a.name='fish';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='ambul_thiyal' AND mt.name='lunch';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='ambul_thiyal' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='ambul_thiyal' AND dt.name='vegan_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='ambul_thiyal' AND dt.name='vegetarian_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='ambul_thiyal' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='ambul_thiyal' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='ambul_thiyal' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='ambul_thiyal' AND dt.name='low_fodmap_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='ambul_thiyal' AND dt.name='low_carb_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='ambul_thiyal' AND dt.name='diabetic_friendly_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='ambul_thiyal' AND dt.name='high_protein';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='ambul_thiyal' AND dt.name='high_purine_caution';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='king_coconut_water' AND m.name='potassium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='king_coconut_water' AND m.name='manganese';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='king_coconut_water' AND m.name='magnesium';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='king_coconut_water' AND mt.name='breakfast';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='king_coconut_water' AND mt.name='lunch';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='king_coconut_water' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='king_coconut_water' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='king_coconut_water' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='king_coconut_water' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='king_coconut_water' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='king_coconut_water' AND dt.name='low_fodmap_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='king_coconut_water' AND dt.name='low_carb_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='king_coconut_water' AND dt.name='diabetic_portion_control';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='king_coconut_water' AND dt.name='ckd_potassium_caution';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='buffalo_curd' AND m.name='calcium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='buffalo_curd' AND m.name='vitamin_b12';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='buffalo_curd' AND m.name='phosphorus';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='buffalo_curd' AND m.name='riboflavin';
INSERT INTO food_allergens (food_id, allergen_id) SELECT f.food_id, a.allergen_id FROM foods f, allergens a WHERE f.name='buffalo_curd' AND a.name='milk';
INSERT INTO food_allergens (food_id, allergen_id) SELECT f.food_id, a.allergen_id FROM foods f, allergens a WHERE f.name='buffalo_curd' AND a.name='lactose';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='buffalo_curd' AND mt.name='breakfast';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='buffalo_curd' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='buffalo_curd' AND dt.name='vegan_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='buffalo_curd' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='buffalo_curd' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='buffalo_curd' AND dt.name='halal_if_certified';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='buffalo_curd' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='buffalo_curd' AND dt.name='low_fodmap_small_only';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='buffalo_curd' AND dt.name='low_carb_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='buffalo_curd' AND dt.name='diabetic_portion_control';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='buffalo_curd' AND dt.name='lactose_present';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='buffalo_curd' AND dt.name='high_sat_fat_caution';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='kola_kenda' AND m.name='iron';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='kola_kenda' AND m.name='folate';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='kola_kenda' AND m.name='vitamin_a';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='kola_kenda' AND m.name='calcium';
INSERT INTO food_allergens (food_id, allergen_id) SELECT f.food_id, a.allergen_id FROM foods f, allergens a WHERE f.name='kola_kenda' AND a.name='coconut';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='kola_kenda' AND mt.name='breakfast';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='kola_kenda' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='kola_kenda' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='kola_kenda' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='kola_kenda' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='kola_kenda' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='kola_kenda' AND dt.name='low_fodmap_small_only';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='kola_kenda' AND dt.name='low_carb_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='kola_kenda' AND dt.name='diabetic_portion_control';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='cassava_boiled' AND m.name='vitamin_c';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='cassava_boiled' AND m.name='manganese';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='cassava_boiled' AND m.name='folate';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='cassava_boiled' AND m.name='potassium';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='cassava_boiled' AND mt.name='breakfast';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='cassava_boiled' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='cassava_boiled' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='cassava_boiled' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='cassava_boiled' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='cassava_boiled' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='cassava_boiled' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='cassava_boiled' AND dt.name='low_fodmap_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='cassava_boiled' AND dt.name='low_carb_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='cassava_boiled' AND dt.name='diabetic_caution';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='mung_bean_curry' AND m.name='folate';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='mung_bean_curry' AND m.name='magnesium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='mung_bean_curry' AND m.name='potassium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='mung_bean_curry' AND m.name='iron';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='mung_bean_curry' AND mt.name='breakfast';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='mung_bean_curry' AND mt.name='lunch';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='mung_bean_curry' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='mung_bean_curry' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='mung_bean_curry' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='mung_bean_curry' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='mung_bean_curry' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='mung_bean_curry' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='mung_bean_curry' AND dt.name='low_fodmap_small_only';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='mung_bean_curry' AND dt.name='low_carb_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='mung_bean_curry' AND dt.name='diabetic_friendly_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='mung_bean_curry' AND dt.name='high_fiber';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='breadfruit_boiled' AND m.name='potassium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='breadfruit_boiled' AND m.name='vitamin_c';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='breadfruit_boiled' AND m.name='magnesium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='breadfruit_boiled' AND m.name='copper';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='breadfruit_boiled' AND mt.name='lunch';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='breadfruit_boiled' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='breadfruit_boiled' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='breadfruit_boiled' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='breadfruit_boiled' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='breadfruit_boiled' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='breadfruit_boiled' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='breadfruit_boiled' AND dt.name='low_fodmap_small_only';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='breadfruit_boiled' AND dt.name='low_carb_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='breadfruit_boiled' AND dt.name='diabetic_portion_control';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='pumpkin_curry' AND m.name='vitamin_a';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='pumpkin_curry' AND m.name='vitamin_c';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='pumpkin_curry' AND m.name='potassium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='pumpkin_curry' AND m.name='manganese';
INSERT INTO food_allergens (food_id, allergen_id) SELECT f.food_id, a.allergen_id FROM foods f, allergens a WHERE f.name='pumpkin_curry' AND a.name='coconut';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='pumpkin_curry' AND mt.name='lunch';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='pumpkin_curry' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='pumpkin_curry' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='pumpkin_curry' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='pumpkin_curry' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='pumpkin_curry' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='pumpkin_curry' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='pumpkin_curry' AND dt.name='low_fodmap_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='pumpkin_curry' AND dt.name='low_carb_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='pumpkin_curry' AND dt.name='diabetic_friendly_ok';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='moringa_mallung' AND m.name='vitamin_a';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='moringa_mallung' AND m.name='vitamin_c';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='moringa_mallung' AND m.name='calcium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='moringa_mallung' AND m.name='iron';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='moringa_mallung' AND mt.name='lunch';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='moringa_mallung' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='moringa_mallung' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='moringa_mallung' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='moringa_mallung' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='moringa_mallung' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='moringa_mallung' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='moringa_mallung' AND dt.name='low_fodmap_small_only';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='moringa_mallung' AND dt.name='low_carb_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='moringa_mallung' AND dt.name='diabetic_friendly_ok';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='snake_gourd_curry' AND m.name='vitamin_c';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='snake_gourd_curry' AND m.name='folate';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='snake_gourd_curry' AND m.name='potassium';
INSERT INTO food_allergens (food_id, allergen_id) SELECT f.food_id, a.allergen_id FROM foods f, allergens a WHERE f.name='snake_gourd_curry' AND a.name='coconut';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='snake_gourd_curry' AND mt.name='lunch';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='snake_gourd_curry' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='snake_gourd_curry' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='snake_gourd_curry' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='snake_gourd_curry' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='snake_gourd_curry' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='snake_gourd_curry' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='snake_gourd_curry' AND dt.name='low_fodmap_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='snake_gourd_curry' AND dt.name='low_carb_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='snake_gourd_curry' AND dt.name='diabetic_friendly_ok';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='coconut_milk' AND m.name='manganese';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='coconut_milk' AND m.name='copper';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='coconut_milk' AND m.name='selenium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='coconut_milk' AND m.name='iron';
INSERT INTO food_allergens (food_id, allergen_id) SELECT f.food_id, a.allergen_id FROM foods f, allergens a WHERE f.name='coconut_milk' AND a.name='coconut';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='coconut_milk' AND mt.name='lunch';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='coconut_milk' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='coconut_milk' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='coconut_milk' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='coconut_milk' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='coconut_milk' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='coconut_milk' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='coconut_milk' AND dt.name='low_fodmap_small_only';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='coconut_milk' AND dt.name='low_carb_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='coconut_milk' AND dt.name='diabetic_portion_control';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='coconut_milk' AND dt.name='high_sat_fat_caution';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='plain_ceylon_tea' AND m.name='manganese';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='plain_ceylon_tea' AND m.name='fluoride';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='plain_ceylon_tea' AND mt.name='breakfast';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='plain_ceylon_tea' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='plain_ceylon_tea' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='plain_ceylon_tea' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='plain_ceylon_tea' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='plain_ceylon_tea' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='plain_ceylon_tea' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='plain_ceylon_tea' AND dt.name='low_fodmap_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='plain_ceylon_tea' AND dt.name='low_carb_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='plain_ceylon_tea' AND dt.name='diabetic_friendly_ok';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='dried_sprats' AND m.name='calcium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='dried_sprats' AND m.name='iodine';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='dried_sprats' AND m.name='selenium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='dried_sprats' AND m.name='vitamin_b12';
INSERT INTO food_allergens (food_id, allergen_id) SELECT f.food_id, a.allergen_id FROM foods f, allergens a WHERE f.name='dried_sprats' AND a.name='fish';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='dried_sprats' AND mt.name='breakfast';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='dried_sprats' AND mt.name='lunch';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='dried_sprats' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='dried_sprats' AND dt.name='vegan_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='dried_sprats' AND dt.name='vegetarian_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='dried_sprats' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='dried_sprats' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='dried_sprats' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='dried_sprats' AND dt.name='low_fodmap_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='dried_sprats' AND dt.name='low_carb_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='dried_sprats' AND dt.name='diabetic_friendly_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='dried_sprats' AND dt.name='high_sodium_caution';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='dried_sprats' AND dt.name='high_purine_caution';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='dried_sprats' AND dt.name='high_protein';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='wood_apple_pulp' AND m.name='vitamin_c';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='wood_apple_pulp' AND m.name='calcium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='wood_apple_pulp' AND m.name='iron';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='wood_apple_pulp' AND m.name='thiamin';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='wood_apple_pulp' AND mt.name='breakfast';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='wood_apple_pulp' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='wood_apple_pulp' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='wood_apple_pulp' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='wood_apple_pulp' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='wood_apple_pulp' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='wood_apple_pulp' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='wood_apple_pulp' AND dt.name='low_fodmap_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='wood_apple_pulp' AND dt.name='low_carb_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='wood_apple_pulp' AND dt.name='diabetic_caution';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='cowpea_curry' AND m.name='folate';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='cowpea_curry' AND m.name='iron';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='cowpea_curry' AND m.name='magnesium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='cowpea_curry' AND m.name='potassium';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='cowpea_curry' AND mt.name='lunch';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='cowpea_curry' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='cowpea_curry' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='cowpea_curry' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='cowpea_curry' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='cowpea_curry' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='cowpea_curry' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='cowpea_curry' AND dt.name='low_fodmap_small_only';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='cowpea_curry' AND dt.name='low_carb_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='cowpea_curry' AND dt.name='diabetic_friendly_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='cowpea_curry' AND dt.name='high_fiber';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='oats' AND m.name='manganese';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='oats' AND m.name='phosphorus';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='oats' AND m.name='magnesium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='oats' AND m.name='iron';
INSERT INTO food_allergens (food_id, allergen_id) SELECT f.food_id, a.allergen_id FROM foods f, allergens a WHERE f.name='oats' AND a.name='possible_gluten_cross_contact';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='oats' AND mt.name='breakfast';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='oats' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='oats' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='oats' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='oats' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='oats' AND dt.name='gluten_free_only_if_certified';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='oats' AND dt.name='low_fodmap_small_only';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='oats' AND dt.name='low_carb_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='oats' AND dt.name='diabetic_friendly_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='oats' AND dt.name='high_fiber';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='whole_wheat_bread' AND m.name='selenium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='whole_wheat_bread' AND m.name='manganese';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='whole_wheat_bread' AND m.name='iron';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='whole_wheat_bread' AND m.name='vitamin_b1';
INSERT INTO food_allergens (food_id, allergen_id) SELECT f.food_id, a.allergen_id FROM foods f, allergens a WHERE f.name='whole_wheat_bread' AND a.name='wheat';
INSERT INTO food_allergens (food_id, allergen_id) SELECT f.food_id, a.allergen_id FROM foods f, allergens a WHERE f.name='whole_wheat_bread' AND a.name='gluten';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='whole_wheat_bread' AND mt.name='breakfast';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='whole_wheat_bread' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='whole_wheat_bread' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='whole_wheat_bread' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='whole_wheat_bread' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='whole_wheat_bread' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='whole_wheat_bread' AND dt.name='contains_gluten';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='whole_wheat_bread' AND dt.name='low_fodmap_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='whole_wheat_bread' AND dt.name='low_carb_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='whole_wheat_bread' AND dt.name='diabetic_portion_control';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='egg_boiled' AND m.name='vitamin_b12';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='egg_boiled' AND m.name='choline';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='egg_boiled' AND m.name='selenium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='egg_boiled' AND m.name='vitamin_d';
INSERT INTO food_allergens (food_id, allergen_id) SELECT f.food_id, a.allergen_id FROM foods f, allergens a WHERE f.name='egg_boiled' AND a.name='egg';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='egg_boiled' AND mt.name='breakfast';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='egg_boiled' AND mt.name='lunch';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='egg_boiled' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='egg_boiled' AND dt.name='vegan_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='egg_boiled' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='egg_boiled' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='egg_boiled' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='egg_boiled' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='egg_boiled' AND dt.name='low_fodmap_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='egg_boiled' AND dt.name='low_carb_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='egg_boiled' AND dt.name='diabetic_friendly_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='egg_boiled' AND dt.name='high_protein';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='chicken_breast' AND m.name='niacin';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='chicken_breast' AND m.name='selenium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='chicken_breast' AND m.name='vitamin_b6';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='chicken_breast' AND m.name='phosphorus';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='chicken_breast' AND mt.name='lunch';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='chicken_breast' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='chicken_breast' AND dt.name='vegan_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='chicken_breast' AND dt.name='vegetarian_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='chicken_breast' AND dt.name='pescatarian_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='chicken_breast' AND dt.name='halal_if_certified';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='chicken_breast' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='chicken_breast' AND dt.name='low_fodmap_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='chicken_breast' AND dt.name='low_carb_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='chicken_breast' AND dt.name='diabetic_friendly_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='chicken_breast' AND dt.name='high_protein';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='chicken_breast' AND dt.name='high_purine_caution';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='salmon' AND m.name='vitamin_d';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='salmon' AND m.name='vitamin_b12';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='salmon' AND m.name='selenium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='salmon' AND m.name='potassium';
INSERT INTO food_allergens (food_id, allergen_id) SELECT f.food_id, a.allergen_id FROM foods f, allergens a WHERE f.name='salmon' AND a.name='fish';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='salmon' AND mt.name='lunch';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='salmon' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='salmon' AND dt.name='vegan_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='salmon' AND dt.name='vegetarian_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='salmon' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='salmon' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='salmon' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='salmon' AND dt.name='low_fodmap_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='salmon' AND dt.name='low_carb_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='salmon' AND dt.name='diabetic_friendly_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='salmon' AND dt.name='high_protein';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='salmon' AND dt.name='high_purine_caution';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='tuna_canned' AND m.name='selenium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='tuna_canned' AND m.name='vitamin_b12';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='tuna_canned' AND m.name='niacin';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='tuna_canned' AND m.name='phosphorus';
INSERT INTO food_allergens (food_id, allergen_id) SELECT f.food_id, a.allergen_id FROM foods f, allergens a WHERE f.name='tuna_canned' AND a.name='fish';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='tuna_canned' AND mt.name='lunch';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='tuna_canned' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='tuna_canned' AND dt.name='vegan_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='tuna_canned' AND dt.name='vegetarian_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='tuna_canned' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='tuna_canned' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='tuna_canned' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='tuna_canned' AND dt.name='low_fodmap_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='tuna_canned' AND dt.name='low_carb_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='tuna_canned' AND dt.name='diabetic_friendly_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='tuna_canned' AND dt.name='high_protein';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='tuna_canned' AND dt.name='high_purine_caution';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='plain_yogurt_low_fat' AND m.name='calcium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='plain_yogurt_low_fat' AND m.name='vitamin_b12';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='plain_yogurt_low_fat' AND m.name='phosphorus';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='plain_yogurt_low_fat' AND m.name='potassium';
INSERT INTO food_allergens (food_id, allergen_id) SELECT f.food_id, a.allergen_id FROM foods f, allergens a WHERE f.name='plain_yogurt_low_fat' AND a.name='milk';
INSERT INTO food_allergens (food_id, allergen_id) SELECT f.food_id, a.allergen_id FROM foods f, allergens a WHERE f.name='plain_yogurt_low_fat' AND a.name='lactose';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='plain_yogurt_low_fat' AND mt.name='breakfast';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='plain_yogurt_low_fat' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='plain_yogurt_low_fat' AND dt.name='vegan_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='plain_yogurt_low_fat' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='plain_yogurt_low_fat' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='plain_yogurt_low_fat' AND dt.name='halal_if_certified';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='plain_yogurt_low_fat' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='plain_yogurt_low_fat' AND dt.name='low_fodmap_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='plain_yogurt_low_fat' AND dt.name='low_carb_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='plain_yogurt_low_fat' AND dt.name='diabetic_friendly_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='plain_yogurt_low_fat' AND dt.name='lactose_present';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='plain_yogurt_low_fat' AND dt.name='high_protein';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='milk_low_fat' AND m.name='calcium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='milk_low_fat' AND m.name='vitamin_b12';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='milk_low_fat' AND m.name='riboflavin';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='milk_low_fat' AND m.name='phosphorus';
INSERT INTO food_allergens (food_id, allergen_id) SELECT f.food_id, a.allergen_id FROM foods f, allergens a WHERE f.name='milk_low_fat' AND a.name='milk';
INSERT INTO food_allergens (food_id, allergen_id) SELECT f.food_id, a.allergen_id FROM foods f, allergens a WHERE f.name='milk_low_fat' AND a.name='lactose';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='milk_low_fat' AND mt.name='breakfast';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='milk_low_fat' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='milk_low_fat' AND dt.name='vegan_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='milk_low_fat' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='milk_low_fat' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='milk_low_fat' AND dt.name='halal_if_certified';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='milk_low_fat' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='milk_low_fat' AND dt.name='low_fodmap_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='milk_low_fat' AND dt.name='low_carb_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='milk_low_fat' AND dt.name='diabetic_friendly_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='milk_low_fat' AND dt.name='lactose_present';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='cheddar_cheese' AND m.name='calcium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='cheddar_cheese' AND m.name='vitamin_a';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='cheddar_cheese' AND m.name='vitamin_b12';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='cheddar_cheese' AND m.name='phosphorus';
INSERT INTO food_allergens (food_id, allergen_id) SELECT f.food_id, a.allergen_id FROM foods f, allergens a WHERE f.name='cheddar_cheese' AND a.name='milk';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='cheddar_cheese' AND mt.name='breakfast';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='cheddar_cheese' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='cheddar_cheese' AND dt.name='vegan_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='cheddar_cheese' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='cheddar_cheese' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='cheddar_cheese' AND dt.name='halal_if_certified';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='cheddar_cheese' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='cheddar_cheese' AND dt.name='low_fodmap_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='cheddar_cheese' AND dt.name='low_carb_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='cheddar_cheese' AND dt.name='diabetic_portion_control';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='cheddar_cheese' AND dt.name='high_sat_fat_caution';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='lentils_boiled' AND m.name='folate';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='lentils_boiled' AND m.name='iron';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='lentils_boiled' AND m.name='manganese';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='lentils_boiled' AND m.name='magnesium';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='lentils_boiled' AND mt.name='lunch';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='lentils_boiled' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='lentils_boiled' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='lentils_boiled' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='lentils_boiled' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='lentils_boiled' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='lentils_boiled' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='lentils_boiled' AND dt.name='low_fodmap_small_only';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='lentils_boiled' AND dt.name='low_carb_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='lentils_boiled' AND dt.name='diabetic_friendly_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='lentils_boiled' AND dt.name='high_fiber';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='chickpeas_boiled' AND m.name='folate';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='chickpeas_boiled' AND m.name='manganese';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='chickpeas_boiled' AND m.name='iron';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='chickpeas_boiled' AND m.name='phosphorus';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='chickpeas_boiled' AND mt.name='lunch';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='chickpeas_boiled' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='chickpeas_boiled' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='chickpeas_boiled' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='chickpeas_boiled' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='chickpeas_boiled' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='chickpeas_boiled' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='chickpeas_boiled' AND dt.name='low_fodmap_small_only';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='chickpeas_boiled' AND dt.name='low_carb_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='chickpeas_boiled' AND dt.name='diabetic_friendly_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='chickpeas_boiled' AND dt.name='high_fiber';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='tofu_firm' AND m.name='calcium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='tofu_firm' AND m.name='iron';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='tofu_firm' AND m.name='manganese';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='tofu_firm' AND m.name='selenium';
INSERT INTO food_allergens (food_id, allergen_id) SELECT f.food_id, a.allergen_id FROM foods f, allergens a WHERE f.name='tofu_firm' AND a.name='soy';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='tofu_firm' AND mt.name='lunch';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='tofu_firm' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='tofu_firm' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='tofu_firm' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='tofu_firm' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='tofu_firm' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='tofu_firm' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='tofu_firm' AND dt.name='low_fodmap_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='tofu_firm' AND dt.name='low_carb_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='tofu_firm' AND dt.name='diabetic_friendly_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='tofu_firm' AND dt.name='high_protein';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='almonds' AND m.name='vitamin_e';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='almonds' AND m.name='magnesium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='almonds' AND m.name='manganese';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='almonds' AND m.name='calcium';
INSERT INTO food_allergens (food_id, allergen_id) SELECT f.food_id, a.allergen_id FROM foods f, allergens a WHERE f.name='almonds' AND a.name='tree_nut';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='almonds' AND mt.name='breakfast';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='almonds' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='almonds' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='almonds' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='almonds' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='almonds' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='almonds' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='almonds' AND dt.name='low_fodmap_small_only';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='almonds' AND dt.name='low_carb_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='almonds' AND dt.name='diabetic_friendly_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='almonds' AND dt.name='high_calorie_dense';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='peanuts' AND m.name='niacin';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='peanuts' AND m.name='folate';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='peanuts' AND m.name='magnesium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='peanuts' AND m.name='vitamin_e';
INSERT INTO food_allergens (food_id, allergen_id) SELECT f.food_id, a.allergen_id FROM foods f, allergens a WHERE f.name='peanuts' AND a.name='peanut';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='peanuts' AND mt.name='breakfast';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='peanuts' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='peanuts' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='peanuts' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='peanuts' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='peanuts' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='peanuts' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='peanuts' AND dt.name='low_fodmap_small_only';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='peanuts' AND dt.name='low_carb_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='peanuts' AND dt.name='diabetic_friendly_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='peanuts' AND dt.name='high_calorie_dense';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='banana' AND m.name='potassium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='banana' AND m.name='vitamin_b6';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='banana' AND m.name='vitamin_c';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='banana' AND m.name='manganese';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='banana' AND mt.name='breakfast';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='banana' AND mt.name='lunch';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='banana' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='banana' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='banana' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='banana' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='banana' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='banana' AND dt.name='low_fodmap_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='banana' AND dt.name='low_carb_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='banana' AND dt.name='diabetic_portion_control';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='banana' AND dt.name='ckd_potassium_caution';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='apple' AND m.name='vitamin_c';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='apple' AND m.name='potassium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='apple' AND m.name='copper';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='apple' AND mt.name='breakfast';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='apple' AND mt.name='lunch';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='apple' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='apple' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='apple' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='apple' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='apple' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='apple' AND dt.name='low_fodmap_small_only';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='apple' AND dt.name='low_carb_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='apple' AND dt.name='diabetic_portion_control';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='orange' AND m.name='vitamin_c';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='orange' AND m.name='folate';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='orange' AND m.name='potassium';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='orange' AND mt.name='breakfast';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='orange' AND mt.name='lunch';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='orange' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='orange' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='orange' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='orange' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='orange' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='orange' AND dt.name='low_fodmap_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='orange' AND dt.name='low_carb_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='orange' AND dt.name='diabetic_friendly_ok';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='avocado' AND m.name='folate';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='avocado' AND m.name='potassium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='avocado' AND m.name='vitamin_k';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='avocado' AND m.name='vitamin_e';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='avocado' AND mt.name='breakfast';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='avocado' AND mt.name='lunch';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='avocado' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='avocado' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='avocado' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='avocado' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='avocado' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='avocado' AND dt.name='low_fodmap_small_only';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='avocado' AND dt.name='low_carb_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='avocado' AND dt.name='diabetic_friendly_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='avocado' AND dt.name='ckd_potassium_caution';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='sweet_potato_baked' AND m.name='vitamin_a';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='sweet_potato_baked' AND m.name='vitamin_c';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='sweet_potato_baked' AND m.name='potassium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='sweet_potato_baked' AND m.name='manganese';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='sweet_potato_baked' AND mt.name='lunch';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='sweet_potato_baked' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='sweet_potato_baked' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='sweet_potato_baked' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='sweet_potato_baked' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='sweet_potato_baked' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='sweet_potato_baked' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='sweet_potato_baked' AND dt.name='low_fodmap_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='sweet_potato_baked' AND dt.name='low_carb_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='sweet_potato_baked' AND dt.name='diabetic_portion_control';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='broccoli_steamed' AND m.name='vitamin_c';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='broccoli_steamed' AND m.name='vitamin_k';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='broccoli_steamed' AND m.name='folate';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='broccoli_steamed' AND m.name='potassium';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='broccoli_steamed' AND mt.name='lunch';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='broccoli_steamed' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='broccoli_steamed' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='broccoli_steamed' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='broccoli_steamed' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='broccoli_steamed' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='broccoli_steamed' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='broccoli_steamed' AND dt.name='low_fodmap_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='broccoli_steamed' AND dt.name='low_carb_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='broccoli_steamed' AND dt.name='diabetic_friendly_ok';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='spinach_cooked' AND m.name='vitamin_k';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='spinach_cooked' AND m.name='folate';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='spinach_cooked' AND m.name='iron';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='spinach_cooked' AND m.name='magnesium';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='spinach_cooked' AND mt.name='lunch';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='spinach_cooked' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='spinach_cooked' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='spinach_cooked' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='spinach_cooked' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='spinach_cooked' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='spinach_cooked' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='spinach_cooked' AND dt.name='low_fodmap_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='spinach_cooked' AND dt.name='low_carb_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='spinach_cooked' AND dt.name='diabetic_friendly_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='spinach_cooked' AND dt.name='ckd_potassium_caution';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='cucumber_raw' AND m.name='vitamin_k';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='cucumber_raw' AND m.name='potassium';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='cucumber_raw' AND mt.name='breakfast';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='cucumber_raw' AND mt.name='lunch';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='cucumber_raw' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='cucumber_raw' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='cucumber_raw' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='cucumber_raw' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='cucumber_raw' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='cucumber_raw' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='cucumber_raw' AND dt.name='low_fodmap_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='cucumber_raw' AND dt.name='low_carb_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='cucumber_raw' AND dt.name='diabetic_friendly_ok';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='tomato_raw' AND m.name='vitamin_c';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='tomato_raw' AND m.name='potassium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='tomato_raw' AND m.name='folate';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='tomato_raw' AND m.name='vitamin_a';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='tomato_raw' AND mt.name='breakfast';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='tomato_raw' AND mt.name='lunch';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='tomato_raw' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='tomato_raw' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='tomato_raw' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='tomato_raw' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='tomato_raw' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='tomato_raw' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='tomato_raw' AND dt.name='low_fodmap_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='tomato_raw' AND dt.name='low_carb_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='tomato_raw' AND dt.name='diabetic_friendly_ok';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='quinoa_cooked' AND m.name='manganese';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='quinoa_cooked' AND m.name='magnesium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='quinoa_cooked' AND m.name='folate';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='quinoa_cooked' AND m.name='phosphorus';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='quinoa_cooked' AND mt.name='lunch';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='quinoa_cooked' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='quinoa_cooked' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='quinoa_cooked' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='quinoa_cooked' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='quinoa_cooked' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='quinoa_cooked' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='quinoa_cooked' AND dt.name='low_fodmap_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='quinoa_cooked' AND dt.name='low_carb_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='quinoa_cooked' AND dt.name='diabetic_friendly_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='quinoa_cooked' AND dt.name='high_fiber';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='brown_rice_cooked' AND m.name='manganese';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='brown_rice_cooked' AND m.name='selenium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='brown_rice_cooked' AND m.name='magnesium';
INSERT INTO food_micronutrients (food_id, micronutrient_id) SELECT f.food_id, m.micronutrient_id FROM foods f, micronutrients m WHERE f.name='brown_rice_cooked' AND m.name='vitamin_b1';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='brown_rice_cooked' AND mt.name='lunch';
INSERT INTO food_meal_types (food_id, meal_type_id) SELECT f.food_id, mt.meal_type_id FROM foods f, meal_types mt WHERE f.name='brown_rice_cooked' AND mt.name='dinner';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='brown_rice_cooked' AND dt.name='vegan_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='brown_rice_cooked' AND dt.name='vegetarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='brown_rice_cooked' AND dt.name='pescatarian_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='brown_rice_cooked' AND dt.name='halal_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='brown_rice_cooked' AND dt.name='gluten_free_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='brown_rice_cooked' AND dt.name='low_fodmap_ok';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='brown_rice_cooked' AND dt.name='low_carb_no';
INSERT INTO food_diet_tags (food_id, tag_id) SELECT f.food_id, dt.tag_id FROM foods f, diet_tags dt WHERE f.name='brown_rice_cooked' AND dt.name='diabetic_portion_control';
INSERT INTO dietary_preference_required_tags (preference_id, tag_id) SELECT dp.preference_id, dt.tag_id FROM dietary_preferences dp, diet_tags dt WHERE dp.name='vegetarian' AND dt.name='vegetarian_ok';
INSERT INTO dietary_preference_required_tags (preference_id, tag_id) SELECT dp.preference_id, dt.tag_id FROM dietary_preferences dp, diet_tags dt WHERE dp.name='vegan' AND dt.name='vegan_ok';
INSERT INTO dietary_preference_required_tags (preference_id, tag_id) SELECT dp.preference_id, dt.tag_id FROM dietary_preferences dp, diet_tags dt WHERE dp.name='pescatarian' AND dt.name='pescatarian_ok';
INSERT INTO dietary_preference_required_tags (preference_id, tag_id) SELECT dp.preference_id, dt.tag_id FROM dietary_preferences dp, diet_tags dt WHERE dp.name='halal' AND dt.name='halal_ok';
INSERT INTO dietary_preference_required_tags (preference_id, tag_id) SELECT dp.preference_id, dt.tag_id FROM dietary_preferences dp, diet_tags dt WHERE dp.name='gluten_free' AND dt.name='gluten_free_ok';
INSERT INTO dietary_preference_required_tags (preference_id, tag_id) SELECT dp.preference_id, dt.tag_id FROM dietary_preferences dp, diet_tags dt WHERE dp.name='low_carb' AND dt.name='low_carb_ok';
INSERT INTO dietary_preference_required_tags (preference_id, tag_id) SELECT dp.preference_id, dt.tag_id FROM dietary_preferences dp, diet_tags dt WHERE dp.name='diabetic_friendly' AND dt.name='diabetic_friendly_ok';
INSERT INTO dietary_preference_required_tags (preference_id, tag_id) SELECT dp.preference_id, dt.tag_id FROM dietary_preferences dp, diet_tags dt WHERE dp.name='high_protein' AND dt.name='high_protein';
INSERT INTO dietary_preference_forbidden_tags (preference_id, tag_id) SELECT dp.preference_id, dt.tag_id FROM dietary_preferences dp, diet_tags dt WHERE dp.name='vegetarian' AND dt.name='vegetarian_no';
INSERT INTO dietary_preference_forbidden_tags (preference_id, tag_id) SELECT dp.preference_id, dt.tag_id FROM dietary_preferences dp, diet_tags dt WHERE dp.name='vegan' AND dt.name='vegan_no';
INSERT INTO dietary_preference_forbidden_tags (preference_id, tag_id) SELECT dp.preference_id, dt.tag_id FROM dietary_preferences dp, diet_tags dt WHERE dp.name='pescatarian' AND dt.name='pescatarian_no';
INSERT INTO dietary_preference_forbidden_tags (preference_id, tag_id) SELECT dp.preference_id, dt.tag_id FROM dietary_preferences dp, diet_tags dt WHERE dp.name='gluten_free' AND dt.name='contains_gluten';
INSERT INTO dietary_preference_forbidden_tags (preference_id, tag_id) SELECT dp.preference_id, dt.tag_id FROM dietary_preferences dp, diet_tags dt WHERE dp.name='gluten_free' AND dt.name='gluten_free_only_if_certified';
INSERT INTO dietary_preference_forbidden_tags (preference_id, tag_id) SELECT dp.preference_id, dt.tag_id FROM dietary_preferences dp, diet_tags dt WHERE dp.name='low_carb' AND dt.name='low_carb_no';
INSERT INTO condition_avoid_tags (condition_id, tag_id) SELECT hc.condition_id, dt.tag_id FROM health_conditions hc, diet_tags dt WHERE hc.name='overweight' AND dt.name='high_calorie_dense';
INSERT INTO condition_avoid_tags (condition_id, tag_id) SELECT hc.condition_id, dt.tag_id FROM health_conditions hc, diet_tags dt WHERE hc.name='overweight' AND dt.name='high_sat_fat_caution';
INSERT INTO condition_avoid_tags (condition_id, tag_id) SELECT hc.condition_id, dt.tag_id FROM health_conditions hc, diet_tags dt WHERE hc.name='diabetes' AND dt.name='diabetic_caution';
INSERT INTO condition_avoid_tags (condition_id, tag_id) SELECT hc.condition_id, dt.tag_id FROM health_conditions hc, diet_tags dt WHERE hc.name='diabetes' AND dt.name='low_carb_no';
INSERT INTO condition_avoid_tags (condition_id, tag_id) SELECT hc.condition_id, dt.tag_id FROM health_conditions hc, diet_tags dt WHERE hc.name='hypertension' AND dt.name='high_sodium_caution';
INSERT INTO condition_avoid_tags (condition_id, tag_id) SELECT hc.condition_id, dt.tag_id FROM health_conditions hc, diet_tags dt WHERE hc.name='hypertension' AND dt.name='high_sat_fat_caution';
INSERT INTO condition_avoid_tags (condition_id, tag_id) SELECT hc.condition_id, dt.tag_id FROM health_conditions hc, diet_tags dt WHERE hc.name='heart_disease' AND dt.name='high_sat_fat_caution';
INSERT INTO condition_avoid_tags (condition_id, tag_id) SELECT hc.condition_id, dt.tag_id FROM health_conditions hc, diet_tags dt WHERE hc.name='heart_disease' AND dt.name='high_sodium_caution';
INSERT INTO condition_avoid_tags (condition_id, tag_id) SELECT hc.condition_id, dt.tag_id FROM health_conditions hc, diet_tags dt WHERE hc.name='kidney_disease' AND dt.name='ckd_potassium_caution';
INSERT INTO condition_avoid_tags (condition_id, tag_id) SELECT hc.condition_id, dt.tag_id FROM health_conditions hc, diet_tags dt WHERE hc.name='kidney_disease' AND dt.name='high_sodium_caution';
INSERT INTO condition_avoid_tags (condition_id, tag_id) SELECT hc.condition_id, dt.tag_id FROM health_conditions hc, diet_tags dt WHERE hc.name='gout' AND dt.name='high_purine_caution';
INSERT INTO condition_avoid_tags (condition_id, tag_id) SELECT hc.condition_id, dt.tag_id FROM health_conditions hc, diet_tags dt WHERE hc.name='celiac' AND dt.name='contains_gluten';
INSERT INTO condition_avoid_tags (condition_id, tag_id) SELECT hc.condition_id, dt.tag_id FROM health_conditions hc, diet_tags dt WHERE hc.name='celiac' AND dt.name='gluten_free_only_if_certified';
INSERT INTO condition_avoid_tags (condition_id, tag_id) SELECT hc.condition_id, dt.tag_id FROM health_conditions hc, diet_tags dt WHERE hc.name='celiac' AND dt.name='gluten_free_if_made_without_wheat';
INSERT INTO condition_avoid_tags (condition_id, tag_id) SELECT hc.condition_id, dt.tag_id FROM health_conditions hc, diet_tags dt WHERE hc.name='lactose_intolerance' AND dt.name='lactose_present';
INSERT INTO condition_avoid_tags (condition_id, tag_id) SELECT hc.condition_id, dt.tag_id FROM health_conditions hc, diet_tags dt WHERE hc.name='ibs' AND dt.name='low_fodmap_no';
INSERT INTO condition_avoid_tags (condition_id, tag_id) SELECT hc.condition_id, dt.tag_id FROM health_conditions hc, diet_tags dt WHERE hc.name='pregnancy' AND dt.name='high_sodium_caution';
INSERT INTO condition_prefer_tags (condition_id, tag_id) SELECT hc.condition_id, dt.tag_id FROM health_conditions hc, diet_tags dt WHERE hc.name='overweight' AND dt.name='low_carb_ok';
INSERT INTO condition_prefer_tags (condition_id, tag_id) SELECT hc.condition_id, dt.tag_id FROM health_conditions hc, diet_tags dt WHERE hc.name='overweight' AND dt.name='high_fiber';
INSERT INTO condition_prefer_tags (condition_id, tag_id) SELECT hc.condition_id, dt.tag_id FROM health_conditions hc, diet_tags dt WHERE hc.name='diabetes' AND dt.name='diabetic_friendly_ok';
INSERT INTO condition_prefer_tags (condition_id, tag_id) SELECT hc.condition_id, dt.tag_id FROM health_conditions hc, diet_tags dt WHERE hc.name='diabetes' AND dt.name='high_fiber';
INSERT INTO condition_prefer_tags (condition_id, tag_id) SELECT hc.condition_id, dt.tag_id FROM health_conditions hc, diet_tags dt WHERE hc.name='hypertension' AND dt.name='low_carb_ok';
INSERT INTO condition_prefer_tags (condition_id, tag_id) SELECT hc.condition_id, dt.tag_id FROM health_conditions hc, diet_tags dt WHERE hc.name='hypertension' AND dt.name='diabetic_friendly_ok';
INSERT INTO condition_prefer_tags (condition_id, tag_id) SELECT hc.condition_id, dt.tag_id FROM health_conditions hc, diet_tags dt WHERE hc.name='heart_disease' AND dt.name='high_fiber';
INSERT INTO condition_prefer_tags (condition_id, tag_id) SELECT hc.condition_id, dt.tag_id FROM health_conditions hc, diet_tags dt WHERE hc.name='heart_disease' AND dt.name='diabetic_friendly_ok';
INSERT INTO condition_prefer_tags (condition_id, tag_id) SELECT hc.condition_id, dt.tag_id FROM health_conditions hc, diet_tags dt WHERE hc.name='kidney_disease' AND dt.name='low_sodium_ok';
INSERT INTO condition_prefer_tags (condition_id, tag_id) SELECT hc.condition_id, dt.tag_id FROM health_conditions hc, diet_tags dt WHERE hc.name='gout' AND dt.name='low_purine_ok';
INSERT INTO condition_prefer_tags (condition_id, tag_id) SELECT hc.condition_id, dt.tag_id FROM health_conditions hc, diet_tags dt WHERE hc.name='celiac' AND dt.name='gluten_free_ok';
INSERT INTO condition_prefer_tags (condition_id, tag_id) SELECT hc.condition_id, dt.tag_id FROM health_conditions hc, diet_tags dt WHERE hc.name='lactose_intolerance' AND dt.name='vegan_ok';
INSERT INTO condition_prefer_tags (condition_id, tag_id) SELECT hc.condition_id, dt.tag_id FROM health_conditions hc, diet_tags dt WHERE hc.name='ibs' AND dt.name='low_fodmap_ok';
INSERT INTO condition_prefer_tags (condition_id, tag_id) SELECT hc.condition_id, dt.tag_id FROM health_conditions hc, diet_tags dt WHERE hc.name='pregnancy' AND dt.name='high_protein';

INSERT INTO meal_plans (name, calorie_level, min_target_calories, max_target_calories, diet_group) VALUES ('low_1800_omnivore', 'low_1800', 1500, 2100, 'omnivore_group');
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_omnivore' AND f.name='oats';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_omnivore' AND f.name='banana';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_omnivore' AND f.name='egg_boiled';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_omnivore' AND f.name='plain_ceylon_tea';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_omnivore' AND f.name='red_rice';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_omnivore' AND f.name='chicken_breast';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_omnivore' AND f.name='parippu_dhal_curry';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_omnivore' AND f.name='gotu_kola_mallung';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_omnivore' AND f.name='pumpkin_curry';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_omnivore' AND f.name='string_hoppers';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_omnivore' AND f.name='ambul_thiyal';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_omnivore' AND f.name='cucumber_raw';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_omnivore' AND f.name='tomato_raw';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_omnivore' AND f.name='plain_yogurt_low_fat';
INSERT INTO meal_plans (name, calorie_level, min_target_calories, max_target_calories, diet_group) VALUES ('low_1800_vegetarian', 'low_1800', 1500, 2100, 'vegetarian_group');
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_vegetarian' AND f.name='oats';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_vegetarian' AND f.name='banana';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_vegetarian' AND f.name='egg_boiled';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_vegetarian' AND f.name='plain_yogurt_low_fat';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_vegetarian' AND f.name='red_rice';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_vegetarian' AND f.name='parippu_dhal_curry';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_vegetarian' AND f.name='gotu_kola_mallung';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_vegetarian' AND f.name='pumpkin_curry';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_vegetarian' AND f.name='buffalo_curd';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_vegetarian' AND f.name='kurakkan_roti';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_vegetarian' AND f.name='mung_bean_curry';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_vegetarian' AND f.name='snake_gourd_curry';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_vegetarian' AND f.name='cucumber_raw';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_vegetarian' AND f.name='plain_yogurt_low_fat';
INSERT INTO meal_plans (name, calorie_level, min_target_calories, max_target_calories, diet_group) VALUES ('low_1800_vegan', 'low_1800', 1500, 2100, 'vegan_group');
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_vegan' AND f.name='oats';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_vegan' AND f.name='banana';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_vegan' AND f.name='kola_kenda';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_vegan' AND f.name='almonds';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_vegan' AND f.name='red_rice';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_vegan' AND f.name='parippu_dhal_curry';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_vegan' AND f.name='gotu_kola_mallung';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_vegan' AND f.name='pumpkin_curry';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_vegan' AND f.name='cucumber_raw';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_vegan' AND f.name='string_hoppers';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_vegan' AND f.name='mung_bean_curry';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_vegan' AND f.name='tofu_firm';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_vegan' AND f.name='tomato_raw';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='low_1800_vegan' AND f.name='peanuts';
INSERT INTO meal_plans (name, calorie_level, min_target_calories, max_target_calories, diet_group) VALUES ('standard_2500_omnivore', 'standard_2500', 2200, 2800, 'omnivore_group');
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_omnivore' AND f.name='oats';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_omnivore' AND f.name='banana';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_omnivore' AND f.name='milk_low_fat';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_omnivore' AND f.name='egg_boiled';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_omnivore' AND f.name='red_rice';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_omnivore' AND f.name='chicken_breast';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_omnivore' AND f.name='parippu_dhal_curry';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_omnivore' AND f.name='gotu_kola_mallung';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_omnivore' AND f.name='pumpkin_curry';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_omnivore' AND f.name='string_hoppers';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_omnivore' AND f.name='ambul_thiyal';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_omnivore' AND f.name='mung_bean_curry';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_omnivore' AND f.name='coconut_sambol';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_omnivore' AND f.name='plain_yogurt_low_fat';
INSERT INTO meal_plans (name, calorie_level, min_target_calories, max_target_calories, diet_group) VALUES ('standard_2500_vegetarian', 'standard_2500', 2200, 2800, 'vegetarian_group');
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_vegetarian' AND f.name='oats';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_vegetarian' AND f.name='banana';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_vegetarian' AND f.name='milk_low_fat';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_vegetarian' AND f.name='egg_boiled';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_vegetarian' AND f.name='red_rice';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_vegetarian' AND f.name='parippu_dhal_curry';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_vegetarian' AND f.name='gotu_kola_mallung';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_vegetarian' AND f.name='pumpkin_curry';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_vegetarian' AND f.name='buffalo_curd';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_vegetarian' AND f.name='kurakkan_roti';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_vegetarian' AND f.name='mung_bean_curry';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_vegetarian' AND f.name='snake_gourd_curry';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_vegetarian' AND f.name='plain_yogurt_low_fat';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_vegetarian' AND f.name='peanuts';
INSERT INTO meal_plans (name, calorie_level, min_target_calories, max_target_calories, diet_group) VALUES ('standard_2500_vegan', 'standard_2500', 2200, 2800, 'vegan_group');
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_vegan' AND f.name='oats';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_vegan' AND f.name='banana';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_vegan' AND f.name='almonds';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_vegan' AND f.name='kola_kenda';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_vegan' AND f.name='red_rice';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_vegan' AND f.name='parippu_dhal_curry';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_vegan' AND f.name='gotu_kola_mallung';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_vegan' AND f.name='pumpkin_curry';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_vegan' AND f.name='avocado';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_vegan' AND f.name='string_hoppers';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_vegan' AND f.name='mung_bean_curry';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_vegan' AND f.name='tofu_firm';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_vegan' AND f.name='cucumber_raw';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='standard_2500_vegan' AND f.name='peanuts';
INSERT INTO meal_plans (name, calorie_level, min_target_calories, max_target_calories, diet_group) VALUES ('high_4000_omnivore', 'high_4000', 3800, 4500, 'omnivore_group');
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 3 FROM meal_plans mp, foods f WHERE mp.name='high_4000_omnivore' AND f.name='oats';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='high_4000_omnivore' AND f.name='banana';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='high_4000_omnivore' AND f.name='milk_low_fat';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='high_4000_omnivore' AND f.name='almonds';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 3 FROM meal_plans mp, foods f WHERE mp.name='high_4000_omnivore' AND f.name='egg_boiled';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 3 FROM meal_plans mp, foods f WHERE mp.name='high_4000_omnivore' AND f.name='red_rice';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='high_4000_omnivore' AND f.name='chicken_breast';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='high_4000_omnivore' AND f.name='parippu_dhal_curry';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='high_4000_omnivore' AND f.name='avocado';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='high_4000_omnivore' AND f.name='buffalo_curd';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='high_4000_omnivore' AND f.name='coconut_sambol';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 3 FROM meal_plans mp, foods f WHERE mp.name='high_4000_omnivore' AND f.name='brown_rice_cooked';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='high_4000_omnivore' AND f.name='salmon';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='high_4000_omnivore' AND f.name='sweet_potato_baked';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='high_4000_omnivore' AND f.name='peanuts';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='high_4000_omnivore' AND f.name='plain_yogurt_low_fat';
INSERT INTO meal_plans (name, calorie_level, min_target_calories, max_target_calories, diet_group) VALUES ('high_4000_high_protein', 'high_4000', 3800, 4600, 'high_protein_group');
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 3 FROM meal_plans mp, foods f WHERE mp.name='high_4000_high_protein' AND f.name='oats';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 4 FROM meal_plans mp, foods f WHERE mp.name='high_4000_high_protein' AND f.name='egg_boiled';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='high_4000_high_protein' AND f.name='milk_low_fat';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='high_4000_high_protein' AND f.name='plain_yogurt_low_fat';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='high_4000_high_protein' AND f.name='banana';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 3 FROM meal_plans mp, foods f WHERE mp.name='high_4000_high_protein' AND f.name='red_rice';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 3 FROM meal_plans mp, foods f WHERE mp.name='high_4000_high_protein' AND f.name='chicken_breast';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='high_4000_high_protein' AND f.name='parippu_dhal_curry';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='high_4000_high_protein' AND f.name='gotu_kola_mallung';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='high_4000_high_protein' AND f.name='avocado';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 3 FROM meal_plans mp, foods f WHERE mp.name='high_4000_high_protein' AND f.name='brown_rice_cooked';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='high_4000_high_protein' AND f.name='salmon';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='high_4000_high_protein' AND f.name='tofu_firm';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='high_4000_high_protein' AND f.name='sweet_potato_baked';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='high_4000_high_protein' AND f.name='peanuts';
INSERT INTO meal_plans (name, calorie_level, min_target_calories, max_target_calories, diet_group) VALUES ('high_4000_vegetarian', 'high_4000', 3800, 4500, 'vegetarian_group');
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 3 FROM meal_plans mp, foods f WHERE mp.name='high_4000_vegetarian' AND f.name='oats';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='high_4000_vegetarian' AND f.name='banana';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='high_4000_vegetarian' AND f.name='milk_low_fat';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='high_4000_vegetarian' AND f.name='almonds';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 3 FROM meal_plans mp, foods f WHERE mp.name='high_4000_vegetarian' AND f.name='egg_boiled';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 3 FROM meal_plans mp, foods f WHERE mp.name='high_4000_vegetarian' AND f.name='red_rice';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 3 FROM meal_plans mp, foods f WHERE mp.name='high_4000_vegetarian' AND f.name='parippu_dhal_curry';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='high_4000_vegetarian' AND f.name='chickpeas_boiled';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='high_4000_vegetarian' AND f.name='avocado';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='high_4000_vegetarian' AND f.name='buffalo_curd';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 3 FROM meal_plans mp, foods f WHERE mp.name='high_4000_vegetarian' AND f.name='kurakkan_roti';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 3 FROM meal_plans mp, foods f WHERE mp.name='high_4000_vegetarian' AND f.name='mung_bean_curry';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='high_4000_vegetarian' AND f.name='tofu_firm';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='high_4000_vegetarian' AND f.name='peanuts';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='high_4000_vegetarian' AND f.name='plain_yogurt_low_fat';
INSERT INTO meal_plans (name, calorie_level, min_target_calories, max_target_calories, diet_group) VALUES ('high_4000_vegan', 'high_4000', 3800, 4500, 'vegan_group');
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 4 FROM meal_plans mp, foods f WHERE mp.name='high_4000_vegan' AND f.name='oats';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 3 FROM meal_plans mp, foods f WHERE mp.name='high_4000_vegan' AND f.name='banana';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 3 FROM meal_plans mp, foods f WHERE mp.name='high_4000_vegan' AND f.name='almonds';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='high_4000_vegan' AND f.name='kola_kenda';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'breakfast', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='high_4000_vegan' AND f.name='peanuts';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 4 FROM meal_plans mp, foods f WHERE mp.name='high_4000_vegan' AND f.name='red_rice';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 3 FROM meal_plans mp, foods f WHERE mp.name='high_4000_vegan' AND f.name='parippu_dhal_curry';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='high_4000_vegan' AND f.name='chickpeas_boiled';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='high_4000_vegan' AND f.name='avocado';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'lunch', f.food_id, 1 FROM meal_plans mp, foods f WHERE mp.name='high_4000_vegan' AND f.name='gotu_kola_mallung';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 4 FROM meal_plans mp, foods f WHERE mp.name='high_4000_vegan' AND f.name='string_hoppers';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 3 FROM meal_plans mp, foods f WHERE mp.name='high_4000_vegan' AND f.name='tofu_firm';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='high_4000_vegan' AND f.name='mung_bean_curry';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='high_4000_vegan' AND f.name='sweet_potato_baked';
INSERT INTO meal_plan_items (plan_id, meal_type, food_id, quantity) SELECT mp.plan_id, 'dinner', f.food_id, 2 FROM meal_plans mp, foods f WHERE mp.name='high_4000_vegan' AND f.name='peanuts';

CREATE VIEW food_full_view AS
SELECT
    f.food_id,
    f.name,
    f.origin,
    f.category,
    f.serving_size,
    f.calories,
    f.carbs_g,
    f.protein_g,
    f.fat_g,
    GROUP_CONCAT(DISTINCT mt.name ORDER BY mt.name SEPARATOR ', ') AS meal_types,
    GROUP_CONCAT(DISTINCT dt.name ORDER BY dt.name SEPARATOR ', ') AS diet_tags
FROM foods f
LEFT JOIN food_meal_types fmt ON f.food_id = fmt.food_id
LEFT JOIN meal_types mt ON fmt.meal_type_id = mt.meal_type_id
LEFT JOIN food_diet_tags fdt ON f.food_id = fdt.food_id
LEFT JOIN diet_tags dt ON fdt.tag_id = dt.tag_id
GROUP BY f.food_id;

CREATE VIEW meal_plan_summary AS
SELECT
    mp.plan_id,
    mp.name AS plan_name,
    mp.calorie_level,
    mp.diet_group,
    SUM(f.calories * mpi.quantity) AS total_calories,
    ROUND(SUM(f.carbs_g * mpi.quantity), 2) AS total_carbs_g,
    ROUND(SUM(f.protein_g * mpi.quantity), 2) AS total_protein_g,
    ROUND(SUM(f.fat_g * mpi.quantity), 2) AS total_fat_g
FROM meal_plans mp
JOIN meal_plan_items mpi ON mp.plan_id = mpi.plan_id
JOIN foods f ON mpi.food_id = f.food_id
GROUP BY mp.plan_id;

-- Test after import:
-- USE mealcraft_db;
-- SELECT COUNT(*) AS total_foods FROM foods;
-- SELECT * FROM meal_plan_summary;
-- SELECT * FROM food_full_view WHERE meal_types LIKE '%breakfast%';
-- SELECT mp.name, mpi.meal_type, f.name AS food, mpi.quantity, f.calories, f.calories * mpi.quantity AS item_calories
-- FROM meal_plans mp
-- JOIN meal_plan_items mpi ON mp.plan_id = mpi.plan_id
-- JOIN foods f ON mpi.food_id = f.food_id
-- WHERE mp.name = 'standard_2500_omnivore'
-- ORDER BY FIELD(mpi.meal_type, 'breakfast', 'lunch', 'dinner'), mpi.plan_item_id;