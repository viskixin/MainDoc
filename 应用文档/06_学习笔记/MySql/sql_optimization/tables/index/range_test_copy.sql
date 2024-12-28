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

 Date: 05/12/2023 12:33:29
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for range_test_copy
-- ----------------------------
DROP TABLE IF EXISTS `range_test_copy`;
CREATE TABLE `range_test_copy`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `age` int NOT NULL,
  `phone` bigint NOT NULL,
  `money` int NOT NULL,
  `addi` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_apm2`(`age` ASC, `phone` ASC, `money` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of range_test_copy
-- ----------------------------
INSERT INTO `range_test_copy` VALUES (1, 11, 123456, 22, NULL);
INSERT INTO `range_test_copy` VALUES (2, 12, 531123, 33, NULL);
INSERT INTO `range_test_copy` VALUES (3, 13, 342124, 44, NULL);
INSERT INTO `range_test_copy` VALUES (4, 14, 225224, 55, NULL);

SET FOREIGN_KEY_CHECKS = 1;
