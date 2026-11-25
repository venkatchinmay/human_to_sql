-- Deterministic benchmark seed data

SET FOREIGN_KEY_CHECKS=0;

INSERT INTO countries (iso_code, name, region) VALUES
  ('US', 'Countries 1', 'Europe'),
  ('CA', 'Countries 2', 'Pacific'),
  ('GB', 'Countries 3', 'North America');

INSERT INTO currencies (code, name, symbol) VALUES
  ('C01', 'Currencies 1', '$'),
  ('C02', 'Currencies 2', 'C$'),
  ('C03', 'Currencies 3', 'GBP');

INSERT INTO languages (code, name) VALUES
  ('C01', 'Languages 1'),
  ('C02', 'Languages 2'),
  ('C03', 'Languages 3');

INSERT INTO channels (name, channel_type, is_active) VALUES
  ('Channels 1', 'mobile', FALSE),
  ('Channels 2', 'store', TRUE),
  ('Channels 3', 'web', FALSE);

INSERT INTO departments (name, cost_center) VALUES
  ('Departments 1', 'Departments 1'),
  ('Departments 2', 'Departments 2'),
  ('Departments 3', 'Departments 3');

INSERT INTO roles (name, description) VALUES
  ('Roles 1', 'Seeded roles row 1'),
  ('Roles 2', 'Seeded roles row 2'),
  ('Roles 3', 'Seeded roles row 3');

INSERT INTO customer_segments (name, description) VALUES
  ('VIP', 'Seeded customer_segments row 1'),
  ('Standard', 'Seeded customer_segments row 2'),
  ('Enterprise', 'Seeded customer_segments row 3');

INSERT INTO categories (parent_id, name, slug) VALUES
  (NULL, 'Categories 1', 'cat-1'),
  (1, 'Categories 2', 'cat-2'),
  (2, 'Categories 3', 'cat-3'),
  (1, 'Categories 4', 'cat-4'),
  (1, 'Categories 5', 'dept-5'),
  (2, 'Categories 6', 'dept-6');

INSERT INTO product_tax_codes (code, description) VALUES
  ('C01', 'Seeded product_tax_codes row 1'),
  ('C02', 'Seeded product_tax_codes row 2'),
  ('C03', 'Seeded product_tax_codes row 3');

INSERT INTO unit_types (code, name) VALUES
  ('C01', 'Unit Types 1'),
  ('C02', 'Unit Types 2'),
  ('C03', 'Unit Types 3');

INSERT INTO product_bundles (name, description, status, created_at, active) VALUES
  ('Product Bundles 1', 'Seeded product_bundles row 1', 'pending', '2024-01-01 10:01:00', FALSE),
  ('Product Bundles 2', 'Seeded product_bundles row 2', 'delivered', '2024-02-02 10:02:00', TRUE),
  ('Product Bundles 3', 'Seeded product_bundles row 3', 'active', '2024-03-03 10:03:00', FALSE);

INSERT INTO return_reasons (name, status, created_at, notes) VALUES
  ('Return Reasons 1', 'pending', '2024-01-01 10:01:00', 'Seeded return_reasons row 1'),
  ('Return Reasons 2', 'delivered', '2024-02-02 10:02:00', 'Seeded return_reasons row 2'),
  ('Return Reasons 3', 'active', '2024-03-03 10:03:00', 'Seeded return_reasons row 3');

INSERT INTO risk_rules (name, status, created_at, notes) VALUES
  ('Risk Rules 1', 'pending', '2024-01-01 10:01:00', 'Seeded risk_rules row 1'),
  ('Risk Rules 2', 'delivered', '2024-02-02 10:02:00', 'Seeded risk_rules row 2'),
  ('Risk Rules 3', 'active', '2024-03-03 10:03:00', 'Seeded risk_rules row 3');

INSERT INTO tax_regions (country_id, name, default_tax_rate) VALUES
  (1, 'Tax Regions 1', 481.78),
  (2, 'Tax Regions 2', 495.12),
  (3, 'Tax Regions 3', 279.33);

INSERT INTO stores (country_id, currency_id, name, opened_on) VALUES
  (1, 1, 'Stores 1', '2024-01-01'),
  (2, 2, 'Stores 2', '2024-02-02'),
  (3, 3, 'Stores 3', '2024-03-03');

INSERT INTO employees (department_id, role_id, manager_id, first_name, last_name, email, hired_on, salary) VALUES
  (1, 1, NULL, 'First1', 'Last1', 'employees1@example.com', '2024-01-01', 333.86),
  (2, 2, 1, 'First2', 'Last2', 'employees2@example.com', '2024-02-02', 221.18),
  (3, 3, 2, 'First3', 'Last3', 'employees3@example.com', '2024-03-03', 374.65),
  (1, 1, 1, 'First4', 'Last4', 'employees4@example.com', '2024-04-04', 115.43),
  (2, 2, 1, 'First5', 'Last5', 'employees5@example.com', '2024-05-05', 281.14),
  (3, 3, 2, 'First6', 'Last6', 'employees6@example.com', '2024-06-06', 156.71);

INSERT INTO customers (segment_id, preferred_language_id, email, first_name, last_name, birth_date, created_at, loyalty_points, metadata) VALUES
  (1, 1, 'customers1@example.com', 'First1', 'Last1', '2024-01-01', '2024-01-01 10:01:00', 7, '{"seed": 1, "tier": "plus"}'),
  (2, 2, 'customers2@example.com', 'First2', 'Last2', '2024-02-02', '2024-02-02 10:02:00', 20, '{"seed": 2, "tier": "vip"}'),
  (3, 3, 'customers3@example.com', 'First3', 'Last3', '2024-03-03', '2024-03-03 10:03:00', 20, '{"seed": 3, "tier": "basic"}'),
  (NULL, 1, 'customers4@example.com', 'First4', 'Last4', '2024-04-04', '2024-04-04 10:04:00', 12, '{"seed": 4, "tier": "plus"}'),
  (2, 2, 'customers5@example.com', 'First5', 'Last5', NULL, '2024-05-05 10:05:00', 11, '{"seed": 5, "tier": "vip"}'),
  (3, 3, 'customers6@example.com', 'First6', 'Last6', '2024-06-06', '2024-06-06 10:06:00', 7, '{"seed": 6, "tier": "basic"}'),
  (1, 1, 'customers7@example.com', 'First7', 'Last7', '2024-07-07', '2024-07-07 10:07:00', 24, '{"seed": 7, "tier": "plus"}'),
  (NULL, 2, 'customers8@example.com', 'First8', 'Last8', '2024-08-08', '2024-08-08 10:08:00', 23, '{"seed": 8, "tier": "vip"}'),
  (3, 3, 'customers9@example.com', 'First9', 'Last9', '2024-09-09', '2024-09-09 10:09:00', 12, '{"seed": 9, "tier": "basic"}'),
  (1, 1, 'customers10@example.com', 'First10', 'Last10', NULL, '2024-10-10 10:10:00', 21, '{"seed": 10, "tier": "plus"}'),
  (2, 2, 'customers11@example.com', 'First11', NULL, '2024-11-11', '2024-11-11 10:11:00', 6, '{"seed": 11, "tier": "vip"}'),
  (NULL, 3, 'customers12@example.com', 'First12', 'Last12', '2024-12-12', '2024-12-12 10:12:00', 8, '{"seed": 12, "tier": "basic"}');

