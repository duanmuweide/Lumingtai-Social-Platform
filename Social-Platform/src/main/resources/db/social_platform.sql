/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80021
 Source Host           : localhost:3306
 Source Schema         : social_platform

 Target Server Type    : MySQL
 Target Server Version : 80021
 File Encoding         : 65001

 Date: 19/06/2025 16:21:27
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for comments
-- ----------------------------
DROP TABLE IF EXISTS `comments`;
CREATE TABLE `comments`  (
                             `cid` int NOT NULL,
                             `cuid` int NOT NULL,
                             `clike` tinyint(1) NOT NULL,
                             `cfile` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
                             `cmessage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
                             `cdate` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
                             PRIMARY KEY (`cid`, `cuid`) USING BTREE,
                             INDEX `cuid`(`cuid` ASC) USING BTREE,
                             CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`cid`) REFERENCES `posts` (`pid`) ON DELETE RESTRICT ON UPDATE RESTRICT,
                             CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`cuid`) REFERENCES `users` (`uid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of comments
-- ----------------------------

-- ----------------------------
-- Table structure for conversations
-- ----------------------------
DROP TABLE IF EXISTS `conversations`;
CREATE TABLE `conversations`  (
                                  `cid` int NOT NULL AUTO_INCREMENT,
                                  `csenderid` int NOT NULL,
                                  `creceiverid` int NOT NULL,
                                  `cmessage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
                                  `cdate` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
                                  PRIMARY KEY (`cid`) USING BTREE,
                                  INDEX `csenderid`(`csenderid` ASC) USING BTREE,
                                  INDEX `creceiverid`(`creceiverid` ASC) USING BTREE,
                                  CONSTRAINT `conversations_ibfk_1` FOREIGN KEY (`csenderid`) REFERENCES `users` (`uid`) ON DELETE RESTRICT ON UPDATE RESTRICT,
                                  CONSTRAINT `conversations_ibfk_2` FOREIGN KEY (`creceiverid`) REFERENCES `users` (`uid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of conversations
-- ----------------------------

-- ----------------------------
-- Table structure for friend_requests
-- ----------------------------
DROP TABLE IF EXISTS `friend_requests`;
CREATE TABLE `friend_requests`  (
                                    `id` int NOT NULL AUTO_INCREMENT,
                                    `reqid` int NULL DEFAULT NULL,
                                    `recid` int NULL DEFAULT NULL,
                                    `message` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
                                    `createtime` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
                                    `status` tinyint(1) NULL DEFAULT NULL,
                                    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of friend_requests
-- ----------------------------

-- ----------------------------
-- Table structure for groupsconversations
-- ----------------------------
DROP TABLE IF EXISTS `groupsconversations`;
CREATE TABLE `groupsconversations`  (
                                        `gcid` int NOT NULL AUTO_INCREMENT,
                                        `gcgid` int NOT NULL,
                                        `gcuid` int NOT NULL,
                                        `gcmessage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
                                        `gcdate` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
                                        PRIMARY KEY (`gcid`) USING BTREE,
                                        INDEX `gcgid`(`gcgid` ASC) USING BTREE,
                                        INDEX `gcuid`(`gcuid` ASC) USING BTREE,
                                        CONSTRAINT `groupsconversations_ibfk_1` FOREIGN KEY (`gcgid`) REFERENCES `usergroups` (`gid`) ON DELETE RESTRICT ON UPDATE RESTRICT,
                                        CONSTRAINT `groupsconversations_ibfk_2` FOREIGN KEY (`gcuid`) REFERENCES `users` (`uid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of groupsconversations
-- ----------------------------

-- ----------------------------
-- Table structure for groupspeople
-- ----------------------------
DROP TABLE IF EXISTS `groupspeople`;
CREATE TABLE `groupspeople`  (
                                 `gpid` int NOT NULL,
                                 `gpuid` int NOT NULL,
                                 `gpname` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
                                 `gpdate` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
                                 `gpidentity` int NOT NULL DEFAULT 1,
                                 PRIMARY KEY (`gpid`, `gpuid`) USING BTREE,
                                 INDEX `gpuid`(`gpuid` ASC) USING BTREE,
                                 CONSTRAINT `groupspeople_ibfk_1` FOREIGN KEY (`gpid`) REFERENCES `usergroups` (`gid`) ON DELETE RESTRICT ON UPDATE RESTRICT,
                                 CONSTRAINT `groupspeople_ibfk_2` FOREIGN KEY (`gpuid`) REFERENCES `users` (`uid`) ON DELETE RESTRICT ON UPDATE RESTRICT,
                                 CONSTRAINT `chk_gpidentity` CHECK (`gpidentity` between 1 and 3)
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of groupspeople
-- ----------------------------

-- ----------------------------
-- Table structure for posts
-- ----------------------------
DROP TABLE IF EXISTS `posts`;
CREATE TABLE `posts`  (
                          `pid` int NOT NULL AUTO_INCREMENT,
                          `puid` int NOT NULL,
                          `pmessage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
                          `pdate` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
                          `pfile` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
                          PRIMARY KEY (`pid`) USING BTREE,
                          INDEX `puid`(`puid` ASC) USING BTREE,
                          CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`puid`) REFERENCES `users` (`uid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of posts
-- ----------------------------

-- ----------------------------
-- Table structure for relationship
-- ----------------------------
DROP TABLE IF EXISTS `relationship`;
CREATE TABLE `relationship`  (
                                 `rid` int NOT NULL AUTO_INCREMENT,
                                 `ruid` int NOT NULL,
                                 `rfiendid` int NOT NULL,
                                 `rtype` int NOT NULL DEFAULT 1,
                                 `rdate` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
                                 PRIMARY KEY (`rid`) USING BTREE,
                                 INDEX `ruid`(`ruid` ASC) USING BTREE,
                                 INDEX `rfiendid`(`rfiendid` ASC) USING BTREE,
                                 CONSTRAINT `relationship_ibfk_1` FOREIGN KEY (`ruid`) REFERENCES `users` (`uid`) ON DELETE RESTRICT ON UPDATE RESTRICT,
                                 CONSTRAINT `relationship_ibfk_2` FOREIGN KEY (`rfiendid`) REFERENCES `users` (`uid`) ON DELETE RESTRICT ON UPDATE RESTRICT,
                                 CONSTRAINT `chk_rtype` CHECK (`rtype` between 1 and 5)
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of relationship
-- ----------------------------

-- ----------------------------
-- Table structure for usergroups
-- ----------------------------
DROP TABLE IF EXISTS `usergroups`;
CREATE TABLE `usergroups`  (
                               `gid` int NOT NULL AUTO_INCREMENT,
                               `gname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
                               `gdate` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
                               `gimage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
                               `gdescription` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
                               `gnumber` int NOT NULL DEFAULT 1,
                               PRIMARY KEY (`gid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of usergroups
-- ----------------------------

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
                          `uid` int NOT NULL AUTO_INCREMENT,
                          `uname` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
                          `upwd` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
                          `uquestion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
                          `uanswer` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
                          `ubirthday` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
                          `ugender` tinyint(1) NULL DEFAULT NULL,
                          `uhobby` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
                          `usign` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
                          `uphonenumber` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
                          `uemail` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
                          `uimage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
                          PRIMARY KEY (`uid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
