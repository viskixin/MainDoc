/*
 Navicat Premium Data Transfer

 Source Server         : vm_mysql
 Source Server Type    : MySQL
 Source Server Version : 80027 (8.0.27)
 Source Host           : 192.168.145.121:3306
 Source Schema         : sql_optimization

 Target Server Type    : MySQL
 Target Server Version : 80027 (8.0.27)
 File Encoding         : 65001

 Date: 05/12/2023 12:33:16
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for film_copy
-- ----------------------------
DROP TABLE IF EXISTS `film_copy`;
CREATE TABLE `film_copy`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `age` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_name2`(`name` ASC) USING BTREE,
  INDEX `idx_age2`(`age` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of film_copy
-- ----------------------------
INSERT INTO `film_copy` VALUES (1, 'film1', 22);
INSERT INTO `film_copy` VALUES (2, 'film2', 33);
INSERT INTO `film_copy` VALUES (3, 'film3', 44);

SET FOREIGN_KEY_CHECKS = 1;
