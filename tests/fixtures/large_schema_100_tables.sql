-- Auto-generated 100-table schema for testing
SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS companies;
CREATE TABLE companies (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    users_id INT,
    FOREIGN KEY (users_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS departments;
CREATE TABLE departments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    companies_id INT,
    FOREIGN KEY (companies_id) REFERENCES companies(id)
);

DROP TABLE IF EXISTS regions;
CREATE TABLE regions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    departments_id INT,
    users_id INT,
    FOREIGN KEY (departments_id) REFERENCES departments(id),
    FOREIGN KEY (users_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS categories;
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    regions_id INT,
    users_id INT,
    FOREIGN KEY (regions_id) REFERENCES regions(id),
    FOREIGN KEY (users_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS domain_entity_6;
CREATE TABLE domain_entity_6 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    categories_id INT,
    departments_id INT,
    FOREIGN KEY (categories_id) REFERENCES categories(id),
    FOREIGN KEY (departments_id) REFERENCES departments(id)
);

DROP TABLE IF EXISTS domain_entity_7;
CREATE TABLE domain_entity_7 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_6_id INT,
    users_id INT,
    FOREIGN KEY (domain_entity_6_id) REFERENCES domain_entity_6(id),
    FOREIGN KEY (users_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS domain_entity_8;
CREATE TABLE domain_entity_8 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_7_id INT,
    companies_id INT,
    FOREIGN KEY (domain_entity_7_id) REFERENCES domain_entity_7(id),
    FOREIGN KEY (companies_id) REFERENCES companies(id)
);

DROP TABLE IF EXISTS domain_entity_9;
CREATE TABLE domain_entity_9 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_8_id INT,
    domain_entity_6_id INT,
    FOREIGN KEY (domain_entity_8_id) REFERENCES domain_entity_8(id),
    FOREIGN KEY (domain_entity_6_id) REFERENCES domain_entity_6(id)
);

DROP TABLE IF EXISTS domain_entity_10;
CREATE TABLE domain_entity_10 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_9_id INT,
    users_id INT,
    FOREIGN KEY (domain_entity_9_id) REFERENCES domain_entity_9(id),
    FOREIGN KEY (users_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS domain_entity_11;
CREATE TABLE domain_entity_11 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_10_id INT,
    companies_id INT,
    FOREIGN KEY (domain_entity_10_id) REFERENCES domain_entity_10(id),
    FOREIGN KEY (companies_id) REFERENCES companies(id)
);

DROP TABLE IF EXISTS domain_entity_12;
CREATE TABLE domain_entity_12 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_11_id INT,
    domain_entity_7_id INT,
    FOREIGN KEY (domain_entity_11_id) REFERENCES domain_entity_11(id),
    FOREIGN KEY (domain_entity_7_id) REFERENCES domain_entity_7(id)
);

DROP TABLE IF EXISTS domain_entity_13;
CREATE TABLE domain_entity_13 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_12_id INT,
    companies_id INT,
    FOREIGN KEY (domain_entity_12_id) REFERENCES domain_entity_12(id),
    FOREIGN KEY (companies_id) REFERENCES companies(id)
);

DROP TABLE IF EXISTS domain_entity_14;
CREATE TABLE domain_entity_14 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_13_id INT,
    domain_entity_9_id INT,
    FOREIGN KEY (domain_entity_13_id) REFERENCES domain_entity_13(id),
    FOREIGN KEY (domain_entity_9_id) REFERENCES domain_entity_9(id)
);

DROP TABLE IF EXISTS domain_entity_15;
CREATE TABLE domain_entity_15 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_14_id INT,
    domain_entity_7_id INT,
    FOREIGN KEY (domain_entity_14_id) REFERENCES domain_entity_14(id),
    FOREIGN KEY (domain_entity_7_id) REFERENCES domain_entity_7(id)
);

DROP TABLE IF EXISTS domain_entity_16;
CREATE TABLE domain_entity_16 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_15_id INT,
    domain_entity_7_id INT,
    FOREIGN KEY (domain_entity_15_id) REFERENCES domain_entity_15(id),
    FOREIGN KEY (domain_entity_7_id) REFERENCES domain_entity_7(id)
);