INSERT INTO brands (name, country_id, is_private_label) VALUES
  ('Brands 1', 1, FALSE),
  ('Brands 2', 2, TRUE),
  ('Brands 3', 3, FALSE);

INSERT INTO suppliers (country_id, name, contact_email, risk_rating) VALUES
  (1, 'Suppliers 1', 'suppliers1@example.com', 'medium'),
  (2, 'Suppliers 2', 'suppliers2@example.com', 'high'),
  (3, 'Suppliers 3', 'suppliers3@example.com', 'low');

INSERT INTO price_lists (currency_id, name, status, created_at, notes) VALUES
  (1, 'Price Lists 1', 'pending', '2024-01-01 10:01:00', 'Seeded price_lists row 1'),
  (2, 'Price Lists 2', 'delivered', '2024-02-02 10:02:00', 'Seeded price_lists row 2'),
  (3, 'Price Lists 3', 'active', '2024-03-03 10:03:00', 'Seeded price_lists row 3');

INSERT INTO warehouses (country_id, name, status, created_at, notes) VALUES
  (1, 'Warehouses 1', 'pending', '2024-01-01 10:01:00', 'Seeded warehouses row 1'),
  (2, 'Warehouses 2', 'delivered', '2024-02-02 10:02:00', 'Seeded warehouses row 2'),
  (3, 'Warehouses 3', 'active', '2024-03-03 10:03:00', 'Seeded warehouses row 3');

INSERT INTO carriers (country_id, name, status, created_at, notes) VALUES
  (1, 'Carriers 1', 'pending', '2024-01-01 10:01:00', 'Seeded carriers row 1'),
  (2, 'Carriers 2', 'delivered', '2024-02-02 10:02:00', 'Seeded carriers row 2'),
  (3, 'Carriers 3', 'active', '2024-03-03 10:03:00', 'Seeded carriers row 3');

INSERT INTO promotions (channel_id, name, status, created_at, notes) VALUES
  (1, 'Promotions 1', 'pending', '2024-01-01 10:01:00', 'Seeded promotions row 1'),
  (2, 'Promotions 2', 'delivered', '2024-02-02 10:02:00', 'Seeded promotions row 2'),
  (3, 'Promotions 3', 'active', '2024-03-03 10:03:00', 'Seeded promotions row 3');

INSERT INTO loyalty_programs (currency_id, name, status, created_at, notes) VALUES
  (1, 'Loyalty Programs 1', 'pending', '2024-01-01 10:01:00', 'Seeded loyalty_programs row 1'),
  (2, 'Loyalty Programs 2', 'delivered', '2024-02-02 10:02:00', 'Seeded loyalty_programs row 2'),
  (3, 'Loyalty Programs 3', 'active', '2024-03-03 10:03:00', 'Seeded loyalty_programs row 3');

INSERT INTO service_level_agreements (customer_segment_id, name, status, created_at, notes) VALUES
  (1, 'Service Level Agreements 1', 'pending', '2024-01-01 10:01:00', 'Seeded service_level_agreements row 1'),
  (2, 'Service Level Agreements 2', 'delivered', '2024-02-02 10:02:00', 'Seeded service_level_agreements row 2'),
  (1, 'Service Level Agreements 3', 'active', '2024-03-03 10:03:00', 'Seeded service_level_agreements row 3');

INSERT INTO marketing_campaigns (channel_id, name, status, created_at, notes) VALUES
  (1, 'Marketing Campaigns 1', 'pending', '2024-01-01 10:01:00', 'Seeded marketing_campaigns row 1'),
  (2, 'Marketing Campaigns 2', 'delivered', '2024-02-02 10:02:00', 'Seeded marketing_campaigns row 2'),
  (3, 'Marketing Campaigns 3', 'active', '2024-03-03 10:03:00', 'Seeded marketing_campaigns row 3');

INSERT INTO email_templates (language_id, name, status, created_at, notes) VALUES
  (1, 'Email Templates 1', 'pending', '2024-01-01 10:01:00', 'Seeded email_templates row 1'),
  (2, 'Email Templates 2', 'delivered', '2024-02-02 10:02:00', 'Seeded email_templates row 2'),
  (3, 'Email Templates 3', 'active', '2024-03-03 10:03:00', 'Seeded email_templates row 3');

INSERT INTO ab_tests (channel_id, name, status, created_at, notes) VALUES
  (1, 'Ab Tests 1', 'pending', '2024-01-01 10:01:00', 'Seeded ab_tests row 1'),
  (2, 'Ab Tests 2', 'delivered', '2024-02-02 10:02:00', 'Seeded ab_tests row 2'),
  (3, 'Ab Tests 3', 'active', '2024-03-03 10:03:00', 'Seeded ab_tests row 3');

INSERT INTO tax_rules (tax_region_id, product_tax_code, tax_rate) VALUES
  (1, 'Tax Rules 1', 215.52),
  (2, 'Tax Rules 2', 143.05),
  (3, 'Tax Rules 3', 80.94);

INSERT INTO employee_store_assignments (employee_id, store_id, started_on, ended_on) VALUES
  (1, 1, '2024-01-01', '2024-01-01'),
  (2, 2, '2024-02-02', '2024-02-02'),
  (3, 3, '2024-03-03', '2024-03-03');

