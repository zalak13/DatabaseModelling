/*
Created: 12/1/2015
Modified: 12/18/2015
Model: MySQL 5.6
Database: MySQL 5.6
*/


-- Create tables section -------------------------------------------------

-- Table member

CREATE TABLE `member`
(
  `mid` Int NOT NULL,
  `aid` Int NOT NULL,
  `insid` Int NOT NULL,
  `dob` Date NOT NULL,
  `f_name` Varchar(20) NOT NULL,
  `l_name` Varchar(20) NOT NULL,
  `m_initials` Char(1),
  `gender` Enum('MALE','FEMALE','UNKNOWN') NOT NULL,
  `ins_relationship` Enum('SELF','MOTHER','FATHER','WIFE','HUSBAND','CHILD','OTHER') NOT NULL,
  `telephone` Char(10)
)
;

CREATE INDEX `IX_Member_Address` ON `member` (`aid`)
;

CREATE INDEX `IX_Relationship1` ON `member` (`insid`)
;

ALTER TABLE `member` ADD  PRIMARY KEY (`mid`)
;

-- Table insurance_policy

CREATE TABLE `insurance_policy`
(
  `polid` Int NOT NULL,
  `group_policy_id` Char(5) NOT NULL,
  `policy_number` Char(10) NOT NULL,
  `plan_name` Char(30) NOT NULL
)
;

CREATE INDEX `IX_Relationship1` ON `insurance_policy` (`group_policy_id`)
;

ALTER TABLE `insurance_policy` ADD  PRIMARY KEY (`polid`)
;

-- Table claim_signs

CREATE TABLE `claim_signs`
(
  `sid` Int NOT NULL,
  `cid` Int NOT NULL,
  `p_sign` Varchar(200) NOT NULL,
  `p_sign_date` Date NOT NULL,
  `i_sign` Varchar(200) NOT NULL,
  `phy_sign` Varchar(200) NOT NULL,
  `phy_sign_date` Date NOT NULL
)
;

ALTER TABLE `claim_signs` ADD  PRIMARY KEY (`sid`,`cid`)
;

-- Table medical_service

CREATE TABLE `medical_service`
(
  `msid` Int NOT NULL,
  `cid` Int NOT NULL,
  `place_of_service` Char(2) NOT NULL,
  `CPT_HCPCS_code` Char(5) NOT NULL,
  `modifier` Char(8) NOT NULL,
  `prov_qualifier_id` Char(3) NOT NULL,
  `EMG` Enum('YES','NO') NOT NULL
 COMMENT 'EMG- Emergency',
  `diagnosis_pointer` Char(4) NOT NULL,
  `from_date` Date NOT NULL,
  `to_date` Date NOT NULL,
  `charge_amount` Float(6) NOT NULL,
  `day_unit` Int(3) NOT NULL,
  `PSDT_family_plan_ind` Enum('Y','N') NOT NULL,
  `rendering_pid` Int NOT NULL
)
;

CREATE INDEX `IX_Relationship1` ON `medical_service` (`cid`)
;

CREATE INDEX `IX_Relationship2` ON `medical_service` (`CPT_HCPCS_code`)
;

CREATE INDEX `IX_Relationship3` ON `medical_service` (`modifier`)
;

CREATE INDEX `IX_Relationship5` ON `medical_service` (`place_of_service`)
;

CREATE INDEX `IX_Relationship9` ON `medical_service` (`prov_qualifier_id`)
;

ALTER TABLE `medical_service` ADD  PRIMARY KEY (`msid`)
;

-- Table claims

CREATE TABLE `claims`
(
  `cid` Int NOT NULL,
  `medical_qualifier_code` Int(3) NOT NULL
 COMMENT '431- On set of current sympton or Illness.
484- Last menstrual period.',
  `resubmission_code` Int(1),
  `other_polid` Int,
  `referring_pid` Int NOT NULL,
  `patient_condition` Enum('Employment','Auto','Other') NOT NULL,
  `medical_qualifier_type` Enum('Illness','Injury','Pregnancy') NOT NULL,
  `medical_qualifier_date` Date NOT NULL,
  `serv_facility_id` Int NOT NULL,
  `billing_pid` Int NOT NULL,
  `original_ref_no` Char(20)
)
;

CREATE INDEX `IX_Relationship8` ON `claims` (`medical_qualifier_code`)
;

CREATE INDEX `IX_Relationship10` ON `claims` (`resubmission_code`)
;

ALTER TABLE `claims` ADD  PRIMARY KEY (`cid`)
;

-- Table claims_account

