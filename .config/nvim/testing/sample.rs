// Sample Rust file with various issues for testing

use std::collections::HashMap;
use std::fs::File;
use std::io::{self, Write};
use std::time::{SystemTime, UNIX_EPOCH};

// Unused import
use std::path::Path;
use std::collections::HashSet; // Another unused import

// Constants with potential issues
const API_URL: &str = "https://api.example.com";
const MAX_RETRIES: u32 = 3;
const TIMEOUT: u64 = 5000;
const UNUSED_CONSTANT: &str = "This is not used";
const ANOTHER_UNUSED: i32 = 42;

// Struct with potential issues
#[derive(Debug, Clone)]
struct Person {
    name: String,
    age: u32,
    email: Option<String>,
    created_at: u64,
}

impl Person {
    fn new(name: String, age: u32, email: Option<String>) -> Self {
        Self {
            name,
            age,
            email,
            created_at: SystemTime::now()
                .duration_since(UNIX_EPOCH)
                .unwrap()
                .as_secs(),
        }
    }

    fn greet(&self, greeting: Option<&str>) -> String {
        let greeting = greeting.unwrap_or("Hello");
        format!("{}, {}!", greeting, self.name)
    }

    fn to_dict(&self) -> HashMap<String, String> {
        let mut map = HashMap::new();
        map.insert("name".to_string(), self.name.clone());
        map.insert("age".to_string(), self.age.to_string());
        map.insert("created_at".to_string(), self.created_at.to_string());

        if let Some(email) = &self.email {
            map.insert("email".to_string(), email.clone());
        }

        map
    }
}

// Enum with potential issues
#[derive(Debug, PartialEq)]
enum Status {
    Active,
    Inactive,
    Pending,
    Suspended,
}

// Trait with potential issues
trait Processable {
    fn process(&self) -> Result<String, String>;
    fn validate(&self) -> bool;
}

impl Processable for Person {
    fn process(&self) -> Result<String, String> {
        if self.age < 18 {
            return Err("Person is underage".to_string());
        }
        Ok(format!("Processed: {}", self.name))
    }

    fn validate(&self) -> bool {
        !self.name.is_empty() && self.age > 0 && self.age <= 120
    }
}

// Function with potential issues
fn create_people(names: Vec<String>) -> Vec<Person> {
    let mut people = Vec::new();

    for (i, name) in names.iter().enumerate() {
        let age = (20 + i as u32).min(100); // Potential issue: arbitrary age calculation
        let person = Person::new(name.clone(), age, None);
        people.push(person);
    }

    // Unused variable
    let unused_var = "This is not used";
    let another_unused = 123;

    // Unused parameter in nested function
    let unused_param = |param1: i32, param2: String, param3: bool| param1;

    people
}

// Generic function with potential issues
fn wrap_in_option<T>(value: T) -> Option<T> {
    Some(value)
}

// Result handling with potential issues
fn divide(a: f64, b: f64) -> Result<f64, String> {
    if b == 0.0 {
        Err("Division by zero".to_string())
    } else {
        Ok(a / b)
    }
}

// Async function (requires async runtime)
async fn fetch_user_data(user_id: u32) -> Result<HashMap<String, String>, String> {
    // Simulated async operation
    tokio::time::sleep(tokio::time::Duration::from_millis(100)).await;

    let mut user_data = HashMap::new();
    user_data.insert("id".to_string(), user_id.to_string());
    user_data.insert("name".to_string(), format!("User {}", user_id));
    user_data.insert("email".to_string(), format!("user{}@example.com", user_id));
    user_data.insert("active".to_string(), "true".to_string());

    Ok(user_data)
}

// Function that's never called
fn never_called() {
    println!("This function is never called");
}

// Function with panic (should use Result)
fn bad_function(x: i32) -> String {
    if x < 0 {
        panic!("This should not panic!"); // Should return Result instead
    }
    format!("Value: {}", x)
}

// File operations with potential issues
fn write_sample_file() -> io::Result<()> {
    let mut file = File::create("sample.txt")?;

    writeln!(file, "Sample Rust output")?;
    writeln!(file, "Generated at: {:?}", SystemTime::now())?;

    // Missing explicit flush
    // file.flush()?;

    Ok(())
}

// Error handling with custom error type
#[derive(Debug)]
enum AppError {
    IoError(io::Error),
    ParseError(String),
    ValidationError(String),
}

impl From<io::Error> for AppError {
    fn from(error: io::Error) -> Self {
        AppError::IoError(error)
    }
}

impl std::fmt::Display for AppError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            AppError::IoError(e) => write!(f, "IO Error: {}", e),
            AppError::ParseError(msg) => write!(f, "Parse Error: {}", msg),
            AppError::ValidationError(msg) => write!(f, "Validation Error: {}", msg),
        }
    }
}

// Function returning custom error
fn validate_person(person: &Person) -> Result<(), AppError> {
    if !person.validate() {
        return Err(AppError::ValidationError(
            "Invalid person data".to_string()
        ));
    }
    Ok(())
}

// Main function with potential issues
fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Create people
    let names = vec![
        "Alice".to_string(),
        "Bob".to_string(),
        "Charlie".to_string(),
    ];

    let people = create_people(names);

    for person in &people {
        println!("{}", person.greet(None));

        match person.process() {
            Ok(result) => println!("Process result: {}", result),
            Err(e) => println!("Process error: {}", e),
        }

        // Validate person
        if let Err(e) = validate_person(person) {
            println!("Validation error: {}", e);
        }
    }

    // Test division
    match divide(10.0, 2.0) {
        Ok(result) => println!("Division result: {}", result),
        Err(e) => println!("Division error: {}", e),
    }

    match divide(10.0, 0.0) {
        Ok(result) => println!("Division result: {}", result),
        Err(e) => println!("Division error: {}", e),
    }

    // Test generic function
    let wrapped_name = wrap_in_option("Test Name");
    println!("Wrapped name: {:?}", wrapped_name);

    // Write file
    write_sample_file()?;

    // HashMap operations
    let mut config = HashMap::new();
    config.insert("api_url".to_string(), API_URL.to_string());
    config.insert("timeout".to_string(), TIMEOUT.to_string());
    config.insert("retries".to_string(), MAX_RETRIES.to_string());

    for (key, value) in &config {
        println!("Config {}: {}", key, value);
    }

    // Vector operations
    let numbers: Vec<i32> = (1..=10).collect();
    let squares: Vec<i32> = numbers.iter().map(|x| x * x).collect();
    let even_squares: Vec<i32> = squares.iter().filter(|x| x % 2 == 0).copied().collect();

    println!("Even squares: {:?}", even_squares);

    // Unused variable in main
    let main_unused = "This is not used";

    // Complex expression that should be split
    let result = if people.len() > 0 && people[0].age > 18 && people[0].email.is_some() {
        format!("First person is valid: {}", people[0].name)
    } else {
        "First person is invalid".to_string()
    };
    println!("{}", result);

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_person_creation() {
        let person = Person::new("Test".to_string(), 25, Some("test@example.com".to_string()));
        assert_eq!(person.name, "Test");
        assert_eq!(person.age, 25);
    }

    #[test]
    fn test_divide() {
        assert_eq!(divide(10.0, 2.0).unwrap(), 5.0);
        assert!(divide(10.0, 0.0).is_err());
    }
}