INSERT INTO customer_profiles (customer_id, gender, income_band, marketing_opt_in) VALUES
  (1, 'female', 'Customer Profiles 1', FALSE),
  (2, 'male', 'Customer Profiles 2', TRUE),
  (3, 'unknown', 'Customer Profiles 3', FALSE);

INSERT INTO addresses (customer_id, country_id, line1, line2, city, state, postal_code, address_type) VALUES
  (1, 1, 'Addresses 1', NULL, 'Austin', 'Addresses 1', 'Addresses 1', 'shipping'),
  (2, 2, 'Addresses 2', 'Suite 20', 'Seattle', 'Addresses 2', 'Addresses 2', 'store'),
  (3, 3, 'Addresses 3', NULL, 'Denver', 'Addresses 3', 'Addresses 3', 'billing'),
  (1, 1, 'Addresses 4', 'Suite 40', 'Boston', 'Addresses 4', 'Addresses 4', 'shipping'),
  (2, 2, 'Addresses 5', NULL, 'Chicago', 'Addresses 5', 'Addresses 5', 'store'),
  (3, 3, 'Addresses 6', 'Suite 60', 'Miami', 'Addresses 6', 'Addresses 6', 'billing');

INSERT INTO customer_notes (customer_id, employee_id, note, created_at) VALUES
  (1, 1, 'Seeded customer_notes row 1', '2024-01-01 10:01:00'),
  (2, 2, 'Seeded customer_notes row 2', '2024-02-02 10:02:00'),
  (3, 3, 'Seeded customer_notes row 3', '2024-03-03 10:03:00');

INSERT INTO customer_consents (customer_id, consent_type, granted, updated_at) VALUES
  (1, 'Customer Consents 1', FALSE, '2024-01-01'),
  (2, 'Customer Consents 2', TRUE, '2024-02-02'),
  (3, 'Customer Consents 3', FALSE, '2024-03-03');

INSERT INTO supplier_contacts (supplier_id, name, email, phone) VALUES
  (1, 'Supplier Contacts 1', 'supplier_contacts1@example.com', 'Supplier Contacts 1'),
  (2, 'Supplier Contacts 2', 'supplier_contacts2@example.com', 'Supplier Contacts 2'),
  (3, 'Supplier Contacts 3', 'supplier_contacts3@example.com', 'Supplier Contacts 3');

INSERT INTO products (brand_id, supplier_id, unit_type_id, tax_code_id, sku, name, description, status, base_price, weight, attributes) VALUES
  (1, 1, 1, 1, 'PRO-00001', 'Classic Canvas Tote', 'Seeded products row 1', 'active', 319.12, 52.05, '{"seed": 1, "tier": "plus"}'),
  (2, 2, 2, 2, 'PRO-00002', 'Studio Monitor 27', 'Seeded products row 2', 'discontinued', 435.29, 26.66, '{"seed": 2, "tier": "vip"}'),
  (3, 3, 3, 3, 'PRO-00003', 'Merino Wool Scarf', 'Seeded products row 3', 'draft', 137.24, 227.47, '{"seed": 3, "tier": "basic"}'),
  (1, 1, 1, 1, 'PRO-00004', 'Wireless Mouse M4', 'Seeded products row 4', 'active', 493.97, 31.03, '{"seed": 4, "tier": "plus"}'),
  (2, 2, 2, 2, 'PRO-00005', 'Ceramic Pour Over', 'Seeded products row 5', 'discontinued', 365.95, 42.11, '{"seed": 5, "tier": "vip"}'),
  (3, 3, 3, 3, 'PRO-00006', 'USB Hub 4-Port', 'Seeded products row 6', 'draft', 254.63, 378.82, '{"seed": 6, "tier": "basic"}'),
  (1, 1, 1, 1, 'PRO-00007', 'Leather Desk Mat', 'Seeded products row 7', 'active', 421.21, 58.4, '{"seed": 7, "tier": "plus"}'),
  (2, 2, 2, 2, 'PRO-00008', 'Smart Thermostat V2', 'Seeded products row 8', 'discontinued', 62.93, 117.25, '{"seed": 8, "tier": "vip"}'),
  (3, 3, 3, 3, 'PRO-00009', 'Cotton Crew Tee', 'Seeded products row 9', 'draft', 215.55, 307.76, '{"seed": 9, "tier": "basic"}'),
  (1, 1, 1, 1, 'PRO-00010', 'Mechanical Keyboard 75', 'Seeded products row 10', 'active', 57.19, 262.78, '{"seed": 10, "tier": "plus"}'),
  (2, 2, 2, 2, 'PRO-00011', 'Bamboo Cutting Board', 'Seeded products row 11', 'discontinued', 9.14, 141.23, '{"seed": 11, "tier": "vip"}'),
  (3, 3, 3, 3, 'PRO-00012', 'Portable SSD 1TB', 'Seeded products row 12', 'draft', 218.61, 187.57, '{"seed": 12, "tier": "basic"}');

INSERT INTO warehouse_zones (warehouse_id, name, status, created_at, notes) VALUES
  (1, 'Warehouse Zones 1', 'pending', '2024-01-01 10:01:00', 'Seeded warehouse_zones row 1'),
  (2, 'Warehouse Zones 2', 'delivered', '2024-02-02 10:02:00', 'Seeded warehouse_zones row 2'),
  (3, 'Warehouse Zones 3', 'active', '2024-03-03 10:03:00', 'Seeded warehouse_zones row 3');

INSERT INTO purchase_orders (supplier_id, warehouse_id, created_by_employee_id, name, status, created_at, notes) VALUES
  (1, 1, 1, 'Purchase Orders 1', 'pending', '2024-01-01 10:01:00', 'Seeded purchase_orders row 1'),
  (2, 2, 2, 'Purchase Orders 2', 'delivered', '2024-02-02 10:02:00', 'Seeded purchase_orders row 2'),
  (3, 3, 3, 'Purchase Orders 3', 'active', '2024-03-03 10:03:00', 'Seeded purchase_orders row 3');

INSERT INTO carts (customer_id, channel_id, name, status, created_at, notes) VALUES
  (1, 1, 'Carts 1', 'pending', '2024-01-01 10:01:00', 'Seeded carts row 1'),
  (2, 2, 'Carts 2', 'delivered', '2024-02-02 10:02:00', 'Seeded carts row 2'),
  (3, 3, 'Carts 3', 'active', '2024-03-03 10:03:00', 'Seeded carts row 3');