DROP TABLE IF EXISTS domain_entity_17;
CREATE TABLE domain_entity_17 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_16_id INT,
    domain_entity_13_id INT,
    FOREIGN KEY (domain_entity_16_id) REFERENCES domain_entity_16(id),
    FOREIGN KEY (domain_entity_13_id) REFERENCES domain_entity_13(id)
);

DROP TABLE IF EXISTS domain_entity_18;
CREATE TABLE domain_entity_18 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_17_id INT,
    regions_id INT,
    FOREIGN KEY (domain_entity_17_id) REFERENCES domain_entity_17(id),
    FOREIGN KEY (regions_id) REFERENCES regions(id)
);

DROP TABLE IF EXISTS domain_entity_19;
CREATE TABLE domain_entity_19 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_18_id INT,
    departments_id INT,
    FOREIGN KEY (domain_entity_18_id) REFERENCES domain_entity_18(id),
    FOREIGN KEY (departments_id) REFERENCES departments(id)
);

DROP TABLE IF EXISTS domain_entity_20;
CREATE TABLE domain_entity_20 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_19_id INT,
    domain_entity_17_id INT,
    FOREIGN KEY (domain_entity_19_id) REFERENCES domain_entity_19(id),
    FOREIGN KEY (domain_entity_17_id) REFERENCES domain_entity_17(id)
);

DROP TABLE IF EXISTS domain_entity_21;
CREATE TABLE domain_entity_21 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_20_id INT,
    companies_id INT,
    FOREIGN KEY (domain_entity_20_id) REFERENCES domain_entity_20(id),
    FOREIGN KEY (companies_id) REFERENCES companies(id)
);

DROP TABLE IF EXISTS domain_entity_22;
CREATE TABLE domain_entity_22 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_21_id INT,
    domain_entity_8_id INT,
    FOREIGN KEY (domain_entity_21_id) REFERENCES domain_entity_21(id),
    FOREIGN KEY (domain_entity_8_id) REFERENCES domain_entity_8(id)
);

DROP TABLE IF EXISTS domain_entity_23;
CREATE TABLE domain_entity_23 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_22_id INT,
    domain_entity_18_id INT,
    FOREIGN KEY (domain_entity_22_id) REFERENCES domain_entity_22(id),
    FOREIGN KEY (domain_entity_18_id) REFERENCES domain_entity_18(id)
);

DROP TABLE IF EXISTS domain_entity_24;
CREATE TABLE domain_entity_24 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_23_id INT,
    domain_entity_12_id INT,
    FOREIGN KEY (domain_entity_23_id) REFERENCES domain_entity_23(id),
    FOREIGN KEY (domain_entity_12_id) REFERENCES domain_entity_12(id)
);

DROP TABLE IF EXISTS domain_entity_25;
CREATE TABLE domain_entity_25 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_24_id INT,
    companies_id INT,
    FOREIGN KEY (domain_entity_24_id) REFERENCES domain_entity_24(id),
    FOREIGN KEY (companies_id) REFERENCES companies(id)
);

DROP TABLE IF EXISTS domain_entity_26;
CREATE TABLE domain_entity_26 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_25_id INT,
    domain_entity_9_id INT,
    FOREIGN KEY (domain_entity_25_id) REFERENCES domain_entity_25(id),
    FOREIGN KEY (domain_entity_9_id) REFERENCES domain_entity_9(id)
);

DROP TABLE IF EXISTS domain_entity_27;
CREATE TABLE domain_entity_27 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_26_id INT,
    domain_entity_6_id INT,
    FOREIGN KEY (domain_entity_26_id) REFERENCES domain_entity_26(id),
    FOREIGN KEY (domain_entity_6_id) REFERENCES domain_entity_6(id)
);

DROP TABLE IF EXISTS domain_entity_28;
CREATE TABLE domain_entity_28 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_27_id INT,
    domain_entity_12_id INT,
    FOREIGN KEY (domain_entity_27_id) REFERENCES domain_entity_27(id),
    FOREIGN KEY (domain_entity_12_id) REFERENCES domain_entity_12(id)
);

