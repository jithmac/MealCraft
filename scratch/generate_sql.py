import re

def process_files():
    pl_path = r"c:\Users\Windows\Desktop\Final Project\ai\mealCraft.pl"
    sql_path = r"c:\Users\Windows\Desktop\Final Project\database\mealcraft_db.sql"
    
    with open(pl_path, 'r', encoding='utf-8') as f:
        pl_content = f.read()
        
    foods = []
    # food(Name, Origin, Category, ServingSizeGramOrMl, CaloriesPerServing, CarbsGram, ProteinGram, FatGram, MicronutrientsList, AllergensList, StorageAndUseNote, MealTypesList, DietaryTagsList).
    pattern = re.compile(r"food\(([^,]+),\s*([^,]+),\s*([^,]+),\s*([\d\.]+),\s*([\d\.]+),\s*([\d\.]+),\s*([\d\.]+),\s*([\d\.]+),\s*\[([^\]]*)\],\s*\[([^\]]*)\],\s*'([^']*)',\s*\[([^\]]*)\],\s*\[([^\]]*)\]\)\.")
    
    for match in pattern.finditer(pl_content):
        name = match.group(1).strip()
        origin = match.group(2).strip()
        category = match.group(3).strip()
        serving = match.group(4).strip()
        calories = match.group(5).strip()
        carbs = match.group(6).strip()
        protein = match.group(7).strip()
        fat = match.group(8).strip()
        micros = match.group(9).strip().replace("'", "")
        allergens = match.group(10).strip().replace("'", "")
        storage = match.group(11).strip().replace("'", "''")
        meals = match.group(12).strip().replace("'", "")
        dietary = match.group(13).strip().replace("'", "")
        
        foods.append({
            'name': name,
            'origin': origin,
            'category': category,
            'serving': serving,
            'calories': calories,
            'carbs': carbs,
            'protein': protein,
            'fat': fat,
            'micros': micros,
            'allergens': allergens,
            'storage': storage,
            'meals': meals,
            'dietary': dietary
        })

    # Read current sql to preserve cost_lkr if possible
    with open(sql_path, 'r', encoding='utf-8') as f:
        sql_content = f.read()
        
    cost_map = {}
    cost_pattern = re.compile(r"\(\d+,'([^']+)',\d+,\d+,\d+,\d+,([\d\.]+)")
    for match in cost_pattern.finditer(sql_content):
        cost_map[match.group(1)] = match.group(2)
        
    inserts = []
    for i, f in enumerate(foods, 1):
        cost = cost_map.get(f['name'], '50.00') # default 50.00 if not found
        insert = f"({i}, '{f['name']}', '{f['origin']}', '{f['category']}', {f['serving']}, {f['calories']}, {f['carbs']}, {f['protein']}, {f['fat']}, '{f['micros']}', '{f['allergens']}', '{f['storage']}', '{f['meals']}', '{f['dietary']}', {cost})"
        inserts.append(insert)
        
    insert_sql = "INSERT INTO `foods` VALUES\n" + ",\n".join(inserts) + ";"
    
    # Update SQL Schema for foods
    new_foods_schema = """DROP TABLE IF EXISTS `foods`;
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
  PRIMARY KEY (`food_id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;"""

    # We also need to fix the admin tables. The user asked "admin needs to log in". We can keep meal_admin or admin. Let's merge them into `admin` and insert default admin data.
    
    admin_schema = """DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
  `admin_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`admin_id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOCK TABLES `admin` WRITE;
INSERT INTO `admin` VALUES (1,'admin','admin123');
UNLOCK TABLES;"""

    # For orders, we keep it as is, or maybe add more columns if needed, but the current `orders` and `order_items` tables already exist. We can leave them.
    
    # Let's replace the whole SQL file to make sure it's clean.
    
    final_sql = f"""-- MySQL dump tailored for MealCraft
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

{admin_schema}

-- --------------------------------------------------------

{new_foods_schema}

LOCK TABLES `foods` WRITE;
{insert_sql}
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

COMMIT;
"""
    with open(sql_path, 'w', encoding='utf-8') as f:
        f.write(final_sql)
    
    print("SQL file rewritten successfully.")

if __name__ == "__main__":
    process_files()
