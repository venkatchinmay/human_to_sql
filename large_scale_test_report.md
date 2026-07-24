# Large-Scale Test Suite Report

**Date:** 2026-07-21T20:40:49.471377

## Test Results

**Passed:** 72/100

**Total Cases:** 100

### Test 1: ❌ FAIL
**Question:** Show me all records from domain_entity_6, including the linked categories, regions, departments, and companies.
**Expected Tables:** domain_entity_6, categories, regions, departments, companies
**Retrieved Tables:** departments, domain_entity_38, categories, companies, domain_entity_80, domain_entity_16, domain_entity_27, domain_entity_77, domain_entity_95, domain_entity_6, domain_entity_26, domain_entity_15, domain_entity_78, domain_entity_12, domain_entity_8, users, domain_entity_61, domain_entity_22, domain_entity_28, domain_entity_79, domain_entity_33, domain_entity_7, domain_entity_9
**Generated SQL:**
```sql
SELECT 
  d.id, 
  d.name, 
  c.name AS category_name, 
  r.name AS region_name, 
  dep.name AS department_name, 
  co.name AS company_name 
FROM domain_entity_6 d
JOIN categories c ON d.categories_id = c.id
LEFT JOIN departments dep ON d.departments_id = dep.id
LEFT JOIN companies co ON dep.companies_id = co.id
```

---

### Test 2: ❌ FAIL
**Question:** Show me all records from domain_entity_7, including the linked domain_entity_6, categories, regions, and departments.
**Expected Tables:** domain_entity_7, domain_entity_6, categories, regions, departments
**Retrieved Tables:** departments, categories, companies, domain_entity_80, domain_entity_69, domain_entity_71, domain_entity_16, domain_entity_27, domain_entity_95, domain_entity_96, domain_entity_6, domain_entity_15, domain_entity_78, domain_entity_12, domain_entity_8, users, domain_entity_61, domain_entity_22, domain_entity_79, domain_entity_33, domain_entity_7, domain_entity_9, domain_entity_70
**Generated SQL:**
```sql
SELECT
    d.*,
    ce.*
FROM
    domain_entity_7 d
JOIN
    domain_entity_6 ce ON d.id = ce.id
LEFT JOIN 
    categories c ON ce.categories_id = c.id
LEFT JOIN 
    regions r ON c.regions_id = r.id
LEFT JOIN 
    departments dp ON r.departments_id = dp.id;
```

---

### Test 3: ❌ FAIL
**Question:** Show me all records from domain_entity_8, including the linked domain_entity_7, domain_entity_6, categories, and regions.
**Expected Tables:** domain_entity_8, domain_entity_7, domain_entity_6, categories, regions
**Retrieved Tables:** departments, categories, domain_entity_55, companies, domain_entity_69, domain_entity_71, domain_entity_16, domain_entity_27, domain_entity_96, domain_entity_6, domain_entity_26, domain_entity_15, domain_entity_10, domain_entity_12, domain_entity_8, users, domain_entity_61, domain_entity_14, domain_entity_22, domain_entity_33, domain_entity_7, domain_entity_9, domain_entity_70
**Generated SQL:**
```sql
SELECT 
    de8.*, 
    de7.name AS domain_entity_7_name, 
    de6.name AS domain_entity_6_name, 
    c.name AS category_name,
    r.name AS region_name
FROM domain_entity_8 de8
JOIN domain_entity_7 de7 ON de8.domain_entity_7_id = de7.id
JOIN domain_entity_6 de6 ON de8.domain_entity_6_id = de6.id
JOIN categories c ON de6.categories_id = c.id
JOIN regions r ON c.regions_id = r.id;
```

---

### Test 4: ✅ PASS
**Question:** Show me all records from domain_entity_9, including the linked domain_entity_8, domain_entity_7, domain_entity_6, and categories.
**Expected Tables:** domain_entity_9, domain_entity_8, domain_entity_7, domain_entity_6, categories
**Retrieved Tables:** domain_entity_11, departments, categories, domain_entity_55, domain_entity_69, domain_entity_71, domain_entity_27, domain_entity_96, domain_entity_6, domain_entity_26, domain_entity_10, domain_entity_47, domain_entity_40, domain_entity_8, domain_entity_44, domain_entity_51, domain_entity_42, users, domain_entity_61, domain_entity_14, domain_entity_41, domain_entity_33, domain_entity_7, domain_entity_9, domain_entity_70
**Generated SQL:**
```sql
SELECT 
    d.id, d.name, 
    e8.name AS domain_entity_8_name,
    e7.name AS domain_entity_7_name,
    e6.name AS domain_entity_6_name,
    c.name AS categories_name
FROM domain_entity_9 d 
LEFT JOIN domain_entity_8 e8 ON d.domain_entity_8_id = e8.id
LEFT JOIN domain_entity_7 e7 ON d.domain_entity_7_id = e7.id
LEFT JOIN domain_entity_6 e6 ON d.domain_entity_6_id = e6.id 
LEFT JOIN categories c ON d.categories_id = c.id;
```

---

### Test 5: ✅ PASS
**Question:** Show me all records from domain_entity_10, including the linked domain_entity_9, domain_entity_8, domain_entity_7, and domain_entity_6.
**Expected Tables:** domain_entity_10, domain_entity_9, domain_entity_8, domain_entity_7, domain_entity_6
**Retrieved Tables:** domain_entity_11, domain_entity_55, companies, domain_entity_62, domain_entity_45, domain_entity_43, domain_entity_6, domain_entity_26, domain_entity_10, domain_entity_47, domain_entity_12, domain_entity_8, domain_entity_44, users, domain_entity_94, domain_entity_14, domain_entity_22, domain_entity_7, domain_entity_9
**Generated SQL:**
```sql
SELECT 
  domain_entity_10.*,
  domain_entity_9.*
FROM domain_entity_10
JOIN domain_entity_9 ON domain_entity_10.domain_entity_9_id = domain_entity_9.id
LEFT JOIN domain_entity_8 ON domain_entity_10.domain_entity_8_id = domain_entity_8.id
LEFT JOIN domain_entity_7 ON domain_entity_10.domain_entity_7_id = domain_entity_7.id
LEFT JOIN domain_entity_6 ON domain_entity_10.domain_entity_6_id = domain_entity_6.id
```

---

### Test 6: ✅ PASS
**Question:** Show me all records from domain_entity_11, including the linked domain_entity_10, domain_entity_9, domain_entity_8, and domain_entity_7.
**Expected Tables:** domain_entity_11, domain_entity_10, domain_entity_9, domain_entity_8, domain_entity_7
**Retrieved Tables:** domain_entity_11, domain_entity_55, companies, domain_entity_13, domain_entity_6, domain_entity_26, domain_entity_10, domain_entity_47, domain_entity_12, domain_entity_8, domain_entity_44, users, domain_entity_39, domain_entity_14, domain_entity_22, domain_entity_28, domain_entity_7, domain_entity_9, domain_entity_24
**Generated SQL:**
```sql
SELECT 
  de11.*, 
  d10.name AS domain_entity_10_name,
  d9.name AS domain_entity_9_name,
  d8.name AS domain_entity_8_name,
  d7.name AS domain_entity_7_name
FROM domain_entity_11 de11
LEFT JOIN domain_entity_10 d10 ON de11.domain_entity_10_id = d10.id 
LEFT JOIN domain_entity_9 d9 ON de11.domain_entity_9_id = d9.id
LEFT JOIN domain_entity_8 d8 ON de11.domain_entity_8_id = d8.id
LEFT JOIN domain_entity_7 d7 ON de11.domain_entity_7_id = d7.id
```

---

### Test 7: ❌ FAIL (API Error)
**Error:** Expecting value: line 1 column 1 (char 0)

---

### Test 8: ✅ PASS
**Question:** Show me all records from domain_entity_13, including the linked domain_entity_12, domain_entity_11, domain_entity_10, and domain_entity_9.
**Expected Tables:** domain_entity_13, domain_entity_12, domain_entity_11, domain_entity_10, domain_entity_9
**Retrieved Tables:** domain_entity_30, domain_entity_7, domain_entity_11, companies, domain_entity_13, domain_entity_34, domain_entity_15, domain_entity_10, domain_entity_47, domain_entity_12, domain_entity_44, users, domain_entity_39, domain_entity_14, domain_entity_28, domain_entity_17, domain_entity_9, domain_entity_24, domain_entity_92
**Generated SQL:**
```sql
SELECT 
  d1.*
FROM domain_entity_13 d1
LEFT JOIN domain_entity_12 d2 ON d1.domain_entity_12_id = d2.id
LEFT JOIN domain_entity_11 d3 ON d2.domain_entity_11_id = d3.id
LEFT JOIN domain_entity_10 d4 ON d3.domain_entity_10_id = d4.id
LEFT JOIN domain_entity_9 d5 ON d4.domain_entity_9_id = d5.id;
```

---

### Test 9: ✅ PASS
**Question:** Show me all records from domain_entity_14, including the linked domain_entity_13, domain_entity_12, domain_entity_11, and domain_entity_10.
**Expected Tables:** domain_entity_14, domain_entity_13, domain_entity_12, domain_entity_11, domain_entity_10
**Retrieved Tables:** domain_entity_30, domain_entity_7, domain_entity_11, companies, domain_entity_13, domain_entity_16, domain_entity_34, domain_entity_15, domain_entity_10, domain_entity_78, domain_entity_12, domain_entity_49, domain_entity_39, domain_entity_14, domain_entity_28, domain_entity_17, domain_entity_9, domain_entity_24, domain_entity_92
**Generated SQL:**
```sql
SELECT 
  de14.*, 
  de13.name, 
  de12.* , 
  de11.*, 
  de10.* 
FROM domain_entity_14 de14 
JOIN domain_entity_13 de13 ON de14.domain_entity_13_id = de13.id 
JOIN domain_entity_12 de12 ON de14.domain_entity_12_id = de12.id 
JOIN domain_entity_11 de11 ON de14.domain_entity_11_id = de11.id 
JOIN domain_entity_10 de10 ON de14.domain_entity_10_id = de10.id;
```

---

### Test 10: ✅ PASS
**Question:** Show me all records from domain_entity_15, including the linked domain_entity_14, domain_entity_13, domain_entity_12, and domain_entity_11.
**Expected Tables:** domain_entity_15, domain_entity_14, domain_entity_13, domain_entity_12, domain_entity_11
**Retrieved Tables:** domain_entity_30, domain_entity_7, domain_entity_11, domain_entity_16, domain_entity_13, domain_entity_77, domain_entity_15, domain_entity_78, domain_entity_12, domain_entity_49, domain_entity_39, domain_entity_14, domain_entity_28, domain_entity_79, domain_entity_17, domain_entity_9, domain_entity_24, domain_entity_92
**Generated SQL:**
```sql
SELECT * 
FROM domain_entity_15
LEFT JOIN domain_entity_14 ON domain_entity_15.domain_entity_14_id = domain_entity_14.id
LEFT JOIN domain_entity_13 ON domain_entity_15.domain_entity_13_id = domain_entity_13.id
LEFT JOIN domain_entity_12 ON domain_entity_15.domain_entity_12_id = domain_entity_12.id
LEFT JOIN domain_entity_11 ON domain_entity_15.domain_entity_11_id = domain_entity_11.id;
```

---

### Test 11: ✅ PASS
**Question:** Show me all records from domain_entity_16, including the linked domain_entity_15, domain_entity_14, domain_entity_13, and domain_entity_12.
**Expected Tables:** domain_entity_16, domain_entity_15, domain_entity_14, domain_entity_13, domain_entity_12
**Retrieved Tables:** domain_entity_30, domain_entity_7, domain_entity_18, companies, domain_entity_16, domain_entity_13, domain_entity_34, domain_entity_15, domain_entity_78, domain_entity_12, domain_entity_20, domain_entity_49, domain_entity_14, domain_entity_29, domain_entity_17, domain_entity_9, domain_entity_92
**Generated SQL:**
```sql
SELECT 
  d1.id, 
  d1.name, 
  d1.created_at, 
  d1.domain_entity_15_id, 
  d1.domain_entity_7_id, 
  d2.name AS domain_entity_15_name, 
  d3.name AS domain_entity_14_name, 
  d4.name AS domain_entity_13_name, 
  d5.name AS domain_entity_12_name 
FROM domain_entity_16 d1
JOIN domain_entity_15 d2 ON d1.domain_entity_15_id = d2.id
LEFT JOIN domain_entity_14 d3 ON d1.domain_entity_14_id = d3.id
LEFT JOIN domain_entity_13 d4 ON d1.domain_entity_13_id = d4.id
LEFT JOIN domain_entity_12 d5 ON d1.domain_entity_12_id = d5.id
```

---

### Test 12: ✅ PASS
**Question:** Show me all records from domain_entity_17, including the linked domain_entity_16, domain_entity_15, domain_entity_14, and domain_entity_13.
**Expected Tables:** domain_entity_17, domain_entity_16, domain_entity_15, domain_entity_14, domain_entity_13
**Retrieved Tables:** domain_entity_30, domain_entity_7, domain_entity_18, domain_entity_45, domain_entity_16, domain_entity_13, domain_entity_15, domain_entity_78, domain_entity_20, domain_entity_19, domain_entity_49, domain_entity_14, domain_entity_23, regions, domain_entity_29, domain_entity_17, domain_entity_9, domain_entity_92
**Generated SQL:**
```sql
SELECT
  de17.*,
  de16.name,
  de15.name,
  de14.name,
  de13.name
FROM
domain_entity_17 de17
LEFT JOIN domain_entity_16 de16 ON de17.domain_entity_16_id = de16.id
LEFT JOIN domain_entity_15 de15 ON de17.domain_entity_15_id = de15.id
LEFT JOIN domain_entity_14 de14 ON de17.domain_entity_14_id = de14.id
LEFT JOIN domain_entity_13 de13 ON de17.domain_entity_13_id = de13.id;
```

