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

 Date: 05/12/2023 12:34:40
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for tb_nf2
-- ----------------------------
DROP TABLE IF EXISTS `tb_nf2`;
CREATE TABLE `tb_nf2`  (
  `c1` int NULL DEFAULT NULL,
  `c2` int NULL DEFAULT NULL,
  INDEX `idx_c1`(`c1` ASC) USING BTREE,
  INDEX `idx_c2`(`c2` ASC) USING BTREE INVISIBLE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tb_nf2
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
