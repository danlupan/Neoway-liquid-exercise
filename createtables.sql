drop database main_business;
create database main_business;
use main_business;

CREATE TABLE `business_record` (
  `name` varchar(100) DEFAULT NULL ,
  `street` varchar(100) DEFAULT NULL,
  `city` varchar(20) DEFAULT NULL,
  `state` varchar(10) DEFAULT NULL,
  `zip_code` int(11) DEFAULT NULL,
  `unique_ID` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA INFILE 'business\ record.csv' INTO TABLE main_business.business_record;

CREATE TABLE `liquor_license` (
  `premises_name` varchar(100) DEFAULT NULL,
  `address` varchar(100) DEFAULT NULL,
  `license_class` varchar(10) DEFAULT NULL COMMENT 'see more on https://www.sla.ny.gov/system/files/license-and-permit-code-classifications-July2015.pdf',
  `license_type` varchar(10) DEFAULT NULL COMMENT 'see more on https://www.sla.ny.gov/system/files/license-and-permit-code-classifications-July2015.pdf',
  `expiration_date` varchar(20) DEFAULT NULL,
  `license_status` varchar(20) DEFAULT NULL COMMENT 'Expired/License is Inactive/License is Active/Pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
LOAD DATA INFILE 'Liquor\ Licenses.csv' INTO TABLE main_business.liquor_license;