DROP TABLE IF EXISTS domain_entity_29;
CREATE TABLE domain_entity_29 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_28_id INT,
    domain_entity_17_id INT,
    FOREIGN KEY (domain_entity_28_id) REFERENCES domain_entity_28(id),
    FOREIGN KEY (domain_entity_17_id) REFERENCES domain_entity_17(id)
);

DROP TABLE IF EXISTS domain_entity_30;
CREATE TABLE domain_entity_30 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_29_id INT,
    domain_entity_14_id INT,
    FOREIGN KEY (domain_entity_29_id) REFERENCES domain_entity_29(id),
    FOREIGN KEY (domain_entity_14_id) REFERENCES domain_entity_14(id)
);

DROP TABLE IF EXISTS domain_entity_31;
CREATE TABLE domain_entity_31 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_30_id INT,
    domain_entity_25_id INT,
    FOREIGN KEY (domain_entity_30_id) REFERENCES domain_entity_30(id),
    FOREIGN KEY (domain_entity_25_id) REFERENCES domain_entity_25(id)
);

DROP TABLE IF EXISTS domain_entity_32;
CREATE TABLE domain_entity_32 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_31_id INT,
    domain_entity_20_id INT,
    FOREIGN KEY (domain_entity_31_id) REFERENCES domain_entity_31(id),
    FOREIGN KEY (domain_entity_20_id) REFERENCES domain_entity_20(id)
);

DROP TABLE IF EXISTS domain_entity_33;
CREATE TABLE domain_entity_33 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_32_id INT,
    domain_entity_6_id INT,
    FOREIGN KEY (domain_entity_32_id) REFERENCES domain_entity_32(id),
    FOREIGN KEY (domain_entity_6_id) REFERENCES domain_entity_6(id)
);

DROP TABLE IF EXISTS domain_entity_34;
CREATE TABLE domain_entity_34 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_33_id INT,
    domain_entity_13_id INT,
    FOREIGN KEY (domain_entity_33_id) REFERENCES domain_entity_33(id),
    FOREIGN KEY (domain_entity_13_id) REFERENCES domain_entity_13(id)
);

DROP TABLE IF EXISTS domain_entity_35;
CREATE TABLE domain_entity_35 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_34_id INT,
    companies_id INT,
    FOREIGN KEY (domain_entity_34_id) REFERENCES domain_entity_34(id),
    FOREIGN KEY (companies_id) REFERENCES companies(id)
);

DROP TABLE IF EXISTS domain_entity_36;
CREATE TABLE domain_entity_36 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_35_id INT,
    domain_entity_31_id INT,
    FOREIGN KEY (domain_entity_35_id) REFERENCES domain_entity_35(id),
    FOREIGN KEY (domain_entity_31_id) REFERENCES domain_entity_31(id)
);

DROP TABLE IF EXISTS domain_entity_37;
CREATE TABLE domain_entity_37 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_36_id INT,
    domain_entity_23_id INT,
    FOREIGN KEY (domain_entity_36_id) REFERENCES domain_entity_36(id),
    FOREIGN KEY (domain_entity_23_id) REFERENCES domain_entity_23(id)
);

DROP TABLE IF EXISTS domain_entity_38;
CREATE TABLE domain_entity_38 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_37_id INT,
    domain_entity_27_id INT,
    FOREIGN KEY (domain_entity_37_id) REFERENCES domain_entity_37(id),
    FOREIGN KEY (domain_entity_27_id) REFERENCES domain_entity_27(id)
);

DROP TABLE IF EXISTS domain_entity_39;
CREATE TABLE domain_entity_39 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_38_id INT,
    domain_entity_12_id INT,
    FOREIGN KEY (domain_entity_38_id) REFERENCES domain_entity_38(id),
    FOREIGN KEY (domain_entity_12_id) REFERENCES domain_entity_12(id)
);

DROP TABLE IF EXISTS domain_entity_40;
CREATE TABLE domain_entity_40 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_39_id INT,
    departments_id INT,
    FOREIGN KEY (domain_entity_39_id) REFERENCES domain_entity_39(id),
    FOREIGN KEY (departments_id) REFERENCES departments(id)
);

