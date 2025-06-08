# Authentication API

This document describes the authentication endpoints for the Rago Meditation App.

## Base URL
All API endpoints are relative to the base URL: `https://api.ragomeditation.com/v1`

## Table of Contents
- [Register User](#register-user)
- [Login](#login)
- [Logout](#logout)
- [Refresh Token](#refresh-token)
- [Forgot Password](#forgot-password)
- [Reset Password](#reset-password)

## Register User

Create a new user account.

```http
POST /auth/register
```

### Request Body

| Parameter   | Type   | Required | Description                |
|-------------|--------|----------|----------------------------|
| email       | string | Yes      | User's email address       |
| password    | string | Yes      | User's password (min 8 chars) |
| name        | string | Yes      | User's full name           |


### Example Request

```json
{
  "email": "user@example.com",
  "password": "securePassword123",
  "name": "John Doe"
}
```

### Responses

#### 201 Created
```json
{
  "message": "User registered successfully",
  "user": {
    "id": "507f1f77bcf86cd799439011",
    "name": "John Doe",
    "email": "user@example.com",
    "createdAt": "2025-06-08T10:00:00.000Z"
  }
}
```

#### 400 Bad Request
```json
{
  "error": "Validation Error",
  "message": "Email is required"
}
```

## Login

Authenticate a user and return access and refresh tokens.

```http
POST /auth/login
```

### Request Body

| Parameter | Type   | Required | Description         |
|-----------|--------|----------|---------------------|
| email     | string | Yes      | User's email        |
| password  | string | Yes      | User's password     |


### Example Request

```json
{
  "email": "user@example.com",
  "password": "securePassword123"
}
```

### Responses

#### 200 OK
Sets HTTP-only cookies with the following attributes:
- `access_token`: JWT access token
- `refresh_token`: JWT refresh token

```json
{
  "message": "Login successful",
  "user": {
    "id": "507f1f77bcf86cd799439011",
    "name": "John Doe",
    "email": "user@example.com"
  }
}
```

## Logout

Invalidate the current user's session.

```http
POST /auth/logout
```

### Headers
- `Authorization: Bearer <access_token>`

### Responses

#### 200 OK
```json
{
  "message": "Logged out successfully"
}
```

## Refresh Token

Refresh the access token using a valid refresh token.

```http
POST /auth/refresh-token
```

### Headers
- `Cookie: refresh_token=<refresh_token>`

### Responses

#### 200 OK
Sets a new HTTP-only `access_token` cookie.

```json
{
  "message": "Token refreshed successfully"
}
```

## Forgot Password

Request a password reset email.

```http
POST /auth/forgot-password
```

### Request Body

| Parameter | Type   | Required | Description        |
|-----------|--------|----------|--------------------|
| email     | string | Yes      | User's email       |


### Example Request

```json
{
  "email": "user@example.com"
}
```

### Responses

#### 200 OK
```json
{
  "message": "Password reset email sent"
}
```

## Reset Password

Reset user's password using a valid reset token.

```http
POST /auth/reset-password
```

### Request Body

| Parameter       | Type   | Required | Description           |
|-----------------|--------|----------|-----------------------|
| token           | string | Yes      | Password reset token  |
| password        | string | Yes      | New password          |
| confirmPassword | string | Yes      | Confirm new password  |


### Example Request

```json
{
  "token": "valid-reset-token",
  "password": "newSecurePassword123",
  "confirmPassword": "newSecurePassword123"
}
```

### Responses

#### 200 OK
```json
{
  "message": "Password reset successful"
}
```

## Error Responses

### 401 Unauthorized
```json
{
  "error": "Unauthorized",
  "message": "Invalid or expired token"
}
```

### 403 Forbidden
```json
{
  "error": "Forbidden",
  "message": "Insufficient permissions"
}
```

### 404 Not Found
```json
{
  "error": "Not Found",
  "message": "User not found"
}
```

### 500 Internal Server Error
```json
{
  "error": "Internal Server Error",
  "message": "An unexpected error occurred"
}
```

## Rate Limiting
- All authentication endpoints are rate limited to 100 requests per 15 minutes per IP address.
- Exceeding the rate limit will result in a `429 Too Many Requests` response.

## Security Considerations
- Always use HTTPS in production
- Passwords are hashed using bcrypt before storage
- Access tokens expire after 15 minutes
- Refresh tokens expire after 7 days
- Implement proper CORS policies on the server
- Use secure and httpOnly flags for cookies
- Implement CSRF protection for web clients