---

### Test 13: ✅ PASS
**Question:** Show me all records from domain_entity_18, including the linked domain_entity_17, domain_entity_16, domain_entity_15, and domain_entity_14.
**Expected Tables:** domain_entity_18, domain_entity_17, domain_entity_16, domain_entity_15, domain_entity_14
**Retrieved Tables:** domain_entity_30, domain_entity_7, domain_entity_18, domain_entity_45, domain_entity_16, domain_entity_13, domain_entity_15, domain_entity_78, domain_entity_20, domain_entity_19, domain_entity_49, domain_entity_14, domain_entity_23, regions, domain_entity_29, domain_entity_17, domain_entity_9, domain_entity_92
**Generated SQL:**
```sql
SELECT 
    de18.*, 
    de17.name, 
    de16.name, 
    de15.name, 
    de14.name 
FROM domain_entity_18 de18
JOIN domain_entity_17 de17 ON de18.domain_entity_17_id = de17.id
LEFT JOIN domain_entity_16 de16 ON de18.domain_entity_15_id = de16.id
LEFT JOIN domain_entity_15 de15 ON de18.domain_entity_14_id = de15.id
LEFT JOIN domain_entity_14 de14 ON de18.domain_entity_14_id = de14.id;
```

---

### Test 14: ✅ PASS
**Question:** Show me all records from domain_entity_19, including the linked domain_entity_18, domain_entity_17, domain_entity_16, and domain_entity_15.
**Expected Tables:** domain_entity_19, domain_entity_18, domain_entity_17, domain_entity_16, domain_entity_15
**Retrieved Tables:** domain_entity_7, departments, domain_entity_18, domain_entity_32, domain_entity_45, domain_entity_16, domain_entity_13, domain_entity_15, domain_entity_93, domain_entity_20, domain_entity_19, domain_entity_23, regions, domain_entity_29, domain_entity_17, domain_entity_21
**Generated SQL:**
```sql
SELECT * 
FROM domain_entity_19
JOIN domain_entity_18 ON domain_entity_19.domain_entity_18_id = domain_entity_18.id
JOIN domain_entity_17 ON domain_entity_18.domain_entity_17_id = domain_entity_17.id
JOIN domain_entity_16 ON domain_entity_17.domain_entity_16_id = domain_entity_16.id
JOIN domain_entity_15 ON domain_entity_16.domain_entity_15_id = domain_entity_15.id;
```

---

### Test 15: ❌ FAIL (API Error)
**Error:** Expecting value: line 1 column 1 (char 0)

---

### Test 16: ✅ PASS
**Question:** Show me all records from domain_entity_21, including the linked domain_entity_20, domain_entity_19, domain_entity_18, and domain_entity_17.
**Expected Tables:** domain_entity_21, domain_entity_20, domain_entity_19, domain_entity_18, domain_entity_17
**Retrieved Tables:** departments, domain_entity_18, domain_entity_32, companies, domain_entity_45, domain_entity_69, domain_entity_52, domain_entity_93, domain_entity_8, domain_entity_20, domain_entity_19, domain_entity_56, domain_entity_22, domain_entity_23, regions, domain_entity_17, domain_entity_76, domain_entity_21
**Generated SQL:**
```sql
SELECT * FROM domain_entity_21
LEFT JOIN domain_entity_20 ON domain_entity_21.domain_entity_20_id = domain_entity_20.id
LEFT JOIN domain_entity_19 ON domain_entity_21.domain_entity_19_id = domain_entity_19.id
LEFT JOIN domain_entity_18 ON domain_entity_21.domain_entity_18_id = domain_entity_18.id
LEFT JOIN domain_entity_17 ON domain_entity_21.domain_entity_17_id = domain_entity_17.id;
```

---

### Test 17: ✅ PASS
**Question:** Show me all records from domain_entity_22, including the linked domain_entity_21, domain_entity_20, domain_entity_19, and domain_entity_18.
**Expected Tables:** domain_entity_22, domain_entity_21, domain_entity_20, domain_entity_19, domain_entity_18
**Retrieved Tables:** departments, domain_entity_18, domain_entity_32, companies, domain_entity_69, domain_entity_52, domain_entity_93, domain_entity_8, domain_entity_20, domain_entity_19, domain_entity_56, domain_entity_22, domain_entity_23, domain_entity_37, domain_entity_17, domain_entity_76, domain_entity_24, domain_entity_21
**Generated SQL:**
```sql
SELECT * 
FROM domain_entity_22 
JOIN domain_entity_21 ON domain_entity_22.domain_entity_21_id = domain_entity_21.id
JOIN domain_entity_20 ON domain_entity_22.domain_entity_20_id = domain_entity_20.id
JOIN domain_entity_19 ON domain_entity_22.domain_entity_18_id = domain_entity_19.id
JOIN domain_entity_18 ON domain_entity_22.domain_entity_18_id = domain_entity_18.id
```

---

### Test 18: ✅ PASS
**Question:** Show me all records from domain_entity_23, including the linked domain_entity_22, domain_entity_21, domain_entity_20, and domain_entity_19.
**Expected Tables:** domain_entity_23, domain_entity_22, domain_entity_21, domain_entity_20, domain_entity_19
**Retrieved Tables:** domain_entity_46, domain_entity_18, domain_entity_32, companies, domain_entity_25, domain_entity_26, domain_entity_93, domain_entity_12, domain_entity_21, domain_entity_8, domain_entity_20, domain_entity_19, domain_entity_31, domain_entity_42, domain_entity_22, domain_entity_23, domain_entity_37, domain_entity_53, domain_entity_17, domain_entity_24, domain_entity_67
**Generated SQL:**
```sql
SELECT 
  de23.* 
FROM domain_entity_23 de23
JOIN domain_entity_22 de22 ON de23.domain_entity_22_id = de22.id
JOIN domain_entity_21 de21 ON de23.domain_entity_20_id = de21.id
JOIN domain_entity_20 de20 ON de23.domain_entity_20_id = de20.id
JOIN domain_entity_19 de19 ON de23.domain_entity_18_id = de19.id;
```

---

### Test 19: ✅ PASS
**Question:** Show me all records from domain_entity_24, including the linked domain_entity_23, domain_entity_22, domain_entity_21, and domain_entity_20.
**Expected Tables:** domain_entity_24, domain_entity_23, domain_entity_22, domain_entity_21, domain_entity_20
**Retrieved Tables:** domain_entity_46, domain_entity_18, companies, domain_entity_25, domain_entity_69, domain_entity_52, domain_entity_26, domain_entity_12, domain_entity_8, domain_entity_20, domain_entity_31, domain_entity_56, domain_entity_42, domain_entity_22, domain_entity_23, domain_entity_37, domain_entity_53, domain_entity_76, domain_entity_24, domain_entity_21, domain_entity_67
**Generated SQL:**
```sql
SELECT *
FROM domain_entity_24
WHERE 
  EXISTS (
    SELECT 1
    FROM domain_entity_23 AS d23
    JOIN domain_entity_24 AS de24 ON d23.id = de24.domain_entity_23_id
  );
```

---

### Test 20: ✅ PASS
**Question:** Show me all records from domain_entity_25, including the linked domain_entity_24, domain_entity_23, domain_entity_22, and domain_entity_21.
**Expected Tables:** domain_entity_25, domain_entity_24, domain_entity_23, domain_entity_22, domain_entity_21
**Retrieved Tables:** domain_entity_46, domain_entity_18, domain_entity_97, companies, domain_entity_80, domain_entity_25, domain_entity_27, domain_entity_26, domain_entity_12, domain_entity_8, domain_entity_31, domain_entity_42, domain_entity_22, domain_entity_23, domain_entity_37, domain_entity_53, domain_entity_9, domain_entity_24, domain_entity_21, domain_entity_67
**Generated SQL:**
```sql
SELECT 
    de25.*
FROM domain_entity_25 de25
JOIN domain_entity_24 de24 ON de25.domain_entity_24_id = de24.id
JOIN domain_entity_23 de23 ON de25.domain_entity_23_id = de23.id
JOIN domain_entity_22 de22 ON de25.domain_entity_22_id = de22.id
JOIN domain_entity_21 de21 ON de25.domain_entity_21_id = de21.id;
```

---

### Test 21: ✅ PASS
**Question:** Show me all records from domain_entity_26, including the linked domain_entity_25, domain_entity_24, domain_entity_23, and domain_entity_22.
**Expected Tables:** domain_entity_26, domain_entity_25, domain_entity_24, domain_entity_23, domain_entity_22
**Retrieved Tables:** domain_entity_46, domain_entity_38, domain_entity_18, domain_entity_97, companies, domain_entity_80, domain_entity_25, domain_entity_27, domain_entity_77, domain_entity_6, domain_entity_26, domain_entity_12, domain_entity_31, domain_entity_42, domain_entity_22, domain_entity_23, domain_entity_28, domain_entity_37, domain_entity_53, domain_entity_9, domain_entity_24, domain_entity_67
**Generated SQL:**
```sql
SELECT 
    de26.*
FROM 
    domain_entity_26 de26
WHERE 1 = 1
    -- Add your WHERE clause conditions here if needed
ORDER BY 
    de26.id;
```

---

### Test 22: ❌ FAIL (API Error)
**Error:** Expecting value: line 1 column 1 (char 0)

---

### Test 23: ✅ PASS
**Question:** Show me all records from domain_entity_28, including the linked domain_entity_27, domain_entity_26, domain_entity_25, and domain_entity_24.
**Expected Tables:** domain_entity_28, domain_entity_27, domain_entity_26, domain_entity_25, domain_entity_24
**Retrieved Tables:** domain_entity_30, domain_entity_38, domain_entity_83, domain_entity_97, companies, domain_entity_80, domain_entity_25, domain_entity_27, domain_entity_77, domain_entity_6, domain_entity_26, domain_entity_12, domain_entity_31, domain_entity_42, domain_entity_28, domain_entity_29, domain_entity_53, domain_entity_17, domain_entity_9, domain_entity_24
**Generated SQL:**
```sql
SELECT 
  de28.*
FROM domain_entity_28 de28
JOIN domain_entity_27 de27 ON de28.domain_entity_27_id = de27.id
JOIN domain_entity_26 de26 ON de28.domain_entity_26_id = de26.id
JOIN domain_entity_25 de25 ON de28.domain_entity_25_id = de25.id
JOIN domain_entity_24 de24 ON de28.domain_entity_24_id = de24.id
```

---

### Test 24: ✅ PASS
**Question:** Show me all records from domain_entity_29, including the linked domain_entity_28, domain_entity_27, domain_entity_26, and domain_entity_25.
**Expected Tables:** domain_entity_29, domain_entity_28, domain_entity_27, domain_entity_26, domain_entity_25
**Retrieved Tables:** domain_entity_30, domain_entity_38, domain_entity_97, domain_entity_32, domain_entity_80, domain_entity_25, domain_entity_27, domain_entity_77, domain_entity_36, domain_entity_6, domain_entity_26, domain_entity_31, domain_entity_14, domain_entity_28, domain_entity_29, domain_entity_17, domain_entity_59, domain_entity_9, domain_entity_89
**Generated SQL:**
```sql
SELECT 
  d29.*, 
  d28.name AS domain_entity_28_name, 
  d27.name AS domain_entity_27_name, 
  d26.name AS domain_entity_26_name, 
  d25.name AS domain_entity_25_name
FROM domain_entity_29 d29
LEFT JOIN domain_entity_28 d28 ON d29.domain_entity_28_id = d28.id
LEFT JOIN domain_entity_27 d27 ON d29.domain_entity_27_id = d27.id
LEFT JOIN domain_entity_26 d26 ON d29.domain_entity_26_id = d26.id
LEFT JOIN domain_entity_25 d25 ON d29.domain_entity_25_id = d25.id;
```

---

### Test 25: ❌ FAIL
**Question:** Show me all records from domain_entity_30, including the linked domain_entity_29, domain_entity_28, domain_entity_27, and domain_entity_26.
**Expected Tables:** domain_entity_30, domain_entity_29, domain_entity_28, domain_entity_27, domain_entity_26
**Retrieved Tables:** domain_entity_30, domain_entity_83, domain_entity_32, domain_entity_88, domain_entity_25, domain_entity_27, domain_entity_36, domain_entity_12, domain_entity_31, domain_entity_14, domain_entity_28, domain_entity_90, domain_entity_29, domain_entity_17, domain_entity_59, domain_entity_89
**Generated SQL:**
```sql
SELECT * 
FROM domain_entity_30 
LEFT JOIN domain_entity_29 ON domain_entity_30.domain_entity_29_id = domain_entity_29.id
LEFT JOIN domain_entity_28 ON domain_entity_30.domain_entity_28_id = domain_entity_28.id
LEFT JOIN domain_entity_27 ON domain_entity_30.domain_entity_27_id = domain_entity_27.id 
LEFT JOIN domain_entity_26 ON domain_entity_30.domain_entity_26_id = domain_entity_26.id;
```

