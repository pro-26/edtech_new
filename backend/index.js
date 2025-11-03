import * as sdk from 'node-appwrite';
import { logger } from './discord-logger.js';

// This is your Appwrite function
export default async ({ req, res, log, error }) => {
  // Initialize Appwrite client
  const client = new sdk.Client();
  client
    .setEndpoint(process.env.APPWRITE_FUNCTION_ENDPOINT || 'https://cloud.appwrite.io/v1')
    .setProject(process.env.APPWRITE_FUNCTION_PROJECT_ID)
    .setKey(process.env.APPWRITE_API_KEY);

  const databases = new sdk.Databases(client);
  const storage = new sdk.Storage(client);

  // Database and collection IDs
  const DATABASE_ID = process.env.DATABASE_ID || 'edtech_db';
  const COLLECTIONS = {
    USERS: 'users',
    INSTRUCTORS: 'instructors',
    COURSES: 'courses',
    LESSONS: 'lessons',
    QUIZZES: 'quizzes',
    QUIZ_QUESTIONS: 'quiz_questions',
    USER_PROGRESS: 'user_progress',
    QUIZ_ATTEMPTS: 'quiz_attempts',
    TRANSACTIONS: 'transactions',
    RANKS: 'ranks',
    BADGES: 'badges',
    USER_BADGES: 'user_badges',
    NOTIFICATIONS: 'notifications'
  };

  // CORS headers
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization, X-Appwrite-Project, X-Appwrite-Key',
    'Access-Control-Max-Age': '86400'
  };

  // Handle preflight requests
  if (req.method === 'OPTIONS') {
    return res.json({ message: 'OK' }, 200, corsHeaders);
  }

  // Helper function to handle errors
  const handleError = async (err, message = 'Internal Server Error') => {
    await logger.logError(`EdTech API Error: ${message}`, err);
    error(err);
    return res.json({ 
      success: false, 
      error: message,
      details: process.env.NODE_ENV === 'development' ? err.message : undefined
    }, 500, corsHeaders);
  };

  // Helper function to generate custom IDs
  const generateCustomId = (prefix) => {
    const randomNum = Math.floor(10000 + Math.random() * 90000); // Generate 5-digit random number
    return `${prefix}_${randomNum}`;
  };

  // Helper function to validate required fields
  const validateRequired = (data, fields) => {
    const missing = fields.filter(field => !data[field]);
    if (missing.length > 0) {
      throw new Error(`Missing required fields: ${missing.join(', ')}`);
    }
  };

  // Helper function to validate foreign key existence
  const validateForeignKey = async (collection, id, fieldName) => {
    if (!id) return; // Skip if ID is not provided
    try {
      await databases.getDocument(DATABASE_ID, collection, id);
    } catch (err) {
      if (err.code === 404 || err.message?.includes('not found')) {
        throw new Error(`Invalid ${fieldName}: ${id} does not exist in ${collection} collection`);
      }
      throw err;
    }
  };

  try {
    // Parse URL path
    const url = new URL(req.url, 'http://localhost');
    const pathSegments = url.pathname.split('/').filter(segment => segment);
    const [resource, id, subResource, subId] = pathSegments;

    log(`${req.method} ${url.pathname}`);
    await logger.logInfo(`API Request: ${req.method} ${url.pathname}`, { 
      userAgent: req.headers['user-agent'],
      ip: req.headers['x-forwarded-for'] || req.headers['x-real-ip']
    });

    // Health check
    if (req.method === 'GET' && (!resource || resource === 'health')) {
      return res.json({ 
        success: true, 
        message: 'EdTech API is running',
        timestamp: new Date().toISOString()
      }, 200, corsHeaders);
    }

    // Discord logger test endpoint
    if (req.method === 'GET' && resource === 'test-discord') {
      try {
        await logger.logSuccess('Discord Test', {
          message: 'Discord webhook is working correctly! 🎉',
          endpoint: '/test-discord',
          timestamp: new Date().toISOString(),
          status: 'Active'
        });
        
        await logger.logInfo('API Test Information', {
          testType: 'Discord Integration',
          result: 'Success',
          webhook: logger.enabled ? 'Enabled' : 'Disabled'
        });
        
        await logger.logWarning('Test Warning', {
          message: 'This is a test warning message',
          level: 'Warning'
        });
        
        return res.json({ 
          success: true, 
          message: 'Discord test messages sent successfully',
          webhookEnabled: logger.enabled,
          timestamp: new Date().toISOString()
        }, 200, corsHeaders);
      } catch (error) {
        await logger.logError('Discord Test Failed', error);
        return res.json({ 
          success: false, 
          message: 'Discord test failed',
          error: error.message
        }, 500, corsHeaders);
      }
    }

    const requestBody = req.bodyRaw ? JSON.parse(req.bodyRaw) : {};

    // USERS ENDPOINTS
    if (resource === 'users') {
      switch (req.method) {
        case 'GET':
          if (id) {
            // Get specific user
            const user = await databases.getDocument(DATABASE_ID, COLLECTIONS.USERS, id);
            return res.json({ success: true, data: user }, 200, corsHeaders);
          } else {
            // List all users
            const queryParams = [];
            if (url.searchParams.get('email')) {
              queryParams.push(sdk.Query.equal('email', url.searchParams.get('email')));
            }
            queryParams.push(sdk.Query.orderDesc('$createdAt'));
            
            const users = await databases.listDocuments(DATABASE_ID, COLLECTIONS.USERS, queryParams);
            return res.json({ 
              success: true, 
              data: users.documents,
              total: users.total
            }, 200, corsHeaders);
          }

        case 'POST':
          validateRequired(requestBody, ['name', 'email', 'password']);
          const newUser = await databases.createDocument(
            DATABASE_ID,
            COLLECTIONS.USERS,
            sdk.ID.unique(),
            requestBody
          );
          await logger.logInfo('User created', { userId: newUser.$id, email: newUser.email });
          return res.json({ success: true, data: newUser }, 201, corsHeaders);

        case 'PUT':
          if (!id) throw new Error('User ID is required');
          const updatedUser = await databases.updateDocument(
            DATABASE_ID,
            COLLECTIONS.USERS,
            id,
            requestBody
          );
          await logger.logInfo('User updated', { userId: id });
          return res.json({ success: true, data: updatedUser }, 200, corsHeaders);

        case 'DELETE':
          if (!id) throw new Error('User ID is required');
          await databases.deleteDocument(DATABASE_ID, COLLECTIONS.USERS, id);
          await logger.logInfo('User deleted', { userId: id });
          return res.json({ success: true, message: 'User deleted' }, 200, corsHeaders);
      }
    }

    // INSTRUCTORS ENDPOINTS
    if (resource === 'instructors') {
      switch (req.method) {
        case 'GET':
          if (id) {
            // Get specific instructor
            const instructor = await databases.getDocument(DATABASE_ID, COLLECTIONS.INSTRUCTORS, id);
            return res.json({ success: true, data: instructor }, 200, corsHeaders);
          } else {
            // List all instructors
            const queryParams = [sdk.Query.orderAsc('instructorName')];
            const instructors = await databases.listDocuments(DATABASE_ID, COLLECTIONS.INSTRUCTORS, queryParams);
            return res.json({ 
              success: true, 
              data: instructors.documents,
              total: instructors.total
            }, 200, corsHeaders);
          }

        case 'POST':
          validateRequired(requestBody, ['instructorName']);
          const newInstructor = await databases.createDocument(
            DATABASE_ID,
            COLLECTIONS.INSTRUCTORS,
            generateCustomId('INSTRUCTOR'),
            requestBody
          );
          await logger.logInfo('Instructor created', { instructorId: newInstructor.$id, name: newInstructor.instructorName });
          return res.json({ success: true, data: newInstructor }, 201, corsHeaders);

        case 'PUT':
          if (!id) throw new Error('Instructor ID is required');
          const updatedInstructor = await databases.updateDocument(
            DATABASE_ID,
            COLLECTIONS.INSTRUCTORS,
            id,
            requestBody
          );
          await logger.logInfo('Instructor updated', { instructorId: id });
          return res.json({ success: true, data: updatedInstructor }, 200, corsHeaders);

        case 'DELETE':
          if (!id) throw new Error('Instructor ID is required');
          await databases.deleteDocument(DATABASE_ID, COLLECTIONS.INSTRUCTORS, id);
          await logger.logInfo('Instructor deleted', { instructorId: id });
          return res.json({ success: true, message: 'Instructor deleted' }, 200, corsHeaders);
      }
    }

    // COURSES ENDPOINTS
    if (resource === 'courses') {
      switch (req.method) {
        case 'GET':
          if (id) {
            // Get specific course
            const course = await databases.getDocument(DATABASE_ID, COLLECTIONS.COURSES, id);
            // Get course lessons
            const lessons = await databases.listDocuments(DATABASE_ID, COLLECTIONS.LESSONS, [
              sdk.Query.equal('courseId', id),
              sdk.Query.orderAsc('order')
            ]);
            return res.json({ 
              success: true, 
              data: { ...course, lessons: lessons.documents }
            }, 200, corsHeaders);
          } else {
            // List all courses
            const queryParams = [];
            if (url.searchParams.get('category')) {
              queryParams.push(sdk.Query.equal('category', url.searchParams.get('category')));
            }
            if (url.searchParams.get('instructor')) {
              queryParams.push(sdk.Query.equal('instructorId', url.searchParams.get('instructor')));
            }
            queryParams.push(sdk.Query.orderDesc('$createdAt'));
            
            const courses = await databases.listDocuments(DATABASE_ID, COLLECTIONS.COURSES, queryParams);
            return res.json({ 
              success: true, 
              data: courses.documents,
              total: courses.total
            }, 200, corsHeaders);
          }

        case 'POST':
          validateRequired(requestBody, ['title', 'description', 'instructorId', 'category', 'price']);
          // Validate instructorId exists
          await validateForeignKey(COLLECTIONS.INSTRUCTORS, requestBody.instructorId, 'instructorId');
          const newCourse = await databases.createDocument(
            DATABASE_ID,
            COLLECTIONS.COURSES,
            generateCustomId('COURSE'),
            {
              ...requestBody,
              enrollmentCount: 0,
              isPublished: false
            }
          );
          await logger.logInfo('Course created', { courseId: newCourse.$id, title: newCourse.title });
          return res.json({ success: true, data: newCourse }, 201, corsHeaders);

        case 'PUT':
          if (!id) throw new Error('Course ID is required');
          // Validate instructorId if being updated
          if (requestBody.instructorId) {
            await validateForeignKey(COLLECTIONS.INSTRUCTORS, requestBody.instructorId, 'instructorId');
          }
          const updatedCourse = await databases.updateDocument(
            DATABASE_ID,
            COLLECTIONS.COURSES,
            id,
            { ...requestBody }
          );
          await logger.logInfo('Course updated', { courseId: id });
          return res.json({ success: true, data: updatedCourse }, 200, corsHeaders);

        case 'DELETE':
          if (!id) throw new Error('Course ID is required');
          await databases.deleteDocument(DATABASE_ID, COLLECTIONS.COURSES, id);
          await logger.logInfo('Course deleted', { courseId: id });
          return res.json({ success: true, message: 'Course deleted' }, 200, corsHeaders);
      }
    }

    // LESSONS ENDPOINTS
    if (resource === 'lessons') {
      switch (req.method) {
        case 'GET':
          if (id) {
            const lesson = await databases.getDocument(DATABASE_ID, COLLECTIONS.LESSONS, id);
            return res.json({ success: true, data: lesson }, 200, corsHeaders);
          } else {
            const courseId = url.searchParams.get('courseId');
            const queryParams = courseId ? [sdk.Query.equal('courseId', courseId)] : [];
            queryParams.push(sdk.Query.orderAsc('order'));
            
            const lessons = await databases.listDocuments(DATABASE_ID, COLLECTIONS.LESSONS, queryParams);
            return res.json({ 
              success: true, 
              data: lessons.documents,
              total: lessons.total
            }, 200, corsHeaders);
          }

        case 'POST':
          validateRequired(requestBody, ['courseId', 'instructorId', 'title', 'content', 'type']);
          // Validate foreign keys exist
          await validateForeignKey(COLLECTIONS.COURSES, requestBody.courseId, 'courseId');
          await validateForeignKey(COLLECTIONS.INSTRUCTORS, requestBody.instructorId, 'instructorId');
          const newLesson = await databases.createDocument(
            DATABASE_ID,
            COLLECTIONS.LESSONS,
            generateCustomId('LESSON'),
            {
              ...requestBody,
              completionCount: 0
            }
          );
          return res.json({ success: true, data: newLesson }, 201, corsHeaders);

        case 'PUT':
          if (!id) throw new Error('Lesson ID is required');
          // Validate foreign keys if being updated
          if (requestBody.courseId) {
            await validateForeignKey(COLLECTIONS.COURSES, requestBody.courseId, 'courseId');
          }
          if (requestBody.instructorId) {
            await validateForeignKey(COLLECTIONS.INSTRUCTORS, requestBody.instructorId, 'instructorId');
          }
          const updatedLesson = await databases.updateDocument(
            DATABASE_ID,
            COLLECTIONS.LESSONS,
            id,
            { ...requestBody }
          );
          return res.json({ success: true, data: updatedLesson }, 200, corsHeaders);

        case 'DELETE':
          if (!id) throw new Error('Lesson ID is required');
          await databases.deleteDocument(DATABASE_ID, COLLECTIONS.LESSONS, id);
          return res.json({ success: true, message: 'Lesson deleted' }, 200, corsHeaders);
      }
    }

    // QUIZZES ENDPOINTS
    if (resource === 'quizzes') {
      switch (req.method) {
        case 'GET':
          if (id) {
            const quiz = await databases.getDocument(DATABASE_ID, COLLECTIONS.QUIZZES, id);
            // Get quiz questions
            const questions = await databases.listDocuments(DATABASE_ID, COLLECTIONS.QUIZ_QUESTIONS, [
              sdk.Query.equal('quizId', id),
              sdk.Query.orderAsc('order')
            ]);
            return res.json({ 
              success: true, 
              data: { ...quiz, questions: questions.documents }
            }, 200, corsHeaders);
          } else {
            const courseId = url.searchParams.get('courseId');
            const queryParams = courseId ? [sdk.Query.equal('courseId', courseId)] : [];
            queryParams.push(sdk.Query.orderDesc('$createdAt'));
            
            const quizzes = await databases.listDocuments(DATABASE_ID, COLLECTIONS.QUIZZES, queryParams);
            return res.json({ 
              success: true, 
              data: quizzes.documents,
              total: quizzes.total
            }, 200, corsHeaders);
          }

        case 'POST':
          validateRequired(requestBody, ['courseId', 'title', 'description', 'timeLimit', 'passingScore']);
          // Validate courseId exists
          await validateForeignKey(COLLECTIONS.COURSES, requestBody.courseId, 'courseId');
          const newQuiz = await databases.createDocument(
            DATABASE_ID,
            COLLECTIONS.QUIZZES,
            generateCustomId('QUIZ'),
            {
              ...requestBody,
              attemptCount: 0
            }
          );
          return res.json({ success: true, data: newQuiz }, 201, corsHeaders);

        case 'PUT':
          if (!id) throw new Error('Quiz ID is required');
          // Validate courseId if being updated
          if (requestBody.courseId) {
            await validateForeignKey(COLLECTIONS.COURSES, requestBody.courseId, 'courseId');
          }
          const updatedQuiz = await databases.updateDocument(
            DATABASE_ID,
            COLLECTIONS.QUIZZES,
            id,
            { ...requestBody }
          );
          return res.json({ success: true, data: updatedQuiz }, 200, corsHeaders);

        case 'DELETE':
          if (!id) throw new Error('Quiz ID is required');
          await databases.deleteDocument(DATABASE_ID, COLLECTIONS.QUIZZES, id);
          return res.json({ success: true, message: 'Quiz deleted' }, 200, corsHeaders);
      }
    }

    // QUIZ QUESTIONS ENDPOINTS
    if (resource === 'quiz-questions') {
      switch (req.method) {
        case 'GET':
          const quizId = url.searchParams.get('quizId');
          const queryParams = quizId ? [sdk.Query.equal('quizId', quizId)] : [];
          queryParams.push(sdk.Query.orderAsc('order'));
          
          const questions = await databases.listDocuments(DATABASE_ID, COLLECTIONS.QUIZ_QUESTIONS, queryParams);
          return res.json({ 
            success: true, 
            data: questions.documents,
            total: questions.total
          }, 200, corsHeaders);

        case 'POST':
          validateRequired(requestBody, ['quizId', 'question', 'options', 'correctAnswer']);
          // Validate quizId exists
          await validateForeignKey(COLLECTIONS.QUIZZES, requestBody.quizId, 'quizId');
          const newQuestion = await databases.createDocument(
            DATABASE_ID,
            COLLECTIONS.QUIZ_QUESTIONS,
            generateCustomId('QUESTION'),
            requestBody
          );
          return res.json({ success: true, data: newQuestion }, 201, corsHeaders);

        case 'PUT':
          if (!id) throw new Error('Question ID is required');
          // Validate quizId if being updated
          if (requestBody.quizId) {
            await validateForeignKey(COLLECTIONS.QUIZZES, requestBody.quizId, 'quizId');
          }
          const updatedQuestion = await databases.updateDocument(
            DATABASE_ID,
            COLLECTIONS.QUIZ_QUESTIONS,
            id,
            requestBody
          );
          return res.json({ success: true, data: updatedQuestion }, 200, corsHeaders);

        case 'DELETE':
          if (!id) throw new Error('Question ID is required');
          await databases.deleteDocument(DATABASE_ID, COLLECTIONS.QUIZ_QUESTIONS, id);
          return res.json({ success: true, message: 'Question deleted' }, 200, corsHeaders);
      }
    }

    // USER PROGRESS ENDPOINTS
    if (resource === 'progress') {
      switch (req.method) {
        case 'GET':
          const userId = url.searchParams.get('userId');
          const courseId = url.searchParams.get('courseId');
          const queryParams = [];
          
          if (userId) queryParams.push(sdk.Query.equal('userId', userId));
          if (courseId) queryParams.push(sdk.Query.equal('courseId', courseId));
          
          const progress = await databases.listDocuments(DATABASE_ID, COLLECTIONS.USER_PROGRESS, queryParams);
          return res.json({ 
            success: true, 
            data: progress.documents,
            total: progress.total
          }, 200, corsHeaders);

        case 'POST':
          validateRequired(requestBody, ['userId', 'courseId', 'lessonId']);
          // Validate foreign keys exist
          await validateForeignKey(COLLECTIONS.USERS, requestBody.userId, 'userId');
          await validateForeignKey(COLLECTIONS.COURSES, requestBody.courseId, 'courseId');
          await validateForeignKey(COLLECTIONS.LESSONS, requestBody.lessonId, 'lessonId');
          // Check if progress already exists
          const existingProgress = await databases.listDocuments(DATABASE_ID, COLLECTIONS.USER_PROGRESS, [
            sdk.Query.equal('userId', requestBody.userId),
            sdk.Query.equal('courseId', requestBody.courseId),
            sdk.Query.equal('lessonId', requestBody.lessonId)
          ]);

          if (existingProgress.documents.length > 0) {
            // Update existing progress
            const updated = await databases.updateDocument(
              DATABASE_ID,
              COLLECTIONS.USER_PROGRESS,
              existingProgress.documents[0].$id,
              {
                ...requestBody
              }
            );
            return res.json({ success: true, data: updated }, 200, corsHeaders);
          } else {
            // Create new progress
            const newProgress = await databases.createDocument(
              DATABASE_ID,
              COLLECTIONS.USER_PROGRESS,
              generateCustomId('PROGRESS'),
              {
                ...requestBody
              }
            );
            return res.json({ success: true, data: newProgress }, 201, corsHeaders);
          }
      }
    }

    // QUIZ ATTEMPTS ENDPOINTS
    if (resource === 'quiz-attempts') {
      switch (req.method) {
        case 'GET':
          const userId = url.searchParams.get('userId');
          const quizId = url.searchParams.get('quizId');
          const queryParams = [];
          
          if (userId) queryParams.push(sdk.Query.equal('userId', userId));
          if (quizId) queryParams.push(sdk.Query.equal('quizId', quizId));
          queryParams.push(sdk.Query.orderDesc('$createdAt'));
          
          const attempts = await databases.listDocuments(DATABASE_ID, COLLECTIONS.QUIZ_ATTEMPTS, queryParams);
          return res.json({ 
            success: true, 
            data: attempts.documents,
            total: attempts.total
          }, 200, corsHeaders);

        case 'POST':
          validateRequired(requestBody, ['userId', 'quizId', 'answers', 'score', 'totalQuestions']);
          // Validate foreign keys exist
          await validateForeignKey(COLLECTIONS.USERS, requestBody.userId, 'userId');
          await validateForeignKey(COLLECTIONS.QUIZZES, requestBody.quizId, 'quizId');
          const newAttempt = await databases.createDocument(
            DATABASE_ID,
            COLLECTIONS.QUIZ_ATTEMPTS,
            generateCustomId('ATTEMPT'),
            {
              ...requestBody,
              attemptedAt: new Date().toISOString(),
              passed: requestBody.score >= requestBody.passingScore
            }
          );
          
          // Update quiz attempt count
          const quiz = await databases.getDocument(DATABASE_ID, COLLECTIONS.QUIZZES, requestBody.quizId);
          await databases.updateDocument(
            DATABASE_ID,
            COLLECTIONS.QUIZZES,
            requestBody.quizId,
            { attemptCount: (quiz.attemptCount || 0) + 1 }
          );

          return res.json({ success: true, data: newAttempt }, 201, corsHeaders);
      }
    }

    // TRANSACTIONS ENDPOINTS
    if (resource === 'transactions') {
      switch (req.method) {
        case 'GET':
          const userId = url.searchParams.get('userId');
          const queryParams = userId ? [sdk.Query.equal('userId', userId)] : [];
          queryParams.push(sdk.Query.orderDesc('$createdAt'));
          
          const transactions = await databases.listDocuments(DATABASE_ID, COLLECTIONS.TRANSACTIONS, queryParams);
          return res.json({ 
            success: true, 
            data: transactions.documents,
            total: transactions.total
          }, 200, corsHeaders);

        case 'POST':
          validateRequired(requestBody, ['userId', 'type', 'amount', 'description']);
          // Validate foreign keys exist
          await validateForeignKey(COLLECTIONS.USERS, requestBody.userId, 'userId');
          if (requestBody.courseId) {
            await validateForeignKey(COLLECTIONS.COURSES, requestBody.courseId, 'courseId');
          }
          const newTransaction = await databases.createDocument(
            DATABASE_ID,
            COLLECTIONS.TRANSACTIONS,
            generateCustomId('TRANSACTION'),
            {
              ...requestBody,
              status: 'completed'
            }
          );
          return res.json({ success: true, data: newTransaction }, 201, corsHeaders);
      }
    }

    // RANKS ENDPOINTS
    if (resource === 'ranks') {
      switch (req.method) {
        case 'GET':
          const courseId = url.searchParams.get('courseId');
          const queryParams = courseId ? [sdk.Query.equal('courseId', courseId)] : [];
          queryParams.push(sdk.Query.orderAsc('rank'));
          
          const ranks = await databases.listDocuments(DATABASE_ID, COLLECTIONS.RANKS, queryParams);
          return res.json({ 
            success: true, 
            data: ranks.documents,
            total: ranks.total
          }, 200, corsHeaders);

        case 'POST':
          validateRequired(requestBody, ['userId', 'courseId', 'score', 'rank']);
          // Validate foreign keys exist
          await validateForeignKey(COLLECTIONS.USERS, requestBody.userId, 'userId');
          await validateForeignKey(COLLECTIONS.COURSES, requestBody.courseId, 'courseId');
          const newRank = await databases.createDocument(
            DATABASE_ID,
            COLLECTIONS.RANKS,
            generateCustomId('RANK'),
            {
              ...requestBody,
              achievedAt: new Date().toISOString()
            }
          );
          return res.json({ success: true, data: newRank }, 201, corsHeaders);
      }
    }

    // BADGES ENDPOINTS
    if (resource === 'badges') {
      switch (req.method) {
        case 'GET':
          const badges = await databases.listDocuments(DATABASE_ID, COLLECTIONS.BADGES, [
            sdk.Query.orderAsc('name')
          ]);
          return res.json({ 
            success: true, 
            data: badges.documents,
            total: badges.total
          }, 200, corsHeaders);

        case 'POST':
          validateRequired(requestBody, ['name', 'description', 'category', 'icon']);
          const newBadge = await databases.createDocument(
            DATABASE_ID,
            COLLECTIONS.BADGES,
            generateCustomId('BADGE'),
            {
              ...requestBody
            }
          );
          return res.json({ success: true, data: newBadge }, 201, corsHeaders);
      }
    }

    // USER BADGES ENDPOINTS
    if (resource === 'user-badges') {
      switch (req.method) {
        case 'GET':
          const userId = url.searchParams.get('userId');
          const queryParams = userId ? [sdk.Query.equal('userId', userId)] : [];
          queryParams.push(sdk.Query.orderDesc('$createdAt'));
          
          const userBadges = await databases.listDocuments(DATABASE_ID, COLLECTIONS.USER_BADGES, queryParams);
          return res.json({ 
            success: true, 
            data: userBadges.documents,
            total: userBadges.total
          }, 200, corsHeaders);

        case 'POST':
          validateRequired(requestBody, ['userId', 'badgeId']);
          // Validate foreign keys exist
          await validateForeignKey(COLLECTIONS.USERS, requestBody.userId, 'userId');
          await validateForeignKey(COLLECTIONS.BADGES, requestBody.badgeId, 'badgeId');
          const newUserBadge = await databases.createDocument(
            DATABASE_ID,
            COLLECTIONS.USER_BADGES,
            generateCustomId('USERBADGE'),
            {
              ...requestBody,
              earnedAt: new Date().toISOString()
            }
          );
          return res.json({ success: true, data: newUserBadge }, 201, corsHeaders);
      }
    }

    // NOTIFICATIONS ENDPOINTS
    if (resource === 'notifications') {
      switch (req.method) {
        case 'GET':
          const userId = url.searchParams.get('userId');
          const queryParams = userId ? [sdk.Query.equal('userId', userId)] : [];
          queryParams.push(sdk.Query.orderDesc('$createdAt'));
          
          const notifications = await databases.listDocuments(DATABASE_ID, COLLECTIONS.NOTIFICATIONS, queryParams);
          return res.json({ 
            success: true, 
            data: notifications.documents,
            total: notifications.total
          }, 200, corsHeaders);

        case 'POST':
          validateRequired(requestBody, ['userId', 'title', 'message', 'type']);
          // Validate userId exists
          await validateForeignKey(COLLECTIONS.USERS, requestBody.userId, 'userId');
          const newNotification = await databases.createDocument(
            DATABASE_ID,
            COLLECTIONS.NOTIFICATIONS,
            generateCustomId('NOTIFICATION'),
            {
              ...requestBody,
              isRead: false
            }
          );
          return res.json({ success: true, data: newNotification }, 201, corsHeaders);

        case 'PUT':
          if (!id) throw new Error('Notification ID is required');
          const updatedNotification = await databases.updateDocument(
            DATABASE_ID,
            COLLECTIONS.NOTIFICATIONS,
            id,
            { isRead: true, readAt: new Date().toISOString() }
          );
          return res.json({ success: true, data: updatedNotification }, 200, corsHeaders);
      }
    }

    // FILE UPLOAD ENDPOINTS
    if (resource === 'upload') {
      if (req.method === 'POST') {
        // This would handle file uploads to Appwrite Storage
        // Implementation depends on how files are sent from frontend
        return res.json({ 
          success: false, 
          error: 'File upload endpoint not implemented yet' 
        }, 501, corsHeaders);
      }
    }

    // Default response for unknown endpoints
    return res.json({ 
      success: false, 
      error: 'Endpoint not found',
      availableEndpoints: [
        'GET /health',
        'GET|POST|PUT|DELETE /users',
        'GET|POST|PUT|DELETE /instructors',
        'GET|POST|PUT|DELETE /courses',
        'GET|POST|PUT|DELETE /lessons',
        'GET|POST|PUT|DELETE /quizzes',
        'GET|POST|PUT|DELETE /quiz-questions',
        'GET|POST /progress',
        'GET|POST /quiz-attempts',
        'GET|POST /transactions',
        'GET|POST /ranks',
        'GET|POST /badges',
        'GET|POST /user-badges',
        'GET|POST|PUT /notifications'
      ]
    }, 404, corsHeaders);

  } catch (err) {
    return await handleError(err, 'An error occurred processing your request');
  }
};


