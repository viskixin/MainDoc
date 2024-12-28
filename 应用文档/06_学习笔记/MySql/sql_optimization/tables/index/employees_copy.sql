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

 Date: 05/12/2023 12:32:51
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for employees_copy
-- ----------------------------
DROP TABLE IF EXISTS `employees_copy`;
CREATE TABLE `employees_copy`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(24) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '姓名',
  `age` int NOT NULL DEFAULT 0 COMMENT '年龄',
  `position` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '职位',
  `hire_time` timestamp NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_name_age_position2`(`name` ASC, `age` ASC, `position` ASC) USING BTREE,
  INDEX `idx_hire_time2`(`hire_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '员工记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of employees_copy
-- ----------------------------
INSERT INTO `employees_copy` VALUES (4, 'LiLei', 22, 'manager', '2023-10-26 19:48:01');
INSERT INTO `employees_copy` VALUES (5, 'HanMeimei', 23, 'dev', '2023-10-26 19:48:01');
INSERT INTO `employees_copy` VALUES (6, 'Lucy', 23, 'dev', '2023-10-26 19:48:01');
INSERT INTO `employees_copy` VALUES (7, 'Linken', 33, 'manager', '2023-10-31 20:04:52');

SET FOREIGN_KEY_CHECKS = 1;