---

### Test 26: ✅ PASS
**Question:** Show me all records from domain_entity_31, including the linked domain_entity_30, domain_entity_29, domain_entity_28, and domain_entity_27.
**Expected Tables:** domain_entity_31, domain_entity_30, domain_entity_29, domain_entity_28, domain_entity_27
**Retrieved Tables:** domain_entity_30, domain_entity_83, domain_entity_32, domain_entity_25, domain_entity_27, domain_entity_36, domain_entity_35, domain_entity_73, domain_entity_12, domain_entity_31, domain_entity_14, domain_entity_28, domain_entity_37, domain_entity_29, domain_entity_17, domain_entity_59, domain_entity_89
**Generated SQL:**
```sql
SELECT 
  de31.*,
  domain_entity_30.name AS domain_entity_30_name,
  domain_entity_29.name AS domain_entity_29_name,
  domain_entity_28.name AS domain_entity_28_name, 
  domain_entity_27.name AS domain_entity_27_name
FROM domain_entity_31 de31 
LEFT JOIN domain_entity_30 on de31.domain_entity_30_id = domain_entity_30.id 
LEFT JOIN domain_entity_29 on de31.domain_entity_29_id = domain_entity_29.id 
LEFT JOIN domain_entity_28 on de31.domain_entity_28_id = domain_entity_28.id 
LEFT JOIN domain_entity_27 on de31.domain_entity_27_id = domain_entity_27.id;
```

---

### Test 27: ✅ PASS
**Question:** Show me all records from domain_entity_32, including the linked domain_entity_31, domain_entity_30, domain_entity_29, and domain_entity_28.
**Expected Tables:** domain_entity_32, domain_entity_31, domain_entity_30, domain_entity_29, domain_entity_28
**Retrieved Tables:** domain_entity_30, domain_entity_32, domain_entity_88, domain_entity_25, domain_entity_36, domain_entity_50, domain_entity_20, domain_entity_31, domain_entity_14, domain_entity_28, domain_entity_33, domain_entity_90, domain_entity_29, domain_entity_17, domain_entity_59, domain_entity_89
**Generated SQL:**
```sql
SELECT 
  * 
FROM domain_entity_32 
JOIN domain_entity_31 ON domain_entity_32.domain_entity_31_id = domain_entity_31.id
JOIN domain_entity_30 ON domain_entity_32.domain_entity_30_id = domain_entity_30.id
JOIN domain_entity_29 ON domain_entity_32.domain_entity_29_id = domain_entity_29.id
JOIN domain_entity_28 ON domain_entity_32.domain_entity_28_id = domain_entity_28.id
```

---

### Test 28: ✅ PASS
**Question:** Show me all records from domain_entity_33, including the linked domain_entity_32, domain_entity_31, domain_entity_30, and domain_entity_29.
**Expected Tables:** domain_entity_33, domain_entity_32, domain_entity_31, domain_entity_30, domain_entity_29
**Retrieved Tables:** domain_entity_30, domain_entity_32, domain_entity_87, domain_entity_13, domain_entity_36, domain_entity_35, domain_entity_48, domain_entity_6, domain_entity_34, domain_entity_73, domain_entity_50, domain_entity_72, domain_entity_20, domain_entity_31, domain_entity_14, domain_entity_33, domain_entity_37, domain_entity_29, domain_entity_59, domain_entity_89
**Generated SQL:**
```sql
SELECT 
    de33.*
FROM domain_entity_33 de33
JOIN domain_entity_32 de32 ON de33.domain_entity_32_id = de32.id
JOIN domain_entity_31 de31 ON de33.domain_entity_30_id = de31.id
JOIN domain_entity_30 de30 ON de33.domain_entity_31_id = de30.id
JOIN domain_entity_29 de29 ON de33.domain_entity_31_id = de29.id
```

---

### Test 29: ✅ PASS
**Question:** Show me all records from domain_entity_34, including the linked domain_entity_33, domain_entity_32, domain_entity_31, and domain_entity_30.
**Expected Tables:** domain_entity_34, domain_entity_33, domain_entity_32, domain_entity_31, domain_entity_30
**Retrieved Tables:** domain_entity_30, domain_entity_32, companies, domain_entity_25, domain_entity_13, domain_entity_36, domain_entity_35, domain_entity_48, domain_entity_34, domain_entity_73, domain_entity_31, domain_entity_14, domain_entity_33, domain_entity_37, domain_entity_29, domain_entity_59, domain_entity_89
**Generated SQL:**
```sql
SELECT 
  de34.*,
  de33.* ,
  de32.*,
  de31.*,
  de30.*
FROM domain_entity_34 de34
JOIN domain_entity_33 de33 ON de34.domain_entity_33_id = de33.id
JOIN domain_entity_32 de32 ON de34.domain_entity_32_id = de32.id
JOIN domain_entity_31 de31 ON de34.domain_entity_31_id = de31.id
JOIN domain_entity_30 de30 ON de34.domain_entity_30_id = de30.id
```

---

### Test 30: ❌ FAIL (API Error)
**Error:** Expecting value: line 1 column 1 (char 0)

---

### Test 31: ✅ PASS
**Question:** Show me all records from domain_entity_36, including the linked domain_entity_35, domain_entity_34, domain_entity_33, and domain_entity_32.
**Expected Tables:** domain_entity_36, domain_entity_35, domain_entity_34, domain_entity_33, domain_entity_32
**Retrieved Tables:** domain_entity_38, domain_entity_32, domain_entity_87, companies, domain_entity_13, domain_entity_36, domain_entity_35, domain_entity_48, domain_entity_6, domain_entity_34, domain_entity_73, domain_entity_72, domain_entity_31, domain_entity_23, domain_entity_33, domain_entity_37
**Generated SQL:**
```sql
SELECT 
  de36.*,
  de35.name AS domain_entity_35_name,
  de34.name AS domain_entity_34_name,
  de33.name AS domain_entity_33_name,
  de32.name AS domain_entity_32_name
FROM domain_entity_36 de36
LEFT JOIN domain_entity_35 de35 ON de36.domain_entity_35_id = de35.id
LEFT JOIN domain_entity_34 de34 ON de36.domain_entity_34_id = de34.id
LEFT JOIN domain_entity_33 de33 ON de36.domain_entity_33_id = de33.id
LEFT JOIN domain_entity_32 de32 ON de36.domain_entity_32_id = de32.id
```

---

### Test 32: ✅ PASS
**Question:** Show me all records from domain_entity_37, including the linked domain_entity_36, domain_entity_35, domain_entity_34, and domain_entity_33.
**Expected Tables:** domain_entity_37, domain_entity_36, domain_entity_35, domain_entity_34, domain_entity_33
**Retrieved Tables:** domain_entity_38, domain_entity_31, companies, domain_entity_39, domain_entity_13, domain_entity_27, domain_entity_36, domain_entity_23, domain_entity_33, domain_entity_35, domain_entity_37, domain_entity_34, domain_entity_73, domain_entity_48
**Generated SQL:**
```sql
SELECT 
  de37.*,
  domain_entity_36.name AS linked_domain_entity_36_name,
  domain_entity_35.name AS linked_domain_entity_35_name,
  domain_entity_34.name AS linked_domain_entity_34_name,
  domain_entity_33.name AS linked_domain_entity_33_name
FROM domain_entity_37 de37
JOIN domain_entity_36 on de37.domain_entity_36_id = domain_entity_36.id
LEFT JOIN domain_entity_35 on de37.domain_entity_35_id = domain_entity_35.id
LEFT JOIN domain_entity_34 on de37.domain_entity_34_id = domain_entity_34.id
LEFT JOIN domain_entity_33 on de37.domain_entity_33_id = domain_entity_33.id;
```

---

### Test 33: ✅ PASS
**Question:** Show me all records from domain_entity_38, including the linked domain_entity_37, domain_entity_36, domain_entity_35, and domain_entity_34.
**Expected Tables:** domain_entity_38, domain_entity_37, domain_entity_36, domain_entity_35, domain_entity_34
**Retrieved Tables:** domain_entity_38, categories, companies, domain_entity_27, domain_entity_36, domain_entity_35, domain_entity_34, domain_entity_73, domain_entity_54, domain_entity_12, domain_entity_40, domain_entity_51, domain_entity_31, domain_entity_42, domain_entity_39, domain_entity_41, domain_entity_37
**Generated SQL:**
```sql
SELECT 
  de38.*, 
  de37.name AS de37_name,
  de36.name AS de36_name, 
  de35.name AS de35_name, 
  de34.name AS de34_name 
FROM domain_entity_38 de38
JOIN domain_entity_37 de37 ON de38.domain_entity_37_id = de37.id
LEFT JOIN domain_entity_36 de36 ON de38.domain_entity_36_id = de36.id 
LEFT JOIN domain_entity_35 de35 ON de38.domain_entity_35_id = de35.id 
LEFT JOIN domain_entity_34 de34 ON de38.domain_entity_34_id = de34.id;
```

---

### Test 34: ✅ PASS
**Question:** Show me all records from domain_entity_39, including the linked domain_entity_38, domain_entity_37, domain_entity_36, and domain_entity_35.
**Expected Tables:** domain_entity_39, domain_entity_38, domain_entity_37, domain_entity_36, domain_entity_35
**Retrieved Tables:** departments, domain_entity_38, categories, domain_entity_27, domain_entity_36, domain_entity_35, domain_entity_73, domain_entity_54, domain_entity_12, domain_entity_40, domain_entity_51, domain_entity_31, domain_entity_42, domain_entity_39, domain_entity_41, domain_entity_91, domain_entity_37
**Generated SQL:**
```sql
SELECT 
  de39.*, 
  de38.name, 
  de37.name, 
  de36.name, 
  de35.name
FROM domain_entity_39 de39 
JOIN domain_entity_38 de38 ON de39.domain_entity_38_id = de38.id 
LEFT JOIN domain_entity_37 de37 ON de39.domain_entity_37_id = de37.id 
LEFT JOIN domain_entity_36 de36 ON de39.domain_entity_36_id = de36.id  
LEFT JOIN domain_entity_35 de35 ON de39.domain_entity_35_id = de35.id;
```

---

### Test 35: ❌ FAIL
**Question:** Show me all records from domain_entity_40, including the linked domain_entity_39, domain_entity_38, domain_entity_37, and domain_entity_36.
**Expected Tables:** domain_entity_40, domain_entity_39, domain_entity_38, domain_entity_37, domain_entity_36
**Retrieved Tables:** domain_entity_12, domain_entity_40, departments, domain_entity_38, domain_entity_51, categories, domain_entity_55, domain_entity_42, domain_entity_39, domain_entity_25, domain_entity_41, domain_entity_91, domain_entity_43, domain_entity_53, domain_entity_54
**Generated SQL:**
```sql
SELECT 
  de.id,
  de.name,
  d.name AS domain_entity_39_name,
  d.created_at AS domain_entity_39_created_at,
  domain_entity_40_id,
  ... 
FROM domain_entity_40 de
JOIN domain_entity_39 d ON de.domain_entity_39_id = d.id
```

---

### Test 36: ❌ FAIL
**Question:** Show me all records from domain_entity_41, including the linked domain_entity_40, domain_entity_39, domain_entity_38, and domain_entity_37.
**Expected Tables:** domain_entity_41, domain_entity_40, domain_entity_39, domain_entity_38, domain_entity_37
**Retrieved Tables:** domain_entity_12, domain_entity_50, domain_entity_40, departments, domain_entity_38, domain_entity_51, categories, domain_entity_42, domain_entity_39, domain_entity_25, domain_entity_41, domain_entity_91, domain_entity_52, domain_entity_43, domain_entity_54
**Generated SQL:**
```sql
SELECT 
  de41.*,
  de40.name AS d_entity_40_name,
  de39.name AS d_entity_39_name,
  de38.name AS d_entity_38_name,
  de37.name AS d_entity_37_name 
FROM domain_entity_41 de41
LEFT JOIN domain_entity_40 de40 ON de41.domain_entity_40_id = de40.id
LEFT JOIN domain_entity_39 de39 ON de41.domain_entity_39_id = de39.id
LEFT JOIN domain_entity_38 de38 ON de41.domain_entity_38_id = de38.id
LEFT JOIN domain_entity_37 de37 ON de41.domain_entity_37_id = de37.id;
```

---

### Test 37: ❌ FAIL
**Question:** Show me all records from domain_entity_42, including the linked domain_entity_41, domain_entity_40, domain_entity_39, and domain_entity_38.
**Expected Tables:** domain_entity_42, domain_entity_41, domain_entity_40, domain_entity_39, domain_entity_38
**Retrieved Tables:** domain_entity_40, departments, domain_entity_44, domain_entity_51, categories, domain_entity_55, domain_entity_42, domain_entity_39, domain_entity_25, domain_entity_41, domain_entity_91, domain_entity_99, domain_entity_43, domain_entity_53, domain_entity_54
**Generated SQL:**
```sql
SELECT 
  de42.*
FROM 
  domain_entity_42 as de42
JOIN 
  domain_entity_41 as de41 ON de42.domain_entity_41_id = de41.id
LEFT JOIN 
  domain_entity_40 as de40 ON de42.domain_entity_41_id = de40.id
LEFT JOIN 
  domain_entity_39 as de39 ON de42.domain_entity_41_id = de39.id
LEFT JOIN 
  domain_entity_38 as de38 ON de42.domain_entity_41_id = de38.id;
```

