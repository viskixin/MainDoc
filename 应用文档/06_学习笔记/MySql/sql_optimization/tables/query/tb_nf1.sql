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

 Date: 05/12/2023 12:34:35
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for tb_nf1
-- ----------------------------
DROP TABLE IF EXISTS `tb_nf1`;
CREATE TABLE `tb_nf1`  (
  `c1` int NULL DEFAULT NULL,
  `c2` int NULL DEFAULT NULL,
  INDEX `idx_c1_c2`(`c1` ASC, `c2` DESC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tb_nf1
-- ----------------------------
INSERT INTO `tb_nf1` VALUES (1, 10);
INSERT INTO `tb_nf1` VALUES (2, 60);
INSERT INTO `tb_nf1` VALUES (3, 50);
INSERT INTO `tb_nf1` VALUES (4, 100);
INSERT INTO `tb_nf1` VALUES (5, 80);

SET FOREIGN_KEY_CHECKS = 1;