DROP TABLE IF EXISTS domain_entity_41;
CREATE TABLE domain_entity_41 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_40_id INT,
    categories_id INT,
    FOREIGN KEY (domain_entity_40_id) REFERENCES domain_entity_40(id),
    FOREIGN KEY (categories_id) REFERENCES categories(id)
);

DROP TABLE IF EXISTS domain_entity_42;
CREATE TABLE domain_entity_42 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_41_id INT,
    domain_entity_25_id INT,
    FOREIGN KEY (domain_entity_41_id) REFERENCES domain_entity_41(id),
    FOREIGN KEY (domain_entity_25_id) REFERENCES domain_entity_25(id)
);

DROP TABLE IF EXISTS domain_entity_43;
CREATE TABLE domain_entity_43 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_42_id INT,
    departments_id INT,
    FOREIGN KEY (domain_entity_42_id) REFERENCES domain_entity_42(id),
    FOREIGN KEY (departments_id) REFERENCES departments(id)
);

DROP TABLE IF EXISTS domain_entity_44;
CREATE TABLE domain_entity_44 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_43_id INT,
    domain_entity_10_id INT,
    FOREIGN KEY (domain_entity_43_id) REFERENCES domain_entity_43(id),
    FOREIGN KEY (domain_entity_10_id) REFERENCES domain_entity_10(id)
);

DROP TABLE IF EXISTS domain_entity_45;
CREATE TABLE domain_entity_45 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_44_id INT,
    domain_entity_18_id INT,
    FOREIGN KEY (domain_entity_44_id) REFERENCES domain_entity_44(id),
    FOREIGN KEY (domain_entity_18_id) REFERENCES domain_entity_18(id)
);

DROP TABLE IF EXISTS domain_entity_46;
CREATE TABLE domain_entity_46 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_45_id INT,
    domain_entity_24_id INT,
    FOREIGN KEY (domain_entity_45_id) REFERENCES domain_entity_45(id),
    FOREIGN KEY (domain_entity_24_id) REFERENCES domain_entity_24(id)
);

DROP TABLE IF EXISTS domain_entity_47;
CREATE TABLE domain_entity_47 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_46_id INT,
    domain_entity_10_id INT,
    FOREIGN KEY (domain_entity_46_id) REFERENCES domain_entity_46(id),
    FOREIGN KEY (domain_entity_10_id) REFERENCES domain_entity_10(id)
);

DROP TABLE IF EXISTS domain_entity_48;
CREATE TABLE domain_entity_48 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_47_id INT,
    domain_entity_34_id INT,
    FOREIGN KEY (domain_entity_47_id) REFERENCES domain_entity_47(id),
    FOREIGN KEY (domain_entity_34_id) REFERENCES domain_entity_34(id)
);

DROP TABLE IF EXISTS domain_entity_49;
CREATE TABLE domain_entity_49 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_48_id INT,
    domain_entity_15_id INT,
    FOREIGN KEY (domain_entity_48_id) REFERENCES domain_entity_48(id),
    FOREIGN KEY (domain_entity_15_id) REFERENCES domain_entity_15(id)
);

DROP TABLE IF EXISTS domain_entity_50;
CREATE TABLE domain_entity_50 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_49_id INT,
    domain_entity_32_id INT,
    FOREIGN KEY (domain_entity_49_id) REFERENCES domain_entity_49(id),
    FOREIGN KEY (domain_entity_32_id) REFERENCES domain_entity_32(id)
);

DROP TABLE IF EXISTS domain_entity_51;
CREATE TABLE domain_entity_51 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_50_id INT,
    domain_entity_41_id INT,
    FOREIGN KEY (domain_entity_50_id) REFERENCES domain_entity_50(id),
    FOREIGN KEY (domain_entity_41_id) REFERENCES domain_entity_41(id)
);

DROP TABLE IF EXISTS domain_entity_52;
CREATE TABLE domain_entity_52 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_51_id INT,
    domain_entity_21_id INT,
    FOREIGN KEY (domain_entity_51_id) REFERENCES domain_entity_51(id),
    FOREIGN KEY (domain_entity_21_id) REFERENCES domain_entity_21(id)
);

