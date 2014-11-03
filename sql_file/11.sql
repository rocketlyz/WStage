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
CREATE DATABASE /*!32312 IF NOT EXISTS*/`wsn` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `wsn`;

/*Table structure for table `node` */

DROP TABLE IF EXISTS `node`;

CREATE TABLE `node` (
  `nid` char(6) character set latin1 NOT NULL COMMENT '汇聚节点node的id',
  `uid` char(11) character set latin1 NOT NULL COMMENT '提供商的id',
  `name` varchar(50) character set latin1 NOT NULL,
  PRIMARY KEY  (`nid`,`uid`),
  KEY `foreignkey_uid` (`uid`),
  CONSTRAINT `foreignkey_uid` FOREIGN KEY (`uid`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `node` */

/*Table structure for table `ph` */

DROP TABLE IF EXISTS `ph`;

CREATE TABLE `ph` (
  `uid` char(11) NOT NULL COMMENT '提供方的ID',
  `nid` char(6) NOT NULL COMMENT '汇聚节点的ID',
  `sid` char(2) NOT NULL COMMENT '传感器节点的ID',
  `value` decimal(2,1) NOT NULL,
  `time` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `ph` */

/*Table structure for table `sensor` */

DROP TABLE IF EXISTS `sensor`;

CREATE TABLE `sensor` (
  `sid` char(2) character set latin1 NOT NULL,
  `nid` char(6) character set latin1 NOT NULL,
  `uid` char(11) character set latin1 NOT NULL,
  `name` varchar(30) default NULL,
  `tid` int(11) default NULL,
  PRIMARY KEY  (`sid`,`nid`,`uid`),
  KEY `foreignkey_nodeid` (`nid`),
  KEY `foreignkey_userid` (`uid`),
  KEY `foreignkey_typeid` (`tid`),
  CONSTRAINT `foreignkey_nodeid` FOREIGN KEY (`nid`) REFERENCES `node` (`nid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `foreignkey_typeid` FOREIGN KEY (`tid`) REFERENCES `type` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `foreignkey_userid` FOREIGN KEY (`uid`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `sensor` */

/*Table structure for table `type` */

DROP TABLE IF EXISTS `type`;

CREATE TABLE `type` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(20) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

/*Data for the table `type` */

insert  into `type`(`id`,`name`) values (1,'ph'),(2,'light'),(3,'temperature'),(4,'humidity');

/*Table structure for table `user` */

DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `id` char(11) character set latin1 NOT NULL,
  `nickname` varchar(30) character set latin1 NOT NULL,
  `email` varchar(30) character set latin1 default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `user` */

insert  into `user`(`id`,`nickname`,`email`) values ('1','he',NULL),('2','liu',NULL);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
