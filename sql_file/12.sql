/*
SQLyog Ultimate v11.13 (32 bit)
MySQL - 5.0.90-community-nt : Database - wsn
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`wsn` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `wsn`;

/*Table structure for table `sensor` */

DROP TABLE IF EXISTS `sensor`;

CREATE TABLE `sensor` (
  `id` varchar(26) NOT NULL COMMENT '传感器唯一标识，结构为 sink_id+''_''+sensor_id',
  `sensor_id` varchar(5) NOT NULL COMMENT '一个发布节点分配给传感器的内部id',
  `sink_id` varchar(20) NOT NULL COMMENT 'sink表外键',
  `name` varchar(100) NOT NULL COMMENT '传感器名字',
  `data_time` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP COMMENT '接受数据的时间',
  `sample_frame` int(11) NOT NULL COMMENT '接受数据的频率(s/次)',
  `type_id` int(11) default NULL COMMENT 'type表外键',
  PRIMARY KEY  (`id`),
  KEY `sink_id` (`sink_id`),
  KEY `type_id` (`type_id`),
  CONSTRAINT `sensor_ibfk_1` FOREIGN KEY (`sink_id`) REFERENCES `sink` (`id`),
  CONSTRAINT `sensor_ibfk_2` FOREIGN KEY (`type_id`) REFERENCES `type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `sensor` */

/*Table structure for table `sink` */

DROP TABLE IF EXISTS `sink`;

CREATE TABLE `sink` (
  `id` varchar(20) NOT NULL COMMENT '发布节点的唯一标识',
  `user_id` varchar(14) default NULL COMMENT '外键',
  `name` varchar(100) NOT NULL COMMENT '节点名字',
  `serial` varchar(30) default NULL COMMENT '节点序列号',
  PRIMARY KEY  (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `sink_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `sink` */

/*Table structure for table `subscription` */

DROP TABLE IF EXISTS `subscription`;

CREATE TABLE `subscription` (
  `id` int(11) NOT NULL auto_increment COMMENT '订阅编号',
  `sensor_id` varchar(26) NOT NULL COMMENT '要订阅的传感器id',
  `user_id` varchar(14) NOT NULL COMMENT '订阅人的id',
  `sub_time` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP COMMENT '订阅发起的时间',
  PRIMARY KEY  (`id`),
  KEY `sensor_id` (`sensor_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `subscription_ibfk_1` FOREIGN KEY (`sensor_id`) REFERENCES `sensor` (`id`),
  CONSTRAINT `subscription_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `subscription` */

/*Table structure for table `type` */

DROP TABLE IF EXISTS `type`;

CREATE TABLE `type` (
  `id` int(11) NOT NULL auto_increment COMMENT '传感器类型的标识',
  `name` varchar(20) NOT NULL COMMENT '传感器类型',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `type` */

/*Table structure for table `user` */

DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `id` varchar(14) NOT NULL COMMENT '用户的唯一标识',
  `password` varchar(100) NOT NULL COMMENT '密码（6-15位）',
  `email` varchar(255) default NULL COMMENT '用户关联邮箱',
  `reg_time` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP COMMENT '注册的时间',
  `posted` bit(1) NOT NULL default b'0' COMMENT '是否为发布方，false表示不是',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `user` */

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