DROP TABLE IF EXISTS domain_entity_53;
CREATE TABLE domain_entity_53 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_52_id INT,
    domain_entity_25_id INT,
    FOREIGN KEY (domain_entity_52_id) REFERENCES domain_entity_52(id),
    FOREIGN KEY (domain_entity_25_id) REFERENCES domain_entity_25(id)
);

DROP TABLE IF EXISTS domain_entity_54;
CREATE TABLE domain_entity_54 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_53_id INT,
    domain_entity_39_id INT,
    FOREIGN KEY (domain_entity_53_id) REFERENCES domain_entity_53(id),
    FOREIGN KEY (domain_entity_39_id) REFERENCES domain_entity_39(id)
);

DROP TABLE IF EXISTS domain_entity_55;
CREATE TABLE domain_entity_55 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_54_id INT,
    domain_entity_9_id INT,
    FOREIGN KEY (domain_entity_54_id) REFERENCES domain_entity_54(id),
    FOREIGN KEY (domain_entity_9_id) REFERENCES domain_entity_9(id)
);

DROP TABLE IF EXISTS domain_entity_56;
CREATE TABLE domain_entity_56 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_55_id INT,
    domain_entity_21_id INT,
    FOREIGN KEY (domain_entity_55_id) REFERENCES domain_entity_55(id),
    FOREIGN KEY (domain_entity_21_id) REFERENCES domain_entity_21(id)
);

DROP TABLE IF EXISTS domain_entity_57;
CREATE TABLE domain_entity_57 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_56_id INT,
    domain_entity_47_id INT,
    FOREIGN KEY (domain_entity_56_id) REFERENCES domain_entity_56(id),
    FOREIGN KEY (domain_entity_47_id) REFERENCES domain_entity_47(id)
);

DROP TABLE IF EXISTS domain_entity_58;
CREATE TABLE domain_entity_58 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_57_id INT,
    domain_entity_55_id INT,
    FOREIGN KEY (domain_entity_57_id) REFERENCES domain_entity_57(id),
    FOREIGN KEY (domain_entity_55_id) REFERENCES domain_entity_55(id)
);

DROP TABLE IF EXISTS domain_entity_59;
CREATE TABLE domain_entity_59 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_58_id INT,
    domain_entity_30_id INT,
    FOREIGN KEY (domain_entity_58_id) REFERENCES domain_entity_58(id),
    FOREIGN KEY (domain_entity_30_id) REFERENCES domain_entity_30(id)
);

DROP TABLE IF EXISTS domain_entity_60;
CREATE TABLE domain_entity_60 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_59_id INT,
    domain_entity_48_id INT,
    FOREIGN KEY (domain_entity_59_id) REFERENCES domain_entity_59(id),
    FOREIGN KEY (domain_entity_48_id) REFERENCES domain_entity_48(id)
);

DROP TABLE IF EXISTS domain_entity_61;
CREATE TABLE domain_entity_61 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_60_id INT,
    domain_entity_6_id INT,
    FOREIGN KEY (domain_entity_60_id) REFERENCES domain_entity_60(id),
    FOREIGN KEY (domain_entity_6_id) REFERENCES domain_entity_6(id)
);

DROP TABLE IF EXISTS domain_entity_62;
CREATE TABLE domain_entity_62 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_61_id INT,
    domain_entity_44_id INT,
    FOREIGN KEY (domain_entity_61_id) REFERENCES domain_entity_61(id),
    FOREIGN KEY (domain_entity_44_id) REFERENCES domain_entity_44(id)
);

DROP TABLE IF EXISTS domain_entity_63;
CREATE TABLE domain_entity_63 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_62_id INT,
    domain_entity_60_id INT,
    FOREIGN KEY (domain_entity_62_id) REFERENCES domain_entity_62(id),
    FOREIGN KEY (domain_entity_60_id) REFERENCES domain_entity_60(id)
);

DROP TABLE IF EXISTS domain_entity_64;
CREATE TABLE domain_entity_64 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_63_id INT,
    domain_entity_46_id INT,
    FOREIGN KEY (domain_entity_63_id) REFERENCES domain_entity_63(id),
    FOREIGN KEY (domain_entity_46_id) REFERENCES domain_entity_46(id)
);

