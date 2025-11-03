# Database Schema Update Summary

## Date: November 3, 2025

## Overview
Updated the EdTech platform backend to support the new database schema with 13 tables. This includes adding new tables, updating existing ones, and ensuring proper foreign key relationships.

---

## Changes Made

### 1. New Tables Added

#### Users Table
- **Purpose**: Store user account information
- **Primary Key**: userId (integer)
- **Columns**: userId, name, email, password
- **API Endpoints**: 
  - `GET /users` - List all users or get user by ID
  - `POST /users` - Create new user
  - `PUT /users/:id` - Update user
  - `DELETE /users/:id` - Delete user

#### Instructors Table
- **Purpose**: Store instructor information
- **Primary Key**: instructorId (string)
- **Columns**: instructorId, instructorName
- **API Endpoints**:
  - `GET /instructors` - List all instructors or get by ID
  - `POST /instructors` - Create new instructor
  - `PUT /instructors/:id` - Update instructor
  - `DELETE /instructors/:id` - Delete instructor

---

### 2. Updated Tables

#### Courses
**Added:**
- Foreign key validation for `instructorId` (references Instructors table)

**Modified:**
- Now validates that instructorId exists before creating/updating courses

#### Lessons
**Added:**
- `instructorId` field (FK → Instructors.instructorId)

**Modified:**
- Required field: `instructorId` (previously not included)
- Removed `order` field requirement (made optional)
- Added validation for both `courseId` and `instructorId`
- Changed required field from `order` to `type`

#### QuizQuestions
**Modified:**
- Removed `order` from required fields (now optional)
- `explanation` remains optional
- `points` remains optional with default value of 1

#### Badges
**Modified:**
- Removed `criteria` field requirement
- Changed required fields to: `name`, `description`, `category`, `icon`
- Added `category` as required field

#### QuizAttempts
**Added:**
- Foreign key validation for `userId` (references Users table)

**Modified:**
- Now validates that userId exists before creating attempts

#### UserProgress
**Added:**
- Foreign key validation for `userId` (references Users table)

**Modified:**
- Now validates userId, courseId, and lessonId before creating/updating progress

#### Transactions
**Added:**
- Foreign key validation for `userId` and `courseId`

**Modified:**
- Validates userId exists before creating transactions
- Validates courseId exists if provided

#### Ranks
**Added:**
- Foreign key validation for `userId` (references Users table)

**Modified:**
- Now validates both userId and courseId exist

#### UserBadges
**Added:**
- Foreign key validation for `userId` (references Users table)

**Modified:**
- Now validates both userId and badgeId exist

#### Notifications
**Added:**
- Foreign key validation for `userId` (references Users table)

**Modified:**
- Now validates userId exists before creating notifications

---

### 3. Foreign Key Relationships

All foreign key relationships are now properly validated:

1. **Courses.instructorId** → Instructors.instructorId
2. **Lessons.courseId** → Courses.courseId
3. **Lessons.instructorId** → Instructors.instructorId
4. **Quizzes.courseId** → Courses.courseId
5. **QuizQuestions.quizId** → Quizzes.quizId
6. **QuizAttempts.userId** → Users.userId
7. **QuizAttempts.quizId** → Quizzes.quizId
8. **UserProgress.userId** → Users.userId
9. **UserProgress.courseId** → Courses.courseId
10. **UserProgress.lessonId** → Lessons.lessonId
11. **Transactions.userId** → Users.userId
12. **Transactions.courseId** → Courses.courseId (optional)
13. **Ranks.userId** → Users.userId
14. **Ranks.courseId** → Courses.courseId
15. **Notifications.userId** → Users.userId
16. **UserBadges.userId** → Users.userId
17. **UserBadges.badgeId** → Badges.badgeId

---

### 4. API Endpoints Summary

#### New Endpoints:
- `/users` - Full CRUD operations
- `/instructors` - Full CRUD operations

#### Updated Endpoints:
- All existing endpoints now have proper foreign key validation
- Error messages improved for foreign key violations

