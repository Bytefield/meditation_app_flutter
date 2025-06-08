# Meditation Sessions API

This document outlines the API endpoints for managing meditation sessions in the Rago Meditation App.

## Base URL
All API endpoints are relative to the base URL: `https://api.ragomeditation.com/v1`

## Table of Contents
- [Get All Sessions](#get-all-sessions)
- [Get Session by ID](#get-session-by-id)
- [Start a Session](#start-a-session)
- [Update Session Progress](#update-session-progress)
- [Complete a Session](#complete-a-session)
- [Get User's Session History](#get-users-session-history)
- [Get Recommended Sessions](#get-recommended-sessions)

## Authentication
All endpoints require authentication. Include the JWT token in the `Authorization` header:
```
Authorization: Bearer <access_token>
```

## Get All Sessions

Retrieve a paginated list of all available meditation sessions.

```http
GET /sessions
```

### Query Parameters

| Parameter  | Type    | Required | Default | Description                           |
|------------|---------|----------|---------|---------------------------------------|
| page       | integer | No       | 1       | Page number                           |
| limit      | integer | No       | 10      | Number of items per page              |
| category   | string  | No       | all     | Filter by category                    |
| duration   | integer | No       |         | Filter by duration (in minutes)       |
| difficulty | string  | No       | all     | Filter by difficulty (beginner, intermediate, advanced) |


### Example Request
```http
GET /sessions?page=1&limit=5&category=anxiety&difficulty=beginner
```

### Response

#### 200 OK
```json
{
  "sessions": [
    {
      "id": "60d21b4667d0d8992e610c85",
      "title": "Calming Anxiety",
      "description": "A guided meditation to help reduce anxiety and stress.",
      "duration": 10,
      "category": "anxiety",
      "difficulty": "beginner",
      "thumbnailUrl": "https://example.com/thumbnails/anxiety.jpg",
      "audioUrl": "https://example.com/audio/calming-anxiety.mp3",
      "instructor": {
        "id": "60d21b4667d0d8992e610c86",
        "name": "Sarah Johnson",
        "avatar": "https://example.com/avatars/sarah.jpg"
      },
      "createdAt": "2025-05-15T10:30:00.000Z"
    }
  ],
  "pagination": {
    "total": 1,
    "page": 1,
    "limit": 5,
    "totalPages": 1
  }
}
```

## Get Session by ID

Retrieve detailed information about a specific meditation session.

```http
GET /sessions/:id
```

### Path Parameters

| Parameter | Type   | Required | Description          |
|-----------|--------|----------|----------------------|
| id        | string | Yes      | Session ID           |

### Example Request
```http
GET /sessions/60d21b4667d0d8992e610c85
```

### Response

#### 200 OK
```json
{
  "id": "60d21b4667d0d8992e610c85",
  "title": "Calming Anxiety",
  "description": "A guided meditation to help reduce anxiety and stress.",
  "longDescription": "This 10-minute guided meditation is designed to help you find calm and reduce anxiety through focused breathing and mindfulness techniques...",
  "duration": 10,
  "category": "anxiety",
  "difficulty": "beginner",
  "thumbnailUrl": "https://example.com/thumbnails/anxiety.jpg",
  "audioUrl": "https://example.com/audio/calming-anxiety.mp3",
  "instructor": {
    "id": "60d21b4667d0d8992e610c86",
    "name": "Sarah Johnson",
    "bio": "Certified meditation instructor with 10+ years of experience...",
    "avatar": "https://example.com/avatars/sarah.jpg"
  },
  "tags": ["anxiety", "stress", "beginner", "calm"],
  "createdAt": "2025-05-15T10:30:00.000Z",
  "updatedAt": "2025-05-15T10:30:00.000Z"
}
```

## Start a Session

Mark the beginning of a meditation session.

```http
POST /sessions/:id/start
```

### Path Parameters

| Parameter | Type   | Required | Description          |
|-----------|--------|----------|----------------------|
| id        | string | Yes      | Session ID           |


### Example Request
```http
POST /sessions/60d21b4667d0d8992e610c85/start
```

### Response

#### 201 Created
```json
{
  "message": "Session started",
  "sessionLogId": "70e21b4667d0d8992e610d95"
}
```

## Update Session Progress

Update the progress of an ongoing meditation session.

```http
PATCH /session-logs/:id/progress
```

### Path Parameters

| Parameter | Type   | Required | Description          |
|-----------|--------|----------|----------------------|
| id        | string | Yes      | Session Log ID       |


### Request Body

| Parameter | Type    | Required | Description                          |
|-----------|---------|----------|--------------------------------------|
| progress  | integer | Yes      | Current progress in seconds          |
| timestamp | string  | Yes      | ISO 8601 timestamp of the update     |


### Example Request
```http
PATCH /session-logs/70e21b4667d0d8992e610d95/progress
```

```json
{
  "progress": 120,
  "timestamp": "2025-06-08T10:15:30.000Z"
}
```

### Response

#### 200 OK
```json
{
  "message": "Progress updated",
  "progress": 120
}
```

## Complete a Session

Mark a meditation session as completed.

```http
POST /session-logs/:id/complete
```

### Path Parameters

| Parameter | Type   | Required | Description          |
|-----------|--------|----------|----------------------|
| id        | string | Yes      | Session Log ID       |


### Request Body

| Parameter | Type    | Required | Description                          |
|-----------|---------|----------|--------------------------------------|
| duration  | integer | No       | Total duration in seconds (if different from session default) |
| moodBefore | string | No      | User's mood before session (1-5)     |
| moodAfter | string  | No      | User's mood after session (1-5)      |
| notes     | string  | No       | Optional user notes about the session |

### Example Request
```http
POST /session-logs/70e21b4667d0d8992e610d95/complete
```

```json
{
  "moodBefore": 3,
  "moodAfter": 4,
  "notes": "Felt very relaxed after this session."
}
```

### Response

#### 200 OK
```json
{
  "message": "Session completed successfully",
  "sessionLog": {
    "id": "70e21b4667d0d8992e610d95",
    "sessionId": "60d21b4667d0d8992e610c85",
    "userId": "507f1f77bcf86cd799439011",
    "startedAt": "2025-06-08T10:00:00.000Z",
    "completedAt": "2025-06-08T10:10:00.000Z",
    "duration": 600,
    "moodBefore": 3,
    "moodAfter": 4,
    "notes": "Felt very relaxed after this session.",
    "createdAt": "2025-06-08T10:00:00.000Z"
  }
}
```

## Get User's Session History

Retrieve the authenticated user's meditation session history.

```http
GET /users/me/sessions
```

### Query Parameters

| Parameter | Type    | Required | Default | Description                           |
|-----------|---------|----------|---------|---------------------------------------|
| page      | integer | No       | 1       | Page number                           |
| limit     | integer | No       | 10      | Number of items per page              |
| from      | string  | No       |         | Filter sessions from date (ISO 8601)  |
| to        | string  | No       |         | Filter sessions to date (ISO 8601)    |
| category  | string  | No       | all     | Filter by category                    |


### Example Request
```http
GET /users/me/sessions?page=1&limit=5&from=2025-01-01&category=anxiety
```

### Response

#### 200 OK
```json
{
  "sessions": [
    {
      "id": "70e21b4667d0d8992e610d95",
      "sessionId": "60d21b4667d0d8992e610c85",
      "title": "Calming Anxiety",
      "duration": 600,
      "category": "anxiety",
      "startedAt": "2025-06-08T10:00:00.000Z",
      "completedAt": "2025-06-08T10:10:00.000Z",
      "moodBefore": 3,
      "moodAfter": 4,
      "notes": "Felt very relaxed after this session."
    }
  ],
  "pagination": {
    "total": 1,
    "page": 1,
    "limit": 5,
    "totalPages": 1
  }
}
```

## Get Recommended Sessions

Get personalized session recommendations for the authenticated user.

```http
GET /sessions/recommended
```

### Query Parameters

| Parameter | Type    | Required | Default | Description                           |
|-----------|---------|----------|---------|---------------------------------------|
| limit     | integer | No       | 5       | Number of recommendations to return   |

### Example Request
```http
GET /sessions/recommended?limit=3
```

### Response

#### 200 OK
```json
[
  {
    "id": "60d21b4667d0d8992e610c85",
    "title": "Calming Anxiety",
    "description": "A guided meditation to help reduce anxiety and stress.",
    "duration": 10,
    "category": "anxiety",
    "difficulty": "beginner",
    "thumbnailUrl": "https://example.com/thumbnails/anxiety.jpg",
    "recommendationReason": "Based on your recent mood and activity"
  }
]
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

### 404 Not Found
```json
{
  "error": "Not Found",
  "message": "Session not found"
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
- All endpoints are rate limited to 1000 requests per hour per user.
- The `/sessions` and `/sessions/:id` endpoints have a higher limit of 5000 requests per hour per IP.

## Versioning
API versioning is handled through the URL path (e.g., `/v1/sessions`).

## Pagination
All list endpoints return paginated results with the following structure:
```json
{
  "data": [],
  "pagination": {
    "total": 100,
    "page": 1,
    "limit": 10,
    "totalPages": 10
  }
}
```

## Data Types
- **Timestamps**: All dates are returned in ISO 8601 format (e.g., `2025-06-08T10:00:00.000Z`)
- **Durations**: All durations are in seconds
- **IDs**: All IDs are MongoDB ObjectIds
