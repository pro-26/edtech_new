# EdTech Platform - Database Schema

## Overview
This document describes the complete database schema for the EdTech platform, including all tables, their attributes, data types, and relationships.

**Last Updated:** November 5, 2025

---

## Tables

### 1. Users
Stores user account information.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| $id | string | PK | Unique user identifier (Appwrite generated) |
| name | string | NOT NULL | User's full name |
| email | string | NOT NULL, UNIQUE | User's email address |
| password | string | NOT NULL | Hashed password |
| $createdAt | datetime | AUTO | Record creation timestamp |
| $updatedAt | datetime | AUTO | Record update timestamp |

**Indexes:**
- email (for login queries)

---

### 2. Instructors
Stores instructor information.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| $id | string | PK | Unique instructor identifier (Appwrite generated) |
| instructorName | string | NOT NULL | Instructor's name |
| $createdAt | datetime | AUTO | Record creation timestamp |
| $updatedAt | datetime | AUTO | Record update timestamp |

**Indexes:**
- instructorName (for searching)

---

### 3. Categories
Stores course categories.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| $id | string | PK | Unique category identifier (Appwrite generated) |
| categoryName | string | NOT NULL | Category name |
| $createdAt | datetime | AUTO | Record creation timestamp |
| $updatedAt | datetime | AUTO | Record update timestamp |

**Indexes:**
- categoryName

---

### 4. Subcategories
Stores course subcategories.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| $id | string | PK | Unique subcategory identifier (Appwrite generated) |
| categoryId | string | FK → Categories.$id | Parent category |
| subcategoryName | string | NOT NULL | Subcategory name |
| $createdAt | datetime | AUTO | Record creation timestamp |
| $updatedAt | datetime | AUTO | Record update timestamp |

**Indexes:**
- categoryId
- subcategoryName

---

### 5. Courses
Stores course information.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| $id | string | PK | Unique course identifier (Appwrite generated) |
| title | string | NOT NULL | Course title |
| description | string | NOT NULL | Course description |
| instructorId | string | FK → Instructors.$id | Instructor teaching the course |
| category | string | NOT NULL | Course category |
| price | double | NOT NULL | Course price |
| thumbnail | string | NULL | URL to course thumbnail image |
| duration | integer | NULL | Course duration in minutes |
| level | string | NULL | Difficulty level (beginner, intermediate, advanced) |
| enrollmentCount | integer | DEFAULT 0 | Number of enrolled students |
| isPublished | boolean | DEFAULT false | Whether course is published |
| $createdAt | datetime | AUTO | Record creation timestamp |
| $updatedAt | datetime | AUTO | Record update timestamp |

**Indexes:**
- instructorId
- category
- isPublished

---

### 6. Lessons
Stores lesson content for courses.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| $id | string | PK | Unique lesson identifier (Appwrite generated) |
| courseId | string | FK → Courses.$id | Course this lesson belongs to |
| instructorId | string | FK → Instructors.$id | Instructor who created the lesson |
| title | string | NOT NULL | Lesson title |
| content | string | NOT NULL | Lesson content/description |
| type | string | NOT NULL | Lesson type (video, text, quiz, etc.) |
| duration | integer | NULL | Lesson duration in minutes |
| videoUrl | string | NULL | URL to video content |
| fileUrl | string | NULL | URL to downloadable files |
| completionCount | integer | DEFAULT 0 | Number of users who completed this lesson |
| thumbnail | string | NULL | URL to lesson thumbnail image |
| categoryId | string | FK → Categories.$id | Category reference |
| subcategoryId | string | FK → Subcategories.$id | Subcategory reference |
| chapterNo | integer | NULL | Chapter number |
| lessonNo | integer | NULL | Lesson number within chapter |
| $createdAt | datetime | AUTO | Record creation timestamp |
| $updatedAt | datetime | AUTO | Record update timestamp |

**Indexes:**
- courseId
- instructorId
- categoryId
- subcategoryId
- chapterNo
- lessonNo

---