INSERT INTO wishlists (customer_id, name, status, created_at, notes) VALUES
  (1, 'Wishlists 1', 'pending', '2024-01-01 10:01:00', 'Seeded wishlists row 1'),
  (2, 'Wishlists 2', 'delivered', '2024-02-02 10:02:00', 'Seeded wishlists row 2'),
  (3, 'Wishlists 3', 'active', '2024-03-03 10:03:00', 'Seeded wishlists row 3');

INSERT INTO payment_methods (customer_id, name, status, created_at, notes) VALUES
  (1, 'Payment Methods 1', 'pending', '2024-01-01 10:01:00', 'Seeded payment_methods row 1'),
  (2, 'Payment Methods 2', 'delivered', '2024-02-02 10:02:00', 'Seeded payment_methods row 2'),
  (3, 'Payment Methods 3', 'active', '2024-03-03 10:03:00', 'Seeded payment_methods row 3');

INSERT INTO shipping_methods (carrier_id, name, status, created_at, notes) VALUES
  (1, 'Shipping Methods 1', 'pending', '2024-01-01 10:01:00', 'Seeded shipping_methods row 1'),
  (2, 'Shipping Methods 2', 'delivered', '2024-02-02 10:02:00', 'Seeded shipping_methods row 2'),
  (3, 'Shipping Methods 3', 'active', '2024-03-03 10:03:00', 'Seeded shipping_methods row 3');

INSERT INTO coupons (promotion_id, name, status, created_at, notes) VALUES
  (1, 'Coupons 1', 'pending', '2024-01-01 10:01:00', 'Seeded coupons row 1'),
  (2, 'Coupons 2', 'delivered', '2024-02-02 10:02:00', 'Seeded coupons row 2'),
  (3, 'Coupons 3', 'active', '2024-03-03 10:03:00', 'Seeded coupons row 3');

INSERT INTO gift_cards (currency_id, purchased_by_customer_id, name, status, created_at, notes) VALUES
  (1, 1, 'Gift Cards 1', 'pending', '2024-01-01 10:01:00', 'Seeded gift_cards row 1'),
  (2, 2, 'Gift Cards 2', 'delivered', '2024-02-02 10:02:00', 'Seeded gift_cards row 2'),
  (3, 3, 'Gift Cards 3', 'active', '2024-03-03 10:03:00', 'Seeded gift_cards row 3');

INSERT INTO campaign_events (campaign_id, customer_id, event_type, event_at, details) VALUES
  (1, 1, 'Campaign Events 1', '2024-01-01 10:01:00', '{"seed": 1, "tier": "plus"}'),
  (2, 2, 'Campaign Events 2', '2024-02-02 10:02:00', '{"seed": 2, "tier": "vip"}'),
  (3, 3, 'Campaign Events 3', '2024-03-03 10:03:00', '{"seed": 3, "tier": "basic"}');

INSERT INTO email_sends (template_id, customer_id, campaign_id, name, status, created_at, notes) VALUES
  (1, 1, 1, 'Email Sends 1', 'pending', '2024-01-01 10:01:00', 'Seeded email_sends row 1'),
  (2, 2, 2, 'Email Sends 2', 'delivered', '2024-02-02 10:02:00', 'Seeded email_sends row 2'),
  (3, 3, 3, 'Email Sends 3', 'active', '2024-03-03 10:03:00', 'Seeded email_sends row 3');

INSERT INTO web_sessions (customer_id, channel_id, name, status, created_at, notes) VALUES
  (1, 1, 'Web Sessions 1', 'pending', '2024-01-01 10:01:00', 'Seeded web_sessions row 1'),
  (2, 2, 'Web Sessions 2', 'delivered', '2024-02-02 10:02:00', 'Seeded web_sessions row 2'),
  (3, 3, 'Web Sessions 3', 'active', '2024-03-03 10:03:00', 'Seeded web_sessions row 3');

INSERT INTO ab_test_assignments (ab_test_id, customer_id, name, status, created_at, notes) VALUES
  (1, 1, 'Ab Test Assignments 1', 'pending', '2024-01-01 10:01:00', 'Seeded ab_test_assignments row 1'),
  (2, 2, 'Ab Test Assignments 2', 'delivered', '2024-02-02 10:02:00', 'Seeded ab_test_assignments row 2'),
  (3, 3, 'Ab Test Assignments 3', 'active', '2024-03-03 10:03:00', 'Seeded ab_test_assignments row 3');

INSERT INTO audit_logs (employee_id, event_type, event_at, details) VALUES
  (1, 'Audit Logs 1', '2024-01-01 10:01:00', '{"seed": 1, "tier": "plus"}'),
  (2, 'Audit Logs 2', '2024-02-02 10:02:00', '{"seed": 2, "tier": "vip"}'),
  (3, 'Audit Logs 3', '2024-03-03 10:03:00', '{"seed": 3, "tier": "basic"}');

INSERT INTO data_exports (requested_by_employee_id, name, status, created_at, notes) VALUES
  (1, 'Data Exports 1', 'pending', '2024-01-01 10:01:00', 'Seeded data_exports row 1'),
  (2, 'Data Exports 2', 'delivered', '2024-02-02 10:02:00', 'Seeded data_exports row 2'),
  (3, 'Data Exports 3', 'active', '2024-03-03 10:03:00', 'Seeded data_exports row 3');

INSERT INTO daily_sales_summary (store_id, channel_id, currency_id, summary_date, metric_count, metric_amount) VALUES
  (1, 1, 1, '2024-01-01', 18, 479.39),
  (2, 2, 2, '2024-02-02', 18, 13.35),
  (3, 3, 3, '2024-03-03', 19, 167.29);

INSERT INTO vendor_scorecards (supplier_id, summary_date, metric_count, metric_amount) VALUES
  (1, '2024-01-01', 5, 53.06),
  (2, '2024-02-02', 2, 404.0),
  (3, '2024-03-03', 23, 65.37);

INSERT INTO route_plans (warehouse_id, carrier_id, name, status, created_at, notes) VALUES
  (1, 1, 'Route Plans 1', 'pending', '2024-01-01 10:01:00', 'Seeded route_plans row 1'),
  (2, 2, 'Route Plans 2', 'delivered', '2024-02-02 10:02:00', 'Seeded route_plans row 2'),
  (3, 3, 'Route Plans 3', 'active', '2024-03-03 10:03:00', 'Seeded route_plans row 3');

