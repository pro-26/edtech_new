# Deployment Instructions

## Option 1: Manual Deployment via Appwrite Console (RECOMMENDED - EASIEST)

1. **Open Appwrite Console**: Go to https://cloud.appwrite.io/console
2. **Navigate to your project** 
3. **Go to Functions** section in the left sidebar
4. **Find your EdTech API function** (the one with URL: `https://68c2a1d90003e461b539.fra.appwrite.run`)
5. **Click on the function** to open its details
6. **Go to "Deployments" tab**
7. **Click "Create Deployment"**
8. **Choose "Manual" deployment method**
9. **Upload the file**: `c:\Pro26\edtech_new\backend\deployment.zip`
10. **Set Entrypoint**: `index.js`
11. **Click "Deploy"**
12. **Wait for build to complete** (usually 1-2 minutes)
13. **Activate the deployment** once it's ready

## Option 2: CLI Deployment (ADVANCED)

If you prefer CLI, you need to:

1. **Get your credentials**:
   - Project ID (from Appwrite Console → Project Settings)
   - Function ID (from Functions list)
   - API Key (from Appwrite Console → Settings → API Keys - needs function.write permission)

2. **Create .env file** in backend directory:
   ```
   APPWRITE_PROJECT_ID=your_project_id_here
   APPWRITE_FUNCTION_ID=your_function_id_here
   APPWRITE_API_KEY=your_api_key_here
   ```

3. **Run deployment command**:
   ```powershell
   cd c:\Pro26\edtech_new\backend
   & "$env:APPDATA\npm\appwrite.cmd" functions createDeployment `
       --functionId YOUR_FUNCTION_ID `
       --entrypoint index.js `
       --code . `
       --activate true
   ```

## After Deployment

Test the endpoints to verify the fix:

```powershell
# Test Categories
Invoke-RestMethod -Method GET -Uri 'https://68c2a1d90003e461b539.fra.appwrite.run/categories'

# Test Subcategories
Invoke-RestMethod -Method GET -Uri 'https://68c2a1d90003e461b539.fra.appwrite.run/subcategories'

# Test Instructors
Invoke-RestMethod -Method GET -Uri 'https://68c2a1d90003e461b539.fra.appwrite.run/instructors'
```

All three should now return proper responses instead of "Endpoint not found" errors.
