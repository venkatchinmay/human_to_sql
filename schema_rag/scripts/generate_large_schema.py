import os
import random

def generate_schema(output_path: str):
    num_tables = 100
    tables = []
    
    # Base tables
    base_tables = ["users", "companies", "departments", "regions", "categories"]
    
    # We will generate a chain of 100 tables to guarantee deep FK relationships.
    # Table i will have a foreign key to Table i-1 (and occasionally i-2).
    
    sql_lines = []
    sql_lines.append("-- Auto-generated 100-table schema for testing")
    sql_lines.append("SET FOREIGN_KEY_CHECKS=0;")
    
    table_names = []
    for i in range(1, num_tables + 1):
        if i <= len(base_tables):
            tname = base_tables[i-1]
        else:
            tname = f"domain_entity_{i}"
        table_names.append(tname)
        
        sql_lines.append(f"DROP TABLE IF EXISTS {tname};")
        sql_lines.append(f"CREATE TABLE {tname} (")
        columns = []
        columns.append("id INT PRIMARY KEY AUTO_INCREMENT")
        columns.append("name VARCHAR(255) NOT NULL")
        columns.append("created_at DATETIME DEFAULT CURRENT_TIMESTAMP")
        
        fks = []
        # Create a deep graph: everyone links to the immediate previous one
        if i > 1:
            prev_tname = table_names[i-2]
            columns.append(f"{prev_tname}_id INT")
            fks.append(f"FOREIGN KEY ({prev_tname}_id) REFERENCES {prev_tname}(id)")
        
        # Add a random jump link to create complex graphs (but only to earlier tables)
        if i > 3:
            rand_idx = random.randint(0, i-4)
            rand_tname = table_names[rand_idx]
            columns.append(f"{rand_tname}_id INT")
            fks.append(f"FOREIGN KEY ({rand_tname}_id) REFERENCES {rand_tname}(id)")
            
        all_lines = columns + fks
        sql_lines.append("    " + ",\n    ".join(all_lines))
            
        sql_lines.append(");")
        sql_lines.append("")

    sql_lines.append("SET FOREIGN_KEY_CHECKS=1;")
    
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    with open(output_path, "w") as f:
        f.write("\n".join(sql_lines))

if __name__ == "__main__":
    out_path = os.path.join(os.path.dirname(__file__), "..", "..", "tests", "fixtures", "large_schema_100_tables.sql")
    generate_schema(out_path)
    print(f"Generated 100-table schema at {out_path}")
