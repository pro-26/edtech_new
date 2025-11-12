# Backend Deployment Guide

## Issue Identified
The Appwrite function currently deployed is an **older version** that's missing the following endpoints:
- `GET|POST|PUT|DELETE /users`
- `GET|POST|PUT|DELETE /instructors`
- `GET|POST|PUT|DELETE /categories`
- `GET|POST|PUT|DELETE /subcategories`

Your local `backend/index.js` file has all these endpoints correctly implemented.

## Solution: Deploy Updated Code

### Option 1: Deploy via Appwrite Console (Recommended)

1. **Prepare the deployment package:**
   ```powershell
   cd backend
   # Create a zip file with your code
   Compress-Archive -Path index.js,discord-logger.js,package.json -DestinationPath deployment.zip -Force
   ```

2. **Upload to Appwrite:**
   - Open Appwrite Console: https://cloud.appwrite.io
   - Navigate to: Functions → "edtech app" → Deployments tab
   - Click "Create deployment"
   - Upload `deployment.zip`
   - Wait for build to complete
   - Once status shows "Ready", the new deployment is active

3. **Verify deployment:**
   - Go to Executions tab
   - Make a test request to `/health`
   - Check the response includes all endpoints

### Option 2: Deploy via Appwrite CLI

1. **Install Appwrite CLI** (if not already installed):
   ```powershell
   npm install -g appwrite-cli
   ```

2. **Login to Appwrite:**
   ```powershell
   appwrite login
   ```

3. **Deploy the function:**
   ```powershell
   cd backend
   appwrite functions createDeployment --functionId=<YOUR_FUNCTION_ID> --entrypoint="index.js" --code="."
   ```

### Option 3: Deploy via Git Integration

If your function is linked to a Git repository:
1. Commit and push your changes to the linked branch
2. Appwrite will automatically detect changes and deploy
3. Check Deployments tab for status

## Environment Variables to Set

Make sure these environment variables are configured in your function settings:

```
DATABASE_ID=edtech_db
APPWRITE_API_KEY=<your-api-key>
APPWRITE_FUNCTION_ENDPOINT=https://cloud.appwrite.io/v1
APPWRITE_FUNCTION_PROJECT_ID=<your-project-id>
DISCORD_WEBHOOK_URL=<your-discord-webhook-url> (optional)
NODE_ENV=production (or development for detailed errors)
```

## Testing After Deployment

Use these Postman requests to verify all endpoints work:

### Test Categories
```
GET https://68c2a1d90003e461b539.fra.appwrite.run/categories
```

### Test Subcategories
```
GET https://68c2a1d90003e461b539.fra.appwrite.run/subcategories
```

### Test Instructors
```
GET https://68c2a1d90003e461b539.fra.appwrite.run/instructors
```

### Test Users (may require authentication)
```
GET https://68c2a1d90003e461b539.fra.appwrite.run/users
```

## Troubleshooting

### If you still see "Endpoint not found":
1. Check Deployments tab - ensure latest deployment is "Active"
2. Check Executions tab - view logs for the request
3. Verify the deployment includes all files (index.js, discord-logger.js, package.json)
4. Check function settings - ensure Runtime is set correctly (Node.js 18 or later)

### If you see authentication errors:
- Ensure APPWRITE_API_KEY environment variable is set
- Verify the API key has correct permissions for database operations
- Check that DATABASE_ID matches your actual database ID

## Quick Verification Command

Run this PowerShell command to test if endpoints are available:

```powershell
$response = Invoke-RestMethod -Method GET -Uri 'https://68c2a1d90003e461b539.fra.appwrite.run/categories' -ErrorAction SilentlyContinue
if ($response.success -eq $false -and $response.error -eq "Endpoint not found") {
    Write-Host "❌ OLD VERSION STILL DEPLOYED - Categories endpoint missing" -ForegroundColor Red
} else {
    Write-Host "✅ NEW VERSION DEPLOYED - Categories endpoint available" -ForegroundColor Green
}
```
