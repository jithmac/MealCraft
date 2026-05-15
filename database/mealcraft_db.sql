-- MySQL dump tailored for MealCraft
-- Admin login and order management

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mealcraft_db`
--

-- --------------------------------------------------------

DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
  `admin_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`admin_id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `admin` WRITE;
INSERT INTO `admin` VALUES (1,'admin','admin123');
UNLOCK TABLES;

DROP TABLE IF EXISTS `meal_admin`;


-- --------------------------------------------------------

DROP TABLE IF EXISTS `foods`;
CREATE TABLE `foods` (
  `food_id` int NOT NULL AUTO_INCREMENT,
  `food_name` varchar(100) NOT NULL,
  `origin` varchar(50) DEFAULT NULL,
  `category` varchar(50) NOT NULL,
  `serving_size` int NOT NULL,
  `calories` decimal(10,2) NOT NULL,
  `carbs` decimal(10,2) NOT NULL,
  `protein` decimal(10,2) NOT NULL,
  `fats` decimal(10,2) NOT NULL,
  `micronutrients` text DEFAULT NULL,
  `allergens` text DEFAULT NULL,
  `storage_note` text DEFAULT NULL,
  `meal_tags` varchar(255) DEFAULT NULL,
  `dietary_tags` text DEFAULT NULL,
  `cost_lkr` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`food_id`),
  UNIQUE KEY `food_name_UNIQUE` (`food_name`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `foods` WRITE;
INSERT INTO `foods` VALUES
(1, 'red_rice', 'sri_lankan', 'grain', 150, 165, 36.0, 3.5, 1.3, 'manganese, magnesium, selenium, vitamin_b1', '', 'Refrigerate cooked rice up to 3 to 4 days. Sri Lankan use: rice-and-curry base.', 'lunch, dinner', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_no, diabetic_portion_control', 40.00),
(2, 'kurakkan_roti', 'sri_lankan', 'grain', 60, 150, 28.0, 3.5, 2.5, 'calcium, iron, magnesium, phosphorus', 'possible_gluten_if_wheat_mixed, coconut', 'Best eaten fresh. Sri Lankan use: breakfast or dinner with lunu miris, dhal or sambol.', 'breakfast, dinner', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_if_made_without_wheat, low_fodmap_small_only, low_carb_no, diabetic_portion_control', 35.00),
(3, 'string_hoppers', 'sri_lankan', 'grain', 100, 150, 33.0, 3.0, 0.5, 'selenium, manganese, iron', '', 'Refrigerate 1 to 2 days. Sri Lankan use: breakfast or dinner with dhal, kiri hodi or fish curry.', 'breakfast, dinner', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_no, diabetic_portion_control', 45.00),
(4, 'hopper', 'sri_lankan', 'grain', 60, 110, 18.0, 2.0, 4.0, 'manganese, selenium, iron', 'coconut', 'Best fresh. Sri Lankan use: breakfast or dinner with egg, sambol or curry.', 'breakfast, dinner', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_no, diabetic_portion_control', 50.00),
(5, 'kiri_bath', 'sri_lankan', 'grain', 100, 175, 28.0, 3.0, 6.0, 'manganese, selenium, iron', 'coconut', 'Refrigerate up to 2 days. Sri Lankan use: festive breakfast or dinner.', 'breakfast, dinner', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_no, diabetic_caution, high_sat_fat_caution', 50.00),
(6, 'parippu_dhal_curry', 'sri_lankan', 'legume', 150, 180, 24.0, 10.0, 5.0, 'folate, iron, potassium, magnesium', 'coconut', 'Refrigerate 3 to 4 days. Sri Lankan use: staple side dish with rice, roti, hoppers or string hoppers.', 'breakfast, lunch, dinner', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_no, diabetic_friendly_ok, high_fiber', 50.00),
(7, 'gotu_kola_mallung', 'sri_lankan', 'vegetable', 80, 70, 7.0, 2.0, 4.0, 'vitamin_a, vitamin_c, vitamin_k, folate', 'coconut', 'Best same day. Sri Lankan use: fresh mallung side dish with rice and curry.', 'lunch, dinner', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_ok, diabetic_friendly_ok, high_fiber', 50.00),
(8, 'polos_curry', 'sri_lankan', 'vegetable', 150, 140, 18.0, 3.0, 6.0, 'vitamin_c, potassium, vitamin_b6, copper', 'coconut', 'Refrigerate 3 days. Sri Lankan use: young jackfruit curry.', 'lunch, dinner', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_no, low_carb_no, diabetic_portion_control', 50.00),
(9, 'jackfruit_ripe', 'sri_lankan', 'fruit', 100, 95, 24.0, 1.7, 0.6, 'vitamin_c, potassium, vitamin_b6, magnesium', '', 'Ripen at room temperature, then refrigerate 2 to 3 days. Sri Lankan use: fresh fruit.', 'breakfast, lunch', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_no, diabetic_portion_control', 50.00),
(10, 'coconut_sambol', 'sri_lankan', 'condiment', 30, 110, 4.0, 1.0, 10.0, 'manganese, copper, selenium, iron', 'coconut', 'Keep refrigerated and use within 1 day. Sri Lankan use: condiment for hoppers, bread or rice.', 'breakfast, lunch, dinner', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_ok, diabetic_portion_control, high_sat_fat_caution, high_sodium_caution', 50.00),
(11, 'ambul_thiyal', 'sri_lankan', 'meat', 100, 165, 2.0, 24.0, 7.0, 'vitamin_b12, selenium, iodine, vitamin_d', 'fish', 'Refrigerate 2 to 3 days. Sri Lankan use: sour fish curry with rice.', 'lunch, dinner', 'vegan_no, vegetarian_no, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_ok, diabetic_friendly_ok, high_protein, high_purine_caution', 50.00),
(12, 'king_coconut_water', 'sri_lankan', 'beverage', 240, 44, 10.0, 1.0, 0.0, 'potassium, manganese, magnesium', '', 'Drink fresh. Refrigerate after opening and use within 24 hours.', 'breakfast, lunch', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_no, diabetic_portion_control, ckd_potassium_caution', 50.00),
(13, 'buffalo_curd', 'sri_lankan', 'dairy', 100, 110, 4.0, 5.0, 8.0, 'calcium, vitamin_b12, phosphorus, riboflavin', 'milk, lactose', 'Keep refrigerated and use by date. Sri Lankan use: breakfast or dessert with fruit.', 'breakfast, dinner', 'vegan_no, vegetarian_ok, pescatarian_ok, halal_if_certified, gluten_free_ok, low_fodmap_small_only, low_carb_ok, diabetic_portion_control, lactose_present, high_sat_fat_caution', 50.00),
(14, 'kola_kenda', 'sri_lankan', 'beverage', 250, 85, 12.0, 3.0, 3.0, 'iron, folate, vitamin_a, calcium', 'coconut', 'Best consumed fresh. Sri Lankan use: herbal breakfast porridge.', 'breakfast', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_no, diabetic_portion_control', 50.00),
(15, 'cassava_boiled', 'sri_lankan', 'grain', 100, 112, 27.0, 1.0, 0.4, 'vitamin_c, manganese, folate, potassium', '', 'Refrigerate cooked cassava up to 3 days. Sri Lankan use: breakfast or dinner starch.', 'breakfast, dinner', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_no, diabetic_caution', 50.00),
(16, 'mung_bean_curry', 'sri_lankan', 'legume', 150, 160, 24.0, 9.0, 2.0, 'folate, magnesium, potassium, iron', '', 'Refrigerate 3 days. Sri Lankan use: curry or breakfast dish.', 'breakfast, lunch, dinner', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_no, diabetic_friendly_ok, high_fiber', 50.00),
(17, 'breadfruit_boiled', 'sri_lankan', 'grain', 100, 103, 27.0, 1.0, 0.2, 'potassium, vitamin_c, magnesium, copper', '', 'Refrigerate cooked breadfruit 2 to 3 days. Sri Lankan use: boiled or curried starch.', 'lunch, dinner', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_no, diabetic_portion_control', 50.00),
(18, 'pumpkin_curry', 'sri_lankan', 'vegetable', 100, 55, 8.0, 1.0, 2.0, 'vitamin_a, vitamin_c, potassium, manganese', 'coconut', 'Refrigerate 2 to 3 days. Sri Lankan use: mild vegetable curry.', 'lunch, dinner', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_ok, diabetic_friendly_ok', 12.00),
(19, 'moringa_mallung', 'sri_lankan', 'vegetable', 75, 45, 6.0, 4.0, 0.8, 'vitamin_a, vitamin_c, calcium, iron', '', 'Best same day. Sri Lankan use: leafy side dish with rice and curry.', 'lunch, dinner', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_ok, diabetic_friendly_ok', 50.00),
(20, 'snake_gourd_curry', 'sri_lankan', 'vegetable', 100, 35, 6.0, 1.0, 1.0, 'vitamin_c, folate, potassium', 'coconut', 'Refrigerate 2 days. Sri Lankan use: light vegetable curry.', 'lunch, dinner', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_ok, diabetic_friendly_ok', 18.00),
(21, 'coconut_milk', 'sri_lankan', 'condiment', 60, 138, 3.0, 1.0, 14.0, 'manganese, copper, selenium, iron', 'coconut', 'Refrigerate after opening and use within 4 to 5 days. Sri Lankan use: curry base.', 'lunch, dinner', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_ok, diabetic_portion_control, high_sat_fat_caution', 50.00),
(22, 'plain_ceylon_tea', 'sri_lankan', 'beverage', 240, 2, 0.0, 0.0, 0.0, 'manganese, fluoride', '', 'Store dry tea leaves airtight. Sri Lankan use: plain beverage without sugar.', 'breakfast, dinner', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_ok, diabetic_friendly_ok', 50.00),
(23, 'dried_sprats', 'sri_lankan', 'meat', 20, 70, 0.0, 11.0, 2.0, 'calcium, iodine, selenium, vitamin_b12', 'fish', 'Store airtight in a cool dry place. Sri Lankan use: fried or added to sambols and curries.', 'breakfast, lunch, dinner', 'vegan_no, vegetarian_no, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_ok, diabetic_friendly_ok, high_sodium_caution, high_purine_caution, high_protein', 50.00),
(24, 'wood_apple_pulp', 'sri_lankan', 'fruit', 100, 134, 31.0, 3.0, 0.6, 'vitamin_c, calcium, iron, thiamin', '', 'Keep ripe pulp refrigerated 1 to 2 days. Sri Lankan use: fresh pulp or juice.', 'breakfast, dinner', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_no, low_carb_no, diabetic_caution', 50.00),
(25, 'cowpea_curry', 'sri_lankan', 'legume', 150, 170, 27.0, 10.0, 2.0, 'folate, iron, magnesium, potassium', '', 'Refrigerate 3 days. Sri Lankan use: curry with rice or bread.', 'lunch, dinner', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_no, diabetic_friendly_ok, high_fiber', 50.00),
(26, 'oats', 'international', 'grain', 40, 156, 27.0, 5.0, 3.0, 'manganese, phosphorus, magnesium, iron', 'possible_gluten_cross_contact', 'Keep dry in an airtight container. Use: porridge or overnight oats.', 'breakfast', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_only_if_certified, low_fodmap_small_only, low_carb_no, diabetic_friendly_ok, high_fiber', 50.00),
(27, 'whole_wheat_bread', 'international', 'grain', 56, 138, 24.0, 7.0, 2.0, 'selenium, manganese, iron, vitamin_b1', 'wheat, gluten', 'Store sealed 3 to 5 days or freeze. Use: toast or sandwiches.', 'breakfast, dinner', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, contains_gluten, low_fodmap_no, low_carb_no, diabetic_portion_control', 50.00),
(28, 'egg_boiled', 'international', 'meat', 50, 78, 0.6, 6.3, 5.3, 'vitamin_b12, choline, selenium, vitamin_d', 'egg', 'Refrigerate boiled eggs up to 1 week. Use: breakfast or protein side.', 'breakfast, lunch, dinner', 'vegan_no, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_ok, diabetic_friendly_ok, high_protein', 50.00),
(29, 'chicken_breast', 'international', 'meat', 100, 165, 0.0, 31.0, 3.6, 'niacin, selenium, vitamin_b6, phosphorus', '', 'Refrigerate cooked chicken 3 to 4 days. Use: grilled, curried or stir-fried protein.', 'lunch, dinner', 'vegan_no, vegetarian_no, pescatarian_no, halal_if_certified, gluten_free_ok, low_fodmap_ok, low_carb_ok, diabetic_friendly_ok, high_protein, high_purine_caution', 50.00),
(30, 'salmon', 'international', 'meat', 100, 206, 0.0, 22.0, 12.0, 'vitamin_d, vitamin_b12, selenium, potassium', 'fish', 'Refrigerate cooked salmon 3 days. Use: grilled or baked fish.', 'lunch, dinner', 'vegan_no, vegetarian_no, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_ok, diabetic_friendly_ok, high_protein, high_purine_caution', 50.00),
(31, 'tuna_canned', 'international', 'meat', 85, 99, 0.0, 22.0, 1.0, 'selenium, vitamin_b12, niacin, phosphorus', 'fish', 'Refrigerate after opening and use within 2 days. Use: sandwiches, salads or rice bowls.', 'lunch, dinner', 'vegan_no, vegetarian_no, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_ok, diabetic_friendly_ok, high_protein, high_purine_caution', 50.00),
(32, 'plain_yogurt_low_fat', 'international', 'dairy', 170, 100, 7.0, 10.0, 3.0, 'calcium, vitamin_b12, phosphorus, potassium', 'milk, lactose', 'Keep refrigerated and use by date. Use: breakfast bowl or snack.', 'breakfast, dinner', 'vegan_no, vegetarian_ok, pescatarian_ok, halal_if_certified, gluten_free_ok, low_fodmap_ok, low_carb_ok, diabetic_friendly_ok, lactose_present, high_protein', 50.00),
(33, 'milk_low_fat', 'international', 'dairy', 240, 102, 12.0, 8.0, 2.4, 'calcium, vitamin_b12, riboflavin, phosphorus', 'milk, lactose', 'Keep refrigerated and use by date. Use: tea, porridge or breakfast drink.', 'breakfast, dinner', 'vegan_no, vegetarian_ok, pescatarian_ok, halal_if_certified, gluten_free_ok, low_fodmap_ok, low_carb_no, diabetic_friendly_ok, lactose_present', 50.00),
(34, 'cheddar_cheese', 'international', 'dairy', 28, 113, 0.4, 7.0, 9.0, 'calcium, vitamin_a, vitamin_b12, phosphorus', 'milk', 'Keep refrigerated. Use: sandwiches, omelettes or baked dishes.', 'breakfast, dinner', 'vegan_no, vegetarian_ok, pescatarian_ok, halal_if_certified, gluten_free_ok, low_fodmap_ok, low_carb_ok, diabetic_portion_control, high_sat_fat_caution', 50.00),
(35, 'lentils_boiled', 'international', 'legume', 100, 116, 20.0, 9.0, 0.4, 'folate, iron, manganese, magnesium', '', 'Refrigerate cooked lentils 3 to 4 days. Use: soups, salads or side dishes.', 'lunch, dinner', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_no, diabetic_friendly_ok, high_fiber', 50.00),
(36, 'chickpeas_boiled', 'international', 'legume', 100, 164, 27.0, 9.0, 2.6, 'folate, manganese, iron, phosphorus', '', 'Refrigerate cooked chickpeas 3 to 4 days. Use: salads, curries or roasted snacks.', 'lunch, dinner', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_no, diabetic_friendly_ok, high_fiber', 50.00),
(37, 'tofu_firm', 'international', 'legume', 100, 144, 3.0, 17.0, 9.0, 'calcium, iron, manganese, selenium', 'soy', 'Keep refrigerated and use within a few days after opening. Use: stir-fries or curries.', 'lunch, dinner', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_ok, diabetic_friendly_ok, high_protein', 50.00),
(38, 'almonds', 'international', 'nut', 28, 164, 6.0, 6.0, 14.0, 'vitamin_e, magnesium, manganese, calcium', 'tree_nut', 'Store airtight in a cool dry place. Use: snack or topping.', 'breakfast, dinner', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_ok, diabetic_friendly_ok, high_calorie_dense', 50.00),
(39, 'peanuts', 'international', 'nut', 28, 170, 6.0, 7.0, 14.0, 'niacin, folate, magnesium, vitamin_e', 'peanut', 'Store airtight in a cool dry place. Use: roasted snack or topping.', 'breakfast, dinner', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_ok, diabetic_friendly_ok, high_calorie_dense', 50.00),
(40, 'banana', 'international', 'fruit', 118, 105, 27.0, 1.3, 0.4, 'potassium, vitamin_b6, vitamin_c, manganese', '', 'Ripen at room temperature then refrigerate 2 to 3 days. Use: breakfast fruit or snack.', 'breakfast, lunch', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_no, diabetic_portion_control, ckd_potassium_caution', 50.00),
(41, 'apple', 'international', 'fruit', 182, 95, 25.0, 0.5, 0.3, 'vitamin_c, potassium, copper', '', 'Refrigerate for best shelf life. Use: breakfast fruit or snack.', 'breakfast, lunch', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_no, diabetic_portion_control', 50.00),
(42, 'orange', 'international', 'fruit', 140, 66, 15.0, 1.3, 0.2, 'vitamin_c, folate, potassium', '', 'Refrigerate for longer keeping. Use: breakfast fruit or snack.', 'breakfast, lunch', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_no, diabetic_friendly_ok', 50.00),
(43, 'avocado', 'international', 'fruit', 100, 160, 9.0, 2.0, 15.0, 'folate, potassium, vitamin_k, vitamin_e', '', 'Ripen at room temperature then refrigerate 1 to 2 days. Use: spreads, salads or bowls.', 'breakfast, lunch', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_small_only, low_carb_ok, diabetic_friendly_ok, ckd_potassium_caution', 50.00),
(44, 'sweet_potato_baked', 'international', 'vegetable', 100, 90, 21.0, 2.0, 0.2, 'vitamin_a, vitamin_c, potassium, manganese', '', 'Refrigerate cooked sweet potato 3 to 4 days. Use: baked side.', 'lunch, dinner', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_no, diabetic_portion_control', 50.00),
(45, 'broccoli_steamed', 'international', 'vegetable', 90, 31, 6.0, 2.5, 0.3, 'vitamin_c, vitamin_k, folate, potassium', '', 'Refrigerate cooked broccoli 3 days. Use: steamed side or stir-fry.', 'lunch, dinner', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_ok, diabetic_friendly_ok', 50.00),
(46, 'spinach_cooked', 'international', 'vegetable', 90, 41, 7.0, 5.0, 0.5, 'vitamin_k, folate, iron, magnesium', '', 'Refrigerate cooked spinach 2 to 3 days. Use: sauteed side or curry.', 'lunch, dinner', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_no, low_carb_ok, diabetic_friendly_ok, ckd_potassium_caution', 50.00),
(47, 'cucumber_raw', 'international', 'vegetable', 100, 15, 4.0, 0.7, 0.1, 'vitamin_k, potassium', '', 'Refrigerate and use within several days. Use: salad or side dish.', 'breakfast, lunch, dinner', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_ok, diabetic_friendly_ok', 50.00),
(48, 'tomato_raw', 'international', 'vegetable', 123, 22, 5.0, 1.1, 0.2, 'vitamin_c, potassium, folate, vitamin_a', '', 'Keep at room temperature until ripe, then refrigerate briefly. Use: salads, sandwiches or curries.', 'breakfast, lunch, dinner', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_ok, diabetic_friendly_ok', 50.00),
(49, 'quinoa_cooked', 'international', 'grain', 185, 222, 39.0, 8.0, 3.6, 'manganese, magnesium, folate, phosphorus', '', 'Refrigerate cooked quinoa 3 to 4 days. Use: grain bowl, salad or rice substitute.', 'lunch, dinner', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_no, diabetic_friendly_ok, high_fiber', 50.00),
(50, 'brown_rice_cooked', 'international', 'grain', 150, 166, 34.0, 3.5, 1.4, 'manganese, selenium, magnesium, vitamin_b1', '', 'Refrigerate cooked rice up to 3 to 4 days. Use: whole-grain rice base.', 'lunch, dinner', 'vegan_ok, vegetarian_ok, pescatarian_ok, halal_ok, gluten_free_ok, low_fodmap_ok, low_carb_no, diabetic_portion_control', 50.00);
UNLOCK TABLES;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `customer_name` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `address` varchar(255) NOT NULL,
  `meal_type` varchar(50) DEFAULT NULL,
  `total_amount` decimal(10,2) DEFAULT NULL,
  `order_status` enum('pending','confirmed','cancelled','delivered') DEFAULT 'pending',
  `order_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--
DROP TABLE IF EXISTS `order_items`;
CREATE TABLE `order_items` (
  `order_item_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int DEFAULT NULL,
  `food_id` int DEFAULT NULL,
  `quantity` int DEFAULT '1',
  `price` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`order_item_id`),
  KEY `order_id` (`order_id`),
  KEY `food_id` (`food_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`food_id`) REFERENCES `foods` (`food_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

COMMIT;
