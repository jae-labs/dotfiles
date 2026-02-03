package main

import (
	"fmt"
	"os"
	"strings"
	"time"
	// Unused import
	// Unused import
)

// Sample Go code with various issues for testing
type Person struct {
	Name    string
	Age     int
	Email   string
	Address string
	// Missing comma here
	Phone string // Added field without proper comma handling
}

func (p Person) String() string {
	return fmt.Sprintf("Person{Name: %s, Age: %d}", p.Name, p.Age)
}

func NewPerson(name string, age int) *Person {
	return &Person{
		Name: name,
		Age:  age,
	}
}

func (p *Person) Greet() {
	fmt.Printf("Hello, %s! You are %d years old.\n", p.Name, p.Age)
}

func processPeople(people []Person) {
	for _, person := range people {
		if person.Age > 18 {
			person.Greet() // This won't work because person is a copy, not pointer
		}
	}

	// Unused variable
	unused := "This is not used"
	anotherUnused := 42 // Another unused variable

	// Unused function parameter
	processWithUnusedParam := func(data string, unusedParam int) {
		fmt.Println("Processing:", data)
	}
	processWithUnusedParam("test", 123)
}

func main() {
	// Create some people with potential issues
	people := []Person{
		{Name: "Alice", Age: 25, Email: "alice@example.com"},
		{Name: "Bob", Age: 17, Email: "bob@example.com"},
		{Name: "Charlie", Age: 30, Email: "charlie@example.com"},
	}

	processPeople(people)

	// String manipulation with potential issues
	text := "Hello, World!"
	upper := strings.ToUpper(text)
	fmt.Println("Uppercase:", upper)

	// Time handling
	now := time.Now()
	fmt.Println("Current time:", now.Format(time.RFC3339))

	// File operations without proper error handling
	data := []byte("Sample data")
	err := os.WriteFile("sample.txt", data, 0644)
	if err != nil {
		fmt.Printf("Error writing file: %v\n", err)
	}

	// Error handling pattern with potential issues
	file, err := os.Open("sample.txt")
	if err != nil {
		fmt.Printf("Error opening file: %v\n", err)
		return
	}
	defer file.Close()

	// Unused variable from file operation
	fileInfo, _ := file.Stat()
	_ = fileInfo // Unused but marked as used

	// Naked return (should be avoided in non-short functions)
	result := someFunction()
	fmt.Println("Result:", result)
}

// Function with naked return
func someFunction() (string, error) {
	return "success", nil
}