INSERT INTO store_transfers (from_store_id, to_store_id, requested_by_employee_id, name, status, created_at, notes) VALUES
  (1, 1, 1, 'Store Transfers 1', 'pending', '2024-01-01 10:01:00', 'Seeded store_transfers row 1'),
  (2, 2, 2, 'Store Transfers 2', 'delivered', '2024-02-02 10:02:00', 'Seeded store_transfers row 2'),
  (3, 3, 3, 'Store Transfers 3', 'active', '2024-03-03 10:03:00', 'Seeded store_transfers row 3');

INSERT INTO pos_registers (store_id, name, status, created_at, notes) VALUES
  (1, 'Pos Registers 1', 'pending', '2024-01-01 10:01:00', 'Seeded pos_registers row 1'),
  (2, 'Pos Registers 2', 'delivered', '2024-02-02 10:02:00', 'Seeded pos_registers row 2'),
  (3, 'Pos Registers 3', 'active', '2024-03-03 10:03:00', 'Seeded pos_registers row 3');

INSERT INTO product_categories (product_id, category_id, is_primary) VALUES
  (1, 1, FALSE),
  (2, 2, TRUE),
  (3, 3, FALSE);

INSERT INTO product_images (product_id, url, alt_text, sort_order) VALUES
  (1, 'Product Images 1', 'Seeded product_images row 1', 11),
  (2, 'Product Images 2', 'Seeded product_images row 2', 2),
  (3, 'Product Images 3', 'Seeded product_images row 3', 16);

INSERT INTO product_variants (product_id, sku, color, size, price_delta) VALUES
  (1, 'PRO-00001', 'Product Variants 1', 'Product Variants 1', 167.35),
  (2, 'PRO-00002', 'Product Variants 2', 'Product Variants 2', 394.33),
  (3, 'PRO-00003', 'Product Variants 3', 'Product Variants 3', 332.25);

INSERT INTO product_bundle_items (bundle_id, product_id, quantity) VALUES
  (1, 1, 11),
  (2, 2, 15),
  (3, 3, 1);

INSERT INTO product_prices (product_id, price_list_id, name, status, created_at, notes) VALUES
  (1, 1, 'Product Prices 1', 'pending', '2024-01-01 10:01:00', 'Seeded product_prices row 1'),
  (2, 2, 'Product Prices 2', 'delivered', '2024-02-02 10:02:00', 'Seeded product_prices row 2'),
  (3, 3, 'Product Prices 3', 'active', '2024-03-03 10:03:00', 'Seeded product_prices row 3');

INSERT INTO price_history (product_id, currency_id, name, status, created_at, notes) VALUES
  (1, 1, 'Price History 1', 'pending', '2024-01-01 10:01:00', 'Seeded price_history row 1'),
  (2, 2, 'Price History 2', 'delivered', '2024-02-02 10:02:00', 'Seeded price_history row 2'),
  (3, 3, 'Price History 3', 'active', '2024-03-03 10:03:00', 'Seeded price_history row 3');

INSERT INTO inventory_items (product_id, warehouse_id, quantity, unit_price, line_total) VALUES
  (1, 1, 16, 332.12, 21.75),
  (2, 2, 5, 206.39, 410.05),
  (3, 3, 10, 216.77, 352.89);

INSERT INTO purchase_order_items (purchase_order_id, product_id, quantity, unit_price, line_total) VALUES
  (1, 1, 20, 130.89, 124.98),
  (2, 2, 14, 418.98, 172.34),
  (3, 3, 4, 375.91, 116.77);

INSERT INTO receiving_batches (purchase_order_id, warehouse_id, name, status, created_at, notes) VALUES
  (1, 1, 'Receiving Batches 1', 'pending', '2024-01-01 10:01:00', 'Seeded receiving_batches row 1'),
  (2, 2, 'Receiving Batches 2', 'delivered', '2024-02-02 10:02:00', 'Seeded receiving_batches row 2'),
  (3, 3, 'Receiving Batches 3', 'active', '2024-03-03 10:03:00', 'Seeded receiving_batches row 3');

INSERT INTO cart_items (cart_id, product_id, quantity, unit_price, line_total) VALUES
  (1, 1, 7, 372.89, 406.24),
  (2, 2, 11, 433.95, 449.43),
  (3, 3, 22, 161.24, 386.64);

INSERT INTO wishlist_items (wishlist_id, product_id, quantity, unit_price, line_total) VALUES
  (1, 1, 12, 276.57, 420.6),
  (2, 2, 22, 454.7, 167.42),
  (3, 3, 23, 115.95, 216.92);

INSERT INTO orders (customer_id, store_id, channel_id, billing_address_id, shipping_address_id, order_number, status, ordered_at, subtotal, discount_amount, tax_amount, shipping_amount, total_amount) VALUES
  (1, 1, 1, 1, 1, 'ORD-000001', 'paid', '2024-01-01 10:01:00', 204.63, 357.91, 19.37, 143.35, 457.61),
  (2, 2, 2, 2, 2, 'ORD-000002', 'delivered', '2024-02-02 10:02:00', 481.09, 418.26, 474.2, 260.24, 482.62),
  (3, 3, 3, 3, 3, 'ORD-000003', 'pending', '2024-03-03 10:03:00', 41.92, 372.28, 0.0, 191.32, 21.12),
  (1, 1, 1, 1, 1, 'ORD-000004', 'paid', '2024-04-04 10:04:00', 455.12, 331.08, 18.88, 195.99, 474.69),
  (2, 2, 2, 2, 2, 'ORD-000005', 'delivered', '2024-05-05 10:05:00', 208.57, 267.62, 20.35, 212.64, 311.83),
  (3, 3, 3, 3, 3, 'ORD-000006', 'pending', '2024-06-06 10:06:00', 331.74, 316.77, 0.0, 333.78, 375.81),
  (1, 1, 1, 1, 1, 'ORD-000007', 'paid', '2024-07-07 10:07:00', 355.17, 219.03, 290.06, 470.84, 376.79),
  (2, 2, 2, 2, 2, 'ORD-000008', 'delivered', '2024-08-08 10:08:00', 82.7, 43.84, 380.45, 366.02, 5.8),
  (3, 3, 3, 3, 3, 'ORD-000009', 'pending', '2024-09-09 10:09:00', 208.13, 161.46, 0.0, 338.25, 283.0),
  (1, 1, 1, 1, 1, 'ORD-000010', 'paid', '2024-10-10 10:10:00', 289.45, 17.85, 32.5, 191.41, 297.04),
  (2, 2, 2, 2, 2, 'ORD-000011', 'delivered', '2024-11-11 10:11:00', 270.66, 10.44, 146.23, 94.28, 361.03),
  (3, 3, 3, 3, 3, 'ORD-000012', 'pending', '2024-12-12 10:12:00', 248.85, 56.35, 0.0, 74.34, 32.02);

