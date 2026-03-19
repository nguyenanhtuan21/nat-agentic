---
name: nat-defaults
description: Default coding standards and conventions for Nat Agentic
version: 1.0.0
---

# Nat Defaults Skill

This skill provides default coding standards and conventions used across Nat Agentic projects.

## Code Style

### General Principles

- **Clarity over cleverness**: Write readable, maintainable code
- **Explicit is better than implicit**: Be clear about types and intentions
- **DRY**: Don't repeat yourself, but don't over-abstract
- **Small functions**: Each function should do one thing well

### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Variables | camelCase | `userName`, `itemCount` |
| Constants | SCREAMING_SNAKE_CASE | `MAX_RETRIES`, `API_BASE_URL` |
| Functions | camelCase | `getUserData()`, `calculateTotal()` |
| Classes | PascalCase | `UserService`, `HttpClient` |
| Files | kebab-case | `user-service.ts`, `http-client.js` |
| Directories | kebab-case | `user-management/`, `api-client/` |

### TypeScript/JavaScript

```typescript
// Prefer interfaces for object shapes
interface User {
  id: string;
  name: string;
  email: string;
}

// Use const assertions for immutability
const ROLES = ['admin', 'user', 'guest'] as const;

// Prefer async/await over .then()
async function fetchUser(id: string): Promise<User> {
  const response = await api.get(`/users/${id}`);
  return response.data;
}

// Use optional chaining and nullish coalescing
const name = user?.profile?.displayName ?? 'Anonymous';
```

### Python

```python
# Use type hints
from typing import Optional, List

def get_user(user_id: str) -> Optional[User]:
    ...

# List comprehensions for simple transformations
names = [user.name for user in users if user.is_active]

# Context managers for resources
with open('file.txt', 'r') as f:
    content = f.read()
```

## Git Commit Messages

Format: `<type>(<scope>): <description>`

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting
- `refactor`: Code restructuring
- `test`: Adding tests
- `chore`: Maintenance

Example:
```
feat(auth): add OAuth2 login support

- Implement Google OAuth provider
- Add session management
- Update login UI

Closes #123
```

## File Organization

```
project/
├── src/
│   ├── components/     # UI components
│   ├── services/       # Business logic
│   ├── utils/          # Helper functions
│   ├── types/          # TypeScript types
│   └── index.ts        # Entry point
├── tests/
│   ├── unit/
│   └── integration/
├── docs/
└── config/
```

## Error Handling

```typescript
// Create custom error types
class ValidationError extends Error {
  constructor(message: string, public field: string) {
    super(message);
    this.name = 'ValidationError';
  }
}

// Use try/catch with specific handling
try {
  await processPayment(order);
} catch (error) {
  if (error instanceof PaymentDeclinedError) {
    // Handle declined payment
  } else {
    // Log unexpected errors
    logger.error('Payment processing failed', { error, orderId: order.id });
    throw error;
  }
}
```

## Security Practices

- Never commit secrets or API keys
- Validate all user input
- Use parameterized queries for database access
- Implement proper authentication and authorization
- Keep dependencies updated
