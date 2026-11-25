-- E-commerce / Retail + Logistics benchmark schema

SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS delivery_proof;

DROP TABLE IF EXISTS review_votes;

DROP TABLE IF EXISTS delivery_stops;

DROP TABLE IF EXISTS ticket_messages;

DROP TABLE IF EXISTS reviews;

DROP TABLE IF EXISTS refunds;

DROP TABLE IF EXISTS return_items;

DROP TABLE IF EXISTS shipment_tracking_events;

DROP TABLE IF EXISTS shipment_items;

DROP TABLE IF EXISTS payment_refunds;

DROP TABLE IF EXISTS pos_transaction_items;

DROP TABLE IF EXISTS fraud_checks;

DROP TABLE IF EXISTS customer_support_tickets;

DROP TABLE IF EXISTS loyalty_transactions;

DROP TABLE IF EXISTS product_answers;

DROP TABLE IF EXISTS gift_card_transactions;

DROP TABLE IF EXISTS coupon_redemptions;

DROP TABLE IF EXISTS returns;

DROP TABLE IF EXISTS shipments;

DROP TABLE IF EXISTS payments;

DROP TABLE IF EXISTS order_discounts;

DROP TABLE IF EXISTS order_status_history;

DROP TABLE IF EXISTS order_items;

DROP TABLE IF EXISTS quality_inspections;

DROP TABLE IF EXISTS stock_reservations;

DROP TABLE IF EXISTS inventory_adjustments;

DROP TABLE IF EXISTS pos_transactions;

DROP TABLE IF EXISTS transfer_items;

DROP TABLE IF EXISTS store_inventory;

DROP TABLE IF EXISTS monthly_inventory_snapshot;

DROP TABLE IF EXISTS search_logs;

DROP TABLE IF EXISTS product_view_events;

DROP TABLE IF EXISTS product_questions;

DROP TABLE IF EXISTS orders;

DROP TABLE IF EXISTS wishlist_items;

DROP TABLE IF EXISTS cart_items;

DROP TABLE IF EXISTS receiving_batches;

DROP TABLE IF EXISTS purchase_order_items;

DROP TABLE IF EXISTS inventory_items;

DROP TABLE IF EXISTS price_history;

DROP TABLE IF EXISTS product_prices;

DROP TABLE IF EXISTS product_bundle_items;

DROP TABLE IF EXISTS product_variants;

DROP TABLE IF EXISTS product_images;

DROP TABLE IF EXISTS product_categories;

DROP TABLE IF EXISTS pos_registers;

DROP TABLE IF EXISTS store_transfers;

DROP TABLE IF EXISTS route_plans;

DROP TABLE IF EXISTS vendor_scorecards;

DROP TABLE IF EXISTS daily_sales_summary;

DROP TABLE IF EXISTS data_exports;

DROP TABLE IF EXISTS audit_logs;

DROP TABLE IF EXISTS ab_test_assignments;

DROP TABLE IF EXISTS web_sessions;

DROP TABLE IF EXISTS email_sends;

DROP TABLE IF EXISTS campaign_events;

DROP TABLE IF EXISTS gift_cards;

DROP TABLE IF EXISTS coupons;

DROP TABLE IF EXISTS shipping_methods;

DROP TABLE IF EXISTS payment_methods;

DROP TABLE IF EXISTS wishlists;

DROP TABLE IF EXISTS carts;

DROP TABLE IF EXISTS purchase_orders;

DROP TABLE IF EXISTS warehouse_zones;

DROP TABLE IF EXISTS products;

DROP TABLE IF EXISTS supplier_contacts;

DROP TABLE IF EXISTS customer_consents;

DROP TABLE IF EXISTS customer_notes;

DROP TABLE IF EXISTS addresses;

DROP TABLE IF EXISTS customer_profiles;

DROP TABLE IF EXISTS employee_store_assignments;

DROP TABLE IF EXISTS tax_rules;

DROP TABLE IF EXISTS ab_tests;

DROP TABLE IF EXISTS email_templates;

DROP TABLE IF EXISTS marketing_campaigns;

DROP TABLE IF EXISTS service_level_agreements;

DROP TABLE IF EXISTS loyalty_programs;

DROP TABLE IF EXISTS promotions;

DROP TABLE IF EXISTS carriers;

DROP TABLE IF EXISTS warehouses;

DROP TABLE IF EXISTS price_lists;

DROP TABLE IF EXISTS suppliers;

DROP TABLE IF EXISTS brands;

DROP TABLE IF EXISTS customers;

DROP TABLE IF EXISTS employees;

DROP TABLE IF EXISTS stores;

DROP TABLE IF EXISTS tax_regions;

DROP TABLE IF EXISTS risk_rules;

DROP TABLE IF EXISTS return_reasons;

DROP TABLE IF EXISTS product_bundles;

DROP TABLE IF EXISTS unit_types;

DROP TABLE IF EXISTS product_tax_codes;

DROP TABLE IF EXISTS categories;

DROP TABLE IF EXISTS customer_segments;

DROP TABLE IF EXISTS roles;

DROP TABLE IF EXISTS departments;

DROP TABLE IF EXISTS channels;

DROP TABLE IF EXISTS languages;

DROP TABLE IF EXISTS currencies;

DROP TABLE IF EXISTS countries;

SET FOREIGN_KEY_CHECKS=1;

