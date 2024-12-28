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

 Date: 05/12/2023 12:32:59
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for employees_copy2
-- ----------------------------
DROP TABLE IF EXISTS `employees_copy2`;
CREATE TABLE `employees_copy2`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(24) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '姓名',
  `age` int NOT NULL DEFAULT 0 COMMENT '年龄',
  `position` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '职位',
  `address` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '地址',
  `hire_time` timestamp NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_name_age_position2`(`name` ASC, `age` ASC, `position` ASC, `address` ASC) USING BTREE,
  INDEX `idx_hire_time2`(`hire_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '员工记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of employees_copy2
-- ----------------------------
INSERT INTO `employees_copy2` VALUES (4, 'LiLei', 22, 'manager', 'snhp', '2023-10-26 19:48:01');
INSERT INTO `employees_copy2` VALUES (5, 'HanMeimei', 23, 'dev', 'zadkf', '2023-10-26 19:48:01');
INSERT INTO `employees_copy2` VALUES (6, 'Lucy', 23, 'dev', 'wsyb', '2023-10-26 19:48:01');
INSERT INTO `employees_copy2` VALUES (7, 'Lucy', 24, 'dev', 'wsyb', '2023-10-31 20:04:52');
INSERT INTO `employees_copy2` VALUES (8, 'Lucy', 23, 'manager', 'lxcydm', '2023-11-01 17:30:21');
INSERT INTO `employees_copy2` VALUES (9, 'Lucy', 24, 'dev', 'owuwu', '2023-11-01 17:32:44');
INSERT INTO `employees_copy2` VALUES (10, 'Lucy', 23, 'manager', 'apach', '2023-11-01 18:14:37');
INSERT INTO `employees_copy2` VALUES (11, 'Lucy', 24, 'manager', 'blandy', '2023-11-01 19:29:51');

SET FOREIGN_KEY_CHECKS = 1;
