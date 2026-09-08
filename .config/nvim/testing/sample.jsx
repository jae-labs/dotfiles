// Sample React JSX file for testing

import React, { useState, useEffect, useCallback } from 'react';
import PropTypes from 'prop-types';

// Component with potential issues
const UserCard = ({ user, onUpdate, onDelete }) => {
  const [isEditing, setIsEditing] = useState(false);
  const [formData, setFormData] = useState({
    name: user.name,
    email: user.email,
    age: user.age
  });
  const [errors, setErrors] = useState({});

  // Unused variable
  const unusedVar = "This is not used";

  // Effect with potential issues
  useEffect(() => {
    console.log('UserCard mounted');

    // Missing dependency array cleanup
    const timer = setTimeout(() => {
      console.log('Timer executed');
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

  // Callback with potential issues
  const handleSubmit = useCallback((e) => {
    e.preventDefault();

    // Validation with potential issues
    const newErrors = {};
    if (!formData.name.trim()) {
      newErrors.name = 'Name is required';
    }
    if (!formData.email.includes('@')) {
      newErrors.email = 'Invalid email';
    }
    if (formData.age < 0) {
      newErrors.age = 'Age must be positive';
    }

    if (Object.keys(newErrors).length > 0) {
      setErrors(newErrors);
      return;
    }

    onUpdate(user.id, formData);
    setIsEditing(false);
    setErrors({});
  }, [formData, user.id, onUpdate]);

  // Callback that changes on every render
  const handleChange = useCallback((value) => {
    console.log('Handling change:', value);
    return value.toUpperCase();
  }); // Missing dependencies

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));

    // Clear error for this field
    if (errors[name]) {
      setErrors(prev => ({
        ...prev,
        [name]: ''
      }));
    }
  };

  const handleDelete = () => {
    if (window.confirm(`Are you sure you want to delete ${user.name}?`)) {
      onDelete(user.id);
    }
  };

  // Inline styles (potential issue)
  const cardStyle = {
    border: '1px solid #ddd',
    borderRadius: '8px',
    padding: '16px',
    margin: '8px',
    backgroundColor: '#fff',
    boxShadow: '0 2px 4px rgba(0,0,0,0.1)'
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
            <button type="submit" style={{ marginRight: '8px' }}>
              Save
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
      <h3>{user.name}</h3>
      <p>Email: {user.email}</p>
      <p>Age: {user.age}</p>
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

// PropTypes with potential issues
UserCard.propTypes = {
  user: PropTypes.shape({
    id: PropTypes.number.isRequired,
    name: PropTypes.string.isRequired,
    email: PropTypes.string.isRequired,
    age: PropTypes.number.isRequired
  }).isRequired,
  onUpdate: PropTypes.func.isRequired,
  onDelete: PropTypes.func.isRequired
};

// Higher-order component with potential issues
const withLogging = (WrappedComponent) => {
  return (props) => {
    console.log(`${WrappedComponent.name} props:`, props);

    // Missing error boundary
    return <WrappedComponent {...props} />;
  };
};

// Component with hooks rule violations
const BadHooksComponent = () => {
  const [count, setCount] = useState(0);

  // Hook in conditional - this is a React rules violation
  if (count > 0) {
    useEffect(() => {
      console.log('Count is greater than 0');
    });
  }

  // Hook in loop - another violation
  for (let i = 0; i < count; i++) {
    const [loopState, setLoopState] = useState(i);
  }

  return <div>Bad hooks: {count}</div>;
};

// Custom hook with potential issues
const useUserData = (userId) => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchUser = async () => {
      try {
        setLoading(true);
        // Simulated API call
        const response = await fetch(`/api/users/${userId}`);
        if (!response.ok) {
          throw new Error('Failed to fetch user');
        }
        const userData = await response.json();
        setUser(userData);
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    if (userId) {
      fetchUser();
    }
  }, [userId]);

  return { user, loading, error };
};

// Main App component
const App = () => {
  const [users, setUsers] = useState([
    { id: 1, name: 'John Doe', email: 'john@example.com', age: 30 },
    { id: 2, name: 'Jane Smith', email: 'jane@example.com', age: 25 },
    { id: 3, name: 'Bob Wilson', email: 'bob@example.com', age: 35 }
  ]);

  const handleUpdateUser = useCallback((userId, updatedData) => {
    setUsers(prev => prev.map(user =>
      user.id === userId ? { ...user, ...updatedData } : user
    ));
  }, []);

  const handleDeleteUser = useCallback((userId) => {
    setUsers(prev => prev.filter(user => user.id !== userId));
  }, []);

  // Missing key in map (intentional for testing)
  return (
    <div style={{ padding: '20px' }}>
      <h1>User Management</h1>
      {users.map(user => (
        <UserCard
          key={user.id}
          user={user}
          onUpdate={handleUpdateUser}
          onDelete={handleDeleteUser}
        />
      ))}

      {/* Accessibility issues */}
      <button onClick={() => alert('Clicked!')}>
        Click me without aria-label
      </button>

      <img src="logo.png" />

      <div role="button" tabIndex="0">
        Fake button
      </div>

      {/* Invalid JSX structure */}
      <div>
        <span>Invalid nesting</span>
        <p>
          <div>Div inside paragraph</div>
        </p>
      </div>
    </div>
  );
};

export default App;
export { UserCard, withLogging, useUserData };