DROP TABLE IF EXISTS domain_entity_65;
CREATE TABLE domain_entity_65 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_64_id INT,
    categories_id INT,
    FOREIGN KEY (domain_entity_64_id) REFERENCES domain_entity_64(id),
    FOREIGN KEY (categories_id) REFERENCES categories(id)
);

DROP TABLE IF EXISTS domain_entity_66;
CREATE TABLE domain_entity_66 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_65_id INT,
    domain_entity_53_id INT,
    FOREIGN KEY (domain_entity_65_id) REFERENCES domain_entity_65(id),
    FOREIGN KEY (domain_entity_53_id) REFERENCES domain_entity_53(id)
);

DROP TABLE IF EXISTS domain_entity_67;
CREATE TABLE domain_entity_67 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_66_id INT,
    domain_entity_24_id INT,
    FOREIGN KEY (domain_entity_66_id) REFERENCES domain_entity_66(id),
    FOREIGN KEY (domain_entity_24_id) REFERENCES domain_entity_24(id)
);

DROP TABLE IF EXISTS domain_entity_68;
CREATE TABLE domain_entity_68 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_67_id INT,
    domain_entity_61_id INT,
    FOREIGN KEY (domain_entity_67_id) REFERENCES domain_entity_67(id),
    FOREIGN KEY (domain_entity_61_id) REFERENCES domain_entity_61(id)
);

DROP TABLE IF EXISTS domain_entity_69;
CREATE TABLE domain_entity_69 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_68_id INT,
    domain_entity_21_id INT,
    FOREIGN KEY (domain_entity_68_id) REFERENCES domain_entity_68(id),
    FOREIGN KEY (domain_entity_21_id) REFERENCES domain_entity_21(id)
);

DROP TABLE IF EXISTS domain_entity_70;
CREATE TABLE domain_entity_70 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_69_id INT,
    categories_id INT,
    FOREIGN KEY (domain_entity_69_id) REFERENCES domain_entity_69(id),
    FOREIGN KEY (categories_id) REFERENCES categories(id)
);

DROP TABLE IF EXISTS domain_entity_71;
CREATE TABLE domain_entity_71 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_70_id INT,
    domain_entity_56_id INT,
    FOREIGN KEY (domain_entity_70_id) REFERENCES domain_entity_70(id),
    FOREIGN KEY (domain_entity_56_id) REFERENCES domain_entity_56(id)
);

DROP TABLE IF EXISTS domain_entity_72;
CREATE TABLE domain_entity_72 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_71_id INT,
    domain_entity_33_id INT,
    FOREIGN KEY (domain_entity_71_id) REFERENCES domain_entity_71(id),
    FOREIGN KEY (domain_entity_33_id) REFERENCES domain_entity_33(id)
);

DROP TABLE IF EXISTS domain_entity_73;
CREATE TABLE domain_entity_73 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_72_id INT,
    domain_entity_36_id INT,
    FOREIGN KEY (domain_entity_72_id) REFERENCES domain_entity_72(id),
    FOREIGN KEY (domain_entity_36_id) REFERENCES domain_entity_36(id)
);

DROP TABLE IF EXISTS domain_entity_74;
CREATE TABLE domain_entity_74 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_73_id INT,
    domain_entity_56_id INT,
    FOREIGN KEY (domain_entity_73_id) REFERENCES domain_entity_73(id),
    FOREIGN KEY (domain_entity_56_id) REFERENCES domain_entity_56(id)
);

DROP TABLE IF EXISTS domain_entity_75;
CREATE TABLE domain_entity_75 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_74_id INT,
    domain_entity_60_id INT,
    FOREIGN KEY (domain_entity_74_id) REFERENCES domain_entity_74(id),
    FOREIGN KEY (domain_entity_60_id) REFERENCES domain_entity_60(id)
);

DROP TABLE IF EXISTS domain_entity_76;
CREATE TABLE domain_entity_76 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_75_id INT,
    domain_entity_21_id INT,
    FOREIGN KEY (domain_entity_75_id) REFERENCES domain_entity_75(id),
    FOREIGN KEY (domain_entity_21_id) REFERENCES domain_entity_21(id)
);