INSERT INTO product_questions (product_id, customer_id, name, status, created_at, notes) VALUES
  (1, 1, 'Product Questions 1', 'pending', '2024-01-01 10:01:00', 'Seeded product_questions row 1'),
  (2, 2, 'Product Questions 2', 'delivered', '2024-02-02 10:02:00', 'Seeded product_questions row 2'),
  (3, 3, 'Product Questions 3', 'active', '2024-03-03 10:03:00', 'Seeded product_questions row 3');

INSERT INTO product_view_events (session_id, product_id, event_type, event_at, details) VALUES
  (1, 1, 'Product View Events 1', '2024-01-01 10:01:00', '{"seed": 1, "tier": "plus"}'),
  (2, 2, 'Product View Events 2', '2024-02-02 10:02:00', '{"seed": 2, "tier": "vip"}'),
  (3, 3, 'Product View Events 3', '2024-03-03 10:03:00', '{"seed": 3, "tier": "basic"}'),
  (1, 1, 'Product View Events 4', '2024-04-04 10:04:00', '{"seed": 4, "tier": "plus"}'),
  (2, 2, 'Product View Events 5', '2024-05-05 10:05:00', '{"seed": 5, "tier": "vip"}'),
  (3, 3, 'Product View Events 6', '2024-06-06 10:06:00', '{"seed": 6, "tier": "basic"}'),
  (1, 1, 'Product View Events 7', '2024-07-07 10:07:00', '{"seed": 7, "tier": "plus"}'),
  (2, 2, 'Product View Events 8', '2024-08-08 10:08:00', '{"seed": 8, "tier": "vip"}'),
  (3, 3, 'Product View Events 9', '2024-09-09 10:09:00', '{"seed": 9, "tier": "basic"}'),
  (1, 1, 'Product View Events 10', '2024-10-10 10:10:00', '{"seed": 10, "tier": "plus"}'),
  (2, 2, 'Product View Events 11', '2024-11-11 10:11:00', '{"seed": 11, "tier": "vip"}'),
  (3, 3, 'Product View Events 12', '2024-12-12 10:12:00', '{"seed": 12, "tier": "basic"}');

INSERT INTO search_logs (session_id, event_type, event_at, details) VALUES
  (1, 'Search Logs 1', '2024-01-01 10:01:00', '{"seed": 1, "tier": "plus"}'),
  (2, 'Search Logs 2', '2024-02-02 10:02:00', '{"seed": 2, "tier": "vip"}'),
  (3, 'Search Logs 3', '2024-03-03 10:03:00', '{"seed": 3, "tier": "basic"}'),
  (1, 'Search Logs 4', '2024-04-04 10:04:00', '{"seed": 4, "tier": "plus"}'),
  (2, 'Search Logs 5', '2024-05-05 10:05:00', '{"seed": 5, "tier": "vip"}'),
  (3, 'Search Logs 6', '2024-06-06 10:06:00', '{"seed": 6, "tier": "basic"}'),
  (1, 'Search Logs 7', '2024-07-07 10:07:00', '{"seed": 7, "tier": "plus"}'),
  (2, 'Search Logs 8', '2024-08-08 10:08:00', '{"seed": 8, "tier": "vip"}'),
  (3, 'Search Logs 9', '2024-09-09 10:09:00', '{"seed": 9, "tier": "basic"}'),
  (1, 'Search Logs 10', '2024-10-10 10:10:00', '{"seed": 10, "tier": "plus"}'),
  (2, 'Search Logs 11', '2024-11-11 10:11:00', '{"seed": 11, "tier": "vip"}'),
  (3, 'Search Logs 12', '2024-12-12 10:12:00', '{"seed": 12, "tier": "basic"}');

INSERT INTO monthly_inventory_snapshot (warehouse_id, product_id, summary_date, metric_count, metric_amount) VALUES
  (1, 1, '2024-01-01', 16, 234.44),
  (2, 2, '2024-02-02', 12, 135.49),
  (3, 3, '2024-03-03', 24, 241.66);

INSERT INTO store_inventory (store_id, product_id, name, status, created_at, notes) VALUES
  (1, 1, 'Store Inventory 1', 'pending', '2024-01-01 10:01:00', 'Seeded store_inventory row 1'),
  (2, 2, 'Store Inventory 2', 'delivered', '2024-02-02 10:02:00', 'Seeded store_inventory row 2'),
  (3, 3, 'Store Inventory 3', 'active', '2024-03-03 10:03:00', 'Seeded store_inventory row 3');

INSERT INTO transfer_items (transfer_id, product_id, quantity, unit_price, line_total) VALUES
  (1, 1, 8, 68.55, 388.61),
  (2, 2, 18, 267.69, 172.86),
  (3, 3, 18, 177.85, 70.08);

INSERT INTO pos_transactions (register_id, customer_id, employee_id, order_number, status, ordered_at, subtotal, discount_amount, tax_amount, shipping_amount, total_amount) VALUES
  (1, 1, 1, 'ORD-000001', 'paid', '2024-01-01 10:01:00', 318.69, 159.42, 443.36, 493.73, 184.38),
  (2, 2, 2, 'ORD-000002', 'delivered', '2024-02-02 10:02:00', 22.0, 135.85, 278.51, 382.73, 184.67),
  (3, 3, 3, 'ORD-000003', 'pending', '2024-03-03 10:03:00', 196.32, 122.82, 450.36, 170.55, 474.78);