CREATE TABLE `claims_account`
(
  `caid` Int NOT NULL,
  `cid` Int NOT NULL,
  `fedral_tax_id` Char(9) NOT NULL,
  `tax_id_type` Enum('SSN','EID') NOT NULL,
  `patient_account_no` Char(5) NOT NULL,
  `accept_assignment_ind` Enum('Y','N') NOT NULL,
  `total_charge` Float(2) NOT NULL,
  `amount_paid` Float(2) NOT NULL,
  `outside_lab_charges` Float(2)
)
;

CREATE INDEX `IX_Relationship1` ON `claims_account` (`cid`)
;

ALTER TABLE `claims_account` ADD  PRIMARY KEY (`caid`)
;

-- Table claims_hospital_info

CREATE TABLE `claims_hospital_info`
(
  `cid` Int NOT NULL,
  `hospitalize_to_date` Date NOT NULL,
  `hospitalize_from_date` Date NOT NULL,
  `work_absence_to_date` Date NOT NULL,
  `work_absence_from_date` Date NOT NULL,
  `prior_authorization_number` Char(29),
  `outside_lab_ind` Enum('YES','NO') NOT NULL
)
;

ALTER TABLE `claims_hospital_info` ADD  PRIMARY KEY (`cid`)
;

-- Table address_lk

CREATE TABLE `address_lk`
(
  `aid` Int NOT NULL,
  `street_address_1` Char(150) NOT NULL,
  `street_address_2` Char(150),
  `city` Varchar(20) NOT NULL,
  `state` Char(2) NOT NULL,
  `zipcode` Char(5) NOT NULL
)
;

ALTER TABLE `address_lk` ADD  PRIMARY KEY (`aid`)
;

-- Table member_policies

CREATE TABLE `member_policies`
(
  `mid` Int NOT NULL,
  `polid` Int NOT NULL,
  `cid` Int NOT NULL
)
;

CREATE INDEX `IX_Relationship4` ON `member_policies` (`mid`)
;

ALTER TABLE `member_policies` ADD  PRIMARY KEY (`cid`,`polid`)
;

-- Table group_policy_lk

CREATE TABLE `group_policy_lk`
(
  `group_policy_id` Char(5) NOT NULL,
  `group_policy_name` Char(50) NOT NULL
)
;

ALTER TABLE `group_policy_lk` ADD  PRIMARY KEY (`group_policy_id`)
;

-- Table CPT_HCPS_code_lk

CREATE TABLE `CPT_HCPS_code_lk`
(
  `CPT_HCPCS_code` Char(5) NOT NULL,
  `code_name` Char(150) NOT NULL
)
;

ALTER TABLE `CPT_HCPS_code_lk` ADD  PRIMARY KEY (`CPT_HCPCS_code`)
;

-- Table place_of_service_lk

CREATE TABLE `place_of_service_lk`
(
  `place_of_service` Char(2) NOT NULL,
  `place_of_service_name` Char(50) NOT NULL
)
;

ALTER TABLE `place_of_service_lk` ADD  PRIMARY KEY (`place_of_service`)
;

-- Table modifier_lk

CREATE TABLE `modifier_lk`
(
  `modifier_code` Char(8) NOT NULL,
  `modifier_name` Char(150) NOT NULL
)
;

ALTER TABLE `modifier_lk` ADD  PRIMARY KEY (`modifier_code`)
;

-- Table ICD_code_desc

CREATE TABLE `ICD_code_desc`
(
  `ICD_code` Char(5) NOT NULL,
  `ICD_description` Char(150) NOT NULL
)
;

ALTER TABLE `ICD_code_desc` ADD  PRIMARY KEY (`ICD_code`)
;

-- Table claims_ICD_codes

CREATE TABLE `claims_ICD_codes`
(
  `ICD_code` Char(5) NOT NULL,
  `cid` Int NOT NULL,
  `diagonisis_label` Enum('A','B','C','D','E','F','G','H','I','J','K','L') NOT NULL
)
;

ALTER TABLE `claims_ICD_codes` ADD  PRIMARY KEY (`ICD_code`,`cid`)
;

-- Table resubmission_code_lk

CREATE TABLE `resubmission_code_lk`
(
  `resubmission_code` Int(1) NOT NULL,
  `code_description` Char(50) NOT NULL
)
;

ALTER TABLE `resubmission_code_lk` ADD  PRIMARY KEY (`resubmission_code`)
;

-- Table provider_qualifier_id_lk

CREATE TABLE `provider_qualifier_id_lk`
(
  `prov_qualifier_id` Char(3) NOT NULL,
  `qualifier_description` Char(50) NOT NULL
)
;

ALTER TABLE `provider_qualifier_id_lk` ADD  PRIMARY KEY (`prov_qualifier_id`)
;

-- Table medical_qualifier_code_lk

CREATE TABLE `medical_qualifier_code_lk`
(
  `medical_qualifier_code` Int(3) NOT NULL,
  `qualifier_description` Char(50) NOT NULL
)
;

