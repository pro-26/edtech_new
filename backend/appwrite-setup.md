# EdTech Platform - Appwrite Function Configuration

## Environment Variables
# Copy these to your Appwrite Function environment variables

# Appwrite Configuration (Required)
APPWRITE_FUNCTION_ENDPOINT=https://cloud.appwrite.io/v1
APPWRITE_FUNCTION_PROJECT_ID=your_project_id_here
APPWRITE_API_KEY=your_server_api_key_here
DATABASE_ID=edtech_db

# Discord Logging (Optional but recommended)
DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/your/webhook/url

# Environment
NODE_ENV=production

## Appwrite Function Settings

### Runtime Settings
- **Runtime**: Node.js 18.0
- **Entrypoint**: index.js
- **Build Commands**: npm install
- **Timeout**: 15 seconds (default)
- **Memory**: 512MB (recommended)

### Permissions Required
- **Database**: Read, Write
- **Collections**: Read, Write, Delete (for all collections)
- **Storage**: Read, Write (if file upload is needed)

### Triggers
- **HTTP**: Enable for API access
- **Schedule**: Optional for background tasks

## Function Deployment Steps

1. **Create Function in Appwrite Console**
   - Go to Functions section
   - Click "Create Function"
   - Choose Node.js 18.0 runtime
   - Set name: "edtech-backend"

2. **Configure Environment Variables**
   - Add all variables listed above
   - Ensure APPWRITE_API_KEY has appropriate permissions

3. **Deploy Code**
   - Upload the entire backend folder
   - Or connect to Git repository
   - Ensure package.json is in root

4. **Set Up Database**
   - Create database with ID: edtech_db
   - Create all collections as per README
   - Set appropriate permissions

5. **Test Deployment**
   - Use health check endpoint
   - Verify in Function logs
   - Test with Postman collection

## Database Permissions Setup

### For each collection, set these permissions:

**Public Collections (categories, subcategories, courses, lessons, quizzes, quiz_questions, badges, instructors):**
- Read: role:all
- Create: role:instructor, role:admin
- Update: role:instructor, role:admin  
- Delete: role:admin

**User-specific Collections (users, user_progress, quiz_attempts, user_badges, notifications, transactions):**
- Read: role:user, role:admin
- Create: role:user, role:admin
- Update: role:user, role:admin
- Delete: role:admin

**Admin-only Collections (ranks):**
- Read: role:all
- Create: role:admin
- Update: role:admin
- Delete: role:admin

**Note:** Categories and Subcategories are new collections added to support hierarchical content organization.

## Collection Attributes

### Users Collection
```json
{
  "name": { "type": "string", "size": 255, "required": true },
  "email": { "type": "string", "size": 255, "required": true },
  "password": { "type": "string", "size": 255, "required": true }
}
```

### Instructors Collection
```json
{
  "instructorName": { "type": "string", "size": 255, "required": true }
}
```

### Categories Collection
```json
{
  "categoryName": { "type": "string", "size": 255, "required": true }
}
```

### Subcategories Collection
```json
{
  "categoryId": { "type": "string", "size": 50, "required": true },
  "subcategoryName": { "type": "string", "size": 255, "required": true }
}
```

### Courses Collection
```json
{
  "title": { "type": "string", "size": 255, "required": true },
  "description": { "type": "string", "size": 2000, "required": true },
  "instructorId": { "type": "string", "size": 50, "required": true },
  "category": { "type": "string", "size": 100, "required": true },
  "price": { "type": "float", "required": true },
  "thumbnail": { "type": "string", "size": 500, "required": false },
  "duration": { "type": "integer", "required": false },
  "level": { "type": "string", "size": 50, "required": false },
  "enrollmentCount": { "type": "integer", "default": 0 },
  "isPublished": { "type": "boolean", "default": false }
}
```

### Lessons Collection  
```json
{
  "courseId": { "type": "string", "size": 50, "required": true },
  "instructorId": { "type": "string", "size": 50, "required": true },
  "title": { "type": "string", "size": 255, "required": true },
  "content": { "type": "string", "size": 5000, "required": true },
  "type": { "type": "string", "size": 20, "required": true },
  "duration": { "type": "integer", "required": false },
  "videoUrl": { "type": "string", "size": 500, "required": false },
  "fileUrl": { "type": "string", "size": 500, "required": false },
  "completionCount": { "type": "integer", "default": 0 },
  "thumbnail": { "type": "string", "size": 500, "required": false },
  "categoryId": { "type": "string", "size": 50, "required": false },
  "subcategoryId": { "type": "string", "size": 50, "required": false },
  "chapterNo": { "type": "integer", "required": false },
  "lessonNo": { "type": "integer", "required": false }
}
```

### Quizzes Collection
```json
{
  "courseId": { "type": "string", "size": 50, "required": true },
  "title": { "type": "string", "size": 255, "required": true },
  "description": { "type": "string", "size": 1000, "required": true },
  "timeLimit": { "type": "integer", "required": true },
  "passingScore": { "type": "integer", "required": true },
  "maxAttempts": { "type": "integer", "required": false },
  "attemptCount": { "type": "integer", "default": 0 },
  "isActive": { "type": "boolean", "default": true },
  "chapterNo": { "type": "integer", "required": false },
  "lessonNo": { "type": "integer", "required": false }
}
```