DROP TABLE IF EXISTS domain_entity_77;
CREATE TABLE domain_entity_77 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_76_id INT,
    domain_entity_27_id INT,
    FOREIGN KEY (domain_entity_76_id) REFERENCES domain_entity_76(id),
    FOREIGN KEY (domain_entity_27_id) REFERENCES domain_entity_27(id)
);

DROP TABLE IF EXISTS domain_entity_78;
CREATE TABLE domain_entity_78 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_77_id INT,
    domain_entity_15_id INT,
    FOREIGN KEY (domain_entity_77_id) REFERENCES domain_entity_77(id),
    FOREIGN KEY (domain_entity_15_id) REFERENCES domain_entity_15(id)
);

DROP TABLE IF EXISTS domain_entity_79;
CREATE TABLE domain_entity_79 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_78_id INT,
    departments_id INT,
    FOREIGN KEY (domain_entity_78_id) REFERENCES domain_entity_78(id),
    FOREIGN KEY (departments_id) REFERENCES departments(id)
);

DROP TABLE IF EXISTS domain_entity_80;
CREATE TABLE domain_entity_80 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_79_id INT,
    domain_entity_26_id INT,
    FOREIGN KEY (domain_entity_79_id) REFERENCES domain_entity_79(id),
    FOREIGN KEY (domain_entity_26_id) REFERENCES domain_entity_26(id)
);

DROP TABLE IF EXISTS domain_entity_81;
CREATE TABLE domain_entity_81 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_80_id INT,
    domain_entity_60_id INT,
    FOREIGN KEY (domain_entity_80_id) REFERENCES domain_entity_80(id),
    FOREIGN KEY (domain_entity_60_id) REFERENCES domain_entity_60(id)
);

DROP TABLE IF EXISTS domain_entity_82;
CREATE TABLE domain_entity_82 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_81_id INT,
    domain_entity_67_id INT,
    FOREIGN KEY (domain_entity_81_id) REFERENCES domain_entity_81(id),
    FOREIGN KEY (domain_entity_67_id) REFERENCES domain_entity_67(id)
);

DROP TABLE IF EXISTS domain_entity_83;
CREATE TABLE domain_entity_83 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_82_id INT,
    domain_entity_28_id INT,
    FOREIGN KEY (domain_entity_82_id) REFERENCES domain_entity_82(id),
    FOREIGN KEY (domain_entity_28_id) REFERENCES domain_entity_28(id)
);

DROP TABLE IF EXISTS domain_entity_84;
CREATE TABLE domain_entity_84 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_83_id INT,
    domain_entity_75_id INT,
    FOREIGN KEY (domain_entity_83_id) REFERENCES domain_entity_83(id),
    FOREIGN KEY (domain_entity_75_id) REFERENCES domain_entity_75(id)
);

DROP TABLE IF EXISTS domain_entity_85;
CREATE TABLE domain_entity_85 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_84_id INT,
    domain_entity_58_id INT,
    FOREIGN KEY (domain_entity_84_id) REFERENCES domain_entity_84(id),
    FOREIGN KEY (domain_entity_58_id) REFERENCES domain_entity_58(id)
);

DROP TABLE IF EXISTS domain_entity_86;
CREATE TABLE domain_entity_86 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_85_id INT,
    domain_entity_67_id INT,
    FOREIGN KEY (domain_entity_85_id) REFERENCES domain_entity_85(id),
    FOREIGN KEY (domain_entity_67_id) REFERENCES domain_entity_67(id)
);

DROP TABLE IF EXISTS domain_entity_87;
CREATE TABLE domain_entity_87 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_86_id INT,
    domain_entity_33_id INT,
    FOREIGN KEY (domain_entity_86_id) REFERENCES domain_entity_86(id),
    FOREIGN KEY (domain_entity_33_id) REFERENCES domain_entity_33(id)
);

DROP TABLE IF EXISTS domain_entity_88;
CREATE TABLE domain_entity_88 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_87_id INT,
    domain_entity_76_id INT,
    FOREIGN KEY (domain_entity_87_id) REFERENCES domain_entity_87(id),
    FOREIGN KEY (domain_entity_76_id) REFERENCES domain_entity_76(id)
);

