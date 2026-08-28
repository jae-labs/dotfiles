// Sample JavaScript file with various issues for testing

// Variables with potential issues
let name = "World";
const count = 5;
var unusedVar = "This variable is not used";
let anotherUnused = 42;
var globalVar = "Should use const/let";

// Function with potential issues
function greet(name) {
    console.log(`Hello, ${name}!`);
    console.log(`Count is: ${count}`);

    // Use of undeclared variable
    console.log(undeclaredVar);

    // Missing semicolon
    let message = "This message is missing a semicolon"

    // Unused parameter
    const unusedParam = (param1, param2, param3) => {
        return param1;
    };

    return message;
}

// Arrow function with potential issues
const processData = (data) => {
    return data.map(item => {
        return {
            id: item.id,
            name: item.name.toUpperCase(),
            processed: true
        };
    });
};

// Object with potential issues
const config = {
    apiUrl: 'https://api.example.com',
    timeout: 5000,
    retries: 3,
    // Trailing comma
};

// Object with duplicate keys
const badConfig = {
    url: 'https://example.com',
    timeout: 3000,
    url: 'https://backup.com', // Duplicate key
};

// Array with potential issues
const items = [1, 2, 3, 4, 5];
const mixedArray = ['string', 42, true, null, undefined, { key: 'value' }];
const emptyArray = [];

// Function that's never called
const neverCalled = () => {
    console.log('This will never be called');
};

// Conditional with potential issues
if (items.length > 3) {
    console.log('Array has more than 3 items');
} else if (items.length === 3) {
    console.log('Array has exactly 3 items');
} else {
    console.log('Array has fewer than 3 items');
}

// Loop with potential issues
for (let i = 0; i < items.length; i++) {
    console.log(`Item ${i}: ${items[i]}`);
}

// Promise with potential issues
const fetchData = () => {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            if (Math.random() > 0.5) {
                resolve({ data: 'Success', timestamp: Date.now() });
            } else {
                reject(new Error('Random failure'));
            }
        }, 1000);
    });
};

// Async/await with potential issues
const main = async () => {
    try {
        const result = await fetchData();
        console.log('Data received:', result);

        const processed = processData([{ id: 1, name: 'test' }]);
        console.log('Processed data:', processed);

        greet(name);

        // Unhandled promise rejection
        fetchData().then(data => {
            console.log('Unhandled:', data);
        });

    } catch (error) {
        console.error('Error:', error.message);
        // Missing rethrow or proper error handling
    }

    // Missing return statement
};

// Export with potential issues
module.exports = {
    greet,
    processData,
    fetchData,
    config,
    unusedExport: function() { return 'never used'; },
};

// Call main function
main();

// Global variable pollution
GLOBAL_VAR = 'This pollutes global scope';
window.anotherGlobal = 'Another global variable';

// Console statements in production code
console.log('Debug info');
console.warn('Warning message');
console.error('Error message');

// Eval usage (security issue)
const evilEval = eval('console.log("Eval is evil")');

// setTimeout with string (security issue)
setTimeout('console.log("Bad setTimeout")', 1000);
