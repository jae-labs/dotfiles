// Sample React TypeScript file for testing

import React, { useState, useEffect, useCallback, useMemo } from 'react';

// Types with potential issues
interface User {
  id: number;
  name: string;
  email: string;
  age: number;
  createdAt?: Date;
  updatedAt?: Date;
}

interface UserFormData {
  name: string;
  email: string;
  age: string; // Using string instead of number (potential issue)
}

interface UserCardProps {
  user: User;
  onUpdate: (userId: number, data: Partial<User>) => Promise<void>;
  onDelete: (userId: number) => Promise<void>;
}

interface FormErrors {
  name?: string;
  email?: string;
  age?: string;
}

// Component with TypeScript issues
const UserCard: React.FC<UserCardProps> = ({ user, onUpdate, onDelete }) => {
  const [isEditing, setIsEditing] = useState<boolean>(false);
  const [formData, setFormData] = useState<UserFormData>({
    name: user.name,
    email: user.email,
    age: user.age.toString()
  });
  const [errors, setErrors] = useState<FormErrors>({});
  const [isLoading, setIsLoading] = useState<boolean>(false);

  // Unused variable with type annotation
  const unusedVar: string = "This is not used";
  const anotherUnused: number = 42;

  // Effect with dependency issues
  useEffect(() => {
    console.log('UserCard mounted for user:', user.id);

    // Missing dependency array cleanup
    const timer = setTimeout(() => {
      console.log('User data:', formData);
    }, 1000);

    return () => {
      clearTimeout(timer);
    };
  }, [user.id]); // Missing formData dependency

  // Another effect with dependency issues
  useEffect(() => {
    // This effect runs on every render because of missing dependency array
    document.title = `User: ${user.name}`;
  }); // Missing dependency array

  // Memoized value with potential issues
  const userDisplayName = useMemo(() => {
    return `${user.name} (${user.age} years old)`;
  }, [user.name]); // Missing user.age dependency

  // Callback with type issues
  const handleSubmit = useCallback(async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);

    // Validation with type issues
    const newErrors: FormErrors = {};

    if (!formData.name.trim()) {
      newErrors.name = 'Name is required';
    }

    if (!formData.email.includes('@')) {
      newErrors.email = 'Invalid email format';
    }

    const ageNum = parseInt(formData.age);
    if (isNaN(ageNum) || ageNum < 0) {
      newErrors.age = 'Age must be a positive number';
    }

    if (Object.keys(newErrors).length > 0) {
      setErrors(newErrors);
      setIsLoading(false);
      return;
    }

    try {
      await onUpdate(user.id, {
        name: formData.name,
        email: formData.email,
        age: ageNum
      });
      setIsEditing(false);
      setErrors({});
    } catch (error) {
      console.error('Update failed:', error);
      // Type assertion with potential issues
      setErrors({ name: (error as Error).message });
    } finally {
      setIsLoading(false);
    }
  }, [formData, user.id, onUpdate]);

  // Callback that changes on every render
  const handleChange = useCallback((value: string) => {
    console.log('Handling change:', value);
    return value.toUpperCase();
  }); // Missing dependencies

  const handleInputChange = useCallback((e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));

    // Clear error for this field
    if (errors[name as keyof FormErrors]) {
      setErrors(prev => ({
        ...prev,
        [name]: ''
      }));
    }
  }, [errors]);

  const handleDelete = useCallback(async () => {
    if (window.confirm(`Are you sure you want to delete ${user.name}?`)) {
      try {
        await onDelete(user.id);
      } catch (error) {
        console.error('Delete failed:', error);
        // Missing proper error handling
      }
    }
  }, [user.name, user.id, onDelete]);

  // Inline styles with type issues
  const cardStyle: React.CSSProperties = {
    border: '1px solid #ddd',
    borderRadius: '8px',
    padding: '16px',
    margin: '8px',
    backgroundColor: '#fff',
    boxShadow: '0 2px 4px rgba(0,0,0,0.1)'
  };

  // Function with unused parameter
  const unusedFunction = (param1: string, param2: number, param3: boolean): void => {
    console.log(param1);
    // param2 and param3 are unused
  };

  if (isEditing) {
    return (
      <div style={cardStyle}>
        <form onSubmit={handleSubmit}>
          <div style={{ marginBottom: '8px' }}>
            <label style={{ display: 'block', marginBottom: '4px' }}>
              Name:
              <input
                type="text"
                name="name"
                value={formData.name}
                onChange={handleInputChange}
                style={{
                  width: '100%',
                  padding: '4px',
                  border: errors.name ? '1px solid red' : '1px solid #ccc'
                }}
              />
            </label>
            {errors.name && <span style={{ color: 'red' }}>{errors.name}</span>}
          </div>

          <div style={{ marginBottom: '8px' }}>
            <label style={{ display: 'block', marginBottom: '4px' }}>
              Email:
              <input
                type="email"
                name="email"
                value={formData.email}
                onChange={handleInputChange}
                style={{
                  width: '100%',
                  padding: '4px',
                  border: errors.email ? '1px solid red' : '1px solid #ccc'
                }}
              />
            </label>
            {errors.email && <span style={{ color: 'red' }}>{errors.email}</span>}
          </div>

          <div style={{ marginBottom: '8px' }}>
            <label style={{ display: 'block', marginBottom: '4px' }}>
              Age:
              <input
                type="number"
                name="age"
                value={formData.age}
                onChange={handleInputChange}
                style={{
                  width: '100%',
                  padding: '4px',
                  border: errors.age ? '1px solid red' : '1px solid #ccc'
                }}
              />
            </label>
            {errors.age && <span style={{ color: 'red' }}>{errors.age}</span>}
          </div>

          <div>
            <button type="submit" disabled={isLoading} style={{ marginRight: '8px' }}>
              {isLoading ? 'Saving...' : 'Save'}
            </button>
            <button type="button" onClick={() => setIsEditing(false)}>
              Cancel
            </button>
          </div>
        </form>
      </div>
    );
  }

  return (
    <div style={cardStyle}>
      <h3>{userDisplayName}</h3>
      <p>Email: {user.email}</p>
      <p>Age: {user.age}</p>
      {user.createdAt && (
        <p>Created: {user.createdAt.toLocaleDateString()}</p>
      )}
      <div style={{ marginTop: '12px' }}>
        <button
          onClick={() => setIsEditing(true)}
          style={{ marginRight: '8px' }}
        >
          Edit
        </button>
        <button
          onClick={handleDelete}
          style={{ backgroundColor: '#dc3545', color: 'white' }}
        >
          Delete
        </button>
      </div>
    </div>
  );
};