### Quiz Questions Collection
```json
{
  "quizId": { "type": "string", "size": 50, "required": true },
  "question": { "type": "string", "size": 1000, "required": true },
  "correctAnswer": { "type": "string", "size": 500, "required": true },
  "explanation": { "type": "string", "size": 1000, "required": false },
  "order": { "type": "integer", "required": true },
  "points": { "type": "integer", "default": 1 },
  "options": { "type": "string", "size": 2000, "required": true, "array": true },
  "questionNo": { "type": "integer", "required": false }
}
```

### Quiz Attempts Collection
```json
{
  "userId": { "type": "string", "size": 50, "required": true },
  "quizId": { "type": "string", "size": 50, "required": true },
  "answers": { "type": "string", "size": 5000, "required": true },
  "score": { "type": "integer", "required": true },
  "totalQuestions": { "type": "integer", "required": true },
  "timeTaken": { "type": "integer", "required": false },
  "passed": { "type": "boolean", "required": true },
  "attemptedAt": { "type": "datetime", "required": false }
}
```

### Ranks Collection
```json
{
  "userId": { "type": "string", "size": 50, "required": true },
  "courseId": { "type": "string", "size": 50, "required": true },
  "score": { "type": "integer", "required": true },
  "rank": { "type": "integer", "required": true },
  "totalParticipants": { "type": "integer", "required": true },
  "achievedAt": { "type": "datetime", "required": false }
}
```

### Transactions Collection
```json
{
  "userId": { "type": "string", "size": 50, "required": true },
  "type": { "type": "string", "size": 20, "required": true },
  "amount": { "type": "float", "required": true },
  "description": { "type": "string", "size": 500, "required": true },
  "courseId": { "type": "string", "size": 50, "required": false },
  "status": { "type": "string", "size": 20, "required": true },
  "paymentMethod": { "type": "string", "size": 50, "required": false }
}
```

### Notifications Collection
```json
{
  "userId": { "type": "string", "size": 50, "required": true },
  "title": { "type": "string", "size": 255, "required": true },
  "message": { "type": "string", "size": 1000, "required": true },
  "type": { "type": "string", "size": 20, "required": true },
  "isRead": { "type": "boolean", "default": false },
  "readAt": { "type": "datetime", "required": false }
}
```

### Badges Collection
```json
{
  "name": { "type": "string", "size": 100, "required": true },
  "description": { "type": "string", "size": 500, "required": true },
  "criteria": { "type": "string", "size": 500, "required": true },
  "icon": { "type": "string", "size": 100, "required": true },
  "points": { "type": "integer", "default": 10 }
}
```

### User Badges Collection
```json
{
  "userId": { "type": "string", "size": 50, "required": true },
  "badgeId": { "type": "string", "size": 50, "required": true },
  "earnedAt": { "type": "datetime", "required": false }
}
```

### User Progress Collection
```json
{
  "userId": { "type": "string", "size": 50, "required": true },
  "courseId": { "type": "string", "size": 50, "required": true },
  "lessonId": { "type": "string", "size": 50, "required": true },
  "completedAt": { "type": "datetime", "required": false },
  "progress": { "type": "integer", "required": true },
  "timeSpent": { "type": "integer", "required": true }
}
```

## Indexes for Performance

### Recommended indexes:

#### Users Collection
- email (unique)

#### Instructors Collection
- instructorName (key)

#### Categories Collection (NEW)
- categoryName (key)
- categoryName (unique)

#### Subcategories Collection (NEW)
- categoryId (key)
- subcategoryName (key)
- categoryId, subcategoryName (composite unique)

#### Courses Collection
- instructorId (key)
- category (key)
- isPublished (key)
- price (key)

#### Lessons Collection
- courseId (key)
- instructorId (key)
- type (key)
- categoryId (key) - NEW
- subcategoryId (key) - NEW
- chapterNo (key) - NEW
- lessonNo (key) - NEW

#### Quizzes Collection
- courseId (key)
- isActive (key)
- chapterNo (key) - NEW
- lessonNo (key) - NEW

#### Quiz Questions Collection
- quizId (key)
- order (key)
- questionNo (key) - NEW

#### Quiz Attempts Collection
- userId (key)
- quizId (key)
- passed (key)
- attemptedAt (key) - NEW
- userId, quizId (composite key)

#### Ranks Collection
- userId (key)
- courseId (key)
- rank (key)
- achievedAt (key) - NEW
- courseId, rank (composite unique)

#### Transactions Collection
- userId (key)
- type (key)
- status (key)
- courseId (key)

#### Notifications Collection
- userId (key)
- type (key)
- isRead (key)
- readAt (key) - NEW

#### Badges Collection
- name (unique)
- criteria (key) - UPDATED from category
- points (key)

#### User Badges Collection
- userId (key)
- badgeId (key)
- earnedAt (key) - NEW
- userId, badgeId (composite unique)

#### User Progress Collection
- userId (key)
- courseId (key)
- lessonId (key)
- completedAt (key) - NEW
- userId, lessonId (composite unique)

## Testing

1. Import Postman collection
2. Set environment variables in Postman:
   - base_url: Your function execution URL
   - project_id: Your Appwrite project ID
   - api_key: Your API key
3. Run health check first
4. Test each endpoint category
5. Verify Discord logging (if enabled)

## Monitoring

- Check Appwrite Function logs
- Monitor Discord webhook for real-time logs
- Set up alerts for errors
- Track performance metrics
- Monitor database usage

## Troubleshooting

### Common Issues:
1. **Function timeout**: Increase timeout in function settings
2. **Permission denied**: Check API key permissions
3. **Database connection**: Verify DATABASE_ID and project settings
4. **Discord logging**: Check webhook URL and Discord server permissions
5. **CORS errors**: Verify CORS headers in function response
