# Schema Update Summary - Version 2.0
**Date:** November 5, 2025

## Overview
This document summarizes the major schema changes implemented in the EdTech platform database, transitioning from the initial 13-table design to a comprehensive 15-table architecture with enhanced tracking and hierarchical organization.

## Major Changes

### 1. New Collections Added

#### Categories Collection (Table 3)
- **Purpose:** Top-level content categorization
- **Fields:**
  - `$id` (string, PK) - Appwrite auto-generated ID
  - `categoryName` (string, required) - Category name
  - `$createdAt` (datetime, auto)
  - `$updatedAt` (datetime, auto)
- **Indexes:** categoryName (key), categoryName (unique)

#### Subcategories Collection (Table 4)
- **Purpose:** Second-level content categorization
- **Fields:**
  - `$id` (string, PK) - Appwrite auto-generated ID
  - `categoryId` (string, FK → Categories.$id, required)
  - `subcategoryName` (string, required)
  - `$createdAt` (datetime, auto)
  - `$updatedAt` (datetime, auto)
- **Indexes:** categoryId (key), subcategoryName (key), composite unique (categoryId, subcategoryName)
- **Relationships:** Many-to-one with Categories

### 2. ID Convention Changes

**From:** Custom ID types (int userId, string courseId, string lessonId, etc.)  
**To:** Unified Appwrite `$id` (string) for all primary keys

**Impact:** All tables now use Appwrite's auto-generated `$id` field as primary key. Foreign key references updated to point to `$id` instead of custom ID fields.

### 3. Enhanced Field Additions

#### Lessons Collection Updates
**New Fields:**
- `thumbnail` (string, optional) - Lesson thumbnail URL
- `categoryId` (string, FK → Categories.$id, optional) - Category reference
- `subcategoryId` (string, FK → Subcategories.$id, optional) - Subcategory reference
- `chapterNo` (integer, optional) - Chapter number for organization
- `lessonNo` (integer, optional) - Lesson number within chapter

**New Indexes:** categoryId, subcategoryId, chapterNo, lessonNo

#### Quizzes Collection Updates
**New Fields:**
- `chapterNo` (integer, optional) - Chapter number
- `lessonNo` (integer, optional) - Lesson number

**New Indexes:** chapterNo, lessonNo

#### Quiz Questions Collection Updates
**New Fields:**
- `questionNo` (integer, optional) - Question number within quiz

**Field Type Changes:**
- `options` - Now explicitly defined as string array (string[])

**New Indexes:** questionNo

### 4. Datetime Tracking Enhancements

Added timestamp fields for better activity tracking:

#### Quiz Attempts Collection
- `attemptedAt` (datetime, optional) - When quiz was attempted

#### Ranks Collection
- `achievedAt` (datetime, optional) - When rank was achieved

#### Notifications Collection
- `readAt` (datetime, optional) - When notification was read

#### User Badges Collection
- `earnedAt` (datetime, optional) - When badge was earned

#### User Progress Collection
- `completedAt` (datetime, optional) - When lesson was completed
  - **Auto-setting:** Automatically set when progress reaches 100%

### 5. Badge Schema Correction

**Changed:** Field name from `category` back to `criteria`
- **Old:** `category` (string) - Badge category
- **New:** `criteria` (string, required) - Badge earning criteria

**Reason:** Aligns with original design intent and avoids confusion with Categories collection

### 6. Appwrite Convention Alignment

All collections now follow Appwrite best practices:
- Use `$id` instead of custom primary keys
- Include `$createdAt` and `$updatedAt` auto-managed fields
- Simplified document structure
- Consistent field naming

## Relationship Updates

### New Relationships
1. **Categories → Subcategories** (One-to-Many)
   - One category has many subcategories
   - FK: Subcategories.categoryId → Categories.$id

2. **Categories → Lessons** (One-to-Many)
   - One category has many lessons
   - FK: Lessons.categoryId → Categories.$id

3. **Subcategories → Lessons** (One-to-Many)
   - One subcategory has many lessons
   - FK: Lessons.subcategoryId → Subcategories.$id

### Updated Relationships
All foreign key references updated to use `$id` format:
- Users.$id (referenced by Quiz Attempts, Ranks, Transactions, Notifications, User Badges, User Progress)
- Instructors.$id (referenced by Courses, Lessons)
- Courses.$id (referenced by Lessons, Quizzes, Ranks, Transactions, User Progress)
- And all other FK relationships...

## Backend Implementation Status

### ✅ Completed

1. **index.js Updates:**
   - Added CATEGORIES and SUBCATEGORIES to COLLECTIONS constant
   - Implemented Categories endpoint (GET, POST, PUT, DELETE)
   - Implemented Subcategories endpoint with foreign key validation
   - Updated Lessons POST/PUT to validate categoryId and subcategoryId
   - Reverted Badges to use 'criteria' field
   - Added completedAt auto-setting in User Progress when progress === 100%
   - Updated available endpoints list

2. **DATABASE_SCHEMA.md:**
   - Completely rewritten with all 15 tables
   - All fields documented with Appwrite conventions
   - All datetime tracking fields included
   - Complete relationship diagram
   - Updated to reflect Nov 5, 2025 schema