INSERT INTO inventory_adjustments (inventory_item_id, employee_id, name, status, created_at, notes) VALUES
  (1, 1, 'Inventory Adjustments 1', 'pending', '2024-01-01 10:01:00', 'Seeded inventory_adjustments row 1'),
  (2, 2, 'Inventory Adjustments 2', 'delivered', '2024-02-02 10:02:00', 'Seeded inventory_adjustments row 2'),
  (3, 3, 'Inventory Adjustments 3', 'active', '2024-03-03 10:03:00', 'Seeded inventory_adjustments row 3');

INSERT INTO stock_reservations (inventory_item_id, order_id, name, status, created_at, notes) VALUES
  (1, 1, 'Stock Reservations 1', 'pending', '2024-01-01 10:01:00', 'Seeded stock_reservations row 1'),
  (2, 2, 'Stock Reservations 2', 'delivered', '2024-02-02 10:02:00', 'Seeded stock_reservations row 2'),
  (3, 3, 'Stock Reservations 3', 'active', '2024-03-03 10:03:00', 'Seeded stock_reservations row 3');

INSERT INTO quality_inspections (receiving_batch_id, employee_id, name, status, created_at, notes) VALUES
  (1, 1, 'Quality Inspections 1', 'pending', '2024-01-01 10:01:00', 'Seeded quality_inspections row 1'),
  (2, 2, 'Quality Inspections 2', 'delivered', '2024-02-02 10:02:00', 'Seeded quality_inspections row 2'),
  (3, 3, 'Quality Inspections 3', 'active', '2024-03-03 10:03:00', 'Seeded quality_inspections row 3');

INSERT INTO order_items (order_id, product_id, product_variant_id, quantity, unit_price, line_total) VALUES
  (1, 1, 1, 3, 23.82, 432.33),
  (2, 2, 2, 15, 364.94, 401.01),
  (3, 3, 3, 22, 419.3, 309.31),
  (1, 1, 1, 24, 232.84, 181.3),
  (2, 2, 2, 18, 68.94, 357.66),
  (3, 3, 3, 20, 170.27, 328.21),
  (1, 1, 1, 20, 441.18, 330.65),
  (2, 2, 2, 7, 173.55, 126.32),
  (3, 3, 3, 4, 82.61, 89.74),
  (1, 1, 1, 10, 54.53, 192.94),
  (2, 2, 2, 3, 82.96, 61.89),
  (3, 3, 3, 6, 389.86, 399.07);

INSERT INTO order_status_history (order_id, changed_by_employee_id, name, status, created_at, notes) VALUES
  (1, 1, 'Order Status History 1', 'pending', '2024-01-01 10:01:00', 'Seeded order_status_history row 1'),
  (2, 2, 'Order Status History 2', 'delivered', '2024-02-02 10:02:00', 'Seeded order_status_history row 2'),
  (3, 3, 'Order Status History 3', 'active', '2024-03-03 10:03:00', 'Seeded order_status_history row 3');

INSERT INTO order_discounts (order_id, coupon_id, name, status, created_at, notes) VALUES
  (1, 1, 'Order Discounts 1', 'pending', '2024-01-01 10:01:00', 'Seeded order_discounts row 1'),
  (2, 2, 'Order Discounts 2', 'delivered', '2024-02-02 10:02:00', 'Seeded order_discounts row 2'),
  (3, 3, 'Order Discounts 3', 'active', '2024-03-03 10:03:00', 'Seeded order_discounts row 3');

INSERT INTO payments (order_id, payment_method_id, status, created_at, amount, notes) VALUES
  (1, 1, 'pending', '2024-01-01 10:01:00', 87.73, 'Seeded payments row 1'),
  (2, 2, 'delivered', '2024-02-02 10:02:00', 295.75, 'Seeded payments row 2'),
  (3, 3, 'active', '2024-03-03 10:03:00', 120.76, 'Seeded payments row 3');

INSERT INTO shipments (order_id, shipping_method_id, warehouse_id, name, status, created_at, notes) VALUES
  (1, 1, 1, 'Shipments 1', 'pending', '2024-01-01 10:01:00', 'Seeded shipments row 1'),
  (2, 2, 2, 'Shipments 2', 'delivered', '2024-02-02 10:02:00', 'Seeded shipments row 2'),
  (3, 3, 3, 'Shipments 3', 'active', '2024-03-03 10:03:00', 'Seeded shipments row 3');

INSERT INTO returns (order_id, customer_id, name, status, created_at, notes) VALUES
  (1, 1, 'Returns 1', 'pending', '2024-01-01 10:01:00', 'Seeded returns row 1'),
  (2, 2, 'Returns 2', 'delivered', '2024-02-02 10:02:00', 'Seeded returns row 2'),
  (3, 3, 'Returns 3', 'active', '2024-03-03 10:03:00', 'Seeded returns row 3');

INSERT INTO coupon_redemptions (coupon_id, customer_id, order_id, name, status, created_at, notes) VALUES
  (1, 1, 1, 'Coupon Redemptions 1', 'pending', '2024-01-01 10:01:00', 'Seeded coupon_redemptions row 1'),
  (2, 2, 2, 'Coupon Redemptions 2', 'delivered', '2024-02-02 10:02:00', 'Seeded coupon_redemptions row 2'),
  (3, 3, 3, 'Coupon Redemptions 3', 'active', '2024-03-03 10:03:00', 'Seeded coupon_redemptions row 3');

INSERT INTO gift_card_transactions (gift_card_id, order_id, status, created_at, amount, notes) VALUES
  (1, 1, 'pending', '2024-01-01 10:01:00', 357.89, 'Seeded gift_card_transactions row 1'),
  (2, 2, 'delivered', '2024-02-02 10:02:00', 68.38, 'Seeded gift_card_transactions row 2'),
  (3, 3, 'active', '2024-03-03 10:03:00', 227.0, 'Seeded gift_card_transactions row 3');

INSERT INTO product_answers (question_id, employee_id, name, status, created_at, notes) VALUES
  (1, 1, 'Product Answers 1', 'pending', '2024-01-01 10:01:00', 'Seeded product_answers row 1'),
  (2, 2, 'Product Answers 2', 'delivered', '2024-02-02 10:02:00', 'Seeded product_answers row 2'),
  (3, 3, 'Product Answers 3', 'active', '2024-03-03 10:03:00', 'Seeded product_answers row 3');