// Generic component with type issues
interface ListProps<T> {
  items: T[];
  renderItem: (item: T, index: number) => React.ReactNode;
  keyExtractor: (item: T) => string | number;
}

const List = <T,>({ items, renderItem, keyExtractor }: ListProps<T>) => {
  return (
    <div>
      {items.map((item, index) => (
        <div key={keyExtractor(item)}>
          {renderItem(item, index)}
        </div>
      ))}
    </div>
  );
};

// Custom hook with type issues
const useUserData = (userId: number | null) => {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchUser = async () => {
      if (!userId) {
        setUser(null);
        setLoading(false);
        return;
      }

      try {
        setLoading(true);
        // Simulated API call
        const response = await fetch(`/api/users/${userId}`);
        if (!response.ok) {
          throw new Error('Failed to fetch user');
        }
        const userData: User = await response.json();
        setUser(userData);
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Unknown error');
      } finally {
        setLoading(false);
      }
    };

    fetchUser();
  }, [userId]);

  return { user, loading, error };
};

// Context with type issues
interface UserContextType {
  users: User[];
  currentUser: User | null;
  updateUser: (userId: number, data: Partial<User>) => Promise<void>;
  deleteUser: (userId: number) => Promise<void>;
  setCurrentUser: (user: User | null) => void;
}

const UserContext = React.createContext<UserContextType | undefined>(undefined);

// Provider component
const UserProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [users, setUsers] = useState<User[]>([]);
  const [currentUser, setCurrentUser] = useState<User | null>(null);

  const updateUser = useCallback(async (userId: number, data: Partial<User>) => {
    // Simulated API call
    await new Promise(resolve => setTimeout(resolve, 500));
    setUsers(prev => prev.map(user =>
      user.id === userId ? { ...user, ...data } : user
    ));
  }, []);

  const deleteUser = useCallback(async (userId: number) => {
    // Simulated API call
    await new Promise(resolve => setTimeout(resolve, 500));
    setUsers(prev => prev.filter(user => user.id !== userId));
    if (currentUser?.id === userId) {
      setCurrentUser(null);
    }
  }, [currentUser]);

  const contextValue: UserContextType = useMemo(() => ({
    users,
    currentUser,
    updateUser,
    deleteUser,
    setCurrentUser
  }), [users, currentUser, updateUser, deleteUser]);

  return (
    <UserContext.Provider value={contextValue}>
      {children}
    </UserContext.Provider>
  );
};

// Hook to use context
const useUserContext = (): UserContextType => {
  const context = React.useContext(UserContext);
  if (context === undefined) {
    throw new Error('useUserContext must be used within a UserProvider');
  }
  return context;
};

// Main App component
const App: React.FC = () => {
  const { users, updateUser, deleteUser } = useUserContext();

  // Unused variable
  const appUnused = "This is not used";

  // Complex expression that should be split
  const userCount = users.length > 0 ? users.filter(u => u.age > 18).length : 0;

  return (
    <div style={{ padding: '20px' }}>
      <h1>User Management System</h1>
      <List
        items={users}
        renderItem={(user) => (
          <UserCard
            key={user.id}
            user={user}
            onUpdate={updateUser}
            onDelete={deleteUser}
          />
        )}
        keyExtractor={(user) => user.id}
      />

      {/* Accessibility issues */}
      <button onClick={() => alert('Clicked!')}>
        Click me without aria-label
      </button>

      <img src="logo.png" />

      <div role="button" tabIndex={0}>
        Fake button
      </div>

      {/* Invalid JSX structure */}
      <div>
        <span>Invalid nesting</span>
        <p>
          <div>Div inside paragraph</div>
        </p>
      </div>

      {/* Missing key in map */}
      {users.map(user => (
        <div key={user.id}>
          <span>{user.name}</span>
        </div>
      ))}

      {/* Console statements in production */}
      {console.log('User count:', userCount)}
      {console.warn('Warning: Some users are underage')}
    </div>
  );
};

// Export with potential issues
export default App;
export { UserCard, List, useBadHook, useUserContext, UserProvider, useUserContext };
export type { User, UserFormData, UserCardProps, BadHooksComponent };

// Global variable pollution
declare global var appGlobal: string;
appGlobal = 'This pollutes global scope';

// Unused export
export const unusedExport = 'This is never used';

// Type alias with issues
type BadType = string | number | boolean | object | Function | undefined | null;

// Interface with unused properties
interface UnusedInterface {
  prop1: string;
  prop2: number;
  prop3: boolean;
  prop4: Array<string>;
  prop5: { [key: string]: any };
}

// Enum with potential issues
enum BadEnum {
  VALUE1 = 'value1',
  VALUE2 = 'value2',
  // Missing semicolon
  VALUE3 = 'value3'
}