ALTER TABLE `medical_qualifier_code_lk` ADD  PRIMARY KEY (`medical_qualifier_code`)
;

-- Create relationships section ------------------------------------------------- 

ALTER TABLE `claims_account` ADD CONSTRAINT `claims_account_details` FOREIGN KEY (`cid`) REFERENCES `claims` (`cid`) ON DELETE RESTRICT ON UPDATE RESTRICT
;

ALTER TABLE `medical_service` ADD CONSTRAINT `claims_medical_services` FOREIGN KEY (`cid`) REFERENCES `claims` (`cid`) ON DELETE RESTRICT ON UPDATE RESTRICT
;

ALTER TABLE `claims_hospital_info` ADD CONSTRAINT `claims_hospital_info` FOREIGN KEY (`cid`) REFERENCES `claims` (`cid`) ON DELETE RESTRICT ON UPDATE RESTRICT
;

ALTER TABLE `member_policies` ADD CONSTRAINT `member_policy` FOREIGN KEY (`mid`) REFERENCES `member` (`mid`) ON DELETE RESTRICT ON UPDATE RESTRICT
;

ALTER TABLE `member_policies` ADD CONSTRAINT `policy_members` FOREIGN KEY (`polid`) REFERENCES `insurance_policy` (`polid`) ON DELETE RESTRICT ON UPDATE RESTRICT
;

ALTER TABLE `member` ADD CONSTRAINT `member_address` FOREIGN KEY (`aid`) REFERENCES `address_lk` (`aid`) ON DELETE RESTRICT ON UPDATE RESTRICT
;

ALTER TABLE `member_policies` ADD CONSTRAINT `claims_and_policies` FOREIGN KEY (`cid`) REFERENCES `claims` (`cid`) ON DELETE RESTRICT ON UPDATE RESTRICT
;

ALTER TABLE `claim_signs` ADD CONSTRAINT `claims_signatures` FOREIGN KEY (`cid`) REFERENCES `claims` (`cid`) ON DELETE RESTRICT ON UPDATE RESTRICT
;

ALTER TABLE `insurance_policy` ADD CONSTRAINT `group_policy_lookup` FOREIGN KEY (`group_policy_id`) REFERENCES `group_policy_lk` (`group_policy_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
;

ALTER TABLE `medical_service` ADD CONSTRAINT `CPT_HCPCS_code_lookup` FOREIGN KEY (`CPT_HCPCS_code`) REFERENCES `CPT_HCPS_code_lk` (`CPT_HCPCS_code`) ON DELETE RESTRICT ON UPDATE RESTRICT
;

ALTER TABLE `medical_service` ADD CONSTRAINT `modifier_lookup` FOREIGN KEY (`modifier`) REFERENCES `modifier_lk` (`modifier_code`) ON DELETE RESTRICT ON UPDATE RESTRICT
;

ALTER TABLE `medical_service` ADD CONSTRAINT `place_of_service_lookup` FOREIGN KEY (`place_of_service`) REFERENCES `place_of_service_lk` (`place_of_service`) ON DELETE RESTRICT ON UPDATE RESTRICT
;

ALTER TABLE `claims_ICD_codes` ADD CONSTRAINT `ICD_code_description` FOREIGN KEY (`ICD_code`) REFERENCES `ICD_code_desc` (`ICD_code`) ON DELETE RESTRICT ON UPDATE RESTRICT
;

ALTER TABLE `claims_ICD_codes` ADD CONSTRAINT `claims_ICD_codes` FOREIGN KEY (`cid`) REFERENCES `claims` (`cid`) ON DELETE RESTRICT ON UPDATE RESTRICT
;

ALTER TABLE `claims` ADD CONSTRAINT `medical_qualifier_code_lookup` FOREIGN KEY (`medical_qualifier_code`) REFERENCES `medical_qualifier_code_lk` (`medical_qualifier_code`) ON DELETE RESTRICT ON UPDATE RESTRICT
;

ALTER TABLE `medical_service` ADD CONSTRAINT `provider_qualifier_id_lookup` FOREIGN KEY (`prov_qualifier_id`) REFERENCES `provider_qualifier_id_lk` (`prov_qualifier_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
;

ALTER TABLE `claims` ADD CONSTRAINT `resubmission_code_lookup` FOREIGN KEY (`resubmission_code`) REFERENCES `resubmission_code_lk` (`resubmission_code`) ON DELETE RESTRICT ON UPDATE RESTRICT
;

ALTER TABLE `member` ADD CONSTRAINT `member_insured` FOREIGN KEY (`insid`) REFERENCES `member` (`mid`) ON DELETE RESTRICT ON UPDATE RESTRICT
;