3. **appwrite-setup.md:**
   - Updated Collection Attributes for all 15 collections
   - Removed custom ID fields, now using $id
   - Added new fields to all relevant collections
   - Updated Indexes section with new fields and collections
   - Updated Database Permissions to include Categories and Subcategories

### 🔄 Pending

1. **Postman Collection Updates:**
   - Add Categories folder with 4 requests (GET all, GET by ID, POST, PUT, DELETE)
   - Add Subcategories folder with 5 requests (GET all, GET by ID, GET filtered, POST, PUT, DELETE)
   - Update Lessons Create request body with new fields
   - Update Quizzes Create request body with new fields
   - Update Quiz Questions Create request body with new fields
   - Update Badges Create request to use 'criteria' instead of 'category'
   - Add documentation for auto-setting completedAt

2. **Frontend Updates:**
   - Update Flutter admin panel to support Categories/Subcategories management
   - Add UI for chapter/lesson numbering
   - Add question numbering interface
   - Update forms to include new fields

## Migration Considerations

### For Existing Data

If you have existing data, consider these migration steps:

1. **Appwrite ID Migration:**
   - Existing custom IDs (userId, courseId, etc.) will be replaced by Appwrite's $id
   - Update all foreign key references in existing documents
   - Use Appwrite SDK to migrate documents programmatically

2. **New Fields:**
   - All new fields are optional (except in Categories/Subcategories)
   - Existing documents will work without these fields
   - Can be populated incrementally

3. **Badge Field Rename:**
   - If you have badges with 'category' field, rename to 'criteria'
   - Update any client code referencing badge.category

4. **Datetime Fields:**
   - Will be null for existing records
   - New records will auto-populate where applicable

### Recommended Migration Script

```javascript
// Example migration pseudocode
const databases = new Databases(client);

// 1. Migrate existing documents to use $id
// 2. Populate categoryId/subcategoryId where applicable
// 3. Rename badge.category to badge.criteria
// 4. Add indexes for new fields
// 5. Verify foreign key integrity
```

## Testing Checklist

- [ ] Categories CRUD operations
- [ ] Subcategories CRUD operations with FK validation
- [ ] Lessons creation with categoryId and subcategoryId
- [ ] Quiz creation with chapterNo and lessonNo
- [ ] Quiz Questions with questionNo
- [ ] Badges using 'criteria' field
- [ ] User Progress completedAt auto-setting
- [ ] All datetime field tracking
- [ ] All foreign key validations
- [ ] Index performance on new fields

## API Endpoint Changes

### New Endpoints

```
GET    /categories          - List all categories
GET    /categories?id=xxx   - Get category by ID
POST   /categories          - Create category (requires: categoryName)
PUT    /categories/:id      - Update category
DELETE /categories/:id      - Delete category

GET    /subcategories                - List all subcategories
GET    /subcategories?id=xxx         - Get subcategory by ID
GET    /subcategories?categoryId=xxx - Filter by category
POST   /subcategories                - Create subcategory (requires: categoryId, subcategoryName)
PUT    /subcategories/:id            - Update subcategory
DELETE /subcategories/:id            - Delete subcategory
```

### Updated Endpoints

```
POST /lessons   - Now accepts: thumbnail, categoryId, subcategoryId, chapterNo, lessonNo
PUT  /lessons   - Now accepts: thumbnail, categoryId, subcategoryId, chapterNo, lessonNo
POST /quizzes   - Now accepts: chapterNo, lessonNo
POST /quiz-questions - Now accepts: questionNo
POST /badges    - Now requires 'criteria' instead of 'category'
POST /user-progress - Auto-sets completedAt when progress === 100
```

## Documentation Updates

All documentation files have been updated:
- ✅ DATABASE_SCHEMA.md - Complete rewrite with all 15 tables
- ✅ appwrite-setup.md - Collection attributes, indexes, and permissions updated
- ✅ index.js - All endpoints implemented with validation
- ✅ SCHEMA_UPDATE_SUMMARY_v2.md - This document
- 🔄 edtech-api.postman_collection.json - Pending update

## Summary Statistics

| Metric | Before | After | Change |
|--------|--------|-------|--------|
| Total Collections | 13 | 15 | +2 |
| Total Fields (approx) | ~85 | ~100 | +15 |
| DateTime Tracking Fields | 0 | 5 | +5 |
| Hierarchical Levels | 1 | 3 | +2 |
| Foreign Key Validations | 8 | 11 | +3 |
| API Endpoints | 13 | 15 | +2 |

## Key Benefits

1. **Hierarchical Organization:** Categories → Subcategories → Lessons provides flexible content structure
2. **Better Tracking:** DateTime fields enable analytics and activity monitoring
3. **Simplified IDs:** Appwrite $id convention reduces complexity
4. **Enhanced Validation:** Foreign key checks ensure data integrity
5. **Improved Organization:** Chapter/Lesson/Question numbering enables sequential ordering
6. **Auto-completion:** User Progress automatically tracks completion timestamps

## Contact & Support

For questions about this schema update:
- Review DATABASE_SCHEMA.md for complete field specifications
- Check appwrite-setup.md for setup instructions
- Test with Postman collection (after update)
- Review backend/index.js for implementation details

---
**Last Updated:** November 5, 2025  
**Version:** 2.0  
**Status:** Backend Complete, Documentation Updated, Postman Pending
