CREATE DATABASE  IF NOT EXISTS `rental_system` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `rental_system`;
-- MySQL dump 10.13  Distrib 9.2.0, for macos15.2 (arm64)
--
-- Host: 127.0.0.1    Database: rental_system
-- ------------------------------------------------------
-- Server version	9.2.0

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
-- Table structure for table `broker`
--

DROP TABLE IF EXISTS `broker`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `broker` (
  `broker_id` int NOT NULL AUTO_INCREMENT,
  `ssn` varchar(11) NOT NULL,
  `license_id` varchar(30) NOT NULL,
  `phone` varchar(30) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  PRIMARY KEY (`broker_id`),
  UNIQUE KEY `uk_broker_ssn` (`ssn`),
  UNIQUE KEY `uk_broker_license` (`license_id`),
  UNIQUE KEY `uk_broker_phone` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `broker`
--

LOCK TABLES `broker` WRITE;
/*!40000 ALTER TABLE `broker` DISABLE KEYS */;
INSERT INTO `broker` VALUES (1,'370-93-1618','LIC0001','475.865.0966x2796','Benjamin','Monroe'),(2,'488-33-6981','LIC0002','806-560-8022x960','Tiffany','Frank'),(3,'247-26-2706','LIC0003','755.149.2432x32012','Lee','Christian'),(4,'481-92-5377','LIC0004','+1-735-768-4489x5318','Edward','Wagner'),(5,'459-33-9765','LIC0005','896-624-7860','Brenda','Lee'),(6,'322-78-4820','LIC0006','001-336-553-7630','Karen','Zuniga'),(7,'155-13-9091','LIC0007','+1-609-055-3282x475','Ralph','Casey'),(8,'779-88-6828','LIC0008','295-894-7420','Jason','Jimenez'),(9,'572-35-4369','LIC0009','365.170.9424x70054','Vanessa','Pugh'),(10,'881-56-5340','LIC0010','(850)006-7880','Gary','Jackson');
/*!40000 ALTER TABLE `broker` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `broker_tenant`
--

DROP TABLE IF EXISTS `broker_tenant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `broker_tenant` (
  `broker_id` int NOT NULL,
  `tenant_id` int NOT NULL,
  PRIMARY KEY (`broker_id`,`tenant_id`),
  KEY `fk_broker_tenant_tenant` (`tenant_id`),
  CONSTRAINT `fk_broker_tenant_broker` FOREIGN KEY (`broker_id`) REFERENCES `broker` (`broker_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_broker_tenant_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `broker_tenant`
--

LOCK TABLES `broker_tenant` WRITE;
/*!40000 ALTER TABLE `broker_tenant` DISABLE KEYS */;
INSERT INTO `broker_tenant` VALUES (6,61),(1,63),(4,64),(8,64),(2,65),(3,65),(8,66),(9,70),(10,71),(7,72),(8,74),(10,74),(4,76),(1,77),(10,79),(8,81),(1,82),(8,84),(10,85),(1,87),(4,87),(6,87),(10,87),(8,88),(9,89),(7,92),(7,93),(1,94),(6,96),(2,98),(10,98),(3,100),(2,102),(8,102),(9,102),(10,103),(7,104),(2,105),(6,107),(8,109);
/*!40000 ALTER TABLE `broker_tenant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bus`
--

DROP TABLE IF EXISTS `bus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bus` (
  `bus_id` int NOT NULL AUTO_INCREMENT,
  `vehicle_license` varchar(20) NOT NULL,
  `bus_number` varchar(20) NOT NULL,
  `station_id` int NOT NULL,
  PRIMARY KEY (`bus_id`),
  UNIQUE KEY `uk_bus_license` (`vehicle_license`),
  UNIQUE KEY `uk_bus_number` (`bus_number`),
  KEY `fk_bus_to_station` (`station_id`),
  CONSTRAINT `fk_bus_to_station` FOREIGN KEY (`station_id`) REFERENCES `bus_station` (`station_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bus`
--

LOCK TABLES `bus` WRITE;
/*!40000 ALTER TABLE `bus` DISABLE KEYS */;
INSERT INTO `bus` VALUES (1,'B-1','Bus-1',1),(2,'B-2','Bus-2',2),(7,'B-7','Bus-7',7),(8,'B-8','Bus-8',8);
/*!40000 ALTER TABLE `bus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bus_station`
--

DROP TABLE IF EXISTS `bus_station`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bus_station` (
  `station_id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`station_id`),
  UNIQUE KEY `uk_bus_station_name` (`name`),
  CONSTRAINT `fk_bus_station` FOREIGN KEY (`station_id`) REFERENCES `public_transport_station` (`station_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bus_station`
--

LOCK TABLES `bus_station` WRITE;
/*!40000 ALTER TABLE `bus_station` DISABLE KEYS */;
INSERT INTO `bus_station` VALUES (1,'Bus Station 1'),(2,'Bus Station 2'),(7,'Bus Station 7'),(8,'Bus Station 8');
/*!40000 ALTER TABLE `bus_station` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `convenience_store`
--

DROP TABLE IF EXISTS `convenience_store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `convenience_store` (
  `store_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `street_number` varchar(20) NOT NULL,
  `street_name` varchar(100) NOT NULL,
  `city` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `neighborhood_id` int NOT NULL,
  PRIMARY KEY (`store_id`),
  UNIQUE KEY `uk_store_address` (`street_number`,`street_name`,`city`,`state`),
  KEY `fk_store_neighborhood` (`neighborhood_id`),
  CONSTRAINT `fk_store_neighborhood` FOREIGN KEY (`neighborhood_id`) REFERENCES `neighborhood` (`neighborhood_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `convenience_store`
--

LOCK TABLES `convenience_store` WRITE;
/*!40000 ALTER TABLE `convenience_store` DISABLE KEYS */;
INSERT INTO `convenience_store` VALUES (1,'Monroe Group','25014','Whitney Drive','South Karlshire','Ohio',11),(2,'Gonzales and Sons','03563','Rachel Greens','Johnland','Tennessee',11),(3,'Owens Inc','546','Katherine Extension','Kyleville','Ohio',10),(4,'Jenkins, Smith and Hickman','1708','Crawford Shoal','Lake Marilynburgh','North Dakota',15),(5,'Williams-Cole','2585','Blevins Inlet','New Antonio','Texas',10),(6,'Schmidt, Gutierrez and Lynch','844','Edward Islands','Castroport','Montana',5),(7,'Madden, Evans and Christian','2276','Elizabeth Circle','Seanbury','New Jersey',12),(8,'Williams, Simmons and Meyers','32905','Arnold Road','Laurabury','Mississippi',15),(9,'Vasquez-Smith','083','Courtney Oval','Lake Jamesbury','Illinois',5),(10,'Morrison Inc','53352','Michael Lodge','Kennethhaven','South Dakota',1);
/*!40000 ALTER TABLE `convenience_store` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `financial_provider`
--

DROP TABLE IF EXISTS `financial_provider`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `financial_provider` (
  `provider_id` int NOT NULL AUTO_INCREMENT,
  `passport_id` varchar(30) NOT NULL,
  `phone` varchar(30) NOT NULL,
  `relationship` varchar(50) NOT NULL,
  PRIMARY KEY (`provider_id`),
  UNIQUE KEY `uk_financial_provider_passport` (`passport_id`),
  UNIQUE KEY `uk_financial_provider_phone` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `financial_provider`
--

LOCK TABLES `financial_provider` WRITE;
/*!40000 ALTER TABLE `financial_provider` DISABLE KEYS */;
INSERT INTO `financial_provider` VALUES (1,'FP0001','850-171-2350x6724','Parent'),(2,'FP0002','(917)479-4964','Parent'),(3,'FP0003','(892)107-2420x49667','Parent'),(4,'FP0004','(330)361-5887','Parent'),(5,'FP0005','001-507-797-3327x4144','Parent'),(6,'FP0006','001-197-432-4200x686','Parent'),(7,'FP0007','001-187-614-5730','Parent'),(8,'FP0008','(940)236-9323','Parent'),(9,'FP0009','+1-717-420-5066x57345','Parent'),(10,'FP0010','956-969-5642x706','Parent'),(11,'FP0011','789-868-1217x38807','Parent'),(12,'FP0012','001-522-845-1627x32940','Parent'),(13,'FP0013','001-434-038-1651','Parent'),(14,'FP0014','387.146.8435','Parent'),(15,'FP0015','+1-730-015-6594','Parent'),(16,'FP0016','325-568-2018','Parent'),(17,'FP0017','+1-354-050-6470x153','Parent'),(18,'FP0018','(273)618-0648','Parent'),(19,'FP0019','745.259.1205x83467','Parent'),(20,'FP0020','+1-495-282-2318x629','Parent');
/*!40000 ALTER TABLE `financial_provider` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `financial_provider_user`
--

DROP TABLE IF EXISTS `financial_provider_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `financial_provider_user` (
  `provider_id` int NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`provider_id`,`user_id`),
  KEY `fk_financial_user_user` (`user_id`),
  CONSTRAINT `fk_financial_user_provider` FOREIGN KEY (`provider_id`) REFERENCES `financial_provider` (`provider_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_financial_user_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `financial_provider_user`
--

LOCK TABLES `financial_provider_user` WRITE;
/*!40000 ALTER TABLE `financial_provider_user` DISABLE KEYS */;
INSERT INTO `financial_provider_user` VALUES (14,64),(15,66),(10,67),(8,74),(17,74),(13,76),(7,77),(6,78),(16,81),(3,85),(19,85),(5,86),(18,88),(12,91),(9,96),(1,102),(11,103),(2,105),(4,106),(20,109);
/*!40000 ALTER TABLE `financial_provider_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `international_student`
--

DROP TABLE IF EXISTS `international_student`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `international_student` (
  `user_id` int NOT NULL,
  `passport_id` varchar(30) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uk_intl_student_passport` (`passport_id`),
  CONSTRAINT `fk_intl_student_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `international_student`
--

LOCK TABLES `international_student` WRITE;
/*!40000 ALTER TABLE `international_student` DISABLE KEYS */;
INSERT INTO `international_student` VALUES (76,'P00076'),(77,'P00077'),(78,'P00078'),(79,'P00079'),(80,'P00080'),(81,'P00081'),(82,'P00082'),(83,'P00083'),(84,'P00084'),(85,'P00085'),(86,'P00086'),(87,'P00087'),(88,'P00088'),(89,'P00089'),(90,'P00090');
/*!40000 ALTER TABLE `international_student` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job`
--

DROP TABLE IF EXISTS `job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job` (
  `job_id` int NOT NULL AUTO_INCREMENT,
  `occupation_id` int NOT NULL,
  `proof_of_income` blob,
  PRIMARY KEY (`job_id`),
  KEY `fk_job_occupation` (`occupation_id`),
  CONSTRAINT `fk_job_occupation` FOREIGN KEY (`occupation_id`) REFERENCES `occupation` (`occupation_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job`
--

LOCK TABLES `job` WRITE;
/*!40000 ALTER TABLE `job` DISABLE KEYS */;
INSERT INTO `job` VALUES (1,1,_binary 'PDF'),(2,2,_binary 'PDF'),(3,3,_binary 'PDF'),(4,4,_binary 'PDF'),(5,5,_binary 'PDF'),(6,6,_binary 'PDF'),(7,7,_binary 'PDF'),(8,8,_binary 'PDF'),(9,9,_binary 'PDF'),(10,10,_binary 'PDF'),(11,11,_binary 'PDF'),(12,12,_binary 'PDF'),(13,13,_binary 'PDF'),(14,14,_binary 'PDF'),(15,15,_binary 'PDF'),(16,16,_binary 'PDF'),(17,17,_binary 'PDF'),(18,18,_binary 'PDF'),(19,19,_binary 'PDF'),(20,20,_binary 'PDF'),(21,21,_binary 'PDF'),(22,22,_binary 'PDF'),(23,23,_binary 'PDF'),(24,24,_binary 'PDF'),(25,25,_binary 'PDF'),(26,26,_binary 'PDF'),(27,27,_binary 'PDF'),(28,28,_binary 'PDF'),(29,29,_binary 'PDF'),(30,30,_binary 'PDF'),(31,31,_binary 'PDF'),(32,32,_binary 'PDF'),(33,33,_binary 'PDF'),(34,34,_binary 'PDF'),(35,35,_binary 'PDF'),(36,36,_binary 'PDF'),(37,37,_binary 'PDF'),(38,38,_binary 'PDF'),(39,39,_binary 'PDF'),(40,40,_binary 'PDF'),(41,41,_binary 'PDF'),(42,42,_binary 'PDF'),(43,43,_binary 'PDF'),(44,44,_binary 'PDF'),(45,45,_binary 'PDF'),(46,46,_binary 'PDF'),(47,47,_binary 'PDF'),(48,48,_binary 'PDF'),(49,49,_binary 'PDF'),(50,50,_binary 'PDF');
/*!40000 ALTER TABLE `job` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `landlord`
--

DROP TABLE IF EXISTS `landlord`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `landlord` (
  `user_id` int NOT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `fk_landlord_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `landlord`
--

LOCK TABLES `landlord` WRITE;
/*!40000 ALTER TABLE `landlord` DISABLE KEYS */;
INSERT INTO `landlord` VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12),(13),(14),(15),(16),(17),(18),(19),(20),(21),(22),(23),(24),(25),(26),(27),(28),(29),(30),(31),(32),(33),(34),(35),(36),(37),(38),(39),(40),(41),(42),(43),(44),(45),(46),(47),(48),(49),(50),(51),(52),(53),(54),(55),(56),(57),(58),(59),(60),(111),(113);
/*!40000 ALTER TABLE `landlord` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `neighborhood`
--

DROP TABLE IF EXISTS `neighborhood`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `neighborhood` (
  `neighborhood_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`neighborhood_id`),
  UNIQUE KEY `uk_neighborhood_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `neighborhood`
--

LOCK TABLES `neighborhood` WRITE;
/*!40000 ALTER TABLE `neighborhood` DISABLE KEYS */;
INSERT INTO `neighborhood` VALUES (1,'Neighborhood 1'),(10,'Neighborhood 10'),(11,'Neighborhood 11'),(12,'Neighborhood 12'),(13,'Neighborhood 13'),(14,'Neighborhood 14'),(15,'Neighborhood 15'),(2,'Neighborhood 2'),(3,'Neighborhood 3'),(4,'Neighborhood 4'),(5,'Neighborhood 5'),(6,'Neighborhood 6'),(7,'Neighborhood 7'),(8,'Neighborhood 8'),(9,'Neighborhood 9');
/*!40000 ALTER TABLE `neighborhood` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `occupation`
--

DROP TABLE IF EXISTS `occupation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `occupation` (
  `occupation_id` int NOT NULL AUTO_INCREMENT,
  `occupation_name` varchar(100) NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`occupation_id`),
  KEY `fk_occupation_user` (`user_id`),
  CONSTRAINT `fk_occupation_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `occupation`
--

LOCK TABLES `occupation` WRITE;
/*!40000 ALTER TABLE `occupation` DISABLE KEYS */;
INSERT INTO `occupation` VALUES (1,'Theatre director',61),(2,'Stage manager',62),(3,'Phytotherapist',63),(4,'Seismic interpreter',64),(5,'Medical technical officer',65),(6,'Advertising account executive',66),(7,'Passenger transport manager',67),(8,'Structural engineer',68),(9,'Data scientist',69),(10,'Medical sales representative',70),(11,'Teacher, secondary school',71),(12,'Careers adviser',72),(13,'Hydrographic surveyor',73),(14,'Conservation officer, nature',74),(15,'Scientist, marine',75),(16,'Hotel manager',76),(17,'Research scientist (physical sciences)',77),(18,'Holiday representative',78),(19,'Chief of Staff',79),(20,'Warehouse manager',80),(21,'Surveyor, minerals',81),(22,'Actor',82),(23,'Biomedical scientist',83),(24,'Advice worker',84),(25,'Nurse, adult',85),(26,'Cartographer',86),(27,'Architectural technologist',87),(28,'Chiropodist',88),(29,'Research scientist (medical)',89),(30,'Leisure centre manager',90),(31,'Printmaker',91),(32,'Volunteer coordinator',92),(33,'Engineering geologist',93),(34,'Technical brewer',94),(35,'Contractor',95),(36,'Data processing manager',96),(37,'Printmaker',97),(38,'Journalist, newspaper',98),(39,'Sport and exercise psychologist',99),(40,'Manufacturing systems engineer',100),(41,'Clinical cytogeneticist',101),(42,'Youth worker',102),(43,'Archaeologist',103),(44,'Advertising art director',104),(45,'Engineer, building services',105),(46,'Conference centre manager',106),(47,'Biochemist, clinical',107),(48,'Sales professional, IT',108),(49,'Education officer, museum',109),(50,'Loss adjuster, chartered',110);
/*!40000 ALTER TABLE `occupation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `properties`
--

DROP TABLE IF EXISTS `properties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `properties` (
  `property_id` int NOT NULL AUTO_INCREMENT,
  `street_number` varchar(10) NOT NULL,
  `street_name` varchar(255) NOT NULL,
  `city` varchar(100) NOT NULL,
  `state` varchar(50) NOT NULL,
  `room_number` varchar(20) NOT NULL,
  `square_foot` decimal(10,2) NOT NULL,
  `for_rent` tinyint(1) NOT NULL DEFAULT '1',
  `price` decimal(10,2) NOT NULL,
  `room_amount` int NOT NULL,
  `landlord_id` int NOT NULL,
  PRIMARY KEY (`property_id`),
  UNIQUE KEY `uk_property_address_room` (`street_number`,`street_name`,`city`,`state`,`room_number`),
  KEY `fk_property_landlord` (`landlord_id`),
  CONSTRAINT `fk_property_landlord` FOREIGN KEY (`landlord_id`) REFERENCES `landlord` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=304 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `properties`
--

LOCK TABLES `properties` WRITE;
/*!40000 ALTER TABLE `properties` DISABLE KEYS */;
INSERT INTO `properties` VALUES (1,'2074','Michael Loaf','Philadelphia','PA','A4',1044.80,1,3750.70,1,59),(2,'750','Oliver Streets ','Los Angeles','CA','A8',883.03,0,3377.56,2,7),(3,'205','Alison Springs ','Chicago','IL','A11',1412.98,1,3648.62,3,13),(4,'595','Bryan Trail','San Diego','CA','A16',1094.11,1,1362.68,4,35),(5,'302','Ryan Estate ','Houston','TX','A7',1194.48,1,3973.97,2,40),(6,'66213','Paul Port','New York','NY','A16',559.06,1,2784.09,4,44),(7,'0072','Veronica Park','Los Angeles','CA','A18',1312.17,1,2189.14,4,59),(8,'338','Strickland Avenue','San Antonio','TX','A19',1118.73,1,3594.58,4,20),(9,'2245','Micheal Branch','San Antonio','TX','A11',535.91,1,2498.94,4,59),(10,'6722','Katherine Creek','Phoenix','AZ','A3',1474.95,1,3256.09,3,43),(11,'836','Smith Court ','Philadelphia','PA','A16',524.57,1,1942.60,4,37),(12,'025','Davis Drive','New York','NY','A5',809.32,1,1382.41,3,14),(13,'81380','Lauren Unions','Dallas','TX','A17',702.71,1,2347.38,3,22),(14,'87804','Robert Motorway ','San Diego','CA','A14',1483.44,1,2947.05,3,20),(15,'9868','Rachel Ways','Philadelphia','PA','A16',1041.71,1,3924.27,1,58),(16,'54582','Gould Curve ','San Antonio','TX','A9',740.41,1,2570.74,2,22),(17,'883','Meghan Ford ','Houston','TX','A2',960.92,1,1947.06,1,17),(18,'74113','Colon Trail ','Phoenix','AZ','A6',667.82,1,3204.34,3,30),(19,'1164','Samantha Radial','New York','NY','A16',1036.26,1,2772.12,3,21),(20,'73152','Jackson Point','San Antonio','TX','A16',1367.48,1,3089.29,3,19),(21,'051','Perkins Lock','Philadelphia','PA','A19',507.46,1,1319.81,3,9),(22,'6873','Wilson Ford','San Jose','CA','A6',1150.06,1,2320.68,3,38),(23,'6537','Christina Parkway','San Diego','CA','A15',1319.41,1,1830.47,2,52),(24,'62556','Casey Lock','Dallas','TX','A5',1162.51,1,1355.50,4,11),(25,'4676','Timothy Parks ','New York','NY','A3',740.21,1,3467.51,2,10),(26,'12926','Stephens Street','Los Angeles','CA','A19',1377.92,1,1753.48,2,31),(27,'3912','Velasquez Vista ','Houston','TX','A8',1354.53,1,3917.00,2,23),(28,'649','Jose Mission','San Antonio','TX','A11',1477.25,1,2429.67,2,48),(29,'01614','Dominguez Courts','Los Angeles','CA','A4',1154.97,1,3675.80,4,9),(30,'8698','Barr Forges ','Dallas','TX','A11',576.99,1,3876.93,4,17),(31,'838','Long Locks','San Antonio','TX','A13',897.13,1,3418.50,2,53),(32,'772','Beard Gardens ','New York','NY','A19',1203.90,1,1883.61,3,46),(33,'1892','Williams Corner ','Philadelphia','PA','A4',932.73,1,3588.17,3,56),(34,'275','Meyer Expressway','Philadelphia','PA','A6',694.44,1,3801.89,2,6),(35,'0211','Sheila Crossing','Philadelphia','PA','A13',1115.37,1,1884.39,2,26),(36,'9376','Darrell Route ','New York','NY','A5',652.04,1,3151.78,1,6),(37,'53608','Rachel Inlet ','Phoenix','AZ','A18',781.36,1,2250.84,4,54),(38,'58452','Scott Camp','Los Angeles','CA','A5',1022.64,1,3493.98,1,58),(39,'669','Thomas Track','Dallas','TX','A20',1093.99,1,3692.05,1,58),(40,'371','Charlotte Viaduct ','Chicago','IL','A6',1363.45,1,1208.81,2,13),(41,'877','Cantrell Place','San Diego','CA','A12',1113.73,1,2118.94,2,38),(42,'196','Stephen Point ','New York','NY','A6',1356.62,1,3401.21,3,57),(43,'59328','Danielle Underpass ','Chicago','IL','A5',1327.25,1,1382.56,2,4),(44,'9948','Ricky Knoll','Philadelphia','PA','A2',1401.03,1,1703.46,3,53),(45,'78268','Caleb Parkway','San Antonio','TX','A4',704.35,1,2648.94,1,26),(46,'465','Lauren Canyon ','Houston','TX','A18',814.24,1,1851.65,2,44),(47,'350','Alvarez Squares ','Chicago','IL','A5',791.86,1,2256.31,3,58),(48,'3349','Vanessa Ways ','Philadelphia','PA','A16',843.47,1,3794.70,4,50),(49,'00703','Gomez Spur ','Los Angeles','CA','A9',994.38,1,3486.21,4,10),(50,'0033','Stewart Port','San Diego','CA','A19',728.82,1,2124.81,1,4),(51,'92782','Cross Road','San Antonio','TX','A8',592.06,1,2553.13,3,11),(52,'656','Sheila Harbors','Los Angeles','CA','A12',560.02,1,3898.20,3,17),(53,'2264','Buckley Club','San Antonio','TX','A11',653.69,1,3289.27,2,53),(54,'5218','Carol Port','San Antonio','TX','A19',561.88,1,3600.69,4,20),(55,'605','Carr Club ','San Antonio','TX','A11',1147.61,1,2955.19,4,22),(56,'4373','Samantha Underpass ','San Antonio','TX','A2',917.18,1,2219.12,2,31),(57,'592','Omar Throughway ','San Diego','CA','A8',1159.81,1,2968.14,3,39),(58,'617','Ashley Ranch ','Houston','TX','A4',855.36,1,3421.10,2,47),(59,'4376','Allen Mount','Houston','TX','A7',570.02,1,3121.88,2,58),(60,'8294','Young Station ','Los Angeles','CA','A18',1308.97,1,2167.54,3,55),(61,'83549','Brittany Lakes','San Diego','CA','A18',1353.23,1,2783.95,3,20),(62,'513','Carr Fields ','San Antonio','TX','A15',564.02,1,3522.69,4,11),(63,'868','Gregory Haven ','San Antonio','TX','A15',1279.72,1,2114.73,2,41),(64,'17671','Morales Ridge','New York','NY','A7',618.60,1,3262.81,3,13),(65,'7862','Roth Street','San Diego','CA','A4',711.92,1,1250.04,4,42),(66,'53410','Steven Throughway ','Houston','TX','A15',567.65,1,1928.07,4,6),(67,'5883','Jeff Falls ','Houston','TX','A10',929.56,1,2015.61,2,36),(68,'5903','Brown Forest ','San Antonio','TX','A4',1147.13,1,3648.52,2,14),(69,'93209','Misty Alley','Los Angeles','CA','A6',703.46,1,3555.29,1,22),(70,'58118','Jonathan Mills','New York','NY','A8',881.22,1,3181.78,4,49),(71,'52260','Taylor Spring','Dallas','TX','A18',756.06,1,1732.90,3,12),(72,'6901','Edwards Place','Philadelphia','PA','A14',548.93,1,2786.08,4,31),(73,'5857','Jessica Corners ','San Jose','CA','A19',998.50,1,3940.12,3,10),(74,'133','Garrett Field ','Dallas','TX','A18',590.10,1,3870.37,4,59),(75,'27856','King Crossing','San Antonio','TX','A18',1053.62,1,1259.15,1,50),(76,'507','Howard Expressway','Los Angeles','CA','A2',622.31,1,3001.87,2,8),(77,'177','Harris Harbor','Dallas','TX','A2',543.62,1,3263.56,3,39),(78,'6629','Kathleen Brook','Philadelphia','PA','A17',881.94,1,3876.24,3,45),(79,'872','Michelle Light ','Dallas','TX','A3',672.49,1,2223.77,2,44),(80,'490','Parsons Garden','San Jose','CA','A8',1286.23,1,1664.90,4,27),(81,'30473','Brenda Alley','New York','NY','A11',928.14,1,1510.49,2,13),(82,'45400','Cheryl Road','Dallas','TX','A2',1144.07,1,3662.64,3,39),(83,'968','Perry Terrace','Philadelphia','PA','A5',907.83,1,2443.72,1,36),(84,'35919','Diana Court','Phoenix','AZ','A8',571.74,1,3388.11,4,21),(85,'94036','Haynes Gardens','New York','NY','A1',577.00,1,3043.15,4,22),(86,'745','Wilkerson Motorway','Dallas','TX','A20',1004.02,1,3644.91,2,8),(87,'670','Diaz Walk','San Jose','CA','A18',772.02,1,3985.93,2,20),(88,'84772','Figueroa Knolls ','New York','NY','A14',1196.87,1,3590.05,4,49),(89,'2952','Benjamin Drives','San Jose','CA','A5',787.60,1,2109.95,4,32),(90,'246','Mark Valleys ','San Diego','CA','A13',817.68,1,3615.71,3,50),(91,'1972','Brandon Glen','Dallas','TX','A20',793.54,1,1770.48,2,43),(92,'15162','Jeffery Extension','Dallas','TX','A6',1201.32,1,3694.54,2,43),(93,'91068','Candice Shoal','Philadelphia','PA','A17',933.28,1,1234.13,2,19),(94,'441','Stacy Rest ','San Diego','CA','A10',1035.11,1,1893.42,4,30),(95,'14272','Riggs Knolls ','San Jose','CA','A5',853.96,1,1425.34,2,33),(96,'43152','Sandra Square','San Antonio','TX','A3',1042.25,1,3575.60,1,41),(97,'5843','Hughes Inlet','San Diego','CA','A5',615.78,1,2738.11,1,6),(98,'5559','Regina Knolls ','Houston','TX','A20',1028.30,1,2377.66,2,28),(99,'8084','Johnson Club ','Dallas','TX','A20',1106.30,1,3362.31,4,4),(100,'8302','Monica Lodge ','Philadelphia','PA','A2',912.73,1,2378.28,1,13),(101,'3620','Aguilar Harbor ','Philadelphia','PA','A6',875.30,1,2917.21,2,38),(102,'102','Michael Trail ','Houston','TX','A8',505.13,1,2734.13,3,46),(103,'9827','Fox Brooks','San Antonio','TX','A10',1441.13,1,1363.84,3,28),(104,'693','Beck Mountains','San Antonio','TX','A3',521.24,1,1457.20,1,17),(105,'0374','Hale Streets ','San Jose','CA','A19',795.08,1,1292.85,1,6),(106,'223','Turner Isle','San Antonio','TX','A6',1251.13,1,1970.06,4,4),(107,'60830','Evans Brook','Dallas','TX','A19',525.44,1,2896.63,3,21),(108,'0754','Miller Heights ','San Antonio','TX','A19',1057.71,1,2392.68,1,32),(109,'7885','Snyder Lodge','Phoenix','AZ','A11',829.13,1,2476.42,3,26),(110,'4740','Christopher Mountains ','Houston','TX','A2',878.42,1,1591.87,4,43),(111,'1185','Albert Run','Los Angeles','CA','A3',837.74,1,1633.16,2,54),(112,'0000','Bennett Canyon ','Phoenix','AZ','A3',1263.63,1,1634.61,3,15),(113,'4646','Manning Canyon ','Dallas','TX','A19',1038.91,1,3848.62,1,2),(114,'0735','Martin Pines','New York','NY','A9',1338.31,1,3711.99,3,10),(115,'031','Bennett Plains','Chicago','IL','A2',697.68,1,2920.34,1,52),(116,'0304','Rogers Court','Los Angeles','CA','A10',1179.76,1,2113.83,1,21),(117,'939','Dorothy Glen ','San Jose','CA','A8',559.76,1,1727.68,2,35),(118,'61191','Hoover Isle ','New York','NY','A10',1073.56,1,1292.19,1,18),(119,'9538','Byrd Views','Chicago','IL','A1',1315.85,1,3001.03,3,13),(120,'2755','Leah Skyway ','San Diego','CA','A1',833.99,1,2429.44,4,36),(121,'021','Patel Views','San Antonio','TX','A16',1408.84,1,2901.95,3,5),(122,'39557','Ashley Ways ','New York','NY','A11',1180.65,1,1733.40,1,38),(123,'52466','Dunlap Forks','San Jose','CA','A10',936.93,1,2787.98,2,20),(124,'2005','Coleman Square ','San Antonio','TX','A4',853.55,1,1954.79,3,48),(125,'30020','Julia Extensions','San Antonio','TX','A10',1480.28,1,1571.74,1,49),(126,'099','Ashley Views','Los Angeles','CA','A6',1148.88,1,2179.03,2,21),(127,'0345','Victor Drive ','New York','NY','A19',676.16,1,3854.98,1,20),(128,'7762','Carla Centers','Chicago','IL','A10',691.83,1,3996.92,3,54),(129,'562','Smith Divide','Houston','TX','A10',1350.42,1,1312.70,4,51),(130,'0891','Young Circles','San Antonio','TX','A1',514.25,1,2050.26,3,38),(131,'491','Nicholas Springs ','San Diego','CA','A10',1297.68,1,3337.76,2,20),(132,'44318','Amanda Mountains','New York','NY','A14',1422.68,1,2626.29,4,50),(133,'514','Morris Run ','San Jose','CA','A9',757.30,1,3031.02,4,56),(134,'9071','Young Pines ','San Antonio','TX','A19',804.51,1,2210.35,3,17),(135,'6913','Rebecca Bridge ','New York','NY','A4',692.79,1,3211.52,1,6),(136,'3641','Andersen Mountains ','San Jose','CA','A6',1174.71,1,3754.17,3,26),(137,'463','Jeffery Fort ','Chicago','IL','A9',618.09,1,2829.81,1,50),(138,'5803','Brian Haven','New York','NY','A14',896.47,1,2296.28,3,20),(139,'943','Ray Rest','Dallas','TX','A2',833.66,1,2233.56,2,39),(140,'373','Shepard Lake ','Phoenix','AZ','A5',650.71,1,3475.32,1,57),(141,'116','Dwayne Flat ','Chicago','IL','A14',512.54,1,3914.32,4,28),(142,'59069','Patricia Squares','Houston','TX','A10',729.00,1,2750.47,2,7),(143,'09069','Jenkins Rue','San Antonio','TX','A5',789.29,1,2089.47,2,47),(144,'89735','Schwartz Corner ','Phoenix','AZ','A18',919.49,1,3247.83,4,30),(145,'358','Singleton Lights','Phoenix','AZ','A8',1412.99,1,1224.39,4,52),(146,'1369','Renee Parkways ','Chicago','IL','A11',730.49,1,3062.20,3,59),(147,'30403','Torres Plain ','San Antonio','TX','A19',616.97,1,3285.44,1,15),(148,'09942','Smith Brook','San Antonio','TX','A13',1493.18,1,1206.73,4,32),(149,'21017','Melissa Club','San Jose','CA','A19',657.35,1,3944.22,3,25),(150,'260','Stephanie Garden','San Antonio','TX','A12',1126.49,1,1957.51,2,32),(151,'13757','Wood Extension ','San Diego','CA','A17',1176.55,1,3744.34,1,12),(152,'529','Lee Mountains ','Phoenix','AZ','A11',592.14,1,2369.01,4,48),(153,'1736','Randolph Radial ','San Jose','CA','A7',580.58,1,3378.36,4,8),(154,'169','Valdez Stravenue','Dallas','TX','A10',938.48,1,3725.96,1,16),(155,'465','Taylor Estate','Phoenix','AZ','A15',755.72,1,2154.37,2,56),(156,'72361','Robin Station ','Phoenix','AZ','A16',1134.02,1,3907.19,1,50),(157,'65392','Ruiz Mission ','San Diego','CA','A16',836.08,1,2323.20,2,17),(158,'75520','Stacey Rest','San Jose','CA','A3',1391.71,1,3182.89,4,44),(159,'6712','Carter Trail ','San Diego','CA','A16',1437.73,1,2835.12,2,36),(160,'90474','Smith Trace ','New York','NY','A20',1197.83,1,2816.84,3,37),(161,'846','Taylor Harbors','San Antonio','TX','A2',858.45,1,3005.75,4,45),(162,'543','Kimberly Mall ','San Antonio','TX','A17',1111.39,1,2016.97,2,21),(163,'77531','Sloan Greens','Chicago','IL','A15',742.66,1,3131.20,4,60),(164,'363','Walker Locks','New York','NY','A1',832.40,1,3794.11,3,53),(165,'5928','Wade Views','Philadelphia','PA','A13',1475.30,1,2932.83,1,15),(166,'33078','Jessica Plains','Dallas','TX','A19',704.73,1,1237.08,3,14),(167,'3523','Perez Rapids ','San Diego','CA','A19',899.20,1,1971.54,1,14),(168,'14622','Reyes Isle ','San Diego','CA','A5',1134.42,1,3687.28,2,53),(169,'9851','Scott Burgs','San Jose','CA','A9',1271.19,1,3155.57,4,11),(170,'4590','Johnson Underpass ','New York','NY','A12',1258.14,1,3466.71,3,57),(171,'8468','Norris Way','Philadelphia','PA','A18',1030.30,1,3917.97,1,1),(172,'379','Hensley Parkways','Los Angeles','CA','A2',1412.22,1,2463.02,3,26),(173,'64438','Miller Corners','Houston','TX','A14',1345.96,1,3328.32,1,12),(174,'77482','Christopher Pass ','Houston','TX','A19',625.16,1,1940.45,1,52),(175,'09796','Adams Ports','Dallas','TX','A20',793.96,1,3638.54,4,30),(176,'4621','Lindsey Plain ','San Diego','CA','A10',937.48,1,3196.78,1,24),(177,'2402','Paul Springs','San Antonio','TX','A19',697.97,1,3628.80,4,38),(178,'101','Kimberly Row','Philadelphia','PA','A10',1421.83,1,1356.07,2,39),(179,'8581','Baxter Place ','Dallas','TX','A8',1281.43,1,3604.43,1,39),(180,'538','Sara Curve ','Phoenix','AZ','A1',563.87,1,1736.52,3,47),(181,'31245','Ruben Pine ','Dallas','TX','A10',1130.11,1,2638.88,4,40),(182,'070','Matthew Via','Dallas','TX','A2',973.48,1,1700.77,2,50),(183,'2174','Anderson Green ','Los Angeles','CA','A1',743.02,1,3762.83,2,20),(184,'647','Kelsey Vista ','Philadelphia','PA','A19',1119.79,1,3661.75,2,7),(185,'09426','William Causeway ','Houston','TX','A1',835.66,1,2718.51,3,1),(186,'16826','Scott Plaza','Dallas','TX','A11',1248.66,1,2714.92,3,28),(187,'3706','Donald Shore ','Dallas','TX','A16',1226.32,1,3284.37,1,32),(188,'65589','Tammy Points','Houston','TX','A11',964.06,1,3831.74,4,40),(189,'69310','Clark Branch ','San Jose','CA','A12',1350.43,1,1807.21,4,8),(190,'44839','Valdez Passage','San Jose','CA','A18',1312.49,1,3635.38,2,2),(191,'22426','Tammy Port','Los Angeles','CA','A13',669.18,1,3451.94,4,50),(192,'06593','Madison Ramp ','New York','NY','A2',1462.13,1,1924.84,3,4),(193,'113','Ashley Mountains','Los Angeles','CA','A11',556.99,1,2080.95,4,53),(194,'8101','Heather Expressway ','Phoenix','AZ','A6',1088.86,1,2846.11,2,27),(195,'1969','Andrew Views ','Los Angeles','CA','A17',1008.27,1,3369.11,4,33),(196,'303','Lisa Plains','San Diego','CA','A12',618.75,1,2887.08,2,14),(197,'3439','Adam Unions','San Antonio','TX','A15',985.26,1,3905.84,4,18),(198,'13886','Daniel Well','San Antonio','TX','A8',1080.27,1,1892.50,2,8),(199,'456','Young Stream ','Phoenix','AZ','A1',963.56,1,3789.83,1,11),(200,'35015','Roberts Mall ','San Jose','CA','A10',1039.86,1,2208.20,2,34),(201,'518','Washington Turnpike ','Philadelphia','PA','A7',821.52,1,2529.21,3,22),(202,'72166','Dylan Ridges','Chicago','IL','A16',1425.61,1,2498.10,2,56),(203,'132','Fernandez Radial','Los Angeles','CA','A10',1207.80,1,2418.43,1,21),(204,'15246','Delgado Place','Houston','TX','A15',1262.65,1,3671.74,4,1),(205,'95026','Christian Mountains ','Los Angeles','CA','A6',1346.57,1,1687.22,4,52),(206,'2484','Christopher Coves ','Dallas','TX','A18',1352.62,1,3211.31,4,6),(207,'35789','Maddox Keys','San Jose','CA','A13',714.86,1,3717.42,2,51),(208,'99214','Lisa Ramp','Houston','TX','A6',1484.71,1,1700.05,2,15),(209,'91472','Deanna Lights ','San Antonio','TX','A1',995.27,1,3997.15,2,33),(210,'5359','Jessica Mountains ','San Antonio','TX','A8',1300.57,1,3914.37,1,4),(211,'58367','Jason Vista ','San Antonio','TX','A7',636.07,1,2642.71,3,18),(212,'70500','Andrea Ridges ','San Jose','CA','A14',919.27,1,3772.45,3,13),(213,'4568','Sharon Rapid ','Los Angeles','CA','A11',674.28,1,3372.36,3,7),(214,'16265','Alyssa Road','San Diego','CA','A5',1473.10,1,3859.86,1,37),(215,'435','Smith Plaza','Los Angeles','CA','A3',1359.47,1,3457.87,2,40),(216,'980','Ellis Summit ','New York','NY','A2',503.06,1,1844.60,4,12),(217,'04339','Richard Junction','Los Angeles','CA','A18',822.13,1,1980.22,1,29),(218,'099','Paul Island','Phoenix','AZ','A18',509.92,1,1751.85,4,52),(219,'195','Chase Grove','San Jose','CA','A10',1231.58,1,1657.58,4,33),(220,'11057','Robertson Vista','San Diego','CA','A15',642.45,1,1743.70,1,5),(221,'665','Richard Corners ','Houston','TX','A8',847.86,1,2408.89,2,53),(222,'68427','Adams Stream','New York','NY','A1',794.33,1,3282.49,3,36),(223,'27194','King Turnpike ','Dallas','TX','A9',1124.31,1,2534.78,4,21),(224,'858','Erin Drive ','Houston','TX','A3',1486.11,1,2253.01,2,32),(225,'893','Contreras Rapids','Houston','TX','A7',747.97,1,2589.72,1,26),(226,'399','Eric Common','Chicago','IL','A6',1448.19,1,2212.48,4,32),(227,'097','Scott Corners','Phoenix','AZ','A10',1356.89,1,3938.95,2,14),(228,'3716','Angela Avenue','Houston','TX','A18',1025.70,1,3906.53,3,6),(229,'907','Hernandez Meadows ','Chicago','IL','A10',534.49,1,3553.85,1,49),(230,'12821','Shea Skyway','San Antonio','TX','A12',935.66,1,2297.44,2,8),(231,'8900','Harris Summit','Phoenix','AZ','A20',529.02,1,2966.13,2,6),(232,'973','Richards Curve','Chicago','IL','A2',934.80,1,2837.34,2,21),(233,'51448','Williams Vista','San Antonio','TX','A12',1389.02,1,2272.16,2,5),(234,'816','Juan Hill','Chicago','IL','A19',1125.70,1,1403.20,1,50),(235,'827','Katelyn Stream ','San Antonio','TX','A17',1102.69,1,1469.04,3,36),(236,'64139','Madden Glen ','Chicago','IL','A16',1113.94,1,2742.88,2,24),(237,'6049','Matthew Tunnel','Philadelphia','PA','A6',542.88,1,3719.44,3,37),(238,'92640','Williams Ferry','San Antonio','TX','A19',872.20,1,3539.70,3,52),(239,'31059','Jonathan Locks','Philadelphia','PA','A7',929.58,1,2165.69,3,36),(240,'746','Miller Glens','Houston','TX','A2',1493.75,1,2787.32,3,39),(241,'585','Jenna Circles','Houston','TX','A13',1332.77,1,2854.61,2,46),(242,'94400','Hill Rest ','Phoenix','AZ','A8',1212.08,1,3991.06,1,41),(243,'546','Tracey Drive ','Houston','TX','A13',786.72,1,3489.13,1,34),(244,'759','Jones Valley','Philadelphia','PA','A7',1359.37,1,1843.45,3,4),(245,'0003','Julia Gardens ','San Antonio','TX','A2',1018.96,1,2553.30,1,32),(246,'32100','Donald Causeway ','Dallas','TX','A3',596.30,1,3489.95,1,42),(247,'15456','Dustin Brooks ','Houston','TX','A3',1421.71,1,3926.75,4,14),(248,'58260','Garcia Vista ','Phoenix','AZ','A5',1313.72,1,2009.93,3,25),(249,'74917','James Terrace ','New York','NY','A20',559.57,1,2100.06,1,1),(250,'79180','Aguirre Hills','Dallas','TX','A18',1421.35,1,2470.33,2,56),(251,'406','Bailey Rue ','Chicago','IL','A13',877.22,1,3862.19,2,4),(252,'83372','Ortega Center','Los Angeles','CA','A2',1413.88,1,3763.43,3,19),(253,'78297','Tran Throughway','Los Angeles','CA','A1',1222.44,1,3891.56,4,15),(254,'017','Yates Pike','San Diego','CA','A4',1112.87,1,1831.96,1,21),(255,'730','Cody Spring ','Philadelphia','PA','A3',624.38,1,3778.17,1,2),(256,'518','Martinez Lake','Philadelphia','PA','A6',533.79,1,2727.98,4,21),(257,'44663','Newton Villages','Los Angeles','CA','A14',992.11,1,3598.29,1,34),(258,'382','Carrie Springs ','Dallas','TX','A18',1327.28,1,3071.48,2,15),(259,'1784','Acosta Fall ','Philadelphia','PA','A12',1228.01,1,3868.29,1,54),(260,'118','Chad Motorway','Phoenix','AZ','A14',1092.62,1,2375.69,3,1),(261,'271','Steven Road','San Diego','CA','A12',1373.55,1,3763.54,3,24),(262,'904','Mack Lakes','San Jose','CA','A2',839.07,1,1741.45,1,54),(263,'8720','Nicholas Crest','Phoenix','AZ','A2',587.88,1,1908.57,3,25),(264,'080','Kellie Highway','Los Angeles','CA','A16',523.05,1,3164.74,1,20),(265,'680','Martin Mills','Los Angeles','CA','A4',594.49,1,3615.10,3,5),(266,'742','Daniel Mountains','Philadelphia','PA','A15',1419.48,1,2616.10,3,59),(267,'91058','Maxwell Pine ','Houston','TX','A12',781.76,1,1502.44,4,30),(268,'8647','Sara Inlet','Philadelphia','PA','A16',819.60,1,3068.03,4,37),(269,'10668','Adam Parks ','Phoenix','AZ','A18',618.42,1,3163.17,2,36),(270,'085','Chandler Manor ','Phoenix','AZ','A6',1482.29,1,3693.86,2,25),(271,'84093','Marshall Park ','Los Angeles','CA','A13',1463.81,1,1633.60,3,42),(272,'2482','Joshua Court ','Dallas','TX','A2',851.86,1,2245.36,1,21),(273,'0692','Ronald Ville ','New York','NY','A7',582.09,1,2718.78,4,48),(274,'495','Lewis Squares ','San Antonio','TX','A4',1478.52,1,3323.95,4,45),(275,'55357','Kayla Rest','Dallas','TX','A18',671.72,1,3947.22,3,25),(276,'180','Joseph Knolls','Philadelphia','PA','A17',881.32,1,1348.74,1,36),(277,'99111','Dixon Turnpike ','Phoenix','AZ','A19',827.83,1,1786.99,3,28),(278,'3275','Lindsey Expressway','Chicago','IL','A9',1412.22,1,2267.80,3,26),(279,'8549','Alicia Ridges','San Antonio','TX','A17',1343.46,1,3861.93,2,59),(280,'4328','Taylor Neck ','Chicago','IL','A19',679.03,1,1579.24,4,52),(281,'33798','Alejandra Trafficway ','New York','NY','A4',1446.48,1,1905.11,3,15),(282,'9839','Myers Key ','Houston','TX','A1',1379.52,1,1275.19,4,5),(283,'300','Sandra Mountain','San Diego','CA','A6',1490.24,1,3185.64,3,59),(284,'564','Erik Isle ','Phoenix','AZ','A19',1423.24,1,1699.45,2,34),(285,'725','Megan Crossroad ','Dallas','TX','A8',1177.83,1,2324.22,2,25),(286,'2715','Cruz Village','Houston','TX','A16',801.63,1,3344.89,3,17),(287,'38192','Christina Skyway','Philadelphia','PA','A7',800.22,1,1283.38,3,29),(288,'5180','Frank Cliff ','Dallas','TX','A2',841.60,1,3539.81,4,45),(289,'085','Jason Crest ','San Diego','CA','A4',903.29,1,1523.91,4,45),(290,'4238','Brenda Ports ','Phoenix','AZ','A20',1088.27,1,3320.33,1,28),(291,'98342','Wilson Knoll','New York','NY','A11',1358.03,1,3178.83,2,19),(292,'8743','Monique Branch ','Houston','TX','A7',732.72,1,2864.79,2,53),(293,'351','Danielle Burg ','Philadelphia','PA','A20',1235.81,1,2365.03,4,57),(294,'204','Arnold Path ','Dallas','TX','A8',650.26,1,2094.72,1,4),(295,'599','Walsh Harbor ','Los Angeles','CA','A4',1147.84,1,1784.53,3,34),(296,'91255','Harris Canyon','New York','NY','A3',515.64,1,2268.59,4,37),(297,'7416','Gonzalez Rapid ','San Diego','CA','A13',1021.29,1,2083.73,2,60),(298,'5374','Andrews Knolls ','San Jose','CA','A6',947.79,1,3493.00,4,5),(299,'57547','Huerta Green ','San Diego','CA','A3',789.11,1,2292.56,2,24),(300,'1085','Jennifer Pine','San Diego','CA','A4',1358.86,1,2152.49,2,52);
/*!40000 ALTER TABLE `properties` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `property_neighborhood`
--

DROP TABLE IF EXISTS `property_neighborhood`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `property_neighborhood` (
  `property_id` int NOT NULL,
  `neighborhood_id` int NOT NULL,
  PRIMARY KEY (`property_id`,`neighborhood_id`),
  KEY `fk_property_neighborhood_neighborhood` (`neighborhood_id`),
  CONSTRAINT `fk_property_neighborhood_neighborhood` FOREIGN KEY (`neighborhood_id`) REFERENCES `neighborhood` (`neighborhood_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_property_neighborhood_property` FOREIGN KEY (`property_id`) REFERENCES `properties` (`property_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `property_neighborhood`
--

LOCK TABLES `property_neighborhood` WRITE;
/*!40000 ALTER TABLE `property_neighborhood` DISABLE KEYS */;
INSERT INTO `property_neighborhood` VALUES (2,1),(30,1),(44,1),(56,1),(91,1),(184,1),(196,1),(205,1),(208,1),(221,1),(231,1),(240,1),(245,1),(264,1),(272,1),(279,1),(286,1),(287,1),(289,1),(42,2),(54,2),(89,2),(94,2),(179,2),(183,2),(185,2),(227,2),(230,2),(235,2),(265,2),(22,3),(27,3),(64,3),(76,3),(102,3),(103,3),(104,3),(114,3),(120,3),(129,3),(149,3),(157,3),(202,3),(247,3),(251,3),(260,3),(262,3),(293,3),(298,3),(12,4),(48,4),(51,4),(84,4),(98,4),(125,4),(133,4),(135,4),(193,4),(214,4),(261,4),(263,4),(282,4),(74,5),(86,5),(101,5),(116,5),(122,5),(137,5),(151,5),(177,5),(181,5),(186,5),(199,5),(211,5),(217,5),(232,5),(234,5),(246,5),(295,5),(296,5),(17,6),(49,6),(58,6),(65,6),(66,6),(96,6),(121,6),(124,6),(130,6),(136,6),(160,6),(165,6),(166,6),(168,6),(169,6),(171,6),(176,6),(198,6),(210,6),(213,6),(238,6),(239,6),(241,6),(255,6),(259,6),(21,7),(31,7),(55,7),(68,7),(83,7),(90,7),(119,7),(127,7),(154,7),(163,7),(178,7),(190,7),(209,7),(218,7),(219,7),(220,7),(228,7),(274,7),(276,7),(8,8),(9,8),(19,8),(26,8),(34,8),(35,8),(41,8),(53,8),(70,8),(77,8),(82,8),(150,8),(162,8),(175,8),(212,8),(237,8),(252,8),(254,8),(281,8),(292,8),(294,8),(300,8),(18,9),(20,9),(24,9),(29,9),(32,9),(63,9),(131,9),(138,9),(140,9),(197,9),(206,9),(223,9),(249,9),(258,9),(269,9),(284,9),(291,9),(36,10),(38,10),(62,10),(75,10),(81,10),(88,10),(113,10),(132,10),(134,10),(142,10),(143,10),(145,10),(158,10),(172,10),(180,10),(187,10),(203,10),(207,10),(224,10),(233,10),(250,10),(277,10),(11,11),(15,11),(23,11),(46,11),(73,11),(87,11),(141,11),(144,11),(146,11),(152,11),(153,11),(156,11),(170,11),(174,11),(200,11),(201,11),(215,11),(222,11),(229,11),(256,11),(278,11),(4,12),(10,12),(25,12),(28,12),(33,12),(45,12),(60,12),(69,12),(97,12),(107,12),(115,12),(117,12),(126,12),(182,12),(188,12),(191,12),(195,12),(225,12),(244,12),(248,12),(253,12),(271,12),(288,12),(299,12),(1,13),(6,13),(13,13),(37,13),(40,13),(52,13),(61,13),(67,13),(79,13),(92,13),(93,13),(99,13),(100,13),(108,13),(110,13),(111,13),(118,13),(139,13),(147,13),(167,13),(216,13),(257,13),(268,13),(270,13),(283,13),(3,14),(16,14),(39,14),(43,14),(47,14),(50,14),(59,14),(71,14),(78,14),(95,14),(105,14),(106,14),(128,14),(148,14),(155,14),(173,14),(194,14),(204,14),(275,14),(297,14),(5,15),(7,15),(14,15),(57,15),(72,15),(80,15),(85,15),(109,15),(112,15),(123,15),(159,15),(161,15),(164,15),(189,15),(192,15),(226,15),(236,15),(242,15),(243,15),(266,15),(267,15),(273,15),(280,15),(285,15),(290,15);
/*!40000 ALTER TABLE `property_neighborhood` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `public_transport_station`
--

DROP TABLE IF EXISTS `public_transport_station`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `public_transport_station` (
  `station_id` int NOT NULL AUTO_INCREMENT,
  `neighborhood_id` int NOT NULL,
  `station_type` enum('subway','bus') NOT NULL,
  PRIMARY KEY (`station_id`),
  KEY `fk_station_neighborhood` (`neighborhood_id`),
  CONSTRAINT `fk_station_neighborhood` FOREIGN KEY (`neighborhood_id`) REFERENCES `neighborhood` (`neighborhood_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `public_transport_station`
--

LOCK TABLES `public_transport_station` WRITE;
/*!40000 ALTER TABLE `public_transport_station` DISABLE KEYS */;
INSERT INTO `public_transport_station` VALUES (1,11,'bus'),(2,11,'bus'),(3,10,'subway'),(4,15,'subway'),(5,10,'subway'),(6,5,'subway'),(7,12,'bus'),(8,15,'bus'),(9,5,'subway'),(10,1,'subway');
/*!40000 ALTER TABLE `public_transport_station` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rent`
--

DROP TABLE IF EXISTS `rent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rent` (
  `rent_id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `property_id` int NOT NULL,
  `contract_length` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `broker_fee` decimal(10,2) DEFAULT NULL,
  `broker_id` int DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  PRIMARY KEY (`rent_id`),
  UNIQUE KEY `uk_tenant_property_date` (`tenant_id`,`property_id`,`start_date`),
  KEY `fk_rent_property` (`property_id`),
  KEY `fk_rent_broker` (`broker_id`),
  CONSTRAINT `fk_rent_broker` FOREIGN KEY (`broker_id`) REFERENCES `broker` (`broker_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_rent_property` FOREIGN KEY (`property_id`) REFERENCES `properties` (`property_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_rent_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rent`
--

LOCK TABLES `rent` WRITE;
/*!40000 ALTER TABLE `rent` DISABLE KEYS */;
INSERT INTO `rent` VALUES (1,105,290,12,2000.00,100.00,9,'2023-01-01','2024-01-01'),(2,76,224,12,2000.00,100.00,8,'2023-01-01','2024-01-01'),(3,108,174,12,2000.00,100.00,9,'2023-01-01','2024-01-01'),(4,97,109,12,2000.00,100.00,6,'2023-01-01','2024-01-01'),(5,87,237,12,2000.00,100.00,5,'2023-01-01','2024-01-01'),(6,82,247,12,2000.00,100.00,2,'2023-01-01','2024-01-01'),(7,70,239,12,2000.00,100.00,9,'2023-01-01','2024-01-01'),(8,88,117,12,2000.00,100.00,4,'2023-01-01','2024-01-01'),(9,74,4,12,2000.00,100.00,7,'2023-01-01','2024-01-01'),(10,103,164,12,2000.00,100.00,9,'2023-01-01','2024-01-01'),(11,76,100,12,2000.00,100.00,10,'2023-01-01','2024-01-01'),(12,85,129,12,2000.00,100.00,7,'2023-01-01','2024-01-01'),(13,90,288,12,2000.00,100.00,9,'2023-01-01','2024-01-01'),(14,86,206,12,2000.00,100.00,3,'2023-01-01','2024-01-01'),(15,78,82,12,2000.00,100.00,5,'2023-01-01','2024-01-01'),(16,98,285,12,2000.00,100.00,1,'2023-01-01','2024-01-01'),(17,67,248,12,2000.00,100.00,5,'2023-01-01','2024-01-01'),(18,94,9,12,2000.00,100.00,5,'2023-01-01','2024-01-01'),(19,105,139,12,2000.00,100.00,6,'2023-01-01','2024-01-01'),(20,90,91,12,2000.00,100.00,3,'2023-01-01','2024-01-01'),(21,82,89,12,2000.00,100.00,6,'2023-01-01','2024-01-01'),(22,90,137,12,2000.00,100.00,9,'2023-01-01','2024-01-01'),(23,93,38,12,2000.00,100.00,3,'2023-01-01','2024-01-01'),(24,61,45,12,2000.00,100.00,1,'2023-01-01','2024-01-01'),(25,80,142,12,2000.00,100.00,1,'2023-01-01','2024-01-01'),(26,93,82,12,2000.00,100.00,6,'2023-01-01','2024-01-01'),(27,100,247,12,2000.00,100.00,6,'2023-01-01','2024-01-01'),(28,89,63,12,2000.00,100.00,10,'2023-01-01','2024-01-01'),(29,90,194,12,2000.00,100.00,8,'2023-01-01','2024-01-01'),(30,68,148,12,2000.00,100.00,1,'2023-01-01','2024-01-01'),(31,109,119,12,2000.00,100.00,4,'2023-01-01','2024-01-01'),(32,102,79,12,2000.00,100.00,9,'2023-01-01','2024-01-01'),(33,79,5,12,2000.00,100.00,10,'2023-01-01','2024-01-01'),(34,61,95,12,2000.00,100.00,3,'2023-01-01','2024-01-01'),(35,96,224,12,2000.00,100.00,4,'2023-01-01','2024-01-01'),(36,105,83,12,2000.00,100.00,7,'2023-01-01','2024-01-01'),(37,83,275,12,2000.00,100.00,7,'2023-01-01','2024-01-01'),(38,81,270,12,2000.00,100.00,4,'2023-01-01','2024-01-01'),(39,92,243,12,2000.00,100.00,2,'2023-01-01','2024-01-01'),(40,104,164,12,2000.00,100.00,10,'2023-01-01','2024-01-01'),(41,105,41,12,2000.00,100.00,5,'2023-01-01','2024-01-01'),(42,103,294,12,2000.00,100.00,3,'2023-01-01','2024-01-01'),(43,69,288,12,2000.00,100.00,1,'2023-01-01','2024-01-01'),(44,69,13,12,2000.00,100.00,6,'2023-01-01','2024-01-01'),(45,104,133,12,2000.00,100.00,5,'2023-01-01','2024-01-01'),(46,63,181,12,2000.00,100.00,9,'2023-01-01','2024-01-01'),(47,64,271,12,2000.00,100.00,1,'2023-01-01','2024-01-01'),(48,87,149,12,2000.00,100.00,7,'2023-01-01','2024-01-01'),(49,103,138,12,2000.00,100.00,10,'2023-01-01','2024-01-01'),(50,97,71,12,2000.00,100.00,4,'2023-01-01','2024-01-01'),(51,111,2,3,3377.56,NULL,NULL,'2025-04-17','2025-07-16');
/*!40000 ALTER TABLE `rent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `restaurant`
--

DROP TABLE IF EXISTS `restaurant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `restaurant` (
  `restaurant_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `street_number` varchar(20) NOT NULL,
  `street_name` varchar(100) NOT NULL,
  `city` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `neighborhood_id` int NOT NULL,
  PRIMARY KEY (`restaurant_id`),
  UNIQUE KEY `uk_restaurant_address` (`street_number`,`street_name`,`city`,`state`),
  KEY `fk_restaurant_neighborhood` (`neighborhood_id`),
  CONSTRAINT `fk_restaurant_neighborhood` FOREIGN KEY (`neighborhood_id`) REFERENCES `neighborhood` (`neighborhood_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurant`
--

LOCK TABLES `restaurant` WRITE;
/*!40000 ALTER TABLE `restaurant` DISABLE KEYS */;
INSERT INTO `restaurant` VALUES (1,'Martin-Krause','701','Jessica Vista','Rodneytown','Colorado',11),(2,'Vaughan-Bailey','523','Rios Street','Macdonaldbury','West Virginia',11),(3,'Hansen-King','1040','Hatfield Pine','East Chadshire','Connecticut',10),(4,'Rangel Group','71748','Sara Junction','Lake Derrickshire','Hawaii',15),(5,'Brooks-Gibbs','80101','Atkins Courts','East Lindachester','Rhode Island',10),(6,'Watson-Hernandez','073','Sharon Cliffs','East Margaret','Florida',5),(7,'Sullivan-Moreno','70170','Lisa Centers','Camposborough','Kentucky',12),(8,'Williams LLC','658','Welch Locks','Carriestad','New Mexico',15),(9,'Mcintyre-Atkinson','1072','Sandra Knoll','South Antoniomouth','South Carolina',5),(10,'Jones Group','44940','David Parkways','Port Mariaville','Arkansas',1);
/*!40000 ALTER TABLE `restaurant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student`
--

DROP TABLE IF EXISTS `student`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student` (
  `user_id` int NOT NULL,
  `transcript` blob,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `fk_student_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student`
--

LOCK TABLES `student` WRITE;
/*!40000 ALTER TABLE `student` DISABLE KEYS */;
INSERT INTO `student` VALUES (76,_binary 'PDF'),(77,_binary 'PDF'),(78,_binary 'PDF'),(79,_binary 'PDF'),(80,_binary 'PDF'),(81,_binary 'PDF'),(82,_binary 'PDF'),(83,_binary 'PDF'),(84,_binary 'PDF'),(85,_binary 'PDF'),(86,_binary 'PDF'),(87,_binary 'PDF'),(88,_binary 'PDF'),(89,_binary 'PDF'),(90,_binary 'PDF'),(91,_binary 'PDF'),(92,_binary 'PDF'),(93,_binary 'PDF'),(94,_binary 'PDF'),(95,_binary 'PDF'),(96,_binary 'PDF'),(97,_binary 'PDF'),(98,_binary 'PDF'),(99,_binary 'PDF'),(100,_binary 'PDF'),(101,_binary 'PDF'),(102,_binary 'PDF'),(103,_binary 'PDF'),(104,_binary 'PDF'),(105,_binary 'PDF'),(106,_binary 'PDF'),(107,_binary 'PDF'),(108,_binary 'PDF'),(109,_binary 'PDF'),(110,_binary 'PDF');
/*!40000 ALTER TABLE `student` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subway`
--

DROP TABLE IF EXISTS `subway`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subway` (
  `subway_id` int NOT NULL AUTO_INCREMENT,
  `vehicle_license` varchar(20) NOT NULL,
  `color` varchar(30) NOT NULL,
  `station_id` int NOT NULL,
  PRIMARY KEY (`subway_id`),
  UNIQUE KEY `uk_subway_license` (`vehicle_license`),
  KEY `fk_subway_to_station` (`station_id`),
  CONSTRAINT `fk_subway_to_station` FOREIGN KEY (`station_id`) REFERENCES `subway_station` (`station_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subway`
--

LOCK TABLES `subway` WRITE;
/*!40000 ALTER TABLE `subway` DISABLE KEYS */;
INSERT INTO `subway` VALUES (3,'S-3','Red',3),(4,'S-4','Red',4),(5,'S-5','Red',5),(6,'S-6','Red',6),(9,'S-9','Red',9),(10,'S-10','Red',10);
/*!40000 ALTER TABLE `subway` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subway_station`
--

DROP TABLE IF EXISTS `subway_station`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subway_station` (
  `station_id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`station_id`),
  UNIQUE KEY `uk_subway_station_name` (`name`),
  CONSTRAINT `fk_subway_station` FOREIGN KEY (`station_id`) REFERENCES `public_transport_station` (`station_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subway_station`
--

LOCK TABLES `subway_station` WRITE;
/*!40000 ALTER TABLE `subway_station` DISABLE KEYS */;
INSERT INTO `subway_station` VALUES (10,'Subway Station 10'),(3,'Subway Station 3'),(4,'Subway Station 4'),(5,'Subway Station 5'),(6,'Subway Station 6'),(9,'Subway Station 9');
/*!40000 ALTER TABLE `subway_station` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tenant`
--

DROP TABLE IF EXISTS `tenant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tenant` (
  `user_id` int NOT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `fk_tenant_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tenant`
--

LOCK TABLES `tenant` WRITE;
/*!40000 ALTER TABLE `tenant` DISABLE KEYS */;
INSERT INTO `tenant` VALUES (61),(62),(63),(64),(65),(66),(67),(68),(69),(70),(71),(72),(73),(74),(75),(76),(77),(78),(79),(80),(81),(82),(83),(84),(85),(86),(87),(88),(89),(90),(91),(92),(93),(94),(95),(96),(97),(98),(99),(100),(101),(102),(103),(104),(105),(106),(107),(108),(109),(110),(111);
/*!40000 ALTER TABLE `tenant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `us_citizen`
--

DROP TABLE IF EXISTS `us_citizen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `us_citizen` (
  `user_id` int NOT NULL,
  `ssn` varchar(11) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uk_us_citizen_ssn` (`ssn`),
  CONSTRAINT `fk_us_citizen_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `us_citizen`
--

LOCK TABLES `us_citizen` WRITE;
/*!40000 ALTER TABLE `us_citizen` DISABLE KEYS */;
INSERT INTO `us_citizen` VALUES (71,'136-71-4938'),(72,'188-62-3985'),(73,'271-48-2841'),(68,'367-82-5866'),(74,'375-23-4418'),(67,'452-13-6094'),(70,'492-57-3698'),(63,'567-61-1517'),(69,'599-33-8419'),(75,'780-15-6524'),(61,'785-90-8004'),(64,'835-10-4788'),(66,'867-41-3105'),(65,'965-70-6017'),(62,'992-43-4918');
/*!40000 ALTER TABLE `us_citizen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `auth_id` int NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `phone` varchar(30) NOT NULL,
  `email` varchar(100) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uk_user_phone` (`phone`),
  UNIQUE KEY `uk_user_email` (`email`),
  KEY `fk_user_auth` (`auth_id`),
  CONSTRAINT `fk_user_auth` FOREIGN KEY (`auth_id`) REFERENCES `user_auth` (`auth_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=114 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,1,'Nathan','Barnes','766-341-7399','user1@example.com'),(2,2,'Juan','Robertson','844.165.0929x89283','user2@example.com'),(3,3,'Sonya','Blanchard','528.960.1692','user3@example.com'),(4,4,'Ryan','Moore','+1-725-836-5277x7425','user4@example.com'),(5,5,'Kent','Jefferson','616.724.2869','user5@example.com'),(6,6,'Carolyn','Tyler','(498)931-7088x0580','user6@example.com'),(7,7,'Daniel','Shields','783-144-2771x480','user7@example.com'),(8,8,'Benjamin','Hill','8820031806','user8@example.com'),(9,9,'Austin','Hoffman','001-954-027-8080','user9@example.com'),(10,10,'Dana','Montgomery','001-461-703-7191x4794','user10@example.com'),(11,11,'Maurice','Reyes','001-245-693-3395x70538','user11@example.com'),(12,12,'Edward','Carter','+1-329-741-5659x7202','user12@example.com'),(13,13,'Brianna','King','618.793.4304x223','user13@example.com'),(14,14,'Kevin','Anderson','714.990.9571x1758','user14@example.com'),(15,15,'Brenda','Morgan','789.553.2769','user15@example.com'),(16,16,'Meagan','Cole','(900)777-9062x97721','user16@example.com'),(17,17,'Eric','Montoya','001-763-550-5633','user17@example.com'),(18,18,'Nicholas','Patterson','742-945-7039x162','user18@example.com'),(19,19,'Melinda','Frey','001-491-214-9449','user19@example.com'),(20,20,'David','Warner','876-715-8317','user20@example.com'),(21,21,'Carolyn','Hendrix','001-505-155-0034','user21@example.com'),(22,22,'Andrea','Donaldson','001-384-859-8425','user22@example.com'),(23,23,'Gwendolyn','Gonzalez','+1-195-197-3788x257','user23@example.com'),(24,24,'Tony','Rivera','688.867.3802','user24@example.com'),(25,25,'Lauren','Cooper','001-736-107-0844x3526','user25@example.com'),(26,26,'David','Martinez','+1-492-002-6484x59998','user26@example.com'),(27,27,'James','Crawford','+1-490-987-0339x92317','user27@example.com'),(28,28,'Regina','Martin','941-097-5335x16581','user28@example.com'),(29,29,'Tammy','Anderson','+1-174-369-6527x066','user29@example.com'),(30,30,'David','Cruz','084.744.2252x12262','user30@example.com'),(31,31,'Laura','Bass','783-581-4336','user31@example.com'),(32,32,'Sheryl','Haynes','425.440.6665x9035','user32@example.com'),(33,33,'Richard','Berg','821.138.0737','user33@example.com'),(34,34,'Carrie','Price','+1-341-695-6234x6439','user34@example.com'),(35,35,'David','Boone','635.149.4259','user35@example.com'),(36,36,'David','Orozco','+1-931-071-8848x6888','user36@example.com'),(37,37,'Megan','Johnson','(294)385-1288','user37@example.com'),(38,38,'Blake','Rivers','0011208915','user38@example.com'),(39,39,'Ivan','Sanders','549.750.5034x465','user39@example.com'),(40,40,'Michael','Williams','3384934427','user40@example.com'),(41,41,'Roy','Miller','001-483-342-1583x396','user41@example.com'),(42,42,'Melissa','Gates','776-463-6286x5347','user42@example.com'),(43,43,'Scott','Wang','873.129.4521x35891','user43@example.com'),(44,44,'Stephanie','Long','+1-982-817-4972x30886','user44@example.com'),(45,45,'David','Reynolds','029.108.9513x06842','user45@example.com'),(46,46,'Angie','Mcintosh','001-742-533-8219x7261','user46@example.com'),(47,47,'Marissa','Rodriguez','9301799153','user47@example.com'),(48,48,'Adam','Torres','(689)471-4529','user48@example.com'),(49,49,'Steven','Hartman','107-105-6524','user49@example.com'),(50,50,'Miranda','Ray','001-759-050-1770x23860','user50@example.com'),(51,51,'Patricia','Robinson','299.185.0221x1874','user51@example.com'),(52,52,'Angela','Rollins','391.615.4467x99089','user52@example.com'),(53,53,'Phillip','Baker','001-183-040-8054x96795','user53@example.com'),(54,54,'Ryan','Walker','3048099035','user54@example.com'),(55,55,'Cathy','Blankenship','+1-895-492-0658','user55@example.com'),(56,56,'Alfred','Hall','001-003-983-8342','user56@example.com'),(57,57,'Craig','Robinson','653.138.1064x88926','user57@example.com'),(58,58,'Tonya','Hernandez','552.571.8296','user58@example.com'),(59,59,'Elizabeth','Hahn','739.876.9650x43742','user59@example.com'),(60,60,'Christopher','Saunders','695.005.6864x576','user60@example.com'),(61,61,'Brandy','Powell','690.296.6067','user61@example.com'),(62,62,'Mary','Jordan','609-053-8185','user62@example.com'),(63,63,'Stephen','Johnson','954.439.2631x083','user63@example.com'),(64,64,'Christian','Nguyen','(191)643-9535x6784','user64@example.com'),(65,65,'Molly','Smith','(162)448-7540x26848','user65@example.com'),(66,66,'Jodi','Ellis','670.045.0903','user66@example.com'),(67,67,'Michael','Wilson','3602832540','user67@example.com'),(68,68,'Dennis','Jones','238-089-8244','user68@example.com'),(69,69,'Mandy','Bray','001-874-020-5459x98997','user69@example.com'),(70,70,'Jennifer','Hopkins','677-222-1189','user70@example.com'),(71,71,'Anita','Lowe','304-236-4819','user71@example.com'),(72,72,'Kimberly','Hodges','001-079-401-2683x525','user72@example.com'),(73,73,'Susan','Leon','7777365600','user73@example.com'),(74,74,'Jessica','Clay','(611)835-0111','user74@example.com'),(75,75,'Felicia','Holloway','574-164-6112x9096','user75@example.com'),(76,76,'Kristy','Vargas','+1-974-731-6780x2340','user76@example.com'),(77,77,'Keith','Martin','(342)653-0697x6356','user77@example.com'),(78,78,'Lisa','Lewis','470.711.5885x04842','user78@example.com'),(79,79,'Clayton','Skinner','(747)129-8736x036','user79@example.com'),(80,80,'Brian','Henderson','001-649-714-1456x39012','user80@example.com'),(81,81,'Benjamin','Bishop','+1-853-576-1187x83000','user81@example.com'),(82,82,'Timothy','Martin','(175)243-3120','user82@example.com'),(83,83,'Rose','Doyle','(631)475-2741','user83@example.com'),(84,84,'Jill','Finley','582-972-6540','user84@example.com'),(85,85,'Pam','Johnson','4583436809','user85@example.com'),(86,86,'Jessica','Gibbs','(567)928-8450','user86@example.com'),(87,87,'Joshua','Guzman','911.132.1183x66146','user87@example.com'),(88,88,'Carlos','Wang','001-584-548-7556x634','user88@example.com'),(89,89,'Michele','Vaughan','982-101-3340x9057','user89@example.com'),(90,90,'Jeremy','Mills','001-394-280-2892x476','user90@example.com'),(91,91,'Paula','Hoffman','+1-452-117-1797x135','user91@example.com'),(92,92,'Linda','Smith','6206963067','user92@example.com'),(93,93,'Patricia','Johnson','731-632-8464x6889','user93@example.com'),(94,94,'Marc','Perry','351.613.8266x7705','user94@example.com'),(95,95,'Andrea','Blackwell','(814)073-6935x79672','user95@example.com'),(96,96,'Emily','Williams','(132)493-0826x8812','user96@example.com'),(97,97,'Paul','Banks','(361)682-4536x22526','user97@example.com'),(98,98,'Steven','Cooke','261-734-0551x2765','user98@example.com'),(99,99,'Erin','Jackson','001-298-648-8762x7585','user99@example.com'),(100,100,'Brandy','Peters','434.726.4137x91453','user100@example.com'),(101,101,'Michael','Mccormick','1240594670','user101@example.com'),(102,102,'Philip','Ford','418.737.9146x7938','user102@example.com'),(103,103,'David','Wang','020.016.7601','user103@example.com'),(104,104,'Gregory','Harris','+1-089-769-1491x50048','user104@example.com'),(105,105,'Frank','Chan','748.038.3825x84980','user105@example.com'),(106,106,'Patricia','Mason','(090)051-6831x14795','user106@example.com'),(107,107,'Logan','Owens','(542)872-1310','user107@example.com'),(108,108,'Carlos','Reese','+1-221-507-0822x383','user108@example.com'),(109,109,'Robert','Howell','345.046.0942x963','user109@example.com'),(110,110,'Jonathan','Harris','0900828698','user110@example.com'),(111,111,'khai','truong','12345','khaihtruong@gmail.com'),(112,112,'Khai','truong','123123','test@gmail.com'),(113,113,'test','user','123123123','test1@gmail.com');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_auth`
--

DROP TABLE IF EXISTS `user_auth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_auth` (
  `auth_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `salt` varchar(100) NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `last_login` datetime DEFAULT NULL,
  `account_locked` tinyint(1) DEFAULT '0',
  `failed_attempts` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`auth_id`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=114 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_auth`
--

LOCK TABLES `user_auth` WRITE;
/*!40000 ALTER TABLE `user_auth` DISABLE KEYS */;
INSERT INTO `user_auth` VALUES (1,'user1','10b842e7c83e2864348b78537d62abfb0352d47c5db4ed267e8658d4eff4dbce','ELIbL6wc44cWTDsH',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(2,'user2','826b753a95cac0841f2d5d47258d5f6eb6716371fada24c67af0e9f0652b5355','e3TK0wR33BiWeFq7',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(3,'user3','9aef918785da09e55772f6f155a00eee8f02faa6b47e379ec7014595dcac5975','oGsSAlHIJdEYwPwH',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(4,'user4','a745484c58258e08b95851730a704243be4cdee44eb9c3f6be057db14d09856b','2GKvWFb7YWPlDZ3E',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(5,'user5','04bab2cf176fd8b39f3c6943a9ad08374078cc3e6ca4ba2427c3dec9fec8cb56','5B9hloIZ2b2Fyheo',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(6,'user6','bca737596276995f73106f44616c7807e33945569bcc3dbc87190534006decdd','1pKtdvbV1WQUQ5zy',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(7,'user7','9c45641f67f7a52cc77b30607bd3882482d90b012595ea8e9459c651c2d1eaec','2wVLkXnE5G81UMMZ',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(8,'user8','2f4ab20c21aa2415602f07b24a11e37a07708e435705125ef32c99581967ad10','y1EWDL6pN68rCWSC',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(9,'user9','c71f69b8fb65d7b7b17363ccc9427434dc0f0af868cdada89b988601b1ff5e36','Hd8vMYFs6e6oxbHT',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(10,'user10','5ac06cdd3c90ea87c074928970619167c395b7549036a9496e0b883e75928cd2','FfEUGa6bLPVGC8IL',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(11,'user11','63c62d761e7c953b96d12d0f5308857061c1bbf40d0925f9981def43aba369ea','9gyM1cBrlmievGp1',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(12,'user12','540d2d7667dd19a2ca09ef95b653202ac86aa89a4dc1630d53e759be775918bd','VBJgh8lmYEWAHXiY',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(13,'user13','2f05f68a8838f9e3888b5c467fc671b8c2e22927264a3a070c4e093766908f40','wm5kSWR1Msp2wubx',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(14,'user14','dfe1b49b403f665bdf06e56e488e5f146bca5c6e88a19da7daeda0bfa032f865','X9XdmowHK2GE4tYF',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(15,'user15','860b3f83ffc4a7c99b9495c4b879517dbe0e67e9781e36bc0531befd5dd0fe14','fmHCBqo8Vf6NTO71',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(16,'user16','d1a02b0f4bf364d5b537b03a4d8d5dd1697963d38f2ae4af5db07dda497c922e','vtVozGEW7h7o5IMa',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(17,'user17','17ae3d1caefbbbdbd79959d9a5080e10ca747665341dc222c31d448b3dfaeb0c','Yq6P9zxIJmY55lsJ',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(18,'user18','6b25f1f08a9871144b4acdab2e91ca0586cb2b78cc1c34a2209578bd87e93cb0','OIy25In2GTDNJA34',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(19,'user19','b078b3334eb6d8b5cdd021873c00f8d944c9abf2def7633d7a5fc3375aabc4df','3Lvq9vCbV3yTKyNf',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(20,'user20','09543f01725014a6a10ad4a642daa6b1742acbea4c8645f6732e0a96b475d19d','LY9I9zksMuILYvtB',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(21,'user21','f99169e1791aca14ff7e04a345b0950be63e79d881f2f978773c943fc3387f5d','R18lNzmjVSjWMIhX',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(22,'user22','90afd38586838779d80b1bafc101c2f5156094f202b466905547856d7ea7c258','Nb3HgCx2FHL77qFl',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(23,'user23','1e23a91c448dbece2705630a6203d7b0f509869629beb94abf2c4770f8595aac','fAvgXxHmpfoEWC9e',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(24,'user24','ef3e8f4448b24f2c0667d59d6fc081532cae9a5164bbbef2f7335782534650ca','WQbjCJbO9E4gmxuL',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(25,'user25','bc125577b6a5ad4c4e6ad1676c247b05c78ad603d95acd9d6a1059bd645fd47b','RNaOL7eicKz1p2Bw',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(26,'user26','a74ea0ff96d94d8af8ffacef6516bbcd596965e95ced8b3f150aa7c3f179d1a3','AI4F5SqYN60cG8Ap',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(27,'user27','5eb594256a53b62d60ada1f3dfddbb4c2edddc8bec48d4cfd19cae4b219e8558','kR5AUGzdTGLthAmE',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(28,'user28','d924fa927ff978623a69a6f1d160b13ebc31cb89d9b3158726f9305470384320','yzDakef6L0zdpIGa',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(29,'user29','e0f94d2a020b6845b0a9fd8976d80e00c5664ca99117f48dc92a57f0dfe7d1ca','aszNlsna6RFZJT2K',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(30,'user30','8369e1f65011ccf338de689fa55e5011ec64890cddc1f6ea9c93048dbd4d32d5','NsrusK6QCfBw16vK',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(31,'user31','0a46fa5622dab25f68b8db38d00a1cc548f1e1b4d05ecfec813f4749a3d47710','XFn41fVAD3i8M8vd',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(32,'user32','a4db9176df8a883c0a09ff8f37d5585ce51e6c63d36845feaad8b8919f760021','2dAJ3WfEcDGeTmp2',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(33,'user33','3a1f6b7d631aa77c6a1ba3a647ce52b6fd0ae903d7c2e54403d6df63bfb643ea','BMLlE8GeZXqdrkaM',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(34,'user34','3fb824e0a2b7d51f7ffcc42331495ec8dbb770910339ccee4cf645245a1cbd65','PdTQU6HGdjsZUvqe',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(35,'user35','846cbb87cb4e66c37d8d8b3e425cf2879b60ed9b026bff7cbabe83e4acf4e611','e1jJcphJGjjKq1Rg',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(36,'user36','a7ceca8287ea42e76c916bd6184e1ba82bc53603a380b804a8ee3a5c1cdb8549','PnGTVrasNx3Dzzah',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(37,'user37','046545df6d08b841a52a201afe5a3b08e568c37b43b958fbee625c6a48dd832d','aRgGjMhdVnY9b9Ul',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(38,'user38','41013218c71a687e69fec3f31ffc1c4f678ce5738e47ca1f58b838c2688f63db','OTmA2Yu7DqWUwNg6',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(39,'user39','6d94003addc4203be2823a5165ad1ea5c3956b6716088881d5b7202ca8595e9d','VXvt1jQxM6HRqkw7',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(40,'user40','7a7355c4bca0fc4dacbc5e16ba1b721c791dce616983a62e59f698ec3f86f8dc','oruhJ69S06HAN4p7',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(41,'user41','106cf2e8853e9c05a38700f5f406a7ba0cadc6c7713fbb26bb78c4d71892ecc8','1VDcKetr2TTDK43A',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(42,'user42','3c4a853ae046177f5ce8d420fdab65ceaff20112568682abe30029c18519726d','Jl0SdNze4ue0yOnN',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(43,'user43','866eef1890b517d6acddddb47aa87406c243429754fcb3bffc30e734ad3cfca7','7NDHAwmgiTHByFZr',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(44,'user44','9ed5eff316ba425d91f3f60c6b2db89c3b0b363628b7144532a655c2d9b69988','Ua3dcO0Z27jX903A',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(45,'user45','e077e2fb96112150f7124ce788f41a3de2d112a97af9108f00d212ec70ae9c9b','ba0mDOGEhKkBqKLJ',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(46,'user46','4b85132b37c4c541ea410de3357b57f60ae0f2a1f431cb92cb198d618ec26342','KMYsRG5kTplE9Gnf',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(47,'user47','b01a0036a4f1e314132c0afa9bc74efc7b91f3f5f4ebc3ab5484e1606bc79695','888JAcqtoH7vdX9w',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(48,'user48','21fedba90776d52c23258a612df4c831c4206fafa3ae643d2c7d224cce277632','0Er6ns6TD9T7hcNk',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(49,'user49','ac923a7c581a8e5856b9bcddc4b6bc439d8eadcb2e0e6715e794577569927478','s0NGGVGNFna0FHPu',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(50,'user50','2ccafb60fd6d449c29641c0fe382fa02043087b64cee5414022c1a84cdc7a0d4','t2Sdo1wv0UawY2xN',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(51,'user51','8a06358b303df15ede74f4c1ab67e418495a2df95f96243ece51bfac3f15247f','4TUeXqk6GbPy8Zxs',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(52,'user52','4af0fd470b8d5595e5815d67496deef54f7056fd4df684633b9408d67f48ddf8','xQAhPTvT1GwYN2J0',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(53,'user53','d6ba80d79862903d0108ceb96aa7c38fe776dc4760ed1419524b5165b37bf899','Rgsi3MgXYPfYq8zE',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(54,'user54','40a9bee4c03b91e3480a579c3f972ac0cd35f0dbc52cedaed9584ba6fa1a915f','sqnV5s3ibfN034MZ',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(55,'user55','e852585a6fab2a9408082e824405bc92dd36de265b7fcf64e8b41ba4e29e22c6','O5VIM8RumM9txwDu',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(56,'user56','5b0e7fbfb70d865b2e4f6580fcbe9968df66dcca6ae6968567be9b2f45df3154','rgmdaxo6XdxzHCWR',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(57,'user57','bf0b24b3af8e7edbc452d98be23612485ceb20b83508b7f353bf79a8fad3e946','faocMNunKXf0COdk',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(58,'user58','45a719acc313d3a09e26a6333642fc42ab282cf26ad21828ac3c907b5a63cbc5','fFsqJe9fAG2RvAuC',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(59,'user59','ec1c771e264e182b88561b1b1ac6ba5c96d358198ed4ab298617a271e21c146c','F0QIg12L5tEuw5gs',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(60,'user60','65a6a507bd43bef1db8eb4540825da40252bb29de02ae1b620e32f144d05d758','gSTG13mYSAYzxfcT',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(61,'user61','28ddb3ac0ac5d6e8505896b33a137003a992c5686120a258df910418706631f3','xB4yCJ1Z9lR9TPV0',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(62,'user62','9c5a04fb596670371c50ef1b1234f2b0bc2852fba09b3a84d9a93302f6675b1b','ql6tl8Hzx6lzPf2l',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(63,'user63','10f542f1f95b964dd9b1c61fbd93ec5781fff578654564e0f18dc4ee891428bc','EcKJ1Yuolp2f6Fft',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(64,'user64','afbe8b398a90fa46f48c4e2271a8617699a4b6d8cdd959d2adc378863e5e9536','GGrjScAKbeTxODlJ',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(65,'user65','6f5ba6ba547651e2ece508d9481940e7c420074d29eee055a5aad021a6339e5c','idjFqAMKHaodSEFr',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(66,'user66','8b4cd843f212e4bfffbe284351e9fc1a5de1a4a04362873a9fa72a00174c6861','IdLQDZiipjAnLUJK',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(67,'user67','6ae2d9a85e2a9c85515a68d2e43e4ab21b5b61fb05a06ddde6c5915faacef9b5','3AFn4NquxhTS8yj9',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(68,'user68','3feb9cd809f226ec2679965eae65f39bf267407da3246e46a1c00425bd440ae5','xdmyk4hwsWqIDo9G',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(69,'user69','4715825ce6db4a8747df7f1ac898584b28adac931bb465daebb1f3a3b332c8fb','2CLKEqzkJPH0Wovt',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(70,'user70','19d957554f961a78fcb958e784492ece476f11532e6bb0372db5fb1fa5a05e46','wLC7KfSH5rtN6aRN',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(71,'user71','fc4e706c87306719cae32dd3049e98eaae9c27766cd14c36636eedc9e1c1c8d4','2N0k2p6kTmogyBxA',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(72,'user72','a61dd6e38878dbc403f5cd1834f3435c4a71abbb84eca91d78f10bbcb96ce8db','t0Qf0zCEmf33wsiB',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(73,'user73','6c124bc7b2e0fbb78eebe97ee80fb04615860db451ec1dfadb0436d53d5d1cf1','reoqTu1NqRNYWGDf',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(74,'user74','6a2e49eb0e43b4705519f129211fbbad3ad2b6a1d2f2c444cb155da1b7526a42','19iIPGHsMDbndF8v',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(75,'user75','19016884b14b23a7e53801fd34471f748642678d724c03ded5bb513e31acb71b','1JjKcVJX7UKtSfJg',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(76,'user76','5322ae62acd6164017422e239fa15715efe09032241c90f33731122350844cc6','dRRskVlBm5rEv9Te',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(77,'user77','f6b986c5b8e6837356420e5fa3c2c30574ecc157ad5ffaf2201b6abfb1f106db','u8OdYWRQM7lCYgzh',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(78,'user78','69d063055ab6467b67c61d33cb6ad792813243e554844add9d448e68b555788a','TFPWqQ0JuxQRqSlu',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(79,'user79','979fba2173245a48f1d4150b16c7efaeb5b388925eef1bf3bce7dfc8c199a7a1','vCWGhdnklSNg8zEc',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(80,'user80','5304c00785dbdeb1ee4e555736a9deb46dbf13e3205e2132caad6ff6161e6902','6vQ0ySRLPWDsq2Uk',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(81,'user81','a3dc3729a725819eb173805ee032c4156f82519595919187d6eb9ceda30f7fd3','b08O68GfgplFxNYq',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(82,'user82','9b27c70e9191ea0e51558306c0e43682c085e4f658a246f4bcd1e8df8aa1f1a4','98CyBOsZAhc0CEqV',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(83,'user83','c5ac3c3538a261de2cdbd02849f947bc4cf2519f50192c6551340bde110d8e88','Fi93XpwLIGOCwfXB',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(84,'user84','074d5198f79615ee6af95687300fd59bea9582b4aa3c37a920d4ad24ef42a066','ZE4o6OZrsUxELXCz',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(85,'user85','7ab15e47e6e6e5d17fe7b44c50f88883c44efa71e6c78af6c62501d0e686e81e','io4Y79B7N5xhjMdz',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(86,'user86','5008a07b8669434720704f49d01f269aa5ecd559a170ad76de81cc4c9e6d9e85','acfZmnmpXGACp21B',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(87,'user87','d334c0fcb5204b580aeb19d70cad73767ad030f9a2da793ac2e4769dee7a25ce','C3LytpnNpMNX8twJ',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(88,'user88','9ef27873b548ae1b834c9f4fffded1d04822b96f153f9191ee545dd84464c730','NwHmuz3L3HXzwgJh',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(89,'user89','2f9ac4da8c040c28fc667dfc490742579b69a5e312d73ce8f605e2ba402775e5','VOc3wHjUt9ITXVOY',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(90,'user90','2345c23725f4ca6b088390782b34fd1d1427fdb35706d1e0ceb32914984b9cbc','57nTosqDinkHXNbp',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(91,'user91','0e060a7e6ef6ee338feb90bab5cacaf1f12715acf1e835341bad99ea70918b06','xp94ihKGz7kDhsGa',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(92,'user92','4bfeb912930422033f56524c0f154d95f16a3b7b64ebfe6981303c94b594d018','6J7V1kafQYegwXOY',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(93,'user93','ff3dd61da7df7971adbc28316961ed4d07349690265762facf9e69df22f244db','OjSdVUo9yEeDBvIW',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(94,'user94','13775419b67e50923404a594b2bbd1b36f62900df69cbafe3876bcc6d2ef4fcd','gEgR9374pVAj8KUO',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(95,'user95','58b85dfaaf7a3efca95bf6efed74e93fb12f9f71bf46bac3c35115cd0ddcc09f','FkgnpQ9RBFIFbk8U',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(96,'user96','77a3f0f081206fe960a1dc46d4b3a9b5f1f7fbe75704620cc8a4c9c50243fb20','jMnOGJ2M6S4TmFCw',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(97,'user97','0217539a593dbee1d2856dbf6bf20828d4818ed91d0e849c9f8bcde426ed4a15','WH4CLYZl25V0rj8P',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(98,'user98','2291c9f38eb6928a0bd295f671f712ee79422fa5f53ce3644679306fa56640d7','y8Nvwol9eAyCPwm0',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(99,'user99','46be5a4ed014aa73924a6b0fa5c0d64f61804d74daa99e14de22ae4c710b6a3c','BDBSuBQA0mOOLt1o',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(100,'user100','741cdaa1e5e5925029d0f31411c53ebcc345bd4ec1b0bf7a4512be89136fa8b4','1JB7uxEr45t8744x',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(101,'user101','dfb4c7058769a61a0b0e79667efa3415ca0713c247b257e14ad0cb432a3a1b30','PdeAqfq3HcKMFjBg',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(102,'user102','688840e3d0ded97ca1004bcb7d23e402df62bf73f62ea091d0541b53cbaa14c3','7CzNOCpYTLl9vTr7',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(103,'user103','b78921b1c65e52f764faede9e0e754572b9a247cda7cffe1a365d6d3e94357ab','eyWke2v3szKRVLyy',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(104,'user104','73987a11a72c6799cdf377213e6971ccdd5319b20a97b0bf98a672186b342f00','1wKrUJEaxQaCzLPz',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(105,'user105','48c47e0503b8edcc4e9b7be8331fafb46c415cb08116b332f56e6c8f309f85f4','kdQac6QNbErCDYjp',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(106,'user106','b721ae413ecb44c219be4220e6326f50471c59f7944ab5c659b338f203581c5c','RVUM4jyRjaFccEB0',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(107,'user107','46a09c7902e13bcfef96c74c6fd5393d09eedde475209d2d4cd48f9393ff77cb','pHEbV0IR2suhzBSp',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(108,'user108','4f82646ce14a4d81660859834718e2eb76f9af8b1323867884d60560fcbf8429','ML3PJJqV2aMXqAHW',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(109,'user109','ebd4120beab975a4031fdc5f07cb45042add1c0e0573d97c3f058fba4baeabf2','PVzAhfySfE9dnqob',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(110,'user110','5bbb758a2fef8149074b03108f0daf7ebb268967244f8b2cdf61abc0148f30c6','pb2FcuUk9FtFCQVW',1,NULL,0,0,'2025-04-17 00:56:15','2025-04-17 00:56:15'),(111,'khaihtruong@gmail.com','3e8d7371ff36b88c6d3c9103257ef84c7c725cdf84aabbfb95903418cf307e05','6d51565f6dfb420b9b2d73db75ef3ec6',1,'2025-04-17 13:53:19',0,0,'2025-04-17 01:05:35','2025-04-17 17:53:19'),(112,'test@gmail.com','dc31528b45d6888aa187f38241774b39517a8a54065a240cb1fdb9c8c7be160b','83eaf61adc00424a8b4c3f2284065e76',1,NULL,0,0,'2025-04-18 01:51:21','2025-04-18 01:51:21'),(113,'test1@gmail.com','d7c9d720a4342237f5e9dd80095b226b5dc2dcb42bac68614f9ed1a3e78be96b','02dc4be4a9be49a8a67188795a678888',1,NULL,0,0,'2025-04-18 02:19:01','2025-04-18 02:19:01');
/*!40000 ALTER TABLE `user_auth` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'rental_system'
--

--
-- Dumping routines for database 'rental_system'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-17 22:35:02
