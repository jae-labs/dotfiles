#!/usr/bin/env python3

# Sample Python file with various issues for testing

import os
import sys
import json
from typing import List, Dict, Optional, Any
from datetime import datetime

# Unused import
import time
import random  # Another unused import
import subprocess  # Unused import

# Constants with potential issues
API_URL = "https://api.example.com"
MAX_RETRIES = 3
TIMEOUT = 5.0
UNUSED_CONSTANT = "This is not used"
ANOTHER_UNUSED = 42

# Global variable (should be in function)
global_var = "This pollutes global scope"

# Class with potential issues
class Person:
    def __init__(self, name: str, age: int, email: str = ""):
        self.name = name
        self.age = age
        self.email = email
        self.created_at = datetime.now()

    def greet(self, greeting: str = "Hello") -> str:
        return f"{greeting}, {self.name}!"

    def to_dict(self) -> Dict[str, Any]:
        return {
            "name": self.name,
            "age": self.age,
            "email": self.email,
            "created_at": self.created_at.isoformat()
        }

    def __str__(self) -> str:
        return f"Person(name='{self.name}', age={self.age})"

# Function with potential issues
def create_people(names: List[str]) -> List[Person]:
    people = []
    for i, name in enumerate(names):
        age = 20 + i * 5  # Potential issue: hardcoded logic
        person = Person(name, age)
        people.append(person)

    # Unused variable
    unused_var = "This is not used"
    another_unused = 123

    # Unused parameter in nested function
    def helper_func(param1, param2, param3):
        return param1

    return people

def process_data(data: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
    processed = []
    for item in data:
        processed_item = {
            "id": item.get("id"),
            "name": item.get("name", "").upper(),
            "processed": True,
            "timestamp": datetime.now().isoformat()
        }
        processed.append(processed_item)

    return processed

# Async function with potential issues
async def fetch_user_data(user_id: int) -> Optional[Dict[str, Any]]:
    try:
        # Simulated async operation
        await asyncio.sleep(0.1)  # Missing import for asyncio
        return {
            "id": user_id,
            "name": f"User {user_id}",
            "email": f"user{user_id}@example.com",
            "active": True
        }
    except Exception as e:
        print(f"Error fetching user {user_id}: {e}")
        return None
        # Missing rethrow or proper error handling

# Context manager with potential issues
class FileHandler:
    def __init__(self, filename: str, mode: str = "r"):
        self.filename = filename
        self.mode = mode
        self.file = None

    def __enter__(self):
        self.file = open(self.filename, self.mode)
        return self.file

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.file:
            self.file.close()

# Decorator with potential issues
def timing_decorator(func):
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        end = time.time()
        print(f"{func.__name__} took {end - start:.4f} seconds")
        return result
    return wrapper

@timing_decorator
def expensive_operation(n: int) -> int:
    total = 0
    for i in range(n):
        total += i * i
    return total

# Main function with potential issues
def main():
    # Create people
    names = ["Alice", "Bob", "Charlie"]
    people = create_people(names)

    for person in people:
        print(person.greet())
        print(person.to_dict())

    # Process data
    sample_data = [
        {"id": 1, "name": "alice"},
        {"id": 2, "name": "bob"},
        {"id": 3, "name": "charlie"}
    ]

    processed = process_data(sample_data)
    print("Processed data:", json.dumps(processed, indent=2))

    # File operations
    with FileHandler("output.txt", "w") as f:
        f.write("Sample output\n")
        f.write(f"Generated at: {datetime.now()}\n")

    # Expensive operation
    result = expensive_operation(1000)
    print(f"Expensive operation result: {result}")

    # Type checking with potential issues
    value: Any = "test"
    if isinstance(value, str):
        print(f"String value: {value.upper()}")

    # List comprehension with potential issues
    squares = [x * x for x in range(10) if x % 2 == 0]
    print(f"Squares of even numbers: {squares}")

    # Unused variable in main
    main_unused = "This is not used"

    # Missing return statement
    # return None

if __name__ == "__main__":
    main()
