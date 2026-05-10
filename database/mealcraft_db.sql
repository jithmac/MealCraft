-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: mealcraft_db
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `admin_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`admin_id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `foods`
--

DROP TABLE IF EXISTS `foods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `foods` (
  `food_id` int NOT NULL AUTO_INCREMENT,
  `food_name` varchar(100) NOT NULL,
  `calories` int NOT NULL,
  `protein` int NOT NULL,
  `carbs` int NOT NULL,
  `fats` int NOT NULL,
  `cost_lkr` decimal(10,2) NOT NULL,
  `category` enum('base','protein','vegetable') NOT NULL,
  `dietary_tags` varchar(255) DEFAULT NULL,
  `meal_tags` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`food_id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `foods`
--

LOCK TABLES `foods` WRITE;
/*!40000 ALTER TABLE `foods` DISABLE KEYS */;
INSERT INTO `foods` VALUES (1,'red_rice',210,5,44,1,40.00,'base','vegan,vegetarian,gluten_free','lunch,dinner'),(2,'white_rice',215,4,47,0,35.00,'base','vegan,vegetarian,gluten_free','lunch,dinner'),(3,'nadu_rice',212,5,45,1,38.00,'base','vegan,vegetarian,gluten_free','lunch,dinner'),(4,'string_hoppers',180,4,40,1,45.00,'base','vegan,vegetarian,gluten_free','breakfast,dinner'),(5,'kurakkan_roti',170,5,32,3,35.00,'base','vegan,vegetarian,gluten_free','breakfast,dinner'),(6,'oats_porridge',170,6,27,3,56.00,'base','vegan,vegetarian,high_protein','breakfast'),(7,'wholemeal_bread',160,8,30,2,62.00,'base','vegan,vegetarian,high_protein','breakfast'),(8,'whole_wheat_pasta',220,8,43,1,98.00,'base','vegan,vegetarian','lunch,dinner'),(9,'tortilla_wrap',150,4,27,3,107.00,'base','vegan,vegetarian','breakfast,lunch,dinner'),(10,'cauliflower_rice',30,2,5,0,45.00,'base','vegan,vegetarian,gluten_free,low_carb','lunch,dinner'),(11,'sweet_potato',108,1,25,0,25.00,'base','vegan,vegetarian,gluten_free','breakfast,lunch,dinner'),(12,'manioc',78,1,19,0,18.00,'base','vegan,vegetarian,gluten_free','breakfast,lunch'),(13,'ash_plantain',114,4,24,1,22.00,'base','vegan,vegetarian,gluten_free','lunch,dinner'),(14,'dhal_curry',180,12,27,3,35.00,'protein','vegan,vegetarian,gluten_free,high_protein','breakfast,lunch,dinner'),(15,'green_gram_curry',170,11,25,2,45.00,'protein','vegan,vegetarian,gluten_free,high_protein','breakfast,lunch'),(16,'red_cowpea_curry',185,11,28,2,40.00,'protein','vegan,vegetarian,gluten_free,high_protein','breakfast,lunch,dinner'),(17,'chickpea_curry',190,10,31,3,44.00,'protein','vegan,vegetarian,gluten_free,high_protein','breakfast,lunch'),(18,'kidney_bean_curry',170,9,23,1,70.00,'protein','vegan,vegetarian,gluten_free,high_protein','lunch,dinner'),(19,'soya_meat_curry',130,15,10,3,35.00,'protein','vegan,vegetarian,high_protein,low_carb','lunch,dinner'),(20,'tofu',145,16,4,9,116.00,'protein','vegan,vegetarian,gluten_free,high_protein,low_carb','lunch,dinner'),(21,'plain_yoghurt',63,5,7,2,80.00,'protein','vegetarian,gluten_free','breakfast,dinner'),(22,'greek_yoghurt',92,10,6,4,272.00,'protein','vegetarian,gluten_free,high_protein,low_carb','breakfast,dinner'),(23,'egg_omelette',140,14,1,9,74.00,'protein','vegetarian,gluten_free,high_protein,low_carb','breakfast,dinner'),(24,'chicken_curry',210,23,4,10,160.00,'protein','gluten_free,high_protein,low_carb','lunch,dinner'),(25,'grilled_chicken',180,28,0,7,160.00,'protein','gluten_free,high_protein,low_carb','lunch,dinner'),(26,'balaya_fish',120,21,0,2,190.00,'protein','gluten_free,high_protein,low_carb','lunch,dinner'),(27,'seer_fish',150,22,0,5,260.00,'protein','gluten_free,high_protein,low_carb','lunch,dinner'),(28,'salaya_fish',110,20,0,2,80.00,'protein','gluten_free,high_protein,low_carb','lunch,dinner'),(29,'prawns',90,15,1,1,280.00,'protein','gluten_free,high_protein,low_carb','lunch,dinner'),(30,'gotukola_sambol',25,1,4,1,25.00,'vegetable','vegan,vegetarian,gluten_free,low_carb','lunch,dinner'),(31,'mukunuwenna_mallung',40,3,4,1,20.00,'vegetable','vegan,vegetarian,gluten_free,low_carb','lunch,dinner'),(32,'kankun_mallung',35,2,4,1,20.00,'vegetable','vegan,vegetarian,gluten_free,low_carb','lunch,dinner'),(33,'nivithi_mallung',35,2,4,1,22.00,'vegetable','vegan,vegetarian,gluten_free,low_carb','lunch,dinner'),(34,'thampala_mallung',45,4,5,1,24.00,'vegetable','vegan,vegetarian,gluten_free,low_carb','lunch,dinner'),(35,'beans_curry',60,4,8,1,72.00,'vegetable','vegan,vegetarian,gluten_free,low_carb','lunch,dinner'),(36,'long_beans_curry',50,3,7,1,33.00,'vegetable','vegan,vegetarian,gluten_free,low_carb','lunch,dinner'),(37,'pumpkin_curry',45,1,8,1,12.00,'vegetable','vegan,vegetarian,gluten_free','lunch,dinner'),(38,'cabbage_stir_fry',40,2,6,1,28.00,'vegetable','vegan,vegetarian,gluten_free,low_carb','lunch,dinner'),(39,'carrot_salad',35,1,7,0,50.00,'vegetable','vegan,vegetarian,gluten_free','breakfast,lunch,dinner'),(40,'beetroot_curry',45,2,9,0,45.00,'vegetable','vegan,vegetarian,gluten_free','lunch,dinner'),(41,'cucumber_salad',20,1,4,0,26.00,'vegetable','vegan,vegetarian,gluten_free,low_carb','breakfast,lunch,dinner'),(42,'tomato_salad',20,1,4,1,29.00,'vegetable','vegan,vegetarian,gluten_free,low_carb','breakfast,lunch,dinner'),(43,'brinjal_curry',40,1,6,1,40.00,'vegetable','vegan,vegetarian,gluten_free,low_carb','lunch,dinner'),(44,'brinjal_moju',90,1,8,6,55.00,'vegetable','vegan,vegetarian,gluten_free','lunch,dinner'),(45,'ladies_fingers_curry',40,2,7,1,20.00,'vegetable','vegan,vegetarian,gluten_free,low_carb','lunch,dinner'),(46,'snake_gourd_curry',25,1,5,0,18.00,'vegetable','vegan,vegetarian,gluten_free,low_carb','lunch,dinner'),(47,'bitter_gourd_stir_fry',35,2,6,1,30.00,'vegetable','vegan,vegetarian,gluten_free,low_carb','lunch,dinner'),(48,'drumstick_curry',40,2,7,1,25.00,'vegetable','vegan,vegetarian,gluten_free,low_carb','lunch,dinner'),(49,'cauliflower_stir_fry',35,2,5,1,35.00,'vegetable','vegan,vegetarian,gluten_free,low_carb','lunch,dinner'),(50,'mushroom_stir_fry',45,3,5,1,95.00,'vegetable','vegan,vegetarian,gluten_free,low_carb','lunch,dinner');
/*!40000 ALTER TABLE `foods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `meal_admin`
--

DROP TABLE IF EXISTS `meal_admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `meal_admin` (
  `admin_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`admin_id`),
  UNIQUE KEY `username_UNIQUE` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meal_admin`
--

LOCK TABLES `meal_admin` WRITE;
/*!40000 ALTER TABLE `meal_admin` DISABLE KEYS */;
INSERT INTO `meal_admin` VALUES (1,'admin','admin123');
/*!40000 ALTER TABLE `meal_admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `order_item_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int DEFAULT NULL,
  `food_id` int DEFAULT NULL,
  `quantity` int DEFAULT '1',
  `price` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`order_item_id`),
  KEY `order_id` (`order_id`),
  KEY `food_id` (`food_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`food_id`) REFERENCES `foods` (`food_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-10 10:55:39
