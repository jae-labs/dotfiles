# Sample Ruby file with various issues for testing
class SampleClass
  def initialize(name)
    @name = name
    # Unused instance variable
    @unused_var = "This is not used"
  end

  def greet
    puts "Hello, #{@name}!"
    # Use of global variable
    $global_var = "This pollutes global scope"
  end

  def self.class_method
    "This is a class method"
  end

  # Method with too many parameters
  def method_with_many_params(param1, param2, param3, param4, param5, param6, param7, param8)
    return param1
  end

  private

  def helper_method
    "Helper method with extra spaces   "
    # Missing return statement
    "should return something"
  end

  # Unused private method
  def unused_private_method
    "This is never called"
  end
end

# Instance with some linting issues
instance = SampleClass.new("World")
instance.greet

# Method chaining with potential issues
result = SampleClass.class_method.upcase.reverse

# Array and hash examples
items = [1, 2, 3, 4, 5]
config = { key: "value", another_key: "another_value", trailing_comma: true, }

# Hash with duplicate keys (last one wins)
bad_hash = {
  key: "first_value",
  key: "second_value", # Duplicate key
  another_key: "test"
}

# Conditional with multiple lines
if items.length > 3
  puts "Array has more than 3 items"
elsif items.length == 3
  puts "Array has exactly 3 items"
else
  puts "Array has fewer than 3 items"
end

# Unused variables
unused_var = "This is not used"
another_unused = 42

# Global variable pollution
$another_global = "Global variable pollution"

# Method with side effects
def side_effect_method
  puts "Side effect"
  # No return value
end

# Class variable without proper initialization
@@class_var = nil

# Constant in wrong scope
BAD_CONSTANT = "Should be uppercase but in wrong place"

# Rescue without exception type
begin
  # Some code that might raise an exception
  raise "Error"
rescue
  puts "Caught exception without specifying type"
end

# Eval usage (security issue)
eval('puts "Eval is evil"')

# Method with complex logic that should be refactored
def complex_method(data)
  if data
    if data.is_a?(Array)
      if data.length > 0
        if data.first.is_a?(String)
          if data.first.length > 5
            return "too nested"
          end
        end
      end
    endn  end
  return "default"
end
