# EdTech Platform - Database Schema

## Overview
This document describes the complete database schema for the EdTech platform, including all tables, their attributes, data types, and relationships.

---

## Tables

### 1. Users
Stores user account information.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| userId | int | PK | Unique user identifier |
| name | varchar | NOT NULL | User's full name |
| email | varchar | NOT NULL, UNIQUE | User's email address |
| password | varchar | NOT NULL | Hashed password |

**Indexes:**
- email (for login queries)

---

### 2. Instructors
Stores instructor information.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| instructorId | string | PK | Unique instructor identifier |
| instructorName | string | NOT NULL | Instructor's name |

**Indexes:**
- instructorName (for searching)

---

### 3. Courses
Stores course information.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| courseId | string | PK | Unique course identifier |
| title | string | NOT NULL | Course title |
| description | string | NOT NULL | Course description |
| instructorId | string | FK → Instructors.instructorId | Instructor teaching the course |
| category | string | NOT NULL | Course category |
| price | double | NOT NULL | Course price |
| thumbnail | string | NULL | URL to course thumbnail image |
| duration | integer | NULL | Course duration in minutes |
| level | string | NULL | Difficulty level (beginner, intermediate, advanced) |
| enrollmentCount | integer | DEFAULT 0 | Number of enrolled students |
| isPublished | boolean | DEFAULT false | Whether course is published |

**Indexes:**
- instructorId
- category
- isPublished

---

### 4. Lessons
Stores lesson content for courses.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| lessonId | string | PK | Unique lesson identifier |
| courseId | string | FK → Courses.courseId | Course this lesson belongs to |
| instructorId | string | FK → Instructors.instructorId | Instructor who created the lesson |
| title | string | NOT NULL | Lesson title |
| content | string | NOT NULL | Lesson content/description |
| type | string | NOT NULL | Lesson type (video, text, quiz, etc.) |
| duration | integer | NULL | Lesson duration in minutes |
| videoUrl | string | NULL | URL to video content |
| fileUrl | string | NULL | URL to downloadable files |
| completionCount | integer | DEFAULT 0 | Number of users who completed this lesson |

**Indexes:**
- courseId
- instructorId

---

### 5. Quizzes
Stores quiz information.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| quizId | string | PK | Unique quiz identifier |
| courseId | string | FK → Courses.courseId | Course this quiz belongs to |
| title | string | NOT NULL | Quiz title |
| description | string | NOT NULL | Quiz description |
| timeLimit | integer | NOT NULL | Time limit in minutes |
| passingScore | integer | NOT NULL | Minimum score to pass |
| maxAttempts | integer | NULL | Maximum number of attempts allowed |
| attemptCount | integer | DEFAULT 0 | Total number of attempts by all users |
| isActive | boolean | DEFAULT true | Whether quiz is active |

**Indexes:**
- courseId
- isActive

---

### 6. QuizQuestions
Stores quiz questions and answers.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| questionId | string | PK | Unique question identifier |
| quizId | string | FK → Quizzes.quizId | Quiz this question belongs to |
| question | string | NOT NULL | Question text |
| correctAnswer | string | NOT NULL | Correct answer(s) |
| explanation | string | NULL | Explanation for the correct answer |
| order | integer | NOT NULL | Question order in quiz |
| points | integer | DEFAULT 1 | Points awarded for correct answer |
| options | string | NOT NULL | JSON array of answer options |

**Indexes:**
- quizId
- order

---

### 7. QuizAttempts
Stores user quiz attempts and results.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| attemptId | string | PK | Unique attempt identifier |
| userId | string | FK → Users.userId | User who took the quiz |
| quizId | string | FK → Quizzes.quizId | Quiz that was attempted |
| answers | string | NOT NULL | JSON object of user's answers |
| score | integer | NOT NULL | Score achieved |
| totalQuestions | integer | NOT NULL | Total number of questions |
| timeTaken | int | NULL | Time taken in minutes |
| passed | boolean | NOT NULL | Whether user passed |

**Indexes:**
- userId
- quizId

---

### 8. Ranks
Stores user rankings for courses.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| rankId | string | PK | Unique rank identifier |
| userId | string | FK → Users.userId | User being ranked |
| courseId | string | FK → Courses.courseId | Course the rank is for |
| score | int | NOT NULL | User's score |
| rank | int | NOT NULL | User's rank position |
| totalParticipants | int | NOT NULL | Total number of participants |

**Indexes:**
- userId
- courseId
- rank

---

### 9. Transactions
Stores payment and transaction records.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| transactionId | string | PK | Unique transaction identifier |
| userId | string | FK → Users.userId | User who made the transaction |
| type | string | NOT NULL | Transaction type (purchase, refund, etc.) |
| amount | decimal | NOT NULL | Transaction amount |
| description | string | NOT NULL | Transaction description |
| courseId | string | FK → Courses.courseId | Course purchased (if applicable) |
| status | string | NOT NULL | Transaction status (completed, pending, failed) |
| paymentMethod | string | NULL | Payment method used |