INSERT INTO loyalty_transactions (customer_id, order_id, program_id, name, status, created_at, notes) VALUES
  (1, 1, 1, 'Loyalty Transactions 1', 'pending', '2024-01-01 10:01:00', 'Seeded loyalty_transactions row 1'),
  (2, 2, 2, 'Loyalty Transactions 2', 'delivered', '2024-02-02 10:02:00', 'Seeded loyalty_transactions row 2'),
  (3, 3, 3, 'Loyalty Transactions 3', 'active', '2024-03-03 10:03:00', 'Seeded loyalty_transactions row 3');

INSERT INTO customer_support_tickets (customer_id, order_id, assigned_employee_id, name, status, created_at, notes) VALUES
  (1, 1, 1, 'Customer Support Tickets 1', 'pending', '2024-01-01 10:01:00', 'Seeded customer_support_tickets row 1'),
  (2, 2, 2, 'Customer Support Tickets 2', 'delivered', '2024-02-02 10:02:00', 'Seeded customer_support_tickets row 2'),
  (3, 3, 3, 'Customer Support Tickets 3', 'active', '2024-03-03 10:03:00', 'Seeded customer_support_tickets row 3');

INSERT INTO fraud_checks (order_id, name, status, created_at, notes) VALUES
  (1, 'Fraud Checks 1', 'pending', '2024-01-01 10:01:00', 'Seeded fraud_checks row 1'),
  (2, 'Fraud Checks 2', 'delivered', '2024-02-02 10:02:00', 'Seeded fraud_checks row 2'),
  (3, 'Fraud Checks 3', 'active', '2024-03-03 10:03:00', 'Seeded fraud_checks row 3');

INSERT INTO pos_transaction_items (transaction_id, product_id, quantity, unit_price, line_total) VALUES
  (1, 1, 16, 36.35, 409.38),
  (2, 2, 6, 210.53, 285.06),
  (3, 3, 9, 337.55, 317.87);

INSERT INTO payment_refunds (payment_id, status, created_at, amount, notes) VALUES
  (1, 'pending', '2024-01-01 10:01:00', 439.49, 'Seeded payment_refunds row 1'),
  (2, 'delivered', '2024-02-02 10:02:00', 266.81, 'Seeded payment_refunds row 2'),
  (3, 'active', '2024-03-03 10:03:00', 101.69, 'Seeded payment_refunds row 3');

INSERT INTO shipment_items (shipment_id, order_item_id, quantity, unit_price, line_total) VALUES
  (1, 1, 21, 83.37, 363.86),
  (2, 2, 21, 395.07, 420.32),
  (3, 3, 4, 116.18, 243.44);

INSERT INTO shipment_tracking_events (shipment_id, event_type, event_at, details) VALUES
  (1, 'Shipment Tracking Events 1', '2024-01-01 10:01:00', '{"seed": 1, "tier": "plus"}'),
  (2, 'Shipment Tracking Events 2', '2024-02-02 10:02:00', '{"seed": 2, "tier": "vip"}'),
  (3, 'Shipment Tracking Events 3', '2024-03-03 10:03:00', '{"seed": 3, "tier": "basic"}');

INSERT INTO return_items (return_id, order_item_id, reason_id, quantity, unit_price, line_total) VALUES
  (1, 1, 1, 6, 230.76, 219.82),
  (2, 2, 2, 1, 274.58, 486.11),
  (3, 3, 3, 5, 355.15, 254.32);

INSERT INTO refunds (return_id, payment_id, status, created_at, amount, notes) VALUES
  (1, 1, 'pending', '2024-01-01 10:01:00', 17.95, 'Seeded refunds row 1'),
  (2, 2, 'delivered', '2024-02-02 10:02:00', 322.74, 'Seeded refunds row 2'),
  (3, 3, 'active', '2024-03-03 10:03:00', 412.79, 'Seeded refunds row 3');

INSERT INTO reviews (product_id, customer_id, order_item_id, name, status, created_at, notes) VALUES
  (1, 1, 1, 'Reviews 1', 'pending', '2024-01-01 10:01:00', 'Seeded reviews row 1'),
  (2, 2, 2, 'Reviews 2', 'delivered', '2024-02-02 10:02:00', 'Seeded reviews row 2'),
  (3, 3, 3, 'Reviews 3', 'active', '2024-03-03 10:03:00', 'Seeded reviews row 3');

INSERT INTO ticket_messages (ticket_id, employee_id, name, status, created_at, notes) VALUES
  (1, 1, 'Ticket Messages 1', 'pending', '2024-01-01 10:01:00', 'Seeded ticket_messages row 1'),
  (2, 2, 'Ticket Messages 2', 'delivered', '2024-02-02 10:02:00', 'Seeded ticket_messages row 2'),
  (3, 3, 'Ticket Messages 3', 'active', '2024-03-03 10:03:00', 'Seeded ticket_messages row 3');

INSERT INTO delivery_stops (route_plan_id, shipment_id, name, status, created_at, notes) VALUES
  (1, 1, 'Delivery Stops 1', 'pending', '2024-01-01 10:01:00', 'Seeded delivery_stops row 1'),
  (2, 2, 'Delivery Stops 2', 'delivered', '2024-02-02 10:02:00', 'Seeded delivery_stops row 2'),
  (3, 3, 'Delivery Stops 3', 'active', '2024-03-03 10:03:00', 'Seeded delivery_stops row 3');

INSERT INTO review_votes (review_id, customer_id, name, status, created_at, notes) VALUES
  (1, 1, 'Review Votes 1', 'pending', '2024-01-01 10:01:00', 'Seeded review_votes row 1'),
  (2, 2, 'Review Votes 2', 'delivered', '2024-02-02 10:02:00', 'Seeded review_votes row 2'),
  (3, 3, 'Review Votes 3', 'active', '2024-03-03 10:03:00', 'Seeded review_votes row 3');

INSERT INTO delivery_proof (delivery_stop_id, name, status, created_at, notes) VALUES
  (1, 'Delivery Proof 1', 'pending', '2024-01-01 10:01:00', 'Seeded delivery_proof row 1'),
  (2, 'Delivery Proof 2', 'delivered', '2024-02-02 10:02:00', 'Seeded delivery_proof row 2'),
  (3, 'Delivery Proof 3', 'active', '2024-03-03 10:03:00', 'Seeded delivery_proof row 3');

SET FOREIGN_KEY_CHECKS=1;