---

### Test 38: ✅ PASS
**Question:** Show me all records from domain_entity_43, including the linked domain_entity_42, domain_entity_41, domain_entity_40, and domain_entity_39.
**Expected Tables:** domain_entity_43, domain_entity_42, domain_entity_41, domain_entity_40, domain_entity_39
**Retrieved Tables:** departments, categories, domain_entity_45, domain_entity_25, domain_entity_43, domain_entity_10, domain_entity_40, domain_entity_44, domain_entity_51, domain_entity_42, domain_entity_39, domain_entity_94, domain_entity_41, domain_entity_91, domain_entity_99, domain_entity_62
**Generated SQL:**
```sql
SELECT *
FROM domain_entity_43
JOIN domain_entity_42 ON domain_entity_43.domain_entity_42_id = domain_entity_42.id
JOIN domain_entity_41 ON domain_entity_43.domain_entity_41_id = domain_entity_41.id
JOIN domain_entity_40 ON domain_entity_43.domain_entity_40_id = domain_entity_40.id
JOIN domain_entity_39 ON domain_entity_43.domain_entity_39_id = domain_entity_39.id;
```

---

### Test 39: ❌ FAIL (API Error)
**Error:** Expecting value: line 1 column 1 (char 0)

---

### Test 40: ✅ PASS
**Question:** Show me all records from domain_entity_45, including the linked domain_entity_44, domain_entity_43, domain_entity_42, and domain_entity_41.
**Expected Tables:** domain_entity_45, domain_entity_44, domain_entity_43, domain_entity_42, domain_entity_41
**Retrieved Tables:** domain_entity_46, departments, domain_entity_18, categories, domain_entity_45, domain_entity_25, domain_entity_43, domain_entity_10, domain_entity_40, domain_entity_44, domain_entity_51, domain_entity_98, domain_entity_42, domain_entity_94, domain_entity_41, domain_entity_99, domain_entity_62
**Generated SQL:**
```sql
SELECT
  d45.*
FROM domain_entity_45 d45
JOIN domain_entity_44 d44 ON d45.domain_entity_44_id = d44.id
JOIN domain_entity_43 d43 ON d44.domain_entity_43_id = d43.id
JOIN domain_entity_42 d42 ON d43.domain_entity_42_id = d42.id
JOIN domain_entity_41 d41 ON d42.domain_entity_41_id = d41.id;
```

---

### Test 41: ✅ PASS
**Question:** Show me all records from domain_entity_46, including the linked domain_entity_45, domain_entity_44, domain_entity_43, and domain_entity_42.
**Expected Tables:** domain_entity_46, domain_entity_45, domain_entity_44, domain_entity_43, domain_entity_42
**Retrieved Tables:** domain_entity_46, departments, domain_entity_18, categories, domain_entity_45, domain_entity_25, domain_entity_43, domain_entity_10, domain_entity_40, domain_entity_44, domain_entity_51, domain_entity_98, domain_entity_42, domain_entity_94, domain_entity_41, domain_entity_99, domain_entity_62
**Generated SQL:**
```sql
SELECT 
    de46.*,
    de45.name AS domain_entity_45_name, 
    de44.name AS domain_entity_44_name, 
    de43.name AS domain_entity_43_name, 
    de42.name AS domain_entity_42_name
FROM domain_entity_46 de46
LEFT JOIN domain_entity_45 de45 ON de46.domain_entity_45_id = de45.id
LEFT JOIN domain_entity_44 de44 ON de46.domain_entity_44_id = de44.id
LEFT JOIN domain_entity_43 de43 ON de46.domain_entity_43_id = de43.id
LEFT JOIN domain_entity_42 de42 ON de46.domain_entity_42_id = de42.id
```

---

### Test 42: ✅ PASS
**Question:** Show me all records from domain_entity_47, including the linked domain_entity_46, domain_entity_45, domain_entity_44, and domain_entity_43.
**Expected Tables:** domain_entity_47, domain_entity_46, domain_entity_45, domain_entity_44, domain_entity_43
**Retrieved Tables:** domain_entity_46, domain_entity_18, domain_entity_45, domain_entity_48, domain_entity_43, domain_entity_34, domain_entity_47, domain_entity_10, domain_entity_60, domain_entity_44, domain_entity_49, domain_entity_56, domain_entity_98, domain_entity_94, domain_entity_57, domain_entity_62, domain_entity_58
**Generated SQL:**
```sql
SELECT 
  de47.*,
  de46.name AS de46_name, 
  de45.name AS de45_name,
  de44.name AS de44_name,
  de43.name AS de43_name
FROM domain_entity_47 de47
LEFT JOIN domain_entity_46 de46 ON de47.domain_entity_46_id = de46.id
LEFT JOIN domain_entity_45 de45 ON de47.domain_entity_45_id = de45.id
LEFT JOIN domain_entity_44 de44 ON de47.domain_entity_44_id = de44.id
LEFT JOIN domain_entity_43 de43 ON de47.domain_entity_43_id = de43.id
```

---

### Test 43: ✅ PASS
**Question:** Show me all records from domain_entity_48, including the linked domain_entity_47, domain_entity_46, domain_entity_45, and domain_entity_44.
**Expected Tables:** domain_entity_48, domain_entity_47, domain_entity_46, domain_entity_45, domain_entity_44
**Retrieved Tables:** domain_entity_46, domain_entity_18, domain_entity_32, domain_entity_45, domain_entity_48, domain_entity_34, domain_entity_15, domain_entity_47, domain_entity_10, domain_entity_50, domain_entity_60, domain_entity_44, domain_entity_51, domain_entity_49, domain_entity_98, domain_entity_57
**Generated SQL:**
```sql
SELECT * FROM domain_entity_48 
  LEFT JOIN domain_entity_47 ON domain_entity_48.domain_entity_47_id = domain_entity_47.id
  LEFT JOIN domain_entity_46 ON domain_entity_48.domain_entity_46_id = domain_entity_46.id
  LEFT JOIN domain_entity_45 ON domain_entity_48.domain_entity_45_id = domain_entity_45.id
  LEFT JOIN domain_entity_44 ON domain_entity_48.domain_entity_44_id = domain_entity_44.id;
```

---

### Test 44: ❌ FAIL
**Question:** Show me all records from domain_entity_49, including the linked domain_entity_48, domain_entity_47, domain_entity_46, and domain_entity_45.
**Expected Tables:** domain_entity_49, domain_entity_48, domain_entity_47, domain_entity_46, domain_entity_45
**Retrieved Tables:** domain_entity_50, domain_entity_60, domain_entity_46, domain_entity_10, domain_entity_51, domain_entity_49, domain_entity_32, domain_entity_57, domain_entity_41, domain_entity_52, domain_entity_48, domain_entity_34, domain_entity_15, domain_entity_47
**Generated SQL:**
```sql
SELECT * 
FROM domain_entity_49 
LEFT JOIN domain_entity_48 de48 ON domain_entity_49.domain_entity_48_id = de48.id 
LEFT JOIN domain_entity_47 de47 ON de48.domain_entity_47_id = de47.id 
LEFT JOIN domain_entity_46 de46 ON de47.domain_entity_46_id = de46.id 
LEFT JOIN domain_entity_45 de45 ON de46.domain_entity_45_id = de45.id;
```

---

### Test 45: ✅ PASS
**Question:** Show me all records from domain_entity_50, including the linked domain_entity_49, domain_entity_48, domain_entity_47, and domain_entity_46.
**Expected Tables:** domain_entity_50, domain_entity_49, domain_entity_48, domain_entity_47, domain_entity_46
**Retrieved Tables:** domain_entity_50, domain_entity_60, domain_entity_46, domain_entity_10, domain_entity_51, domain_entity_49, domain_entity_32, domain_entity_57, domain_entity_41, domain_entity_52, domain_entity_48, domain_entity_34, domain_entity_15, domain_entity_47
**Generated SQL:**
```sql
SELECT 
    de50.id,
    de50.name,
    de49.name AS de49name,
    de48.name AS de48name,
    de47.name AS de47name,
    de46.name AS de46name 
FROM domain_entity_50 de50
LEFT JOIN domain_entity_49 de49 ON de50.domain_entity_49_id = de49.id
LEFT JOIN domain_entity_48 de48 ON de50.domain_entity_48_id = de48.id
LEFT JOIN domain_entity_47 de47 ON de50.domain_entity_47_id = de47.id
LEFT JOIN domain_entity_46 de46 ON de50.domain_entity_46_id = de46.id;
```

---

### Test 46: ✅ PASS
**Question:** Show me all records from domain_entity_51, including the linked domain_entity_50, domain_entity_49, domain_entity_48, and domain_entity_47.
**Expected Tables:** domain_entity_51, domain_entity_50, domain_entity_49, domain_entity_48, domain_entity_47
**Retrieved Tables:** domain_entity_50, domain_entity_60, domain_entity_51, domain_entity_49, domain_entity_32, domain_entity_41, domain_entity_52, domain_entity_48, domain_entity_53, domain_entity_34, domain_entity_15, domain_entity_47, domain_entity_21
**Generated SQL:**
```sql
SELECT 
    de51.*, 
    de50.name, 
    de49.name, 
    de48.name, 
    de47.name 
FROM domain_entity_51 de51 
JOIN domain_entity_50 de50 ON de51.domain_entity_50_id = de50.id 
LEFT JOIN domain_entity_49 de49 ON de51.domain_entity_49_id = de49.id 
LEFT JOIN domain_entity_48 de48 ON de51.domain_entity_48_id = de48.id 
LEFT JOIN domain_entity_47 de47 ON de51.domain_entity_47_id = de47.id
```

---

### Test 47: ✅ PASS
**Question:** Show me all records from domain_entity_52, including the linked domain_entity_51, domain_entity_50, domain_entity_49, and domain_entity_48.
**Expected Tables:** domain_entity_52, domain_entity_51, domain_entity_50, domain_entity_49, domain_entity_48
**Retrieved Tables:** domain_entity_50, domain_entity_51, domain_entity_49, domain_entity_32, domain_entity_66, domain_entity_25, domain_entity_41, domain_entity_52, domain_entity_48, domain_entity_53, domain_entity_15, domain_entity_21, domain_entity_54
**Generated SQL:**
```sql
SELECT 
  de52.*, 
  de51.*, 
  de50.*, 
  de49.*, 
  de48.*
FROM domain_entity_52 de52
LEFT JOIN domain_entity_51 de51 ON de52.domain_entity_51_id = de51.id
LEFT JOIN domain_entity_50 de50 ON de52.domain_entity_50_id = de50.id
LEFT JOIN domain_entity_49 de49 ON de52.domain_entity_49_id = de49.id
LEFT JOIN domain_entity_48 de48 ON de52.domain_entity_48_id = de48.id;
```

---

### Test 48: ❌ FAIL (API Error)
**Error:** Expecting value: line 1 column 1 (char 0)

---

### Test 49: ✅ PASS
**Question:** Show me all records from domain_entity_54, including the linked domain_entity_53, domain_entity_52, domain_entity_51, and domain_entity_50.
**Expected Tables:** domain_entity_54, domain_entity_53, domain_entity_52, domain_entity_51, domain_entity_50
**Retrieved Tables:** domain_entity_50, domain_entity_51, domain_entity_49, domain_entity_55, domain_entity_32, domain_entity_66, domain_entity_39, domain_entity_25, domain_entity_41, domain_entity_52, domain_entity_53, domain_entity_21, domain_entity_54
**Generated SQL:**
```sql
SELECT 
  * 
FROM domain_entity_54
INNER JOIN domain_entity_53 ON domain_entity_54.domain_entity_53_id = domain_entity_53.id
INNER JOIN domain_entity_52 ON domain_entity_54.domain_entity_53_id = domain_entity_52.id
INNER JOIN domain_entity_51 ON domain_entity_54.domain_entity_53_id = domain_entity_51.id
INNER JOIN domain_entity_50 ON domain_entity_54.domain_entity_53_id = domain_entity_50.id;
```

---

### Test 50: ✅ PASS
**Question:** Show me all records from domain_entity_55, including the linked domain_entity_54, domain_entity_53, domain_entity_52, and domain_entity_51.
**Expected Tables:** domain_entity_55, domain_entity_54, domain_entity_53, domain_entity_52, domain_entity_51
**Retrieved Tables:** domain_entity_51, domain_entity_55, domain_entity_58, domain_entity_56, domain_entity_66, domain_entity_74, domain_entity_39, domain_entity_25, domain_entity_57, domain_entity_71, domain_entity_52, domain_entity_53, domain_entity_9, domain_entity_21, domain_entity_54
**Generated SQL:**
```sql
SELECT 
    de55.*,
    de54.name,
    de53.name,
    de52.name,
    de51.name
FROM domain_entity_55 as de55
JOIN domain_entity_54 as de54 ON de55.domain_entity_54_id = de54.id
JOIN domain_entity_53 as de53 ON de55.domain_entity_53_id = de53.id
JOIN domain_entity_52 as de52 ON de55.domain_entity_52_id = de52.id
JOIN domain_entity_51 as de51 ON de55.domain_entity_51_id = de51.id;
```

