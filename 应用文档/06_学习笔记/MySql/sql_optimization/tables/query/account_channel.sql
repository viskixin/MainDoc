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

 Date: 05/12/2023 12:34:29
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for account_channel
-- ----------------------------
DROP TABLE IF EXISTS `account_channel`;
CREATE TABLE `account_channel`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '姓名',
  `channel` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '账户渠道',
  `balance` int NULL DEFAULT NULL COMMENT '余额',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of account_channel
-- ----------------------------
INSERT INTO `account_channel` VALUES (1, 'zhuge', 'wx', 100);
INSERT INTO `account_channel` VALUES (2, 'zhuge', 'alipay', 200);
INSERT INTO `account_channel` VALUES (3, 'zhuge', 'yinhang', 300);
INSERT INTO `account_channel` VALUES (4, 'lilei', 'wx', 200);
INSERT INTO `account_channel` VALUES (5, 'lilei', 'alipay', 100);
INSERT INTO `account_channel` VALUES (6, 'hanmeimei', 'wx', 500);

SET FOREIGN_KEY_CHECKS = 1;
