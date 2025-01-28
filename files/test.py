import os

db_url = os.getenv("DATABASE_URL")
print(f"Database URL from Python: {db_url}")