---

### Test 51: ✅ PASS
**Question:** Show me all records from domain_entity_56, including the linked domain_entity_55, domain_entity_54, domain_entity_53, and domain_entity_52.
**Expected Tables:** domain_entity_56, domain_entity_55, domain_entity_54, domain_entity_53, domain_entity_52
**Retrieved Tables:** domain_entity_55, domain_entity_58, domain_entity_56, domain_entity_66, domain_entity_74, domain_entity_39, domain_entity_25, domain_entity_57, domain_entity_71, domain_entity_52, domain_entity_53, domain_entity_9, domain_entity_47, domain_entity_21, domain_entity_54
**Generated SQL:**
```sql
SELECT 
  de56.*,
  de55.name AS domain_entity_55_name,
  de54.name AS domain_entity_54_name,
  de53.name AS domain_entity_53_name,
  de52.name AS domain_entity_52_name 
FROM domain_entity_56 de56
LEFT JOIN domain_entity_55 de55 ON de56.domain_entity_55_id = de55.id
LEFT JOIN domain_entity_54 de54 ON de56.domain_entity_54_id = de54.id
LEFT JOIN domain_entity_53 de53 ON de56.domain_entity_53_id = de53.id
LEFT JOIN domain_entity_52 de52 ON de56.domain_entity_52_id = de52.id;
```

---

### Test 52: ✅ PASS
**Question:** Show me all records from domain_entity_57, including the linked domain_entity_56, domain_entity_55, domain_entity_54, and domain_entity_53.
**Expected Tables:** domain_entity_57, domain_entity_56, domain_entity_55, domain_entity_54, domain_entity_53
**Retrieved Tables:** domain_entity_55, domain_entity_58, domain_entity_56, domain_entity_85, domain_entity_74, domain_entity_39, domain_entity_57, domain_entity_71, domain_entity_53, domain_entity_59, domain_entity_9, domain_entity_47, domain_entity_21, domain_entity_54
**Generated SQL:**
```sql
SELECT 
  de57.*,
  de56.name AS domain_entity_56_name,
  de55.name AS domain_entity_55_name,
  de54.name AS domain_entity_54_name,
  de53.name AS domain_entity_53_name
FROM domain_entity_57 de57
LEFT JOIN domain_entity_56 de56 ON de57.domain_entity_56_id = de56.id
LEFT JOIN domain_entity_55 de55 ON de57.domain_entity_55_id = de55.id
LEFT JOIN domain_entity_54 de54 ON de57.domain_entity_54_id = de54.id
LEFT JOIN domain_entity_53 de53 ON de57.domain_entity_53_id = de53.id
```

---

### Test 53: ✅ PASS
**Question:** Show me all records from domain_entity_58, including the linked domain_entity_57, domain_entity_56, domain_entity_55, and domain_entity_54.
**Expected Tables:** domain_entity_58, domain_entity_57, domain_entity_56, domain_entity_55, domain_entity_54
**Retrieved Tables:** domain_entity_85, domain_entity_58, domain_entity_55, domain_entity_86, domain_entity_56, domain_entity_84, domain_entity_39, domain_entity_57, domain_entity_53, domain_entity_59, domain_entity_9, domain_entity_47, domain_entity_54
**Generated SQL:**
```sql
SELECT 
  de58.*,
  de57.name AS domain_entity_57_name,
  de56.name AS domain_entity_56_name,
  de55.name AS domain_entity_55_name,
  de54.name AS domain_entity_54_name 
FROM domain_entity_58 de58
LEFT JOIN domain_entity_57 de57 ON de58.domain_entity_57_id = de57.id
LEFT JOIN domain_entity_56 de56 ON de58.domain_entity_56_id = de56.id
LEFT JOIN domain_entity_55 de55 ON de58.domain_entity_55_id = de55.id 
LEFT JOIN domain_entity_54 de54 ON de58.domain_entity_54_id = de54.id
```

---

### Test 54: ✅ PASS
**Question:** Show me all records from domain_entity_59, including the linked domain_entity_58, domain_entity_57, domain_entity_56, and domain_entity_55.
**Expected Tables:** domain_entity_59, domain_entity_58, domain_entity_57, domain_entity_56, domain_entity_55
**Retrieved Tables:** domain_entity_30, domain_entity_60, domain_entity_54, domain_entity_55, domain_entity_85, domain_entity_56, domain_entity_74, domain_entity_57, domain_entity_71, domain_entity_59, domain_entity_9, domain_entity_47, domain_entity_21, domain_entity_58
**Generated SQL:**
```sql
SELECT 
  *
FROM domain_entity_59
INNER JOIN domain_entity_58 ON domain_entity_59.domain_entity_58_id = domain_entity_58.id
INNER JOIN domain_entity_57 ON domain_entity_59.domain_entity_58_id = domain_entity_57.id
INNER JOIN domain_entity_56 ON domain_entity_59.domain_entity_58_id = domain_entity_56.id
INNER JOIN domain_entity_55 ON domain_entity_59.domain_entity_58_id = domain_entity_55.id;
```

---

### Test 55: ✅ PASS
**Question:** Show me all records from domain_entity_60, including the linked domain_entity_59, domain_entity_58, domain_entity_57, and domain_entity_56.
**Expected Tables:** domain_entity_60, domain_entity_59, domain_entity_58, domain_entity_57, domain_entity_56
**Retrieved Tables:** domain_entity_55, domain_entity_64, domain_entity_63, domain_entity_74, domain_entity_71, domain_entity_48, domain_entity_47, domain_entity_75, domain_entity_60, domain_entity_81, domain_entity_85, domain_entity_56, domain_entity_61, domain_entity_57, domain_entity_59, domain_entity_62, domain_entity_21, domain_entity_58
**Generated SQL:**
```sql
SELECT 
  *
FROM domain_entity_60
LEFT JOIN domain_entity_59 ON domain_entity_60.domain_entity_59_id = domain_entity_59.id
LEFT JOIN domain_entity_58 ON domain_entity_60.domain_entity_58_id = domain_entity_58.id
LEFT JOIN domain_entity_57 ON domain_entity_60.domain_entity_57_id = domain_entity_57.id
LEFT JOIN domain_entity_56 ON domain_entity_60.domain_entity_56_id = domain_entity_56.id;
```

---

### Test 56: ✅ PASS
**Question:** Show me all records from domain_entity_61, including the linked domain_entity_60, domain_entity_59, domain_entity_58, and domain_entity_57.
**Expected Tables:** domain_entity_61, domain_entity_60, domain_entity_59, domain_entity_58, domain_entity_57
**Retrieved Tables:** domain_entity_55, domain_entity_63, domain_entity_69, domain_entity_48, domain_entity_6, domain_entity_75, domain_entity_60, domain_entity_68, domain_entity_44, domain_entity_81, domain_entity_85, domain_entity_61, domain_entity_57, domain_entity_59, domain_entity_62, domain_entity_67, domain_entity_58
**Generated SQL:**
```sql
SELECT *
FROM domain_entity_61
INNER JOIN domain_entity_60 ON domain_entity_61.domain_entity_60_id = domain_entity_60.id
INNER JOIN domain_entity_59 ON domain_entity_61.domain_entity_59_id = domain_entity_59.id
INNER JOIN domain_entity_58 ON domain_entity_61.domain_entity_58_id = domain_entity_58.id
INNER JOIN domain_entity_57 ON domain_entity_61.domain_entity_57_id = domain_entity_57.id
```

---

### Test 57: ❌ FAIL (API Error)
**Error:** Expecting value: line 1 column 1 (char 0)

---

### Test 58: ✅ PASS
**Question:** Show me all records from domain_entity_63, including the linked domain_entity_62, domain_entity_61, domain_entity_60, and domain_entity_59.
**Expected Tables:** domain_entity_63, domain_entity_62, domain_entity_61, domain_entity_60, domain_entity_59
**Retrieved Tables:** domain_entity_60, domain_entity_68, domain_entity_44, domain_entity_81, domain_entity_64, domain_entity_63, domain_entity_61, domain_entity_69, domain_entity_48, domain_entity_6, domain_entity_59, domain_entity_62, domain_entity_75, domain_entity_67
**Generated SQL:**
```sql
SELECT 
  de63.*, 
  de62.name,
  de61.name,
  de60.name,
  de59.name
FROM domain_entity_63 de63
LEFT JOIN domain_entity_62 de62 ON de63.domain_entity_62_id = de62.id
LEFT JOIN domain_entity_61 de61 ON de63.domain_entity_61_id = de61.id
LEFT JOIN domain_entity_60 de60 ON de63.domain_entity_60_id = de60.id
LEFT JOIN domain_entity_59 de59 ON de63.domain_entity_59_id = de59.id;
```

---

### Test 59: ✅ PASS
**Question:** Show me all records from domain_entity_64, including the linked domain_entity_63, domain_entity_62, domain_entity_61, and domain_entity_60.
**Expected Tables:** domain_entity_64, domain_entity_63, domain_entity_62, domain_entity_61, domain_entity_60
**Retrieved Tables:** domain_entity_46, domain_entity_60, domain_entity_68, domain_entity_65, domain_entity_44, domain_entity_64, domain_entity_63, domain_entity_61, domain_entity_69, domain_entity_6, domain_entity_62, domain_entity_67
**Generated SQL:**
```sql
SELECT *
FROM domain_entity_64
JOIN domain_entity_63 ON domain_entity_64.domain_entity_63_id = domain_entity_63.id
LEFT JOIN domain_entity_62 ON domain_entity_64.domain_entity_62_id = domain_entity_62.id
LEFT JOIN domain_entity_61 ON domain_entity_64.domain_entity_61_id = domain_entity_61.id
LEFT JOIN domain_entity_60 ON domain_entity_64.domain_entity_60_id = domain_entity_60.id;
```

---

### Test 60: ✅ PASS
**Question:** Show me all records from domain_entity_65, including the linked domain_entity_64, domain_entity_63, domain_entity_62, and domain_entity_61.
**Expected Tables:** domain_entity_65, domain_entity_64, domain_entity_63, domain_entity_62, domain_entity_61
**Retrieved Tables:** domain_entity_60, domain_entity_68, domain_entity_65, domain_entity_64, categories, domain_entity_66, domain_entity_63, domain_entity_61, domain_entity_69, domain_entity_53, domain_entity_62, domain_entity_21, domain_entity_70, domain_entity_67
**Generated SQL:**
```sql
SELECT 
  de65.*,
  domain_entity_64.name AS domain_entity_64_name, 
  domain_entity_63.name AS domain_entity_63_name, 
  domain_entity_62.name AS domain_entity_62_name, 
  domain_entity_61.name AS domain_entity_61_name 
FROM domain_entity_65 de65
LEFT JOIN domain_entity_64 ON de65.domain_entity_64_id = domain_entity_64.id
LEFT JOIN domain_entity_63 ON de65.domain_entity_64_id = domain_entity_63.id
LEFT JOIN domain_entity_62 ON de65.domain_entity_64_id = domain_entity_62.id
LEFT JOIN domain_entity_61 ON de65.domain_entity_64_id = domain_entity_61.id;
```

---

### Test 61: ✅ PASS
**Question:** Show me all records from domain_entity_66, including the linked domain_entity_65, domain_entity_64, domain_entity_63, and domain_entity_62.
**Expected Tables:** domain_entity_66, domain_entity_65, domain_entity_64, domain_entity_63, domain_entity_62
**Retrieved Tables:** domain_entity_60, domain_entity_65, domain_entity_68, domain_entity_64, categories, domain_entity_66, domain_entity_63, domain_entity_86, domain_entity_61, domain_entity_69, domain_entity_53, domain_entity_62, domain_entity_24, domain_entity_67, domain_entity_82
**Generated SQL:**
```sql
SELECT 
  de66.*,
  de65.name as de65_name,
  de64.name as de64_name,
  de63.name as de63_name,
  de62.name as de62_name
FROM domain_entity_66 de66
LEFT JOIN domain_entity_65 de65 ON de66.domain_entity_65_id = de65.id
LEFT JOIN domain_entity_64 de64 ON de66.domain_entity_64_id = de64.id
LEFT JOIN domain_entity_63 de63 ON de66.domain_entity_63_id = de63.id
LEFT JOIN domain_entity_62 de62 ON de66.domain_entity_62_id = de62.id
```

---

### Test 62: ❌ FAIL
**Question:** Show me all records from domain_entity_67, including the linked domain_entity_66, domain_entity_65, domain_entity_64, and domain_entity_63.
**Expected Tables:** domain_entity_67, domain_entity_66, domain_entity_65, domain_entity_64, domain_entity_63
**Retrieved Tables:** domain_entity_68, domain_entity_65, domain_entity_64, domain_entity_86, domain_entity_66, categories, domain_entity_85, domain_entity_87, domain_entity_61, domain_entity_69, domain_entity_53, domain_entity_24, domain_entity_67, domain_entity_82
**Generated SQL:**
```sql
SELECT
  de67.*,
  de66.name,
  de65.name,
  de64.name,
  de63.name 
FROM domain_entity_67 de67
LEFT JOIN domain_entity_66 de66 ON de67.domain_entity_66_id = de66.id
LEFT JOIN domain_entity_65 de65 ON de67.domain_entity_65_id = de65.id
LEFT JOIN domain_entity_64 de64 ON de67.domain_entity_64_id = de64.id
LEFT JOIN domain_entity_63 de63 ON de67.domain_entity_63_id = de63.id;
```

