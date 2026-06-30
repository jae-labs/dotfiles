#!/bin/bash

# Sample shell script with various issues for testing

# Variables with potential issues
name="World"
count=5
unused_var="This variable is not used"
another_unused=42

# Global variable (should use local)
global_var="This should be local"

# Function with potential issues
greet() {
    echo "Hello, $name!"
    echo "Count is: $count"

    # Use of unquoted variables
    ls $HOME

    # Command substitution
    current_date=$(date)
    echo "Current date: $current_date"

    # Unused parameter
    local unused_param=$1

    # Missing local keyword
    message="This should be local"

    return $message # Should return number, not string
}

# Loop with potential issues
for i in 1 2 3 4 5; do
    echo "Iteration $i"

    # Use of $* instead of "$@"
    for arg in $*; do
        echo "Arg: $arg"
    done

    # Unused variable in loop
    loop_unused="This is not used"
done

# Conditional with potential issues
if [ $count -gt 3 ]; then
    echo "Count is greater than 3"
fi

# Array usage with issues
files=(file1.txt file2.txt file3.txt)
for file in ${files[@]}; do
    echo "Processing: $file"
done

# Command with potential issues
grep -r "pattern" /path/to/search | head -n 10

# Function call
greet "$@"

# Function that's never called
never_called() {
    echo "This function is never called"
}

# Complex command that should be split
if [ -f "$1" ] && [ "$1" != "" ] && [ "${1##*.}" = "sh" ] || [ "${1##*.}" = "bash" ]; then
    echo "Shell script detected"
fi

# Eval usage (security issue)
eval 'echo "Eval is evil"'

# Subshell issues
(
    cd /tmp
    ls -la
    # Changes directory but doesn't affect parent
)

# Error handling issues
rm -rf /some/path  # No check if path exists
mkdir -p /some/other/path  # No error handling

# Use of backticks instead of $()
result=`ls -la | wc -l`
echo "Files: $result"

# Missing quotes around variables
echo "Processing file: $filename"  # filename might contain spaces

# Use of [ instead of [[
if [ "$name" = "World" ]; then
    echo "Hello World"
fi

# Global variable pollution
export GLOBAL_POLLUTION="This pollutes environment"

# Unused function with side effects
unused_function() {
    local temp_file="/tmp/temp_$$"
    echo "temp data" > "$temp_file"
    # File not cleaned up
}

# Complex logic that should be simplified
if [ -n "$1" ]; then
    if [ -f "$1" ]; then
        if [ -r "$1" ]; then
            if [ -s "$1" ]; then
                echo "File exists, is readable, and is not empty"
            else
                echo "File exists but is empty"
            fi
        else
            echo "File exists but is not readable"
        fi
    else
        echo "File does not exist"
    fi
else
    echo "No filename provided"
fi