### 7. Quizzes
Stores quiz information.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| $id | string | PK | Unique quiz identifier (Appwrite generated) |
| courseId | string | FK → Courses.$id | Course this quiz belongs to |
| title | string | NOT NULL | Quiz title |
| description | string | NOT NULL | Quiz description |
| timeLimit | integer | NOT NULL | Time limit in minutes |
| passingScore | integer | NOT NULL | Minimum score to pass |
| maxAttempts | integer | NULL | Maximum number of attempts allowed |
| attemptCount | integer | DEFAULT 0 | Total number of attempts by all users |
| isActive | boolean | DEFAULT true | Whether quiz is active |
| chapterNo | integer | NULL | Chapter number |
| lessonNo | integer | NULL | Lesson number |
| $createdAt | datetime | AUTO | Record creation timestamp |
| $updatedAt | datetime | AUTO | Record update timestamp |

**Indexes:**
- courseId
- isActive
- chapterNo
- lessonNo

---

### 8. QuizQuestions
Stores quiz questions and answers.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| $id | string | PK | Unique question identifier (Appwrite generated) |
| quizId | string | FK → Quizzes.$id | Quiz this question belongs to |
| question | string | NOT NULL | Question text |
| correctAnswer | string | NOT NULL | Correct answer(s) |
| explanation | string | NULL | Explanation for the correct answer |
| order | integer | NOT NULL | Question order in quiz |
| points | integer | DEFAULT 1 | Points awarded for correct answer |
| options | string[] | NOT NULL | Array of answer options |
| questionNo | integer | NULL | Question number |
| $createdAt | datetime | AUTO | Record creation timestamp |
| $updatedAt | datetime | AUTO | Record update timestamp |

**Indexes:**
- quizId
- order
- questionNo

---

### 9. QuizAttempts
Stores user quiz attempts and results.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| $id | string | PK | Unique attempt identifier (Appwrite generated) |
| userId | string | FK → Users.$id | User who took the quiz |
| quizId | string | FK → Quizzes.$id | Quiz that was attempted |
| answers | string | NOT NULL | JSON object of user's answers |
| score | integer | NOT NULL | Score achieved |
| totalQuestions | integer | NOT NULL | Total number of questions |
| timeTaken | integer | NULL | Time taken in minutes |
| passed | boolean | NOT NULL | Whether user passed |
| attemptedAt | datetime | NULL | When the quiz was attempted |
| $createdAt | datetime | AUTO | Record creation timestamp |
| $updatedAt | datetime | AUTO | Record update timestamp |

**Indexes:**
- userId
- quizId
- attemptedAt

---

### 10. Ranks
Stores user rankings for courses.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| $id | string | PK | Unique rank identifier (Appwrite generated) |
| userId | string | FK → Users.$id | User being ranked |
| courseId | string | FK → Courses.$id | Course the rank is for |
| score | integer | NOT NULL | User's score |
| rank | integer | NOT NULL | User's rank position |
| totalParticipants | integer | NOT NULL | Total number of participants |
| achievedAt | datetime | NULL | When the rank was achieved |
| $createdAt | datetime | AUTO | Record creation timestamp |
| $updatedAt | datetime | AUTO | Record update timestamp |

**Indexes:**
- userId
- courseId
- rank

---

### 11. Transactions
Stores payment and transaction records.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| $id | string | PK | Unique transaction identifier (Appwrite generated) |
| userId | string | FK → Users.$id | User who made the transaction |
| type | string | NOT NULL | Transaction type (purchase, refund, etc.) |
| amount | double | NOT NULL | Transaction amount |
| description | string | NOT NULL | Transaction description |
| courseId | string | FK → Courses.$id | Course purchased (if applicable) |
| status | string | NOT NULL | Transaction status (completed, pending, failed) |
| paymentMethod | string | NULL | Payment method used |
| $createdAt | datetime | AUTO | Record creation timestamp |
| $updatedAt | datetime | AUTO | Record update timestamp |

**Indexes:**
- userId
- type
- courseId

---

### 12. Notifications
Stores user notifications.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| $id | string | PK | Unique notification identifier (Appwrite generated) |
| userId | string | FK → Users.$id | User receiving the notification |
| title | string | NOT NULL | Notification title |
| message | string | NOT NULL | Notification message |
| type | string | NOT NULL | Notification type (info, warning, success) |
| isRead | boolean | DEFAULT false | Whether notification has been read |
| readAt | datetime | NULL | When the notification was read |
| $createdAt | datetime | AUTO | Record creation timestamp |
| $updatedAt | datetime | AUTO | Record update timestamp |

**Indexes:**
- userId
- isRead

---