---

### Test 63: ✅ PASS
**Question:** Show me all records from domain_entity_68, including the linked domain_entity_67, domain_entity_66, domain_entity_65, and domain_entity_64.
**Expected Tables:** domain_entity_68, domain_entity_67, domain_entity_66, domain_entity_65, domain_entity_64
**Retrieved Tables:** domain_entity_21, domain_entity_68, domain_entity_65, domain_entity_64, domain_entity_86, categories, domain_entity_66, domain_entity_85, domain_entity_87, domain_entity_61, domain_entity_69, domain_entity_24, domain_entity_67, domain_entity_70, domain_entity_82
**Generated SQL:**
```sql
SELECT * 
FROM domain_entity_68 
INNER JOIN domain_entity_67 ON domain_entity_68.domain_entity_67_id = domain_entity_67.id
INNER JOIN domain_entity_66 ON domain_entity_68.domain_entity_66_id = domain_entity_66.id
INNER JOIN domain_entity_65 ON domain_entity_68.domain_entity_65_id = domain_entity_65.id
INNER JOIN domain_entity_64 ON domain_entity_68.domain_entity_64_id = domain_entity_64.id;
```

---

### Test 64: ❌ FAIL
**Question:** Show me all records from domain_entity_69, including the linked domain_entity_68, domain_entity_67, domain_entity_66, and domain_entity_65.
**Expected Tables:** domain_entity_69, domain_entity_68, domain_entity_67, domain_entity_66, domain_entity_65
**Retrieved Tables:** domain_entity_21, domain_entity_68, domain_entity_72, categories, domain_entity_86, domain_entity_66, domain_entity_56, domain_entity_61, domain_entity_69, domain_entity_71, domain_entity_96, domain_entity_24, domain_entity_67, domain_entity_70, domain_entity_82
**Generated SQL:**
```sql
SELECT *
FROM domain_entity_69
LEFT JOIN domain_entity_68 ON domain_entity_69.domain_entity_68_id = domain_entity_68.id
LEFT JOIN domain_entity_67 ON domain_entity_69.domain_entity_67_id = domain_entity_67.id
LEFT JOIN domain_entity_66 ON domain_entity_69.domain_entity_66_id = domain_entity_66.id
LEFT JOIN domain_entity_65 ON domain_entity_69.domain_entity_65_id = domain_entity_65.id;
```

---

### Test 65: ❌ FAIL
**Question:** Show me all records from domain_entity_70, including the linked domain_entity_69, domain_entity_68, domain_entity_67, and domain_entity_66.
**Expected Tables:** domain_entity_70, domain_entity_69, domain_entity_68, domain_entity_67, domain_entity_66
**Retrieved Tables:** domain_entity_68, domain_entity_72, categories, domain_entity_56, domain_entity_61, domain_entity_69, domain_entity_71, domain_entity_33, domain_entity_96, domain_entity_73, domain_entity_21, domain_entity_70, domain_entity_67
**Generated SQL:**
```sql
SELECT * 
FROM domain_entity_70 
LEFT JOIN domain_entity_69 ON domain_entity_70.domain_entity_69_id = domain_entity_69.id
LEFT JOIN domain_entity_68 ON domain_entity_70.domain_entity_68_id = domain_entity_68.id
LEFT JOIN domain_entity_67 ON domain_entity_70.domain_entity_67_id = domain_entity_67.id
LEFT JOIN domain_entity_66 ON domain_entity_70.domain_entity_66_id = domain_entity_66.id;
```

---

### Test 66: ❌ FAIL (API Error)
**Error:** Expecting value: line 1 column 1 (char 0)

---

### Test 67: ✅ PASS
**Question:** Show me all records from domain_entity_72, including the linked domain_entity_71, domain_entity_70, domain_entity_69, and domain_entity_68.
**Expected Tables:** domain_entity_72, domain_entity_71, domain_entity_70, domain_entity_69, domain_entity_68
**Retrieved Tables:** domain_entity_72, domain_entity_68, categories, domain_entity_56, domain_entity_74, domain_entity_69, domain_entity_71, domain_entity_36, domain_entity_33, domain_entity_96, domain_entity_73, domain_entity_21, domain_entity_70
**Generated SQL:**
```sql
SELECT 
    de72.*
FROM 
    domain_entity_72 as de72
JOIN 
    domain_entity_71 as de71 ON de72.domain_entity_71_id = de71.id
JOIN 
    domain_entity_70 as de70 ON de71.domain_entity_70_id = de70.id
JOIN 
    domain_entity_69 as de69 ON de70.domain_entity_69_id = de69.id
JOIN 
    domain_entity_68 as de68 ON de69.domain_entity_68_id = de68.id;
```

---

### Test 68: ✅ PASS
**Question:** Show me all records from domain_entity_73, including the linked domain_entity_72, domain_entity_71, domain_entity_70, and domain_entity_69.
**Expected Tables:** domain_entity_73, domain_entity_72, domain_entity_71, domain_entity_70, domain_entity_69
**Retrieved Tables:** domain_entity_72, domain_entity_75, categories, domain_entity_56, domain_entity_74, domain_entity_69, domain_entity_71, domain_entity_100, domain_entity_36, domain_entity_33, domain_entity_96, domain_entity_73, domain_entity_70
**Generated SQL:**
```sql
SELECT 
  de73.*, 
  de72.* , 
  de71.* , 
  de70.* , 
  de69.* 
FROM domain_entity_73 de73 
LEFT JOIN domain_entity_72 de72 ON de73.domain_entity_72_id = de72.id 
LEFT JOIN domain_entity_71 de71 ON de73.domain_entity_71_id = de71.id 
LEFT JOIN domain_entity_70 de70 ON de73.domain_entity_70_id = de70.id 
LEFT JOIN domain_entity_69 de69 ON de73.domain_entity_69_id = de69.id;
```

---

### Test 69: ✅ PASS
**Question:** Show me all records from domain_entity_74, including the linked domain_entity_73, domain_entity_72, domain_entity_71, and domain_entity_70.
**Expected Tables:** domain_entity_74, domain_entity_73, domain_entity_72, domain_entity_71, domain_entity_70
**Retrieved Tables:** domain_entity_72, domain_entity_75, categories, domain_entity_56, domain_entity_74, domain_entity_69, domain_entity_71, domain_entity_100, domain_entity_36, domain_entity_33, domain_entity_96, domain_entity_73, domain_entity_70
**Generated SQL:**
```sql
SELECT 
  de74.*
FROM domain_entity_74 de74
JOIN domain_entity_73 de73 ON de74.domain_entity_73_id = de73.id
JOIN domain_entity_72 de72 ON de73.domain_entity_72_id = de72.id
JOIN domain_entity_71 de71 ON de72.domain_entity_71_id = de71.id
JOIN domain_entity_70 de70 ON de71.domain_entity_70_id = de70.id
```

---

### Test 70: ✅ PASS
**Question:** Show me all records from domain_entity_75, including the linked domain_entity_74, domain_entity_73, domain_entity_72, and domain_entity_71.
**Expected Tables:** domain_entity_75, domain_entity_74, domain_entity_73, domain_entity_72, domain_entity_71
**Retrieved Tables:** domain_entity_83, domain_entity_88, domain_entity_74, domain_entity_84, domain_entity_71, domain_entity_100, domain_entity_77, domain_entity_75, domain_entity_73, domain_entity_60, domain_entity_72, domain_entity_85, domain_entity_56, domain_entity_33, domain_entity_76, domain_entity_21
**Generated SQL:**
```sql
SELECT * FROM domain_entity_75
JOIN domain_entity_74 ON domain_entity_75.domain_entity_74_id = domain_entity_74.id
JOIN domain_entity_73 ON domain_entity_75.domain_entity_73_id = domain_entity_73.id
JOIN domain_entity_72 ON domain_entity_75.domain_entity_72_id = domain_entity_72.id
JOIN domain_entity_71 ON domain_entity_75.domain_entity_71_id = domain_entity_71.id;
```

---

### Test 71: ✅ PASS
**Question:** Show me all records from domain_entity_76, including the linked domain_entity_75, domain_entity_74, domain_entity_73, and domain_entity_72.
**Expected Tables:** domain_entity_76, domain_entity_75, domain_entity_74, domain_entity_73, domain_entity_72
**Retrieved Tables:** domain_entity_88, domain_entity_74, domain_entity_84, domain_entity_71, domain_entity_100, domain_entity_27, domain_entity_77, domain_entity_78, domain_entity_75, domain_entity_73, domain_entity_60, domain_entity_72, domain_entity_56, domain_entity_33, domain_entity_76, domain_entity_21
**Generated SQL:**
```sql
SELECT 
    de76.*,
    domain_entity_75.name AS domain_entity_75_name,
    domain_entity_74.name AS domain_entity_74_name,
    domain_entity_73.name AS domain_entity_73_name,
    domain_entity_72.name AS domain_entity_72_name
FROM domain_entity_76 de76
LEFT JOIN domain_entity_75 ON de76.domain_entity_75_id = domain_entity_75.id
LEFT JOIN domain_entity_74 ON de76.domain_entity_74_id = domain_entity_74.id
LEFT JOIN domain_entity_73 ON de76.domain_entity_73_id = domain_entity_73.id
LEFT JOIN domain_entity_72 ON de76.domain_entity_72_id = domain_entity_72.id
```

---

### Test 72: ✅ PASS
**Question:** Show me all records from domain_entity_77, including the linked domain_entity_76, domain_entity_75, domain_entity_74, and domain_entity_73.
**Expected Tables:** domain_entity_77, domain_entity_76, domain_entity_75, domain_entity_74, domain_entity_73
**Retrieved Tables:** domain_entity_73, domain_entity_60, domain_entity_15, domain_entity_56, domain_entity_74, domain_entity_88, domain_entity_84, domain_entity_100, domain_entity_27, domain_entity_77, domain_entity_79, domain_entity_76, domain_entity_78, domain_entity_75, domain_entity_21
**Generated SQL:**
```sql
SELECT 
  * 
FROM domain_entity_77
WHERE 1=1;
UNION ALL 
SELECT 
  domain_entity_77.*,
  d.name as domain_entity_76_name,
  d.id as domain_entity_76_id,
  -- Rest of the join for domain_entity_76
FROM domain_entity_77 AS domain_entity_77 
JOIN domain_entity_76 AS d ON domain_entity_77.domain_entity_76_id = d.id;
UNION ALL 
SELECT 
  domain_entity_77.*,
  d.name as domain_entity_75_name,
  d.id as domain_entity_75_id,
  -- Rest of the join for domain_entity_75
FROM domain_entity_77 AS domain_entity_77 
JOIN domain_entity_75 AS d ON domain_entity_77.domain_entity_75_id = d.id;
UNION ALL 
SELECT 
  domain_entity_77.*,
  d.name as domain_entity_74_name,
  d.id as domain_entity_74_id,
  -- Rest of the join for domain_entity_74
FROM domain_entity_77 AS domain_entity_77 
JOIN domain_entity_74 AS d ON domain_entity_77.domain_entity_74_id = d.id;
UNION ALL 
SELECT 
  domain_entity_77.*,
  d.name as domain_entity_73_name,
  d.id as domain_entity_73_id,
  -- Rest of the join for domain_entity_73
FROM domain_entity_77 AS domain_entity_77 
JOIN domain_entity_73 AS d ON domain_entity_77.domain_entity_73_id = d.id;
```

---

### Test 73: ✅ PASS
**Question:** Show me all records from domain_entity_78, including the linked domain_entity_77, domain_entity_76, domain_entity_75, and domain_entity_74.
**Expected Tables:** domain_entity_78, domain_entity_77, domain_entity_76, domain_entity_75, domain_entity_74
**Retrieved Tables:** domain_entity_60, departments, domain_entity_15, domain_entity_88, domain_entity_74, domain_entity_80, domain_entity_84, domain_entity_27, domain_entity_77, domain_entity_79, domain_entity_95, domain_entity_76, domain_entity_78, domain_entity_75, domain_entity_21
**Generated SQL:**
```sql
SELECT 
  de.*, 
  domain_entity_77.name as name_domain_entity_77,
  domain_entity_76.name as name_domain_entity_76,
  domain_entity_75.name as name_domain_entity_75,
  domain_entity_74.name as name_domain_entity_74 
FROM domain_entity_78 de
LEFT JOIN domain_entity_77 ON de.id = domain_entity_77.id
LEFT JOIN domain_entity_76 ON de.id = domain_entity_76.id
LEFT JOIN domain_entity_75 ON de.id = domain_entity_75.id
LEFT JOIN domain_entity_74 ON de.id = domain_entity_74.id;
```

---

