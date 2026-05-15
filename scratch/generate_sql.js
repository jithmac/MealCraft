const fs = require('fs');

const plPath = 'c:\\Users\\Windows\\Desktop\\Final Project\\ai\\mealCraft.pl';
const sqlPath = 'c:\\Users\\Windows\\Desktop\\Final Project\\database\\mealcraft_db.sql';

const plContent = fs.readFileSync(plPath, 'utf8');
const sqlContent = fs.readFileSync(sqlPath, 'utf8');

const foods = [];
const pattern = /food\(([^,]+),\s*([^,]+),\s*([^,]+),\s*([\d\.]+),\s*([\d\.]+),\s*([\d\.]+),\s*([\d\.]+),\s*([\d\.]+),\s*\[([^\]]*)\],\s*\[([^\]]*)\],\s*'([^']*)',\s*\[([^\]]*)\],\s*\[([^\]]*)\]\)\./g;

let match;
while ((match = pattern.exec(plContent)) !== null) {
    foods.push({
        name: match[1].trim(),
        origin: match[2].trim(),
        category: match[3].trim(),
        serving: match[4].trim(),
        calories: match[5].trim(),
        carbs: match[6].trim(),
        protein: match[7].trim(),
        fat: match[8].trim(),
        micros: match[9].trim().replace(/'/g, ""),
        allergens: match[10].trim().replace(/'/g, ""),
        storage: match[11].trim().replace(/'/g, "''"),
        meals: match[12].trim().replace(/'/g, ""),
        dietary: match[13].trim().replace(/'/g, "")
    });
}

const costMap = {};
const costPattern = /\(\d+,'([^']+)',\d+,\d+,\d+,\d+,([\d\.]+)/g;
let costMatch;
while ((costMatch = costPattern.exec(sqlContent)) !== null) {
    costMap[costMatch[1]] = costMatch[2];
}

const inserts = foods.map((f, index) => {
    const cost = costMap[f.name] || '50.00';
    return `(${index + 1}, '${f.name}', '${f.origin}', '${f.category}', ${f.serving}, ${f.calories}, ${f.carbs}, ${f.protein}, ${f.fat}, '${f.micros}', '${f.allergens}', '${f.storage}', '${f.meals}', '${f.dietary}', ${cost})`;
});

const insertSql = `INSERT INTO \`foods\` VALUES\n${inserts.join(',\n')};`;

const newFoodsSchema = `DROP TABLE IF EXISTS \`foods\`;
CREATE TABLE \`foods\` (
  \`food_id\` int NOT NULL AUTO_INCREMENT,
  \`food_name\` varchar(100) NOT NULL,
  \`origin\` varchar(50) DEFAULT NULL,
  \`category\` varchar(50) NOT NULL,
  \`serving_size\` int NOT NULL,
  \`calories\` decimal(10,2) NOT NULL,
  \`carbs\` decimal(10,2) NOT NULL,
  \`protein\` decimal(10,2) NOT NULL,
  \`fats\` decimal(10,2) NOT NULL,
  \`micronutrients\` text DEFAULT NULL,
  \`allergens\` text DEFAULT NULL,
  \`storage_note\` text DEFAULT NULL,
  \`meal_tags\` varchar(255) DEFAULT NULL,
  \`dietary_tags\` text DEFAULT NULL,
  \`cost_lkr\` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (\`food_id\`),
  UNIQUE KEY \`food_name_UNIQUE\` (\`food_name\`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;`;

const adminSchema = `DROP TABLE IF EXISTS \`admin\`;
CREATE TABLE \`admin\` (
  \`admin_id\` int NOT NULL AUTO_INCREMENT,
  \`username\` varchar(50) NOT NULL,
  \`password\` varchar(255) NOT NULL,
  PRIMARY KEY (\`admin_id\`),
  UNIQUE KEY \`username\` (\`username\`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOCK TABLES \`admin\` WRITE;
INSERT INTO \`admin\` VALUES (1,'admin','admin123');
UNLOCK TABLES;

DROP TABLE IF EXISTS \`meal_admin\`;
`;

const finalSql = `-- MySQL dump tailored for MealCraft
-- Admin login and order management

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: \`mealcraft_db\`
--

-- --------------------------------------------------------

${adminSchema}

-- --------------------------------------------------------

${newFoodsSchema}

LOCK TABLES \`foods\` WRITE;
${insertSql}
UNLOCK TABLES;

-- --------------------------------------------------------

--
-- Table structure for table \`orders\`
--
DROP TABLE IF EXISTS \`orders\`;
CREATE TABLE \`orders\` (
  \`order_id\` int NOT NULL AUTO_INCREMENT,
  \`customer_name\` varchar(100) NOT NULL,
  \`phone\` varchar(20) NOT NULL,
  \`address\` varchar(255) NOT NULL,
  \`meal_type\` varchar(50) DEFAULT NULL,
  \`total_amount\` decimal(10,2) DEFAULT NULL,
  \`order_status\` enum('pending','confirmed','cancelled','delivered') DEFAULT 'pending',
  \`order_date\` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (\`order_id\`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table \`order_items\`
--
DROP TABLE IF EXISTS \`order_items\`;
CREATE TABLE \`order_items\` (
  \`order_item_id\` int NOT NULL AUTO_INCREMENT,
  \`order_id\` int DEFAULT NULL,
  \`food_id\` int DEFAULT NULL,
  \`quantity\` int DEFAULT '1',
  \`price\` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (\`order_item_id\`),
  KEY \`order_id\` (\`order_id\`),
  KEY \`food_id\` (\`food_id\`),
  CONSTRAINT \`order_items_ibfk_1\` FOREIGN KEY (\`order_id\`) REFERENCES \`orders\` (\`order_id\`) ON DELETE CASCADE,
  CONSTRAINT \`order_items_ibfk_2\` FOREIGN KEY (\`food_id\`) REFERENCES \`foods\` (\`food_id\`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

COMMIT;
`;

fs.writeFileSync(sqlPath, finalSql, 'utf8');
console.log('SQL file rewritten successfully.');
