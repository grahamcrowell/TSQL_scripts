import sqlite3

SQL_TEXT = ''
with open("test.sql") as SQL_FILE:
  SQL_TEXT = SQL_FILE.read()


print(SQL_TEXT)

def run_sql_code(sql_code):
  conn = sqlite3.connect('example.db')
  c = conn.cursor()
  c.execute(sql_code)
  c.commit()
  conn.close()

run_sql_code(SQL_TEXT)