### Test 74: ❌ FAIL
**Question:** Show me all records from domain_entity_79, including the linked domain_entity_78, domain_entity_77, domain_entity_76, and domain_entity_75.
**Expected Tables:** domain_entity_79, domain_entity_78, domain_entity_77, domain_entity_76, domain_entity_75
**Retrieved Tables:** domain_entity_15, departments, domain_entity_81, domain_entity_80, domain_entity_94, domain_entity_27, domain_entity_77, domain_entity_95, domain_entity_79, domain_entity_96, domain_entity_26, domain_entity_76, domain_entity_78
**Generated SQL:**
```sql
SELECT 
    de79.*, 
    de78.*, 
    de77.*, 
    de76.*, 
    de75.*
FROM domain_entity_79 de79 
LEFT JOIN domain_entity_78 de78 ON de79.domain_entity_78_id = de78.id
LEFT JOIN domain_entity_77 de77 ON de79.domain_entity_77_id = de77.id
LEFT JOIN domain_entity_76 de76 ON de79.domain_entity_76_id = de76.id
LEFT JOIN domain_entity_75 de75 ON de79.domain_entity_75_id = de75.id;
```

---

### Test 75: ❌ FAIL (API Error)
**Error:** Expecting value: line 1 column 1 (char 0)

---

### Test 76: ❌ FAIL
**Question:** Show me all records from domain_entity_81, including the linked domain_entity_80, domain_entity_79, domain_entity_78, and domain_entity_77.
**Expected Tables:** domain_entity_81, domain_entity_80, domain_entity_79, domain_entity_78, domain_entity_77
**Retrieved Tables:** domain_entity_60, departments, domain_entity_89, domain_entity_81, domain_entity_83, domain_entity_80, domain_entity_91, domain_entity_90, domain_entity_79, domain_entity_95, domain_entity_26, domain_entity_78, domain_entity_67, domain_entity_82
**Generated SQL:**
```sql
SELECT 
  *
FROM domain_entity_81
WHERE 
  
JOIN domain_entity_80 ON domain_entity_81.domain_entity_80_id = domain_entity_80.id
JOIN domain_entity_79 ON domain_entity_81.domain_entity_79_id = domain_entity_79.id
JOIN domain_entity_78 ON domain_entity_81.domain_entity_78_id = domain_entity_78.id
JOIN domain_entity_77 ON domain_entity_81.domain_entity_77_id = domain_entity_77.id
```

---

### Test 77: ✅ PASS
**Question:** Show me all records from domain_entity_82, including the linked domain_entity_81, domain_entity_80, domain_entity_79, and domain_entity_78.
**Expected Tables:** domain_entity_82, domain_entity_81, domain_entity_80, domain_entity_79, domain_entity_78
**Retrieved Tables:** domain_entity_60, departments, domain_entity_89, domain_entity_81, domain_entity_83, domain_entity_80, domain_entity_91, domain_entity_90, domain_entity_79, domain_entity_95, domain_entity_26, domain_entity_78, domain_entity_67, domain_entity_82
**Generated SQL:**
```sql
SELECT * FROM domain_entity_82 
INNER JOIN domain_entity_81 ON domain_entity_82.domain_entity_81_id = domain_entity_81.id
INNER JOIN domain_entity_80 ON domain_entity_82.domain_entity_80_id = domain_entity_80.id
INNER JOIN domain_entity_79 ON domain_entity_82.domain_entity_79_id = domain_entity_79.id
INNER JOIN domain_entity_78 ON domain_entity_82.domain_entity_78_id = domain_entity_78.id
```

---

### Test 78: ✅ PASS
**Question:** Show me all records from domain_entity_83, including the linked domain_entity_82, domain_entity_81, domain_entity_80, and domain_entity_79.
**Expected Tables:** domain_entity_83, domain_entity_82, domain_entity_81, domain_entity_80, domain_entity_79
**Retrieved Tables:** domain_entity_60, domain_entity_81, domain_entity_83, domain_entity_85, domain_entity_80, domain_entity_84, domain_entity_90, domain_entity_79, domain_entity_28, domain_entity_26, domain_entity_75, domain_entity_67, domain_entity_82
**Generated SQL:**
```sql
SELECT 
  *
FROM domain_entity_83
JOIN domain_entity_82 ON domain_entity_83.domain_entity_82_id = domain_entity_82.id
JOIN domain_entity_81 ON domain_entity_83.domain_entity_81_id = domain_entity_81.id
JOIN domain_entity_80 ON domain_entity_83.domain_entity_80_id = domain_entity_80.id
JOIN domain_entity_79 ON domain_entity_83.domain_entity_79_id = domain_entity_79.id;
```

---

### Test 79: ✅ PASS
**Question:** Show me all records from domain_entity_84, including the linked domain_entity_83, domain_entity_82, domain_entity_81, and domain_entity_80.
**Expected Tables:** domain_entity_84, domain_entity_83, domain_entity_82, domain_entity_81, domain_entity_80
**Retrieved Tables:** domain_entity_60, domain_entity_85, domain_entity_81, domain_entity_83, domain_entity_86, domain_entity_84, domain_entity_80, domain_entity_90, domain_entity_28, domain_entity_75, domain_entity_67, domain_entity_58, domain_entity_82
**Generated SQL:**
```sql
SELECT * FROM domain_entity_84
INNER JOIN domain_entity_83 ON domain_entity_84.domain_entity_83_id = domain_entity_83.id
INNER JOIN domain_entity_82 ON domain_entity_84.domain_entity_83_id = domain_entity_82.id
INNER JOIN domain_entity_81 ON domain_entity_84.domain_entity_83_id = domain_entity_81.id
INNER JOIN domain_entity_80 ON domain_entity_84.domain_entity_83_id = domain_entity_80.id;
```

---

### Test 80: ✅ PASS
**Question:** Show me all records from domain_entity_85, including the linked domain_entity_84, domain_entity_83, domain_entity_82, and domain_entity_81.
**Expected Tables:** domain_entity_85, domain_entity_84, domain_entity_83, domain_entity_82, domain_entity_81
**Retrieved Tables:** domain_entity_60, domain_entity_81, domain_entity_85, domain_entity_86, domain_entity_83, domain_entity_87, domain_entity_84, domain_entity_80, domain_entity_90, domain_entity_75, domain_entity_67, domain_entity_58, domain_entity_82
**Generated SQL:**
```sql
SELECT 
  de85.*
FROM 
domain_entity_85 de85
LEFT JOIN domain_entity_84 de84 ON de85.domain_entity_84_id = de84.id
LEFT JOIN domain_entity_83 de83 ON de85.domain_entity_83_id = de83.id
LEFT JOIN domain_entity_82 de82 ON de85.domain_entity_82_id = de82.id
LEFT JOIN domain_entity_81 de81 ON de85.domain_entity_81_id = de81.id
```

---

### Test 81: ✅ PASS
**Question:** Show me all records from domain_entity_86, including the linked domain_entity_85, domain_entity_84, domain_entity_83, and domain_entity_82.
**Expected Tables:** domain_entity_86, domain_entity_85, domain_entity_84, domain_entity_83, domain_entity_82
**Retrieved Tables:** domain_entity_85, domain_entity_86, domain_entity_87, domain_entity_81, domain_entity_83, domain_entity_88, domain_entity_84, domain_entity_33, domain_entity_75, domain_entity_67, domain_entity_58, domain_entity_82
**Generated SQL:**
```sql
SELECT 
    de86.*
FROM 
    domain_entity_86 AS de86
LEFT JOIN 
    domain_entity_85 AS de85 ON de86.domain_entity_85_id = de85.id
LEFT JOIN 
    domain_entity_84 AS de84 ON de86.domain_entity_84_id = de84.id
LEFT JOIN 
    domain_entity_83 AS de83 ON de86.domain_entity_83_id = de83.id
LEFT JOIN 
    domain_entity_82 AS de82 ON de86.domain_entity_82_id = de82.id
```

---

### Test 82: ❌ FAIL
**Question:** Show me all records from domain_entity_87, including the linked domain_entity_86, domain_entity_85, domain_entity_84, and domain_entity_83.
**Expected Tables:** domain_entity_87, domain_entity_86, domain_entity_85, domain_entity_84, domain_entity_83
**Retrieved Tables:** domain_entity_85, domain_entity_86, domain_entity_87, domain_entity_88, domain_entity_81, domain_entity_84, domain_entity_91, domain_entity_90, domain_entity_33, domain_entity_76, domain_entity_67, domain_entity_58, domain_entity_89
**Generated SQL:**
```sql
SELECT 
    de87.*,
    d86.name AS domain_entity_86_name, 
    d85.name AS domain_entity_85_name,
    d84.name AS domain_entity_84_name, 
    d83.name AS domain_entity_83_name
FROM domain_entity_87 de87
LEFT JOIN domain_entity_86 d86 ON de87.domain_entity_86_id = d86.id 
LEFT JOIN domain_entity_85 d85 ON de87.domain_entity_85_id = d85.id
LEFT JOIN domain_entity_84 d84 ON de87.domain_entity_84_id = d84.id
LEFT JOIN domain_entity_83 d83 ON de87.domain_entity_83_id = d83.id
```

---

### Test 83: ✅ PASS
**Question:** Show me all records from domain_entity_88, including the linked domain_entity_87, domain_entity_86, domain_entity_85, and domain_entity_84.
**Expected Tables:** domain_entity_88, domain_entity_87, domain_entity_86, domain_entity_85, domain_entity_84
**Retrieved Tables:** domain_entity_30, domain_entity_85, domain_entity_86, domain_entity_88, domain_entity_87, domain_entity_84, domain_entity_90, domain_entity_33, domain_entity_76, domain_entity_67, domain_entity_58, domain_entity_89
**Generated SQL:**
```sql
SELECT *
FROM domain_entity_88
LEFT JOIN domain_entity_87 ON domain_entity_88.id = domain_entity_87.domain_entity_88_id
LEFT JOIN domain_entity_86 ON domain_entity_88.id = domain_entity_86.domain_entity_88_id
LEFT JOIN domain_entity_85 ON domain_entity_88.id = domain_entity_85.domain_entity_88_id
LEFT JOIN domain_entity_84 ON domain_entity_88.id = domain_entity_84.domain_entity_88_id;
```

---

### Test 84: ✅ PASS
**Question:** Show me all records from domain_entity_89, including the linked domain_entity_88, domain_entity_87, domain_entity_86, and domain_entity_85.
**Expected Tables:** domain_entity_89, domain_entity_88, domain_entity_87, domain_entity_86, domain_entity_85
**Retrieved Tables:** domain_entity_30, domain_entity_81, domain_entity_86, domain_entity_87, domain_entity_88, domain_entity_85, domain_entity_91, domain_entity_90, domain_entity_33, domain_entity_76, domain_entity_67, domain_entity_89
**Generated SQL:**
```sql
SELECT 
    de90.*, 
    domain_entity_88.name AS domain_entity_88_name, 
    domain_entity_87.name AS domain_entity_87_name, 
    domain_entity_86.name AS domain_entity_86_name, 
    domain_entity_85.name AS domain_entity_85_name
FROM domain_entity_90 de90
LEFT JOIN domain_entity_88 on de90.domain_entity_89_id = domain_entity_88.id
LEFT JOIN domain_entity_87 on de90.domain_entity_89_id = domain_entity_87.id
LEFT JOIN domain_entity_86 on de90.domain_entity_89_id = domain_entity_86.id
LEFT JOIN domain_entity_85 on de90.domain_entity_89_id = domain_entity_85.id;
```

---

### Test 85: ❌ FAIL (API Error)
**Error:** Expecting value: line 1 column 1 (char 0)

---

### Test 86: ✅ PASS
**Question:** Show me all records from domain_entity_91, including the linked domain_entity_90, domain_entity_89, domain_entity_88, and domain_entity_87.
**Expected Tables:** domain_entity_91, domain_entity_90, domain_entity_89, domain_entity_88, domain_entity_87
**Retrieved Tables:** domain_entity_30, domain_entity_40, domain_entity_93, domain_entity_81, domain_entity_88, domain_entity_87, domain_entity_14, domain_entity_91, domain_entity_90, domain_entity_76, domain_entity_92, domain_entity_89
**Generated SQL:**
```sql
SELECT de91.*, de90.name AS domain_entity_90_name, de89.* , de88.*, de87.* 
FROM domain_entity_91 AS de91
LEFT JOIN domain_entity_90 AS de90 ON de91.domain_entity_90_id = de90.id
LEFT JOIN domain_entity_89 AS de89 ON de91.domain_entity_90_id = de89.id 
LEFT JOIN domain_entity_88 AS de88 ON de91.domain_entity_90_id = de88.id
LEFT JOIN domain_entity_87 AS de87 ON de91.domain_entity_90_id = de87.id
```

---

### Test 87: ✅ PASS
**Question:** Show me all records from domain_entity_92, including the linked domain_entity_91, domain_entity_90, domain_entity_89, and domain_entity_88.
**Expected Tables:** domain_entity_92, domain_entity_91, domain_entity_90, domain_entity_89, domain_entity_88
**Retrieved Tables:** domain_entity_30, domain_entity_40, domain_entity_20, domain_entity_93, domain_entity_81, domain_entity_88, domain_entity_94, domain_entity_14, domain_entity_91, domain_entity_90, domain_entity_92, domain_entity_89
**Generated SQL:**
```sql
SELECT 
  de92.*,
  de91.name,
  de90.name,
  de89.name,
  de88.name 
FROM domain_entity_92 as de92
LEFT JOIN domain_entity_91 as de91 ON de92.domain_entity_91_id = de91.id
LEFT JOIN domain_entity_90 as de90 ON de92.domain_entity_90_id = de90.id
LEFT JOIN domain_entity_89 as de89 ON de92.domain_entity_89_id = de89.id
LEFT JOIN domain_entity_88 as de88 ON de92.domain_entity_88_id = de88.id
```

