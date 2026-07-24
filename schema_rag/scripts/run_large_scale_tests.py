import os
import subprocess
import time
import json
from datetime import datetime

def generate_questions():
    questions = []
    
    base_tables = ["users", "companies", "departments", "regions", "categories"]
    tables = base_tables + [f"domain_entity_{i}" for i in range(6, 101)]
    
    # Generate 100 queries
    for i in range(5, 105):
        # We pick a target index. Let's wrap around.
        idx = i % 100
        
        # We want to span 5 tables. Since we generated table N with a FK to N-1,
        # querying table N and asking for its N-1, N-2, N-3, N-4 will naturally span 5 tables.
        
        t1 = tables[idx]
        t2 = tables[(idx - 1) % 100]
        t3 = tables[(idx - 2) % 100]
        t4 = tables[(idx - 3) % 100]
        t5 = tables[(idx - 4) % 100]
        
        question = f"Show me all records from {t1}, including the linked {t2}, {t3}, {t4}, and {t5}."
        
        questions.append({
            "id": i - 4,
            "question": question,
            "expected_tables": [t1, t2, t3, t4, t5]
        })
    return questions

def run_tests():
    report_lines = []
    report_lines.append("# Large-Scale Test Suite Report\n")
    report_lines.append(f"**Date:** {datetime.now().isoformat()}\n")
    
    print("1. Installing the 100-table schema...")
    # Load env vars
    from dotenv import load_dotenv
    load_dotenv(os.path.join(os.path.dirname(__file__), "..", "..", ".env"))
    
    mysql_host = os.environ.get("MYSQL_HOST", "localhost")
    mysql_port = os.environ.get("MYSQL_PORT", "3306")
    mysql_user = os.environ.get("MYSQL_USER", "root")
    mysql_pass = os.environ.get("MYSQL_PASSWORD", "")
    mysql_db = os.environ.get("MYSQL_DATABASE", "schema_rag_test")
    
    schema_path = os.path.join(os.path.dirname(__file__), "..", "..", "tests", "fixtures", "large_schema_100_tables.sql")
    
    # Execute schema using python mysql-connector to avoid requiring mysql CLI
    import mysql.connector
    
    conn = mysql.connector.connect(
        host=mysql_host,
        port=int(mysql_port),
        user=mysql_user,
        password=mysql_pass,
        database=mysql_db
    )
    cursor = conn.cursor()
    
    with open(schema_path, "r") as f:
        sql_script = f.read()
    
    # execute split statements (mysql.connector has multi=True for execute)
    try:
        for result in cursor.execute(sql_script, multi=True):
            pass # just iterate through the statements to execute them all
    except Exception as e:
        print(f"Error executing schema: {e}")
        
    conn.commit()
    cursor.close()
    conn.close()
    
    print("2. Running ingestion pipeline via API...")
    import requests
    try:
        resp = requests.post("http://localhost:8000/ingest", timeout=600)
        print(f"Ingestion response: {resp.text}")
    except Exception as e:
        print(f"Ingestion API call failed: {e}")
        # Proceed anyway to test the query API even if ingestion failed or timed out
    
    print("3. Executing 100 test cases via API...")
    questions = generate_questions()
    
    passed_count = 0
    total_count = len(questions)
    
    report_lines.append("## Test Results\n")
    report_lines.append(f"**Total Cases:** {total_count}\n")
    
    for q in questions:
        print(f"Running Test {q['id']}/100...")
        
        try:
            res = requests.post("http://localhost:8000/query", json={"question": q['question']}, timeout=600)
            res_data = res.json()
            expanded = res_data.get("expanded_tables", [])
            sql_generated = res_data.get("sql", "")
            
            retrieved_tables = set(expanded)
            expected_set = set(q['expected_tables'])
            
            # Check if ALL expected tables are in the retrieved tables
            passed = expected_set.issubset(retrieved_tables)
            
            status = "✅ PASS" if passed else "❌ FAIL"
            if passed:
                passed_count += 1
                
            report_lines.append(f"### Test {q['id']}: {status}")
            report_lines.append(f"**Question:** {q['question']}")
            report_lines.append(f"**Expected Tables:** {', '.join(q['expected_tables'])}")
            report_lines.append(f"**Retrieved Tables:** {', '.join(expanded)}")
            report_lines.append("**Generated SQL:**")
            report_lines.append("```sql\n" + sql_generated + "\n```")
            report_lines.append("\n---\n")
        except Exception as e:
            report_lines.append(f"### Test {q['id']}: ❌ FAIL (API Error)")
            report_lines.append(f"**Error:** {str(e)}")
            report_lines.append("\n---\n")
        
    report_lines.insert(3, f"**Passed:** {passed_count}/{total_count}\n")
    
    report_path = os.path.join(os.path.dirname(__file__), "..", "..", "large_scale_test_report.md")
    with open(report_path, "w") as f:
        f.write("\n".join(report_lines))
        
    print(f"Done. Passed {passed_count}/{total_count}. Report saved to {report_path}.")

if __name__ == "__main__":
    run_tests()