#### Complete Endpoint List:
1. `GET /health` - Health check
2. `GET|POST|PUT|DELETE /users` - User management
3. `GET|POST|PUT|DELETE /instructors` - Instructor management
4. `GET|POST|PUT|DELETE /courses` - Course management
5. `GET|POST|PUT|DELETE /lessons` - Lesson management
6. `GET|POST|PUT|DELETE /quizzes` - Quiz management
7. `GET|POST|PUT|DELETE /quiz-questions` - Quiz question management
8. `GET|POST /progress` - User progress tracking
9. `GET|POST /quiz-attempts` - Quiz attempt tracking
10. `GET|POST /transactions` - Transaction management
11. `GET|POST /ranks` - Ranking management
12. `GET|POST /badges` - Badge management
13. `GET|POST /user-badges` - User badge assignment
14. `GET|POST|PUT /notifications` - Notification management

---

## Files Modified

1. **index.js**
   - Added Users and Instructors endpoints
   - Updated all foreign key validations
   - Updated COLLECTIONS constant
   - Updated available endpoints list

2. **appwrite-setup.md**
   - Added Users collection schema
   - Added Instructors collection schema
   - Updated all existing collection schemas
   - Updated indexes section
   - Updated permissions section

3. **DATABASE_SCHEMA.md** (New)
   - Complete database schema documentation
   - All table definitions with columns and types
   - Foreign key relationships diagram
   - Data validation rules
   - Comprehensive notes

---

## Migration Steps

To implement these changes in your Appwrite database:

### 1. Create New Collections

**Users Collection:**
```
Collection ID: users
Attributes:
- userId (integer, required)
- name (string, 255, required)
- email (string, 255, required)
- password (string, 255, required)

Indexes:
- email (unique)
```

**Instructors Collection:**
```
Collection ID: instructors
Attributes:
- instructorId (string, 50, required)
- instructorName (string, 255, required)

Indexes:
- instructorName
```

### 2. Update Existing Collections

**Lessons Collection - Add:**
```
- instructorId (string, 50, required)

Indexes:
- Add instructorId index
```

**Badges Collection - Update:**
```
- Remove: criteria field
- Add: category (string, 100, required)

Indexes:
- Add category index
```

### 3. Data Migration

If you have existing data:

1. **Instructors**: Create instructor records for all existing instructorId values in courses
2. **Users**: If using Appwrite Auth, sync users table with Auth users
3. **Lessons**: Add instructorId to all existing lessons
4. **Badges**: Add category field to all existing badges

### 4. Verify Foreign Keys

After migration, verify all foreign key relationships:
- All courses have valid instructorId
- All lessons have valid courseId and instructorId
- All quiz attempts have valid userId and quizId
- All progress records have valid userId, courseId, and lessonId
- All transactions have valid userId (and courseId if provided)
- All ranks have valid userId and courseId
- All notifications have valid userId
- All user badges have valid userId and badgeId

---

## Testing Checklist

- [ ] Health check endpoint works
- [ ] Create user account
- [ ] Create instructor
- [ ] Create course with valid instructorId
- [ ] Create course with invalid instructorId (should fail)
- [ ] Create lesson with valid courseId and instructorId
- [ ] Create quiz with valid courseId
- [ ] Create quiz question with valid quizId
- [ ] Submit quiz attempt with valid userId and quizId
- [ ] Track progress with valid userId, courseId, lessonId
- [ ] Create transaction with valid userId
- [ ] Create rank with valid userId and courseId
- [ ] Create badge with category
- [ ] Assign badge to user
- [ ] Create notification for user

---

## Breaking Changes

⚠️ **Important**: The following changes may break existing code:

1. **Lessons**: Now requires `instructorId` field
2. **Lessons**: `order` field is no longer required
3. **Badges**: No longer requires `criteria` field, now requires `category`
4. **QuizQuestions**: `order` field is no longer required

Make sure to update your frontend code accordingly!

---

## Next Steps

1. Deploy updated backend function to Appwrite
2. Create Users and Instructors collections in Appwrite database
3. Update Lessons collection to add instructorId attribute
4. Update Badges collection schema
5. Run data migration scripts if needed
6. Test all endpoints with Postman
7. Update frontend code to use new schema
8. Update API documentation

---

## Support

For questions or issues with the schema update, please refer to:
- `DATABASE_SCHEMA.md` - Complete schema documentation
- `appwrite-setup.md` - Appwrite setup instructions
- `README.md` - General backend documentation
