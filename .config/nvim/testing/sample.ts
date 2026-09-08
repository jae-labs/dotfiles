// Sample TypeScript file with various issues for testing

// Interface with potential issues
interface Person {
    name: string;
    age: number;
    email?: string;
    address?: string;
    // Missing semicolon
}

// Type with potential issues
type Status = 'active' | 'inactive' | 'pending';

// Interface with unused property
interface UnusedInterface {
    prop1: string;
    prop2: number;
    prop3: boolean;
}

// Class with potential issues
class User implements Person {
    name: string;
    age: number;
    email: string;
    private status: Status;

    // Unused property
    private unusedProperty: string = "This is not used";

    constructor(name: string, age: number, email: string) {
        this.name = name;
        this.age = age;
        this.email = email;
        this.status = 'active';
    }

    // Method with potential type issues
    greet(greeting?: string): string {
        const message = greeting || 'Hello';
        return `${message}, ${this.name}!`;
    }

    // Method with any type
    processData(data: any): any {
        return data.map((item: any) => ({
            ...item,
            processed: true,
            processedAt: new Date()
        }));
    }

    // Method with unused parameter
    methodWithUnusedParam(param1: string, param2: number, param3: boolean): void {
        console.log(param1);
        // param2 and param3 are unused
    }

    // Getter with potential issues
    get userInfo(): string {
        return `${this.name} (${this.age}) - ${this.email}`;
    }
}

// Function with potential issues
function createUser(name: string, age: number, email?: string): User {
    return new User(name, age, email || 'default@example.com');
}

// Function with unused type parameter
function unusedGeneric<T>(value: T): T {
    return value;
}

// Generic function with potential issues
function wrapInArray<T>(value: T): T[] {
    return [value];
}

// Function with complex return type that could be simplified
function complexFunction(param1: string, param2: number, param3: boolean): { success: boolean; data: { message: string; timestamp: number; value: string; } | null; error: string | null } {
    if (param1 && param2 > 0 && param3) {
        return {
            success: true,
            data: {
                message: param1,
                timestamp: Date.now(),
                value: param2.toString()
            },
            error: null
        };
    } else {
        return {
            success: false,
            data: null,
            error: 'Invalid parameters'
        };
    }
}

// Enum with potential issues
enum UserRole {
    ADMIN = 'admin',
    USER = 'user',
    GUEST = 'guest'
}

// Constants with potential issues
const API_URL = 'https://api.example.com';
const MAX_RETRIES = 3;
const TIMEOUT = 5000;

// Object with type issues
const config: Record<string, unknown> = {
    apiUrl: API_URL,
    timeout: TIMEOUT,
    retries: MAX_RETRIES,
    enableLogging: true,
    // Trailing comma
};

// Object with implicit any type
const badConfig = {
    url: 'https://example.com',
    timeout: 3000,
    // No type annotation
};

// Array with type issues
const users: User[] = [
    new User('Alice', 25, 'alice@example.com'),
    new User('Bob', 17, 'bob@example.com'),
    new User('Charlie', 30, 'charlie@example.com'),
];

// Array with mixed types (should be avoided)
const mixedArray: (string | number | boolean)[] = ['string', 42, true, null, undefined];

// Unused variables
const unusedVar = "This is not used";
const anotherUnused = 42;
const unusedFunction = () => {
    console.log('Never called');
};

// Async function with potential issues
const fetchUserData = async (userId: number): Promise<Person> => {
    try {
        const response = await fetch(`${API_URL}/users/${userId}`);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        const data = await response.json();
        return data;
    } catch (error) {
        console.error('Error fetching user data:', error);
        throw error;
        // Missing proper error type handling
    }
};

// Union type usage
const printStatus = (status: Status): void => {
    console.log(`User status: ${status.toUpperCase()}`);
};

// Type guard function
const isString = (value: unknown): value is string => {
    return typeof value === 'string';
};

// Function with type assertion issues
const badTypeAssertion = (value: unknown): string => {
    return (value as string).toUpperCase(); // Unsafe type assertion
};

// Main function with potential issues
const main = async (): Promise<void> => {
    const user = createUser('John Doe', 30);
    console.log(user.greet('Hi there'));
    console.log(user.userInfo);

    const wrappedUsers = wrapInArray(users);
    console.log(`Wrapped ${wrappedUsers.length} users`);

    try {
        const userData = await fetchUserData(1);
        console.log('Fetched user:', userData);
        printStatus('active');
    } catch (error) {
        if (error instanceof Error) {
            console.error('Failed to fetch user:', error.message);
        }
        // Missing proper error handling for non-Error types
    }

    // Type assertion with potential issues
    const unknownValue: unknown = 'test';
    if (isString(unknownValue)) {
        console.log('String value:', unknownValue.toUpperCase());
    }

    // Unused variable in main
    const mainUnused = "This is not used";

    // Complex expression that should be split
    const result = users.length > 0 && users[0].age > 18 && users[0].email.includes('@') ? users[0].name : 'No valid user';
    console.log('Result:', result);
};

// Export with potential issues
export {
    User,
    Person,
    Status,
    UserRole,
    createUser,
    fetchUserData,
    config,
    // Exporting unused function
    unusedFunction,
    // Exporting type assertion function
    badTypeAssertion,
};

// Call main function
main().catch(console.error);

// Global variable pollution
declare global var globalVar: string;
globalVar = 'This pollutes global scope';

// Console statements in production code
console.log('Debug info');
console.warn('Warning message');
console.error('Error message');

// Eval usage (security issue)
const evilEval = eval('console.log("Eval is evil")');

// Type alias with issues
type BadType = string | number | boolean | object | Function | undefined | null;