---

### Test 88: ✅ PASS
**Question:** Show me all records from domain_entity_93, including the linked domain_entity_92, domain_entity_91, domain_entity_90, and domain_entity_89.
**Expected Tables:** domain_entity_93, domain_entity_92, domain_entity_91, domain_entity_90, domain_entity_89
**Retrieved Tables:** domain_entity_40, domain_entity_44, domain_entity_20, domain_entity_89, domain_entity_81, domain_entity_94, domain_entity_14, domain_entity_91, domain_entity_90, domain_entity_95, domain_entity_92, domain_entity_93
**Generated SQL:**
```sql
SELECT 
  * 
FROM domain_entity_93
JOIN domain_entity_92 ON domain_entity_93.domain_entity_92_id = domain_entity_92.id
LEFT JOIN domain_entity_91 ON domain_entity_93.domain_entity_92_id = domain_entity_91.id
LEFT JOIN domain_entity_90 ON domain_entity_93.domain_entity_92_id = domain_entity_90.id
LEFT JOIN domain_entity_89 ON domain_entity_93.domain_entity_92_id = domain_entity_89.id
```

---

### Test 89: ✅ PASS
**Question:** Show me all records from domain_entity_94, including the linked domain_entity_93, domain_entity_92, domain_entity_91, and domain_entity_90.
**Expected Tables:** domain_entity_94, domain_entity_93, domain_entity_92, domain_entity_91, domain_entity_90
**Retrieved Tables:** domain_entity_44, domain_entity_20, domain_entity_89, domain_entity_81, domain_entity_94, domain_entity_14, domain_entity_91, domain_entity_90, domain_entity_95, domain_entity_79, domain_entity_96, domain_entity_92, domain_entity_93
**Generated SQL:**
```sql
SELECT * 
FROM domain_entity_94
WHERE 1=1
UNION
SELECT 
    d.id, 
    d.name, 
    d.created_at, 
    d.domain_entity_93_id, 
    d.domain_entity_92_id, 
    d.domain_entity_91_id, 
    d.domain_entity_90_id  
FROM domain_entity_94 d
LEFT JOIN domain_entity_93 dm ON d.domain_entity_93_id = dm.id
LEFT JOIN domain_entity_92 dj ON dm.domain_entity_92_id = dj.id
LEFT JOIN domain_entity_91 dj ON dj.id = d.domain_entity_91_id 
LEFT JOIN domain_entity_90 dj ON dj.id = d.domain_entity_90_id
```

---

### Test 90: ✅ PASS
**Question:** Show me all records from domain_entity_95, including the linked domain_entity_94, domain_entity_93, domain_entity_92, and domain_entity_91.
**Expected Tables:** domain_entity_95, domain_entity_94, domain_entity_93, domain_entity_92, domain_entity_91
**Retrieved Tables:** domain_entity_44, domain_entity_20, domain_entity_89, domain_entity_81, domain_entity_94, domain_entity_14, domain_entity_91, domain_entity_90, domain_entity_95, domain_entity_79, domain_entity_96, domain_entity_92, domain_entity_93
**Generated SQL:**
```sql
SELECT 
    de95.*
FROM 
    domain_entity_95 de95
JOIN 
    domain_entity_94 de94 ON de95.domain_entity_94_id = de94.id
JOIN 
    domain_entity_93 de93 ON de94.domain_entity_93_id = de93.id
JOIN 
    domain_entity_92 de92 ON de93.domain_entity_92_id = de92.id
JOIN 
    domain_entity_91 de91 ON de92.domain_entity_91_id = de91.id;
```

---

### Test 91: ✅ PASS
**Question:** Show me all records from domain_entity_96, including the linked domain_entity_95, domain_entity_94, domain_entity_93, and domain_entity_92.
**Expected Tables:** domain_entity_96, domain_entity_95, domain_entity_94, domain_entity_93, domain_entity_92
**Retrieved Tables:** domain_entity_44, domain_entity_20, domain_entity_97, domain_entity_94, domain_entity_14, domain_entity_91, domain_entity_95, domain_entity_79, domain_entity_96, domain_entity_92, domain_entity_70, domain_entity_93
**Generated SQL:**
```sql
SELECT 
  de96.*,
  de95.name AS domain_entity_95_name,
  de94.* ,
  de93.* ,
  de92.* 
FROM domain_entity_96 de96
LEFT JOIN domain_entity_95 de95 ON de96.domain_entity_95_id = de95.id 
LEFT JOIN domain_entity_94 de94 ON de96.domain_entity_95_id = de94.id  
LEFT JOIN domain_entity_93 de93 ON de96.domain_entity_95_id = de93.id
LEFT JOIN domain_entity_92 de92 ON de96.domain_entity_95_id = de92.id
```

---

### Test 92: ✅ PASS
**Question:** Show me all records from domain_entity_97, including the linked domain_entity_96, domain_entity_95, domain_entity_94, and domain_entity_93.
**Expected Tables:** domain_entity_97, domain_entity_96, domain_entity_95, domain_entity_94, domain_entity_93
**Retrieved Tables:** domain_entity_44, domain_entity_97, domain_entity_98, domain_entity_45, domain_entity_94, domain_entity_99, domain_entity_95, domain_entity_79, domain_entity_96, domain_entity_26, domain_entity_70, domain_entity_93
**Generated SQL:**
```sql
SELECT de97.*, de96.name, de95.name, de94.name, de93.name 
FROM domain_entity_97 de97 
LEFT JOIN domain_entity_96 de96 ON de97.id = de96.domain_entity_97_id 
LEFT JOIN domain_entity_95 de95 ON de96.id = de95.domain_entity_95_id 
LEFT JOIN domain_entity_94 de94 ON de95.id = de94.domain_entity_94_id  
LEFT JOIN domain_entity_93 de93 ON de94.id = de93.domain_entity_92_id;
```

---

### Test 93: ✅ PASS
**Question:** Show me all records from domain_entity_98, including the linked domain_entity_97, domain_entity_96, domain_entity_95, and domain_entity_94.
**Expected Tables:** domain_entity_98, domain_entity_97, domain_entity_96, domain_entity_95, domain_entity_94
**Retrieved Tables:** domain_entity_44, domain_entity_97, domain_entity_98, domain_entity_45, domain_entity_94, domain_entity_43, domain_entity_100, domain_entity_99, domain_entity_95, domain_entity_79, domain_entity_96, domain_entity_70, domain_entity_93
**Generated SQL:**
```sql
SELECT 
  de98.*,
  de97.name AS domain_entity_97_name, 
  de96.name AS domain_entity_96_name, 
  de95.name AS domain_entity_95_name, 
  de94.name AS domain_entity_94_name
FROM domain_entity_98 de98
LEFT JOIN domain_entity_97 de97 ON de98.domain_entity_97_id = de97.id
LEFT JOIN domain_entity_96 de96 ON de98.domain_entity_96_id = de96.id
LEFT JOIN domain_entity_95 de95 ON de98.domain_entity_95_id = de95.id
LEFT JOIN domain_entity_94 de94 ON de98.domain_entity_94_id = de94.id
```

---

### Test 94: ✅ PASS
**Question:** Show me all records from domain_entity_99, including the linked domain_entity_98, domain_entity_97, domain_entity_96, and domain_entity_95.
**Expected Tables:** domain_entity_99, domain_entity_98, domain_entity_97, domain_entity_96, domain_entity_95
**Retrieved Tables:** domain_entity_97, domain_entity_98, domain_entity_74, domain_entity_45, domain_entity_94, domain_entity_43, domain_entity_100, domain_entity_99, domain_entity_95, domain_entity_79, domain_entity_96, domain_entity_70
**Generated SQL:**
```sql
SELECT * FROM domain_entity_99
INNER JOIN domain_entity_98 ON domain_entity_99.domain_entity_98_id = domain_entity_98.id
INNER JOIN domain_entity_97 ON domain_entity_99.domain_entity_97_id = domain_entity_97.id
INNER JOIN domain_entity_96 ON domain_entity_99.domain_entity_96_id = domain_entity_96.id
INNER JOIN domain_entity_95 ON domain_entity_99.domain_entity_95_id = domain_entity_95.id
```

---

### Test 95: ❌ FAIL (API Error)
**Error:** Expecting value: line 1 column 1 (char 0)

---

### Test 96: ✅ PASS
**Question:** Show me all records from users, including the linked domain_entity_100, domain_entity_99, domain_entity_98, and domain_entity_97.
**Expected Tables:** users, domain_entity_100, domain_entity_99, domain_entity_98, domain_entity_97
**Retrieved Tables:** domain_entity_11, categories, domain_entity_97, domain_entity_74, domain_entity_45, domain_entity_69, domain_entity_100, domain_entity_71, domain_entity_96, domain_entity_43, domain_entity_10, domain_entity_47, domain_entity_44, domain_entity_98, users, domain_entity_99, domain_entity_9, domain_entity_70
**Generated SQL:**
```sql
SELECT * 
FROM users u
INNER JOIN domain_entity_100 de100 ON u.id = de100.users_id
INNER JOIN domain_entity_99 de99 ON de100.domain_entity_99_id = de99.id
INNER JOIN domain_entity_98 de98 ON de99.id = de98.domain_entity_97_id
INNER JOIN domain_entity_97 de97 ON de98.domain_entity_96_id = de97.id;
```

---

### Test 97: ❌ FAIL
**Question:** Show me all records from companies, including the linked users, domain_entity_100, domain_entity_99, and domain_entity_98.
**Expected Tables:** companies, users, domain_entity_100, domain_entity_99, domain_entity_98
**Retrieved Tables:** domain_entity_11, domain_entity_97, companies, domain_entity_74, domain_entity_45, domain_entity_25, domain_entity_100, domain_entity_43, domain_entity_26, domain_entity_10, domain_entity_12, domain_entity_31, domain_entity_98, domain_entity_42, domain_entity_99, domain_entity_53, domain_entity_24
**Generated SQL:**
```sql
SELECT c.*, eu.name, de100.name, de99.name, de98.name
FROM companies c
LEFT JOIN users eu ON c.users_id = eu.id
LEFT JOIN domain_entity_100 de100 ON c.id = de100.domain_entity_10_id
LEFT JOIN domain_entity_99 de99 ON c.id = de99.domain_entity_99_id
LEFT JOIN domain_entity_98 de98 ON c.id = de98.domain_entity_98_id;
```

---

### Test 98: ❌ FAIL
**Question:** Show me all records from departments, including the linked companies, users, domain_entity_100, and domain_entity_99.
**Expected Tables:** departments, companies, users, domain_entity_100, domain_entity_99
**Retrieved Tables:** departments, categories, domain_entity_74, domain_entity_80, domain_entity_100, domain_entity_27, domain_entity_95, domain_entity_43, domain_entity_6, domain_entity_78, domain_entity_40, domain_entity_44, domain_entity_42, domain_entity_39, domain_entity_61, domain_entity_99, domain_entity_41, domain_entity_79, domain_entity_91, domain_entity_33, domain_entity_7, domain_entity_9
**Generated SQL:**
```sql
SELECT d.*
FROM departments d
JOIN domain_entity_100 de100 ON d.id = de100.departments_id
LEFT JOIN users u ON d.companies_id = u.id
LEFT JOIN domain_entity_99 de99 ON de100.domain_entity_99_id = de99.id;
```

---

### Test 99: ❌ FAIL
**Question:** Show me all records from regions, including the linked departments, companies, users, and domain_entity_100.
**Expected Tables:** regions, departments, companies, users, domain_entity_100
**Retrieved Tables:** departments, domain_entity_18, categories, domain_entity_74, domain_entity_45, domain_entity_80, domain_entity_100, domain_entity_27, domain_entity_95, domain_entity_6, domain_entity_17, domain_entity_78, domain_entity_19, users, domain_entity_61, domain_entity_99, domain_entity_23, regions, domain_entity_79, domain_entity_33, domain_entity_7, domain_entity_9
**Generated SQL:**
```sql
SELECT r.*, d.name AS department_name, c.name AS company_name, u.name AS user_name, de100.name as domain_entity_100_name 
FROM regions r
JOIN departments d ON r.departments_id = d.id
JOIN companies c ON d.companies_id = c.id
JOIN users u ON r.users_id = u.id
LEFT JOIN domain_entity_100 de100 ON r.regions_id = de100.id;
```

---

### Test 100: ✅ PASS
**Question:** Show me all records from categories, including the linked regions, departments, companies, and users.
**Expected Tables:** categories, regions, departments, companies, users
**Retrieved Tables:** departments, domain_entity_65, domain_entity_18, categories, companies, domain_entity_27, domain_entity_43, domain_entity_6, domain_entity_40, domain_entity_44, domain_entity_19, domain_entity_42, users, domain_entity_61, domain_entity_99, domain_entity_41, regions, domain_entity_79, domain_entity_33, domain_entity_7, domain_entity_9, domain_entity_70
**Generated SQL:**
```sql
SELECT 
  c.*,
  r.name AS region_name,
  d.name AS department_name,
  co.name AS company_name,
  u.name AS user_name
FROM categories c
LEFT JOIN regions r ON c.regions_id = r.id
LEFT JOIN departments d ON c.departments_id = d.id
LEFT JOIN companies co ON c.users_id = co.id
LEFT JOIN users u ON c.users_id = u.id;
```

---