CREATE TABLE countries (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  iso_code CHAR(2) NOT NULL,
  name VARCHAR(80) NOT NULL,
  region VARCHAR(50) NOT NULL,
  UNIQUE KEY uq_countries_iso (iso_code)
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for countries';

CREATE TABLE currencies (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  code CHAR(3) NOT NULL,
  name VARCHAR(80) NOT NULL,
  symbol VARCHAR(8) NOT NULL,
  UNIQUE KEY uq_currencies_code (code)
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for currencies';

CREATE TABLE languages (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(12) NOT NULL,
  name VARCHAR(80) NOT NULL,
  UNIQUE KEY uq_languages_code (code)
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for languages';

CREATE TABLE channels (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(80) NOT NULL,
  channel_type ENUM('web','mobile','marketplace','store') NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  UNIQUE KEY uq_channels_name (name)
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for channels';

CREATE TABLE departments (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  cost_center VARCHAR(40) NOT NULL,
  UNIQUE KEY uq_departments_cost_center (cost_center)
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for departments';

CREATE TABLE roles (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(80) NOT NULL,
  description TEXT NULL,
  UNIQUE KEY uq_roles_name (name)
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for roles';

CREATE TABLE customer_segments (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(80) NOT NULL,
  description TEXT NULL,
  UNIQUE KEY uq_customer_segments_name (name)
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for customer segments';

CREATE TABLE categories (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  parent_id BIGINT NULL,
  name VARCHAR(120) NOT NULL,
  slug VARCHAR(140) NOT NULL,
  UNIQUE KEY uq_categories_slug (slug),
  KEY idx_categories_parent (parent_id),
  CONSTRAINT fk_categories_parent_id FOREIGN KEY (parent_id) REFERENCES categories(id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for categories';

CREATE TABLE product_tax_codes (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(40) NOT NULL,
  description TEXT NULL,
  UNIQUE KEY uq_product_tax_codes_code (code)
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for product tax codes';

CREATE TABLE unit_types (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(20) NOT NULL,
  name VARCHAR(60) NOT NULL,
  UNIQUE KEY uq_unit_types_code (code)
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for unit types';

CREATE TABLE product_bundles (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(160) NOT NULL,
  description TEXT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  active BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for product bundles';

CREATE TABLE return_reasons (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_return_reasons_created_at (created_at)
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for return reasons';

CREATE TABLE risk_rules (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_risk_rules_created_at (created_at)
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for risk rules';

CREATE TABLE tax_regions (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  country_id BIGINT NOT NULL,
  name VARCHAR(80) NOT NULL,
  default_tax_rate DECIMAL(5,2) NOT NULL DEFAULT 0.00,
  CONSTRAINT fk_tax_regions_country_id FOREIGN KEY (country_id) REFERENCES countries(id) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for tax regions';

CREATE TABLE stores (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  country_id BIGINT NOT NULL,
  currency_id BIGINT NOT NULL,
  name VARCHAR(120) NOT NULL,
  opened_on DATE NOT NULL,
  CONSTRAINT fk_stores_country_id FOREIGN KEY (country_id) REFERENCES countries(id) ON DELETE RESTRICT,
  CONSTRAINT fk_stores_currency_id FOREIGN KEY (currency_id) REFERENCES currencies(id) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for stores';

CREATE TABLE employees (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  department_id BIGINT NULL,
  role_id BIGINT NOT NULL,
  manager_id BIGINT NULL,
  first_name VARCHAR(80) NOT NULL,
  last_name VARCHAR(80) NOT NULL,
  email VARCHAR(160) NOT NULL,
  hired_on DATE NOT NULL,
  salary DECIMAL(12,2) NOT NULL,
  UNIQUE KEY uq_employees_email (email),
  KEY idx_employees_manager (manager_id),
  CONSTRAINT fk_employees_department_id FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL,
  CONSTRAINT fk_employees_role_id FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE RESTRICT,
  CONSTRAINT fk_employees_manager_id FOREIGN KEY (manager_id) REFERENCES employees(id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for employees';

CREATE TABLE customers (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  segment_id BIGINT NULL,
  preferred_language_id BIGINT NULL,
  email VARCHAR(160) NOT NULL,
  first_name VARCHAR(80) NOT NULL,
  last_name VARCHAR(80) NULL,
  birth_date DATE NULL,
  created_at DATETIME NOT NULL,
  loyalty_points INT NOT NULL DEFAULT 0,
  metadata JSON NULL,
  UNIQUE KEY uq_customers_email (email),
  KEY idx_customers_created_at (created_at),
  CONSTRAINT fk_customers_segment_id FOREIGN KEY (segment_id) REFERENCES customer_segments(id) ON DELETE SET NULL,
  CONSTRAINT fk_customers_preferred_language_id FOREIGN KEY (preferred_language_id) REFERENCES languages(id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for customers';

CREATE TABLE brands (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  country_id BIGINT NULL,
  is_private_label BOOLEAN NOT NULL DEFAULT FALSE,
  UNIQUE KEY uq_brands_name (name),
  CONSTRAINT fk_brands_country_id FOREIGN KEY (country_id) REFERENCES countries(id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for brands';

CREATE TABLE suppliers (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  country_id BIGINT NOT NULL,
  name VARCHAR(160) NOT NULL,
  contact_email VARCHAR(160) NULL,
  risk_rating ENUM('low','medium','high') NOT NULL DEFAULT 'low',
  CONSTRAINT fk_suppliers_country_id FOREIGN KEY (country_id) REFERENCES countries(id) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for suppliers';

CREATE TABLE price_lists (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  currency_id BIGINT NOT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_price_lists_currency_id (currency_id),
  KEY idx_price_lists_created_at (created_at),
  CONSTRAINT fk_price_lists_currency_id FOREIGN KEY (currency_id) REFERENCES currencies(id) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for price lists';

CREATE TABLE warehouses (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  country_id BIGINT NOT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_warehouses_country_id (country_id),
  KEY idx_warehouses_created_at (created_at),
  CONSTRAINT fk_warehouses_country_id FOREIGN KEY (country_id) REFERENCES countries(id) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for warehouses';

CREATE TABLE carriers (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  country_id BIGINT NOT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_carriers_country_id (country_id),
  KEY idx_carriers_created_at (created_at),
  CONSTRAINT fk_carriers_country_id FOREIGN KEY (country_id) REFERENCES countries(id) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for carriers';

CREATE TABLE promotions (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  channel_id BIGINT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_promotions_channel_id (channel_id),
  KEY idx_promotions_created_at (created_at),
  CONSTRAINT fk_promotions_channel_id FOREIGN KEY (channel_id) REFERENCES channels(id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for promotions';

CREATE TABLE loyalty_programs (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  currency_id BIGINT NOT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_loyalty_programs_currency_id (currency_id),
  KEY idx_loyalty_programs_created_at (created_at),
  CONSTRAINT fk_loyalty_programs_currency_id FOREIGN KEY (currency_id) REFERENCES currencies(id) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for loyalty programs';

CREATE TABLE service_level_agreements (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  customer_segment_id BIGINT NOT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_service_level_agreements_customer_segment_id (customer_segment_id),
  KEY idx_service_level_agreements_created_at (created_at),
  CONSTRAINT fk_service_level_agreements_customer_segment_id FOREIGN KEY (customer_segment_id) REFERENCES customer_segments(id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for service level agreements';

CREATE TABLE marketing_campaigns (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  channel_id BIGINT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_marketing_campaigns_channel_id (channel_id),
  KEY idx_marketing_campaigns_created_at (created_at),
  CONSTRAINT fk_marketing_campaigns_channel_id FOREIGN KEY (channel_id) REFERENCES channels(id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for marketing campaigns';

CREATE TABLE email_templates (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  language_id BIGINT NOT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_email_templates_language_id (language_id),
  KEY idx_email_templates_created_at (created_at),
  CONSTRAINT fk_email_templates_language_id FOREIGN KEY (language_id) REFERENCES languages(id) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for email templates';

CREATE TABLE ab_tests (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  channel_id BIGINT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_ab_tests_channel_id (channel_id),
  KEY idx_ab_tests_created_at (created_at),
  CONSTRAINT fk_ab_tests_channel_id FOREIGN KEY (channel_id) REFERENCES channels(id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for ab tests';

CREATE TABLE tax_rules (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  tax_region_id BIGINT NOT NULL,
  product_tax_code VARCHAR(40) NOT NULL,
  tax_rate DECIMAL(5,2) NOT NULL,
  CONSTRAINT fk_tax_rules_tax_region_id FOREIGN KEY (tax_region_id) REFERENCES tax_regions(id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for tax rules';

CREATE TABLE employee_store_assignments (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  employee_id BIGINT NOT NULL,
  store_id BIGINT NOT NULL,
  started_on DATE NOT NULL,
  ended_on DATE NULL,
  UNIQUE KEY uq_employee_store_start (employee_id, store_id, started_on),
  CONSTRAINT fk_employee_store_assignments_employee_id FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE,
  CONSTRAINT fk_employee_store_assignments_store_id FOREIGN KEY (store_id) REFERENCES stores(id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for employee store assignments';

CREATE TABLE customer_profiles (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  customer_id BIGINT NOT NULL,
  gender ENUM('female','male','nonbinary','unknown') NOT NULL DEFAULT 'unknown',
  income_band VARCHAR(40) NULL,
  marketing_opt_in BOOLEAN NOT NULL DEFAULT TRUE,
  UNIQUE KEY uq_customer_profiles_customer (customer_id),
  CONSTRAINT fk_customer_profiles_customer_id FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for customer profiles';

CREATE TABLE addresses (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  customer_id BIGINT NULL,
  country_id BIGINT NOT NULL,
  line1 VARCHAR(160) NOT NULL,
  line2 VARCHAR(160) NULL,
  city VARCHAR(100) NOT NULL,
  state VARCHAR(100) NULL,
  postal_code VARCHAR(30) NOT NULL,
  address_type ENUM('billing','shipping','store','supplier') NOT NULL,
  CONSTRAINT fk_addresses_customer_id FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
  CONSTRAINT fk_addresses_country_id FOREIGN KEY (country_id) REFERENCES countries(id) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for addresses';

CREATE TABLE customer_notes (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  customer_id BIGINT NOT NULL,
  employee_id BIGINT NULL,
  note TEXT NOT NULL,
  created_at DATETIME NOT NULL,
  CONSTRAINT fk_customer_notes_customer_id FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
  CONSTRAINT fk_customer_notes_employee_id FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for customer notes';

CREATE TABLE customer_consents (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  customer_id BIGINT NOT NULL,
  consent_type VARCHAR(50) NOT NULL,
  granted BOOLEAN NOT NULL,
  updated_at DATETIME NOT NULL,
  UNIQUE KEY uq_customer_consent (customer_id, consent_type),
  CONSTRAINT fk_customer_consents_customer_id FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for customer consents';

CREATE TABLE supplier_contacts (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  supplier_id BIGINT NOT NULL,
  name VARCHAR(120) NOT NULL,
  email VARCHAR(160) NOT NULL,
  phone VARCHAR(40) NULL,
  CONSTRAINT fk_supplier_contacts_supplier_id FOREIGN KEY (supplier_id) REFERENCES suppliers(id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for supplier contacts';

CREATE TABLE products (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  brand_id BIGINT NOT NULL,
  supplier_id BIGINT NOT NULL,
  unit_type_id BIGINT NOT NULL,
  tax_code_id BIGINT NOT NULL,
  sku VARCHAR(64) NOT NULL,
  name VARCHAR(180) NOT NULL,
  description TEXT NULL,
  status ENUM('draft','active','discontinued') NOT NULL DEFAULT 'active',
  base_price DECIMAL(10,2) NOT NULL,
  weight DECIMAL(10,3) NULL,
  attributes JSON NULL,
  UNIQUE KEY uq_products_sku (sku),
  FULLTEXT KEY ft_products_name_desc (name, description),
  KEY idx_products_status_price (status, base_price),
  CHECK (base_price >= 0),
  CONSTRAINT fk_products_brand_id FOREIGN KEY (brand_id) REFERENCES brands(id) ON DELETE RESTRICT,
  CONSTRAINT fk_products_supplier_id FOREIGN KEY (supplier_id) REFERENCES suppliers(id) ON DELETE RESTRICT,
  CONSTRAINT fk_products_unit_type_id FOREIGN KEY (unit_type_id) REFERENCES unit_types(id) ON DELETE RESTRICT,
  CONSTRAINT fk_products_tax_code_id FOREIGN KEY (tax_code_id) REFERENCES product_tax_codes(id) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for products';

CREATE TABLE warehouse_zones (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  warehouse_id BIGINT NOT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_warehouse_zones_warehouse_id (warehouse_id),
  KEY idx_warehouse_zones_created_at (created_at),
  CONSTRAINT fk_warehouse_zones_warehouse_id FOREIGN KEY (warehouse_id) REFERENCES warehouses(id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for warehouse zones';

CREATE TABLE purchase_orders (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  supplier_id BIGINT NOT NULL,
  warehouse_id BIGINT NOT NULL,
  created_by_employee_id BIGINT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_purchase_orders_supplier_id (supplier_id),
  KEY idx_purchase_orders_warehouse_id (warehouse_id),
  KEY idx_purchase_orders_created_by_employee_id (created_by_employee_id),
  KEY idx_purchase_orders_created_at (created_at),
  CONSTRAINT fk_purchase_orders_supplier_id FOREIGN KEY (supplier_id) REFERENCES suppliers(id) ON DELETE RESTRICT,
  CONSTRAINT fk_purchase_orders_warehouse_id FOREIGN KEY (warehouse_id) REFERENCES warehouses(id) ON DELETE RESTRICT,
  CONSTRAINT fk_purchase_orders_created_by_employee_id FOREIGN KEY (created_by_employee_id) REFERENCES employees(id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for purchase orders';

CREATE TABLE carts (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  customer_id BIGINT NOT NULL,
  channel_id BIGINT NOT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_carts_customer_id (customer_id),
  KEY idx_carts_channel_id (channel_id),
  KEY idx_carts_created_at (created_at),
  CONSTRAINT fk_carts_customer_id FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
  CONSTRAINT fk_carts_channel_id FOREIGN KEY (channel_id) REFERENCES channels(id) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for carts';

CREATE TABLE wishlists (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  customer_id BIGINT NOT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_wishlists_customer_id (customer_id),
  KEY idx_wishlists_created_at (created_at),
  CONSTRAINT fk_wishlists_customer_id FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for wishlists';

CREATE TABLE payment_methods (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  customer_id BIGINT NOT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_payment_methods_customer_id (customer_id),
  KEY idx_payment_methods_created_at (created_at),
  CONSTRAINT fk_payment_methods_customer_id FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for payment methods';

CREATE TABLE shipping_methods (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  carrier_id BIGINT NOT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_shipping_methods_carrier_id (carrier_id),
  KEY idx_shipping_methods_created_at (created_at),
  CONSTRAINT fk_shipping_methods_carrier_id FOREIGN KEY (carrier_id) REFERENCES carriers(id) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for shipping methods';

CREATE TABLE coupons (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  promotion_id BIGINT NOT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_coupons_promotion_id (promotion_id),
  KEY idx_coupons_created_at (created_at),
  CONSTRAINT fk_coupons_promotion_id FOREIGN KEY (promotion_id) REFERENCES promotions(id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for coupons';

CREATE TABLE gift_cards (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  currency_id BIGINT NOT NULL,
  purchased_by_customer_id BIGINT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_gift_cards_currency_id (currency_id),
  KEY idx_gift_cards_purchased_by_customer_id (purchased_by_customer_id),
  KEY idx_gift_cards_created_at (created_at),
  CONSTRAINT fk_gift_cards_currency_id FOREIGN KEY (currency_id) REFERENCES currencies(id) ON DELETE RESTRICT,
  CONSTRAINT fk_gift_cards_purchased_by_customer_id FOREIGN KEY (purchased_by_customer_id) REFERENCES customers(id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for gift cards';

CREATE TABLE campaign_events (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  campaign_id BIGINT NOT NULL,
  customer_id BIGINT NOT NULL,
  event_type VARCHAR(80) NOT NULL,
  event_at DATETIME NOT NULL,
  details JSON NULL,
  KEY idx_campaign_events_campaign_id (campaign_id),
  KEY idx_campaign_events_customer_id (customer_id),
  CONSTRAINT fk_campaign_events_campaign_id FOREIGN KEY (campaign_id) REFERENCES marketing_campaigns(id) ON DELETE CASCADE,
  CONSTRAINT fk_campaign_events_customer_id FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for campaign events';

CREATE TABLE email_sends (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  template_id BIGINT NOT NULL,
  customer_id BIGINT NOT NULL,
  campaign_id BIGINT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_email_sends_template_id (template_id),
  KEY idx_email_sends_customer_id (customer_id),
  KEY idx_email_sends_campaign_id (campaign_id),
  KEY idx_email_sends_created_at (created_at),
  CONSTRAINT fk_email_sends_template_id FOREIGN KEY (template_id) REFERENCES email_templates(id) ON DELETE RESTRICT,
  CONSTRAINT fk_email_sends_customer_id FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE RESTRICT,
  CONSTRAINT fk_email_sends_campaign_id FOREIGN KEY (campaign_id) REFERENCES marketing_campaigns(id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for email sends';

CREATE TABLE web_sessions (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  customer_id BIGINT NULL,
  channel_id BIGINT NOT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_web_sessions_customer_id (customer_id),
  KEY idx_web_sessions_channel_id (channel_id),
  KEY idx_web_sessions_created_at (created_at),
  CONSTRAINT fk_web_sessions_customer_id FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE SET NULL,
  CONSTRAINT fk_web_sessions_channel_id FOREIGN KEY (channel_id) REFERENCES channels(id) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for web sessions';

CREATE TABLE ab_test_assignments (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  ab_test_id BIGINT NOT NULL,
  customer_id BIGINT NOT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_ab_test_assignments_ab_test_id (ab_test_id),
  KEY idx_ab_test_assignments_customer_id (customer_id),
  KEY idx_ab_test_assignments_created_at (created_at),
  CONSTRAINT fk_ab_test_assignments_ab_test_id FOREIGN KEY (ab_test_id) REFERENCES ab_tests(id) ON DELETE CASCADE,
  CONSTRAINT fk_ab_test_assignments_customer_id FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for ab test assignments';

CREATE TABLE audit_logs (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  employee_id BIGINT NULL,
  event_type VARCHAR(80) NOT NULL,
  event_at DATETIME NOT NULL,
  details JSON NULL,
  KEY idx_audit_logs_employee_id (employee_id),
  CONSTRAINT fk_audit_logs_employee_id FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for audit logs';

CREATE TABLE data_exports (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  requested_by_employee_id BIGINT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_data_exports_requested_by_employee_id (requested_by_employee_id),
  KEY idx_data_exports_created_at (created_at),
  CONSTRAINT fk_data_exports_requested_by_employee_id FOREIGN KEY (requested_by_employee_id) REFERENCES employees(id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for data exports';

CREATE TABLE daily_sales_summary (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  store_id BIGINT NOT NULL,
  channel_id BIGINT NOT NULL,
  currency_id BIGINT NOT NULL,
  summary_date DATE NOT NULL,
  metric_count INT NOT NULL DEFAULT 0,
  metric_amount DECIMAL(14,2) NOT NULL DEFAULT 0.00,
  KEY idx_daily_sales_summary_store_id (store_id),
  KEY idx_daily_sales_summary_channel_id (channel_id),
  KEY idx_daily_sales_summary_currency_id (currency_id),
  CONSTRAINT fk_daily_sales_summary_store_id FOREIGN KEY (store_id) REFERENCES stores(id) ON DELETE RESTRICT,
  CONSTRAINT fk_daily_sales_summary_channel_id FOREIGN KEY (channel_id) REFERENCES channels(id) ON DELETE RESTRICT,
  CONSTRAINT fk_daily_sales_summary_currency_id FOREIGN KEY (currency_id) REFERENCES currencies(id) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for daily sales summary';

CREATE TABLE vendor_scorecards (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  supplier_id BIGINT NOT NULL,
  summary_date DATE NOT NULL,
  metric_count INT NOT NULL DEFAULT 0,
  metric_amount DECIMAL(14,2) NOT NULL DEFAULT 0.00,
  KEY idx_vendor_scorecards_supplier_id (supplier_id),
  CONSTRAINT fk_vendor_scorecards_supplier_id FOREIGN KEY (supplier_id) REFERENCES suppliers(id) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for vendor scorecards';

CREATE TABLE route_plans (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  warehouse_id BIGINT NOT NULL,
  carrier_id BIGINT NOT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_route_plans_warehouse_id (warehouse_id),
  KEY idx_route_plans_carrier_id (carrier_id),
  KEY idx_route_plans_created_at (created_at),
  CONSTRAINT fk_route_plans_warehouse_id FOREIGN KEY (warehouse_id) REFERENCES warehouses(id) ON DELETE RESTRICT,
  CONSTRAINT fk_route_plans_carrier_id FOREIGN KEY (carrier_id) REFERENCES carriers(id) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for route plans';

CREATE TABLE store_transfers (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  from_store_id BIGINT NOT NULL,
  to_store_id BIGINT NOT NULL,
  requested_by_employee_id BIGINT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_store_transfers_from_store_id (from_store_id),
  KEY idx_store_transfers_to_store_id (to_store_id),
  KEY idx_store_transfers_requested_by_employee_id (requested_by_employee_id),
  KEY idx_store_transfers_created_at (created_at),
  CONSTRAINT fk_store_transfers_from_store_id FOREIGN KEY (from_store_id) REFERENCES stores(id) ON DELETE RESTRICT,
  CONSTRAINT fk_store_transfers_to_store_id FOREIGN KEY (to_store_id) REFERENCES stores(id) ON DELETE RESTRICT,
  CONSTRAINT fk_store_transfers_requested_by_employee_id FOREIGN KEY (requested_by_employee_id) REFERENCES employees(id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for store transfers';

CREATE TABLE pos_registers (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  store_id BIGINT NOT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_pos_registers_store_id (store_id),
  KEY idx_pos_registers_created_at (created_at),
  CONSTRAINT fk_pos_registers_store_id FOREIGN KEY (store_id) REFERENCES stores(id) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for pos registers';

CREATE TABLE product_categories (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  product_id BIGINT NOT NULL,
  category_id BIGINT NOT NULL,
  is_primary BOOLEAN NOT NULL DEFAULT FALSE,
  UNIQUE KEY uq_product_category (product_id, category_id),
  CONSTRAINT fk_product_categories_product_id FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  CONSTRAINT fk_product_categories_category_id FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for product categories';

CREATE TABLE product_images (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  product_id BIGINT NOT NULL,
  url VARCHAR(255) NOT NULL,
  alt_text VARCHAR(180) NULL,
  sort_order INT NOT NULL DEFAULT 0,
  CONSTRAINT fk_product_images_product_id FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for product images';

CREATE TABLE product_variants (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  product_id BIGINT NOT NULL,
  sku VARCHAR(64) NOT NULL,
  color VARCHAR(40) NULL,
  size VARCHAR(40) NULL,
  price_delta DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  UNIQUE KEY uq_product_variants_sku (sku),
  CONSTRAINT fk_product_variants_product_id FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for product variants';

CREATE TABLE product_bundle_items (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  bundle_id BIGINT NOT NULL,
  product_id BIGINT NOT NULL,
  quantity INT NOT NULL DEFAULT 1,
  UNIQUE KEY uq_bundle_product (bundle_id, product_id),
  CONSTRAINT fk_product_bundle_items_bundle_id FOREIGN KEY (bundle_id) REFERENCES product_bundles(id) ON DELETE CASCADE,
  CONSTRAINT fk_product_bundle_items_product_id FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for product bundle items';

CREATE TABLE product_prices (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  product_id BIGINT NOT NULL,
  price_list_id BIGINT NOT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_product_prices_product_id (product_id),
  KEY idx_product_prices_price_list_id (price_list_id),
  KEY idx_product_prices_created_at (created_at),
  CONSTRAINT fk_product_prices_product_id FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  CONSTRAINT fk_product_prices_price_list_id FOREIGN KEY (price_list_id) REFERENCES price_lists(id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for product prices';

CREATE TABLE price_history (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  product_id BIGINT NOT NULL,
  currency_id BIGINT NOT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_price_history_product_id (product_id),
  KEY idx_price_history_currency_id (currency_id),
  KEY idx_price_history_created_at (created_at),
  CONSTRAINT fk_price_history_product_id FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  CONSTRAINT fk_price_history_currency_id FOREIGN KEY (currency_id) REFERENCES currencies(id) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for price history';

CREATE TABLE inventory_items (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  product_id BIGINT NOT NULL,
  warehouse_id BIGINT NOT NULL,
  quantity INT NOT NULL DEFAULT 1,
  unit_price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  line_total DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  KEY idx_inventory_items_product_id (product_id),
  KEY idx_inventory_items_warehouse_id (warehouse_id),
  CONSTRAINT fk_inventory_items_product_id FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT,
  CONSTRAINT fk_inventory_items_warehouse_id FOREIGN KEY (warehouse_id) REFERENCES warehouses(id) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for inventory items';

CREATE TABLE purchase_order_items (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  purchase_order_id BIGINT NOT NULL,
  product_id BIGINT NOT NULL,
  quantity INT NOT NULL DEFAULT 1,
  unit_price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  line_total DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  KEY idx_purchase_order_items_purchase_order_id (purchase_order_id),
  KEY idx_purchase_order_items_product_id (product_id),
  CONSTRAINT fk_purchase_order_items_purchase_order_id FOREIGN KEY (purchase_order_id) REFERENCES purchase_orders(id) ON DELETE CASCADE,
  CONSTRAINT fk_purchase_order_items_product_id FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for purchase order items';

CREATE TABLE receiving_batches (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  purchase_order_id BIGINT NOT NULL,
  warehouse_id BIGINT NOT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_receiving_batches_purchase_order_id (purchase_order_id),
  KEY idx_receiving_batches_warehouse_id (warehouse_id),
  KEY idx_receiving_batches_created_at (created_at),
  CONSTRAINT fk_receiving_batches_purchase_order_id FOREIGN KEY (purchase_order_id) REFERENCES purchase_orders(id) ON DELETE CASCADE,
  CONSTRAINT fk_receiving_batches_warehouse_id FOREIGN KEY (warehouse_id) REFERENCES warehouses(id) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for receiving batches';

CREATE TABLE cart_items (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  cart_id BIGINT NOT NULL,
  product_id BIGINT NOT NULL,
  quantity INT NOT NULL DEFAULT 1,
  unit_price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  line_total DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  KEY idx_cart_items_cart_id (cart_id),
  KEY idx_cart_items_product_id (product_id),
  CONSTRAINT fk_cart_items_cart_id FOREIGN KEY (cart_id) REFERENCES carts(id) ON DELETE CASCADE,
  CONSTRAINT fk_cart_items_product_id FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for cart items';

CREATE TABLE wishlist_items (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  wishlist_id BIGINT NOT NULL,
  product_id BIGINT NOT NULL,
  quantity INT NOT NULL DEFAULT 1,
  unit_price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  line_total DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  KEY idx_wishlist_items_wishlist_id (wishlist_id),
  KEY idx_wishlist_items_product_id (product_id),
  CONSTRAINT fk_wishlist_items_wishlist_id FOREIGN KEY (wishlist_id) REFERENCES wishlists(id) ON DELETE CASCADE,
  CONSTRAINT fk_wishlist_items_product_id FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for wishlist items';

CREATE TABLE orders (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  customer_id BIGINT NOT NULL,
  store_id BIGINT NOT NULL,
  channel_id BIGINT NOT NULL,
  billing_address_id BIGINT NOT NULL,
  shipping_address_id BIGINT NOT NULL,
  order_number VARCHAR(40) NOT NULL,
  status ENUM('pending','paid','shipped','delivered','cancelled','returned') NOT NULL,
  ordered_at DATETIME NOT NULL,
  subtotal DECIMAL(12,2) NOT NULL,
  discount_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  tax_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  shipping_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  total_amount DECIMAL(12,2) NOT NULL,
  KEY idx_orders_customer_id (customer_id),
  KEY idx_orders_store_id (store_id),
  KEY idx_orders_channel_id (channel_id),
  KEY idx_orders_billing_address_id (billing_address_id),
  KEY idx_orders_shipping_address_id (shipping_address_id),
  CONSTRAINT fk_orders_customer_id FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE RESTRICT,
  CONSTRAINT fk_orders_store_id FOREIGN KEY (store_id) REFERENCES stores(id) ON DELETE RESTRICT,
  CONSTRAINT fk_orders_channel_id FOREIGN KEY (channel_id) REFERENCES channels(id) ON DELETE RESTRICT,
  CONSTRAINT fk_orders_billing_address_id FOREIGN KEY (billing_address_id) REFERENCES addresses(id) ON DELETE RESTRICT,
  CONSTRAINT fk_orders_shipping_address_id FOREIGN KEY (shipping_address_id) REFERENCES addresses(id) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for orders';

CREATE TABLE product_questions (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  product_id BIGINT NOT NULL,
  customer_id BIGINT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_product_questions_product_id (product_id),
  KEY idx_product_questions_customer_id (customer_id),
  KEY idx_product_questions_created_at (created_at),
  CONSTRAINT fk_product_questions_product_id FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  CONSTRAINT fk_product_questions_customer_id FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for product questions';

CREATE TABLE product_view_events (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  session_id BIGINT NOT NULL,
  product_id BIGINT NOT NULL,
  event_type VARCHAR(80) NOT NULL,
  event_at DATETIME NOT NULL,
  details JSON NULL,
  KEY idx_product_view_events_session_id (session_id),
  KEY idx_product_view_events_product_id (product_id),
  CONSTRAINT fk_product_view_events_session_id FOREIGN KEY (session_id) REFERENCES web_sessions(id) ON DELETE CASCADE,
  CONSTRAINT fk_product_view_events_product_id FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for product view events';

CREATE TABLE search_logs (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  session_id BIGINT NOT NULL,
  event_type VARCHAR(80) NOT NULL,
  event_at DATETIME NOT NULL,
  details JSON NULL,
  KEY idx_search_logs_session_id (session_id),
  CONSTRAINT fk_search_logs_session_id FOREIGN KEY (session_id) REFERENCES web_sessions(id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for search logs';

CREATE TABLE monthly_inventory_snapshot (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  warehouse_id BIGINT NOT NULL,
  product_id BIGINT NOT NULL,
  summary_date DATE NOT NULL,
  metric_count INT NOT NULL DEFAULT 0,
  metric_amount DECIMAL(14,2) NOT NULL DEFAULT 0.00,
  KEY idx_monthly_inventory_snapshot_warehouse_id (warehouse_id),
  KEY idx_monthly_inventory_snapshot_product_id (product_id),
  CONSTRAINT fk_monthly_inventory_snapshot_warehouse_id FOREIGN KEY (warehouse_id) REFERENCES warehouses(id) ON DELETE RESTRICT,
  CONSTRAINT fk_monthly_inventory_snapshot_product_id FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for monthly inventory snapshot';

CREATE TABLE store_inventory (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  store_id BIGINT NOT NULL,
  product_id BIGINT NOT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_store_inventory_store_id (store_id),
  KEY idx_store_inventory_product_id (product_id),
  KEY idx_store_inventory_created_at (created_at),
  CONSTRAINT fk_store_inventory_store_id FOREIGN KEY (store_id) REFERENCES stores(id) ON DELETE RESTRICT,
  CONSTRAINT fk_store_inventory_product_id FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for store inventory';

CREATE TABLE transfer_items (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  transfer_id BIGINT NOT NULL,
  product_id BIGINT NOT NULL,
  quantity INT NOT NULL DEFAULT 1,
  unit_price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  line_total DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  KEY idx_transfer_items_transfer_id (transfer_id),
  KEY idx_transfer_items_product_id (product_id),
  CONSTRAINT fk_transfer_items_transfer_id FOREIGN KEY (transfer_id) REFERENCES store_transfers(id) ON DELETE CASCADE,
  CONSTRAINT fk_transfer_items_product_id FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for transfer items';

CREATE TABLE pos_transactions (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  register_id BIGINT NOT NULL,
  customer_id BIGINT NULL,
  employee_id BIGINT NULL,
  order_number VARCHAR(40) NOT NULL,
  status ENUM('pending','paid','shipped','delivered','cancelled','returned') NOT NULL,
  ordered_at DATETIME NOT NULL,
  subtotal DECIMAL(12,2) NOT NULL,
  discount_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  tax_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  shipping_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  total_amount DECIMAL(12,2) NOT NULL,
  KEY idx_pos_transactions_register_id (register_id),
  KEY idx_pos_transactions_customer_id (customer_id),
  KEY idx_pos_transactions_employee_id (employee_id),
  CONSTRAINT fk_pos_transactions_register_id FOREIGN KEY (register_id) REFERENCES pos_registers(id) ON DELETE RESTRICT,
  CONSTRAINT fk_pos_transactions_customer_id FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE SET NULL,
  CONSTRAINT fk_pos_transactions_employee_id FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for pos transactions';

CREATE TABLE inventory_adjustments (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  inventory_item_id BIGINT NOT NULL,
  employee_id BIGINT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_inventory_adjustments_inventory_item_id (inventory_item_id),
  KEY idx_inventory_adjustments_employee_id (employee_id),
  KEY idx_inventory_adjustments_created_at (created_at),
  CONSTRAINT fk_inventory_adjustments_inventory_item_id FOREIGN KEY (inventory_item_id) REFERENCES inventory_items(id) ON DELETE CASCADE,
  CONSTRAINT fk_inventory_adjustments_employee_id FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for inventory adjustments';

CREATE TABLE stock_reservations (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  inventory_item_id BIGINT NOT NULL,
  order_id BIGINT NOT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_stock_reservations_inventory_item_id (inventory_item_id),
  KEY idx_stock_reservations_order_id (order_id),
  KEY idx_stock_reservations_created_at (created_at),
  CONSTRAINT fk_stock_reservations_inventory_item_id FOREIGN KEY (inventory_item_id) REFERENCES inventory_items(id) ON DELETE CASCADE,
  CONSTRAINT fk_stock_reservations_order_id FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for stock reservations';

CREATE TABLE quality_inspections (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  receiving_batch_id BIGINT NOT NULL,
  employee_id BIGINT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_quality_inspections_receiving_batch_id (receiving_batch_id),
  KEY idx_quality_inspections_employee_id (employee_id),
  KEY idx_quality_inspections_created_at (created_at),
  CONSTRAINT fk_quality_inspections_receiving_batch_id FOREIGN KEY (receiving_batch_id) REFERENCES receiving_batches(id) ON DELETE CASCADE,
  CONSTRAINT fk_quality_inspections_employee_id FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for quality inspections';

CREATE TABLE order_items (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  order_id BIGINT NOT NULL,
  product_id BIGINT NOT NULL,
  product_variant_id BIGINT NULL,
  quantity INT NOT NULL DEFAULT 1,
  unit_price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  line_total DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  KEY idx_order_items_order_id (order_id),
  KEY idx_order_items_product_id (product_id),
  KEY idx_order_items_product_variant_id (product_variant_id),
  CONSTRAINT fk_order_items_order_id FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  CONSTRAINT fk_order_items_product_id FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT,
  CONSTRAINT fk_order_items_product_variant_id FOREIGN KEY (product_variant_id) REFERENCES product_variants(id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for order items';

CREATE TABLE order_status_history (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  order_id BIGINT NOT NULL,
  changed_by_employee_id BIGINT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_order_status_history_order_id (order_id),
  KEY idx_order_status_history_changed_by_employee_id (changed_by_employee_id),
  KEY idx_order_status_history_created_at (created_at),
  CONSTRAINT fk_order_status_history_order_id FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  CONSTRAINT fk_order_status_history_changed_by_employee_id FOREIGN KEY (changed_by_employee_id) REFERENCES employees(id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for order status history';

CREATE TABLE order_discounts (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  order_id BIGINT NOT NULL,
  coupon_id BIGINT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_order_discounts_order_id (order_id),
  KEY idx_order_discounts_coupon_id (coupon_id),
  KEY idx_order_discounts_created_at (created_at),
  CONSTRAINT fk_order_discounts_order_id FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  CONSTRAINT fk_order_discounts_coupon_id FOREIGN KEY (coupon_id) REFERENCES coupons(id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for order discounts';

CREATE TABLE payments (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  order_id BIGINT NOT NULL,
  payment_method_id BIGINT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  notes TEXT NULL,
  KEY idx_payments_order_id (order_id),
  KEY idx_payments_payment_method_id (payment_method_id),
  KEY idx_payments_created_at (created_at),
  CONSTRAINT fk_payments_order_id FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  CONSTRAINT fk_payments_payment_method_id FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for payments';

CREATE TABLE shipments (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  order_id BIGINT NOT NULL,
  shipping_method_id BIGINT NOT NULL,
  warehouse_id BIGINT NOT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_shipments_order_id (order_id),
  KEY idx_shipments_shipping_method_id (shipping_method_id),
  KEY idx_shipments_warehouse_id (warehouse_id),
  KEY idx_shipments_created_at (created_at),
  CONSTRAINT fk_shipments_order_id FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  CONSTRAINT fk_shipments_shipping_method_id FOREIGN KEY (shipping_method_id) REFERENCES shipping_methods(id) ON DELETE RESTRICT,
  CONSTRAINT fk_shipments_warehouse_id FOREIGN KEY (warehouse_id) REFERENCES warehouses(id) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for shipments';

CREATE TABLE returns (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  order_id BIGINT NOT NULL,
  customer_id BIGINT NOT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_returns_order_id (order_id),
  KEY idx_returns_customer_id (customer_id),
  KEY idx_returns_created_at (created_at),
  CONSTRAINT fk_returns_order_id FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE RESTRICT,
  CONSTRAINT fk_returns_customer_id FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for returns';

CREATE TABLE coupon_redemptions (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  coupon_id BIGINT NOT NULL,
  customer_id BIGINT NOT NULL,
  order_id BIGINT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_coupon_redemptions_coupon_id (coupon_id),
  KEY idx_coupon_redemptions_customer_id (customer_id),
  KEY idx_coupon_redemptions_order_id (order_id),
  KEY idx_coupon_redemptions_created_at (created_at),
  CONSTRAINT fk_coupon_redemptions_coupon_id FOREIGN KEY (coupon_id) REFERENCES coupons(id) ON DELETE CASCADE,
  CONSTRAINT fk_coupon_redemptions_customer_id FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE RESTRICT,
  CONSTRAINT fk_coupon_redemptions_order_id FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for coupon redemptions';

CREATE TABLE gift_card_transactions (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  gift_card_id BIGINT NOT NULL,
  order_id BIGINT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  notes TEXT NULL,
  KEY idx_gift_card_transactions_gift_card_id (gift_card_id),
  KEY idx_gift_card_transactions_order_id (order_id),
  KEY idx_gift_card_transactions_created_at (created_at),
  CONSTRAINT fk_gift_card_transactions_gift_card_id FOREIGN KEY (gift_card_id) REFERENCES gift_cards(id) ON DELETE CASCADE,
  CONSTRAINT fk_gift_card_transactions_order_id FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for gift card transactions';

CREATE TABLE product_answers (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  question_id BIGINT NOT NULL,
  employee_id BIGINT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_product_answers_question_id (question_id),
  KEY idx_product_answers_employee_id (employee_id),
  KEY idx_product_answers_created_at (created_at),
  CONSTRAINT fk_product_answers_question_id FOREIGN KEY (question_id) REFERENCES product_questions(id) ON DELETE CASCADE,
  CONSTRAINT fk_product_answers_employee_id FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for product answers';

CREATE TABLE loyalty_transactions (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  customer_id BIGINT NOT NULL,
  order_id BIGINT NULL,
  program_id BIGINT NOT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_loyalty_transactions_customer_id (customer_id),
  KEY idx_loyalty_transactions_order_id (order_id),
  KEY idx_loyalty_transactions_program_id (program_id),
  KEY idx_loyalty_transactions_created_at (created_at),
  CONSTRAINT fk_loyalty_transactions_customer_id FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
  CONSTRAINT fk_loyalty_transactions_order_id FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE SET NULL,
  CONSTRAINT fk_loyalty_transactions_program_id FOREIGN KEY (program_id) REFERENCES loyalty_programs(id) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for loyalty transactions';

CREATE TABLE customer_support_tickets (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  customer_id BIGINT NOT NULL,
  order_id BIGINT NULL,
  assigned_employee_id BIGINT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_customer_support_tickets_customer_id (customer_id),
  KEY idx_customer_support_tickets_order_id (order_id),
  KEY idx_customer_support_tickets_assigned_employee_id (assigned_employee_id),
  KEY idx_customer_support_tickets_created_at (created_at),
  CONSTRAINT fk_customer_support_tickets_customer_id FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE RESTRICT,
  CONSTRAINT fk_customer_support_tickets_order_id FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE SET NULL,
  CONSTRAINT fk_customer_support_tickets_assigned_employee_id FOREIGN KEY (assigned_employee_id) REFERENCES employees(id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for customer support tickets';

CREATE TABLE fraud_checks (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  order_id BIGINT NOT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_fraud_checks_order_id (order_id),
  KEY idx_fraud_checks_created_at (created_at),
  CONSTRAINT fk_fraud_checks_order_id FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for fraud checks';

CREATE TABLE pos_transaction_items (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  transaction_id BIGINT NOT NULL,
  product_id BIGINT NOT NULL,
  quantity INT NOT NULL DEFAULT 1,
  unit_price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  line_total DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  KEY idx_pos_transaction_items_transaction_id (transaction_id),
  KEY idx_pos_transaction_items_product_id (product_id),
  CONSTRAINT fk_pos_transaction_items_transaction_id FOREIGN KEY (transaction_id) REFERENCES pos_transactions(id) ON DELETE CASCADE,
  CONSTRAINT fk_pos_transaction_items_product_id FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for pos transaction items';

CREATE TABLE payment_refunds (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  payment_id BIGINT NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  notes TEXT NULL,
  KEY idx_payment_refunds_payment_id (payment_id),
  KEY idx_payment_refunds_created_at (created_at),
  CONSTRAINT fk_payment_refunds_payment_id FOREIGN KEY (payment_id) REFERENCES payments(id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for payment refunds';

CREATE TABLE shipment_items (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  shipment_id BIGINT NOT NULL,
  order_item_id BIGINT NOT NULL,
  quantity INT NOT NULL DEFAULT 1,
  unit_price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  line_total DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  KEY idx_shipment_items_shipment_id (shipment_id),
  KEY idx_shipment_items_order_item_id (order_item_id),
  CONSTRAINT fk_shipment_items_shipment_id FOREIGN KEY (shipment_id) REFERENCES shipments(id) ON DELETE CASCADE,
  CONSTRAINT fk_shipment_items_order_item_id FOREIGN KEY (order_item_id) REFERENCES order_items(id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for shipment items';

CREATE TABLE shipment_tracking_events (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  shipment_id BIGINT NOT NULL,
  event_type VARCHAR(80) NOT NULL,
  event_at DATETIME NOT NULL,
  details JSON NULL,
  KEY idx_shipment_tracking_events_shipment_id (shipment_id),
  CONSTRAINT fk_shipment_tracking_events_shipment_id FOREIGN KEY (shipment_id) REFERENCES shipments(id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for shipment tracking events';

CREATE TABLE return_items (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  return_id BIGINT NOT NULL,
  order_item_id BIGINT NOT NULL,
  reason_id BIGINT NOT NULL,
  quantity INT NOT NULL DEFAULT 1,
  unit_price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  line_total DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  KEY idx_return_items_return_id (return_id),
  KEY idx_return_items_order_item_id (order_item_id),
  KEY idx_return_items_reason_id (reason_id),
  CONSTRAINT fk_return_items_return_id FOREIGN KEY (return_id) REFERENCES returns(id) ON DELETE CASCADE,
  CONSTRAINT fk_return_items_order_item_id FOREIGN KEY (order_item_id) REFERENCES order_items(id) ON DELETE RESTRICT,
  CONSTRAINT fk_return_items_reason_id FOREIGN KEY (reason_id) REFERENCES return_reasons(id) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for return items';

CREATE TABLE refunds (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  return_id BIGINT NOT NULL,
  payment_id BIGINT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  notes TEXT NULL,
  KEY idx_refunds_return_id (return_id),
  KEY idx_refunds_payment_id (payment_id),
  KEY idx_refunds_created_at (created_at),
  CONSTRAINT fk_refunds_return_id FOREIGN KEY (return_id) REFERENCES returns(id) ON DELETE CASCADE,
  CONSTRAINT fk_refunds_payment_id FOREIGN KEY (payment_id) REFERENCES payments(id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for refunds';

CREATE TABLE reviews (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  product_id BIGINT NOT NULL,
  customer_id BIGINT NOT NULL,
  order_item_id BIGINT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_reviews_product_id (product_id),
  KEY idx_reviews_customer_id (customer_id),
  KEY idx_reviews_order_item_id (order_item_id),
  KEY idx_reviews_created_at (created_at),
  CONSTRAINT fk_reviews_product_id FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  CONSTRAINT fk_reviews_customer_id FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
  CONSTRAINT fk_reviews_order_item_id FOREIGN KEY (order_item_id) REFERENCES order_items(id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for reviews';

CREATE TABLE ticket_messages (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  ticket_id BIGINT NOT NULL,
  employee_id BIGINT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_ticket_messages_ticket_id (ticket_id),
  KEY idx_ticket_messages_employee_id (employee_id),
  KEY idx_ticket_messages_created_at (created_at),
  CONSTRAINT fk_ticket_messages_ticket_id FOREIGN KEY (ticket_id) REFERENCES customer_support_tickets(id) ON DELETE CASCADE,
  CONSTRAINT fk_ticket_messages_employee_id FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE SET NULL
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for ticket messages';

CREATE TABLE delivery_stops (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  route_plan_id BIGINT NOT NULL,
  shipment_id BIGINT NOT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_delivery_stops_route_plan_id (route_plan_id),
  KEY idx_delivery_stops_shipment_id (shipment_id),
  KEY idx_delivery_stops_created_at (created_at),
  CONSTRAINT fk_delivery_stops_route_plan_id FOREIGN KEY (route_plan_id) REFERENCES route_plans(id) ON DELETE CASCADE,
  CONSTRAINT fk_delivery_stops_shipment_id FOREIGN KEY (shipment_id) REFERENCES shipments(id) ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for delivery stops';

CREATE TABLE review_votes (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  review_id BIGINT NOT NULL,
  customer_id BIGINT NOT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_review_votes_review_id (review_id),
  KEY idx_review_votes_customer_id (customer_id),
  KEY idx_review_votes_created_at (created_at),
  CONSTRAINT fk_review_votes_review_id FOREIGN KEY (review_id) REFERENCES reviews(id) ON DELETE CASCADE,
  CONSTRAINT fk_review_votes_customer_id FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for review votes';

CREATE TABLE delivery_proof (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  delivery_stop_id BIGINT NOT NULL,
  name VARCHAR(160) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'active',
  created_at DATETIME NOT NULL,
  notes TEXT NULL,
  KEY idx_delivery_proof_delivery_stop_id (delivery_stop_id),
  KEY idx_delivery_proof_created_at (created_at),
  CONSTRAINT fk_delivery_proof_delivery_stop_id FOREIGN KEY (delivery_stop_id) REFERENCES delivery_stops(id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='E-commerce benchmark table for delivery proof';

CREATE OR REPLACE VIEW v_customer_lifetime_value AS
SELECT c.id AS customer_id, c.email, COALESCE(SUM(o.total_amount), 0) AS lifetime_revenue, COUNT(o.id) AS order_count
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.id
GROUP BY c.id, c.email;

CREATE OR REPLACE VIEW v_product_sales AS
SELECT p.id AS product_id, p.sku, p.name, COALESCE(SUM(oi.quantity), 0) AS units_sold, COALESCE(SUM(oi.line_total), 0) AS revenue
FROM products p
LEFT JOIN order_items oi ON oi.product_id = p.id
GROUP BY p.id, p.sku, p.name;

CREATE OR REPLACE VIEW v_order_fulfillment AS
SELECT o.id AS order_id, o.order_number, o.status, s.id AS shipment_id, s.status AS shipment_status
FROM orders o
LEFT JOIN shipments s ON s.order_id = o.id;

CREATE OR REPLACE VIEW v_inventory_health AS
SELECT p.id AS product_id, p.sku, p.name, COUNT(ii.id) AS stocked_locations
FROM products p
LEFT JOIN inventory_items ii ON ii.product_id = p.id
GROUP BY p.id, p.sku, p.name;