DROP TABLE IF EXISTS domain_entity_89;
CREATE TABLE domain_entity_89 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_88_id INT,
    domain_entity_30_id INT,
    FOREIGN KEY (domain_entity_88_id) REFERENCES domain_entity_88(id),
    FOREIGN KEY (domain_entity_30_id) REFERENCES domain_entity_30(id)
);

DROP TABLE IF EXISTS domain_entity_90;
CREATE TABLE domain_entity_90 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_89_id INT,
    domain_entity_81_id INT,
    FOREIGN KEY (domain_entity_89_id) REFERENCES domain_entity_89(id),
    FOREIGN KEY (domain_entity_81_id) REFERENCES domain_entity_81(id)
);

DROP TABLE IF EXISTS domain_entity_91;
CREATE TABLE domain_entity_91 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_90_id INT,
    domain_entity_40_id INT,
    FOREIGN KEY (domain_entity_90_id) REFERENCES domain_entity_90(id),
    FOREIGN KEY (domain_entity_40_id) REFERENCES domain_entity_40(id)
);

DROP TABLE IF EXISTS domain_entity_92;
CREATE TABLE domain_entity_92 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_91_id INT,
    domain_entity_14_id INT,
    FOREIGN KEY (domain_entity_91_id) REFERENCES domain_entity_91(id),
    FOREIGN KEY (domain_entity_14_id) REFERENCES domain_entity_14(id)
);

DROP TABLE IF EXISTS domain_entity_93;
CREATE TABLE domain_entity_93 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_92_id INT,
    domain_entity_20_id INT,
    FOREIGN KEY (domain_entity_92_id) REFERENCES domain_entity_92(id),
    FOREIGN KEY (domain_entity_20_id) REFERENCES domain_entity_20(id)
);

DROP TABLE IF EXISTS domain_entity_94;
CREATE TABLE domain_entity_94 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_93_id INT,
    domain_entity_44_id INT,
    FOREIGN KEY (domain_entity_93_id) REFERENCES domain_entity_93(id),
    FOREIGN KEY (domain_entity_44_id) REFERENCES domain_entity_44(id)
);

DROP TABLE IF EXISTS domain_entity_95;
CREATE TABLE domain_entity_95 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_94_id INT,
    domain_entity_79_id INT,
    FOREIGN KEY (domain_entity_94_id) REFERENCES domain_entity_94(id),
    FOREIGN KEY (domain_entity_79_id) REFERENCES domain_entity_79(id)
);

DROP TABLE IF EXISTS domain_entity_96;
CREATE TABLE domain_entity_96 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_95_id INT,
    domain_entity_70_id INT,
    FOREIGN KEY (domain_entity_95_id) REFERENCES domain_entity_95(id),
    FOREIGN KEY (domain_entity_70_id) REFERENCES domain_entity_70(id)
);

DROP TABLE IF EXISTS domain_entity_97;
CREATE TABLE domain_entity_97 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_96_id INT,
    domain_entity_26_id INT,
    FOREIGN KEY (domain_entity_96_id) REFERENCES domain_entity_96(id),
    FOREIGN KEY (domain_entity_26_id) REFERENCES domain_entity_26(id)
);

DROP TABLE IF EXISTS domain_entity_98;
CREATE TABLE domain_entity_98 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_97_id INT,
    domain_entity_45_id INT,
    FOREIGN KEY (domain_entity_97_id) REFERENCES domain_entity_97(id),
    FOREIGN KEY (domain_entity_45_id) REFERENCES domain_entity_45(id)
);

DROP TABLE IF EXISTS domain_entity_99;
CREATE TABLE domain_entity_99 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_98_id INT,
    domain_entity_43_id INT,
    FOREIGN KEY (domain_entity_98_id) REFERENCES domain_entity_98(id),
    FOREIGN KEY (domain_entity_43_id) REFERENCES domain_entity_43(id)
);

DROP TABLE IF EXISTS domain_entity_100;
CREATE TABLE domain_entity_100 (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    domain_entity_99_id INT,
    domain_entity_74_id INT,
    FOREIGN KEY (domain_entity_99_id) REFERENCES domain_entity_99(id),
    FOREIGN KEY (domain_entity_74_id) REFERENCES domain_entity_74(id)
);

SET FOREIGN_KEY_CHECKS=1;