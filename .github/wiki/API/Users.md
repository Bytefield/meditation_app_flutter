# Users API

This document describes the API endpoints for managing user accounts and profiles in the Rago Meditation App.

## Base URL
All API endpoints are relative to the base URL: `https://api.ragomeditation.com/v1`

## Table of Contents
- [Get Current User](#get-current-user)
- [Update User Profile](#update-user-profile)
- [Change Password](#change-password)
- [Upload Profile Picture](#upload-profile-picture)
- [Delete Account](#delete-account)
- [Get User Statistics](#get-user-statistics)
- [Get User Preferences](#get-user-preferences)
- [Update User Preferences](#update-user-preferences)

## Authentication
All endpoints require authentication. Include the JWT token in the `Authorization` header:
```
Authorization: Bearer <access_token>
```

## Get Current User

Retrieve the currently authenticated user's profile information.

```http
GET /users/me
```

### Responses

#### 200 OK
```json
{
  "id": "507f1f77bcf86cd799439011",
  "name": "John Doe",
  "email": "john.doe@example.com",
  "avatarUrl": "https://example.com/avatars/john-doe.jpg",
  "createdAt": "2025-01-01T00:00:00.000Z",
  "updatedAt": "2025-06-01T12:00:00.000Z",
  "lastLogin": "2025-06-08T10:30:00.000Z",
  "preferences": {
    "theme": "system",
    "notifications": {
      "email": true,
      "push": true,
      "reminders": true
    },
    "playback": {
      "defaultVolume": 70,
      "skipSilence": true
    }
  },
  "stats": {
    "totalSessions": 42,
    "totalMinutes": 1260,
    "currentStreak": 7,
    "longestStreak": 30
  }
}
```

## Update User Profile

Update the current user's profile information.

```http
PATCH /users/me
```

### Request Body

| Parameter | Type   | Required | Description                |
|-----------|--------|----------|----------------------------|
| name      | string | No       | User's full name           |
| email     | string | No       | User's email address       |
| bio       | string | No       | Short biography            |
| location  | string | No       | User's location            |
| website   | string | No       | Personal website URL       |


### Example Request

```json
{
  "name": "John Updated",
  "bio": "Meditation enthusiast and yoga practitioner"
}
```

### Responses

#### 200 OK
```json
{
  "message": "Profile updated successfully",
  "user": {
    "id": "507f1f77bcf86cd799439011",
    "name": "John Updated",
    "email": "john.doe@example.com",
    "bio": "Meditation enthusiast and yoga practitioner",
    "avatarUrl": "https://example.com/avatars/john-doe.jpg",
    "updatedAt": "2025-06-08T11:00:00.000Z"
  }
}
```

## Change Password

Change the current user's password.

```http
POST /users/me/change-password
```

### Request Body

| Parameter       | Type   | Required | Description                |
|-----------------|--------|----------|----------------------------|
| currentPassword | string | Yes      | Current password           |
| newPassword     | string | Yes      | New password (min 8 chars) |

### Example Request

```json
{
  "currentPassword": "oldPassword123",
  "newPassword": "newSecurePassword456"
}
```

### Responses

#### 200 OK
```json
{
  "message": "Password updated successfully"
}
```

## Upload Profile Picture

Upload a new profile picture for the current user.

```http
POST /users/me/avatar
Content-Type: multipart/form-data
```

### Request Body

| Parameter | Type  | Required | Description                |
|-----------|-------|----------|----------------------------|
| avatar    | file  | Yes      | Image file (JPG, PNG, etc.) |

### Responses

#### 200 OK
```json
{
  "message": "Profile picture updated successfully",
  "avatarUrl": "https://example.com/avatars/new-avatar.jpg"
}
```

## Delete Account

Permanently delete the current user's account and all associated data.

```http
DELETE /users/me
```

### Request Body

| Parameter | Type   | Required | Description                |
|-----------|--------|----------|----------------------------|
| password  | string | Yes      | User's current password    |

### Example Request

```json
{
  "password": "currentPassword123"
}
```

### Responses

#### 200 OK
```json
{
  "message": "Account deleted successfully"
}
```

## Get User Statistics

Retrieve statistics about the current user's meditation practice.

```http
GET /users/me/stats
```

### Responses

#### 200 OK
```json
{
  "totalSessions": 42,
  "totalMinutes": 1260,
  "currentStreak": 7,
  "longestStreak": 30,
  "favoriteCategory": "anxiety",
  "sessionsByDay": [
    { "day": "Mon", "count": 5 },
    { "day": "Tue", "count": 6 },
    { "day": "Wed", "count": 4 },
    { "day": "Thu", "count": 7 },
    { "day": "Fri", "count": 3 },
    { "day": "Sat", "count": 9 },
    { "day": "Sun", "count": 8 }
  ],
  "minutesByCategory": [
    { "category": "anxiety", "minutes": 420 },
    { "category": "sleep", "minutes": 360 },
    { "category": "focus", "minutes": 300 },
    { "category": "stress", "minutes": 180 }
  ]
}
```

## Get User Preferences

Retrieve the current user's preferences.

```http
GET /users/me/preferences
```

### Responses

#### 200 OK
```json
{
  "theme": "system",
  "notifications": {
    "email": true,
    "push": true,
    "reminders": true,
    "dailyReminderTime": "20:00",
    "weeklySummary": true
  },
  "playback": {
    "defaultVolume": 70,
    "skipSilence": true,
    "backgroundPlayback": true,
    "downloadQuality": "high"
  },
  "privacy": {
    "profileVisible": true,
    "activitySharing": false,
    "emailSearchable": false
  }
}
```

## Update User Preferences

Update the current user's preferences.

```http
PATCH /users/me/preferences
```

### Request Body

| Parameter | Type   | Required | Description                |
|-----------|--------|----------|----------------------------|
| theme     | string | No       | UI theme (light/dark/system)|
| notifications | object | No | Notification preferences    |
| playback  | object | No       | Playback preferences       |
| privacy   | object | No       | Privacy settings           |

### Example Request

```json
{
  "theme": "dark",
  "notifications": {
    "dailyReminderTime": "21:30",
    "push": false
  },
  "playback": {
    "defaultVolume": 80
  }
}
```

### Responses

#### 200 OK
```json
{
  "message": "Preferences updated successfully",
  "preferences": {
    "theme": "dark",
    "notifications": {
      "email": true,
      "push": false,
      "reminders": true,
      "dailyReminderTime": "21:30",
      "weeklySummary": true
    },
    "playback": {
      "defaultVolume": 80,
      "skipSilence": true,
      "backgroundPlayback": true,
      "downloadQuality": "high"
    },
    "privacy": {
      "profileVisible": true,
      "activitySharing": false,
      "emailSearchable": false
    }
  }
}
```

## Error Responses

### 400 Bad Request
```json
{
  "error": "Validation Error",
  "message": "Invalid input data"
}
```

### 401 Unauthorized
```json
{
  "error": "Unauthorized",
  "message": "Authentication required"
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

## Rate Limiting
- All endpoints are rate limited to 1000 requests per hour per user.
- The `/users/me` endpoint has a higher limit of 5000 requests per hour per IP.

## Data Types
- **Timestamps**: All dates are returned in ISO 8601 format (e.g., `2025-06-08T10:00:00.000Z`)
- **IDs**: All IDs are MongoDB ObjectIds
