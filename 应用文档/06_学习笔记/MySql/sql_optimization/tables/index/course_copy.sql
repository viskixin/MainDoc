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

 Date: 05/12/2023 12:32:38
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for course_copy
-- ----------------------------
DROP TABLE IF EXISTS `course_copy`;
CREATE TABLE `course_copy`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `price` bigint NOT NULL,
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_title_price`(`title` ASC, `price` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of course_copy
-- ----------------------------
INSERT INTO `course_copy` VALUES (1, '高等数学', 999, NULL);
INSERT INTO `course_copy` VALUES (2, '线性代数', 888, NULL);
INSERT INTO `course_copy` VALUES (3, '概率论与数理统计', 666, NULL);
INSERT INTO `course_copy` VALUES (4, 'A', 1, NULL);
INSERT INTO `course_copy` VALUES (5, 'B', 2, NULL);
INSERT INTO `course_copy` VALUES (6, 'AB', 3, NULL);
INSERT INTO `course_copy` VALUES (7, 'ABC', 4, NULL);
INSERT INTO `course_copy` VALUES (8, 'BC', 5, NULL);
INSERT INTO `course_copy` VALUES (9, 'CB', 6, NULL);
INSERT INTO `course_copy` VALUES (10, 'AAA', 7, NULL);
INSERT INTO `course_copy` VALUES (11, 'AC', 8, NULL);
INSERT INTO `course_copy` VALUES (12, 'AD', 9, NULL);
INSERT INTO `course_copy` VALUES (13, 'abc', 10, NULL);
INSERT INTO `course_copy` VALUES (14, 'ad', 11, NULL);
INSERT INTO `course_copy` VALUES (15, 'z', 12, NULL);

SET FOREIGN_KEY_CHECKS = 1;