### 13. Badges
Stores badge definitions.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| $id | string | PK | Unique badge identifier (Appwrite generated) |
| name | string | NOT NULL | Badge name |
| description | string | NOT NULL | Badge description |
| criteria | string | NOT NULL | Criteria to earn the badge |
| icon | string | NOT NULL | URL to badge icon |
| points | integer | DEFAULT 10 | Points awarded for earning badge |
| $createdAt | datetime | AUTO | Record creation timestamp |
| $updatedAt | datetime | AUTO | Record update timestamp |

**Indexes:**
- name

---

### 14. UserBadges
Junction table linking users to earned badges.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| $id | string | PK | Unique record identifier (Appwrite generated) |
| userId | string | FK → Users.$id | User who earned the badge |
| badgeId | string | FK → Badges.$id | Badge that was earned |
| earnedAt | datetime | NULL | When the badge was earned |
| $createdAt | datetime | AUTO | Record creation timestamp |
| $updatedAt | datetime | AUTO | Record update timestamp |

**Composite Unique:** (userId, badgeId)

**Indexes:**
- userId
- badgeId

---

### 15. UserProgress
Tracks user progress through lessons.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| $id | string | PK | Unique progress identifier (Appwrite generated) |
| userId | string | FK → Users.$id | User tracking progress |
| courseId | string | FK → Courses.$id | Course being tracked |
| lessonId | string | FK → Lessons.$id | Current lesson |
| completedAt | datetime | NULL | When the lesson was completed |
| progress | integer | NOT NULL | Progress percentage (0-100) |
| timeSpent | integer | NOT NULL | Time spent in minutes |
| $createdAt | datetime | AUTO | Record creation timestamp |
| $updatedAt | datetime | AUTO | Record update timestamp |

**Indexes:**
- userId
- courseId
- lessonId

---

## Relationships

### One-to-Many Relationships

1. **Instructors → Courses**
   - One instructor can teach many courses
   - `Courses.instructorId` → `Instructors.$id`

2. **Instructors → Lessons**
   - One instructor can create many lessons
   - `Lessons.instructorId` → `Instructors.$id`

3. **Categories → Subcategories**
   - One category can have many subcategories
   - `Subcategories.categoryId` → `Categories.$id`

4. **Categories → Lessons**
   - One category can have many lessons
   - `Lessons.categoryId` → `Categories.$id`

5. **Subcategories → Lessons**
   - One subcategory can have many lessons
   - `Lessons.subcategoryId` → `Subcategories.$id`

6. **Courses → Lessons**
   - One course can have many lessons
   - `Lessons.courseId` → `Courses.$id`

7. **Courses → Quizzes**
   - One course can have many quizzes
   - `Quizzes.courseId` → `Courses.$id`

8. **Quizzes → QuizQuestions**
   - One quiz can have many questions
   - `QuizQuestions.quizId` → `Quizzes.$id`

9. **Users → QuizAttempts**
   - One user can have many quiz attempts
   - `QuizAttempts.userId` → `Users.$id`

10. **Quizzes → QuizAttempts**
    - One quiz can have many attempts
    - `QuizAttempts.quizId` → `Quizzes.$id`

11. **Users → Transactions**
    - One user can have many transactions
    - `Transactions.userId` → `Users.$id`

12. **Courses → Transactions**
    - One course can have many transactions
    - `Transactions.courseId` → `Courses.$id`

13. **Users → Notifications**
    - One user can have many notifications
    - `Notifications.userId` → `Users.$id`

14. **Users → Ranks**
    - One user can have many ranks (across different courses)
    - `Ranks.userId` → `Users.$id`

15. **Courses → Ranks**
    - One course can have many ranks
    - `Ranks.courseId` → `Courses.$id`

16. **Users → UserProgress**
    - One user can have many progress records
    - `UserProgress.userId` → `Users.$id`

17. **Courses → UserProgress**
    - One course can have many progress records
    - `UserProgress.courseId` → `Courses.$id`

18. **Lessons → UserProgress**
    - One lesson can have many progress records
    - `UserProgress.lessonId` → `Lessons.$id`

### Many-to-Many Relationships

1. **Users ↔ Badges** (via UserBadges)
   - Many users can earn many badges
   - `UserBadges.userId` → `Users.$id`
   - `UserBadges.badgeId` → `Badges.$id`

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