**Indexes:**
- userId
- type
- courseId

---

### 10. Notifications
Stores user notifications.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| notificationId | string | PK | Unique notification identifier |
| userId | string | FK → Users.userId | User receiving the notification |
| title | string | NOT NULL | Notification title |
| message | string | NOT NULL | Notification message |
| type | string | NOT NULL | Notification type (info, warning, success) |
| isRead | boolean | DEFAULT false | Whether notification has been read |

**Indexes:**
- userId
- isRead

---

### 11. Badges
Stores badge definitions.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| badgeId | string | PK | Unique badge identifier |
| name | string | NOT NULL | Badge name |
| description | string | NOT NULL | Badge description |
| category | string | NOT NULL | Badge category |
| icon | string | NOT NULL | URL to badge icon |
| points | int | DEFAULT 10 | Points awarded for earning badge |

**Indexes:**
- category

---

### 12. UserBadges
Junction table linking users to earned badges.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| userId | string | FK → Users.userId | User who earned the badge |
| badgeId | string | FK → Badges.badgeId | Badge that was earned |

**Composite Primary Key:** (userId, badgeId)

**Indexes:**
- userId
- badgeId

---

### 13. UserProgress
Tracks user progress through lessons.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| progressId | string | PK | Unique progress identifier |
| userId | string | FK → Users.userId | User tracking progress |
| courseId | string | FK → Courses.courseId | Course being tracked |
| lessonId | string | FK → Lessons.lessonId | Current lesson |
| progress | int | NOT NULL | Progress percentage (0-100) |
| timeSpent | int | NOT NULL | Time spent in minutes |

**Indexes:**
- userId
- courseId
- lessonId

---

## Relationships

### One-to-Many Relationships

1. **Instructors → Courses**
   - One instructor can teach many courses
   - `Courses.instructorId` → `Instructors.instructorId`

2. **Instructors → Lessons**
   - One instructor can create many lessons
   - `Lessons.instructorId` → `Instructors.instructorId`

3. **Courses → Lessons**
   - One course can have many lessons
   - `Lessons.courseId` → `Courses.courseId`

4. **Courses → Quizzes**
   - One course can have many quizzes
   - `Quizzes.courseId` → `Courses.courseId`

5. **Quizzes → QuizQuestions**
   - One quiz can have many questions
   - `QuizQuestions.quizId` → `Quizzes.quizId`

6. **Users → QuizAttempts**
   - One user can have many quiz attempts
   - `QuizAttempts.userId` → `Users.userId`

7. **Quizzes → QuizAttempts**
   - One quiz can have many attempts
   - `QuizAttempts.quizId` → `Quizzes.quizId`

8. **Users → Transactions**
   - One user can have many transactions
   - `Transactions.userId` → `Users.userId`

9. **Courses → Transactions**
   - One course can have many transactions
   - `Transactions.courseId` → `Courses.courseId`

10. **Users → Notifications**
    - One user can have many notifications
    - `Notifications.userId` → `Users.userId`

11. **Users → Ranks**
    - One user can have many ranks (across different courses)
    - `Ranks.userId` → `Users.userId`

12. **Courses → Ranks**
    - One course can have many ranks
    - `Ranks.courseId` → `Courses.courseId`

13. **Users → UserProgress**
    - One user can have many progress records
    - `UserProgress.userId` → `Users.userId`

14. **Courses → UserProgress**
    - One course can have many progress records
    - `UserProgress.courseId` → `Courses.courseId`

15. **Lessons → UserProgress**
    - One lesson can have many progress records
    - `UserProgress.lessonId` → `Lessons.lessonId`

### Many-to-Many Relationships

1. **Users ↔ Badges** (via UserBadges)
   - Many users can earn many badges
   - `UserBadges.userId` → `Users.userId`
   - `UserBadges.badgeId` → `Badges.badgeId`

---

## Data Validation Rules

1. **Email Format**: Must be valid email format
2. **Password**: Minimum 8 characters, must be hashed before storage
3. **Price**: Must be >= 0
4. **Progress**: Must be between 0 and 100
5. **Score**: Must be >= 0
6. **Rank**: Must be > 0
7. **Time Values**: Must be >= 0
8. **Boolean Fields**: Must be true or false

---

## Notes

- All string primary keys use custom ID generation (e.g., `COURSE_12345`, `QUIZ_67890`)
- All timestamps are handled automatically by Appwrite ($createdAt, $updatedAt)
- Foreign key validation is enforced at the application level
- JSON fields (answers, options) are stored as strings and parsed in application
- Cascade deletes should be handled at application level for data integrity
