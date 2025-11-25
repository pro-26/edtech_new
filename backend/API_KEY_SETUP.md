# How to Create an Appwrite API Key with Function.Write Permission

## Step-by-Step Guide

### 1. **Open Appwrite Console**
   - Go to: https://cloud.appwrite.io/console
   - Log in to your account

### 2. **Select Your Project**
   - Click on your EdTech project from the projects list

### 3. **Navigate to Settings**
   - In the left sidebar, scroll down to the bottom
   - Click on **"Settings"** (gear icon)

### 4. **Go to API Keys Section**
   - In Settings, click on **"API Keys"** tab
   - Or directly go to: `https://cloud.appwrite.io/console/project-YOUR_PROJECT_ID/settings/keys`

### 5. **Create New API Key**
   - Click the **"Create API Key"** button
   - You'll see a form with the following fields:

### 6. **Configure the API Key**
   
   **Name**: Enter a descriptive name
   ```
   CLI Deployment Key
   ```
   
   **Expiration**: Choose expiration (recommended: 1 year or Never)
   ```
   Never (or set a future date)
   ```
   
   **Scopes**: You need to select the following permissions:
   
   #### Required Scopes for Function Deployment:
   - ✅ **functions.read** - Read function details
   - ✅ **functions.write** - Create/update functions
   - ✅ **execution.read** - Read execution logs
   - ✅ **execution.write** - Execute functions
   
   #### Additional Recommended Scopes (for full backend operations):
   - ✅ **databases.read** - Read database collections
   - ✅ **databases.write** - Write to database collections
   - ✅ **collections.read** - Read collections structure
   - ✅ **collections.write** - Modify collections
   - ✅ **documents.read** - Read documents
   - ✅ **documents.write** - Write documents
   - ✅ **storage.read** - Read storage files
   - ✅ **storage.write** - Upload/delete files

### 7. **Copy the API Key**
   - After clicking **"Create"**, you'll see the API Key
   - ⚠️ **IMPORTANT**: Copy it immediately and save it securely
   - ⚠️ **You won't be able to see it again!**
   - Store it in a password manager or secure location

### 8. **Get Your Project ID and Function ID**

   #### **Project ID**:
   - In the Appwrite Console, look at the URL
   - Format: `https://cloud.appwrite.io/console/project-YOUR_PROJECT_ID/...`
   - Or go to Settings → Overview → Copy the Project ID
   
   #### **Function ID**:
   - Go to **Functions** in the left sidebar
   - Find your EdTech API function
   - Click on it
   - Look at the URL: `https://cloud.appwrite.io/console/project-XXX/functions/function/YOUR_FUNCTION_ID`
   - Or copy it from the function details page (under "Function ID")

### 9. **Use the Credentials**

   Once you have all three values, you can deploy via CLI:

   ```powershell
   cd c:\Pro26\edtech_new\backend
   
   & "$env:APPDATA\npm\appwrite.cmd" client --endpoint https://cloud.appwrite.io/v1
   
   & "$env:APPDATA\npm\appwrite.cmd" client --projectId YOUR_PROJECT_ID
   
   & "$env:APPDATA\npm\appwrite.cmd" client --key YOUR_API_KEY
   
   & "$env:APPDATA\npm\appwrite.cmd" functions createDeployment `
       --functionId YOUR_FUNCTION_ID `
       --entrypoint index.js `
       --code . `
       --activate true
   ```

## Quick Visual Guide

```
Appwrite Console
├── Projects
│   └── [Your EdTech Project] ← Click here
│       └── Settings (bottom left)
│           └── API Keys tab
│               └── Create API Key button
│                   ├── Name: "CLI Deployment Key"
│                   ├── Expiration: Never/1 year
│                   └── Scopes:
│                       ├── ✅ functions.read
│                       ├── ✅ functions.write
│                       ├── ✅ execution.read
│                       └── ✅ execution.write
```

## Security Best Practices

1. **Never commit API keys to Git**
   - Already added `.env` to `.gitignore`
   - Store keys in environment variables or secure vaults

2. **Use minimal required scopes**
   - For deployment only: functions.read, functions.write
   - For full backend: add database and storage scopes

3. **Set expiration dates**
   - Keys should expire after a reasonable time
   - Rotate keys periodically

4. **Revoke unused keys**
   - Delete old/unused API keys from the Console
   - Create new ones when needed

## Troubleshooting

### "Unauthorized" or "Invalid API Key" error
- Check that you copied the full API key (they're usually long strings)
- Verify the key has the required scopes
- Make sure the key hasn't expired

### "Function not found" error
- Double-check your Function ID
- Ensure the API key's project matches the function's project

### "Insufficient permissions" error
- Go back to API Keys settings
- Edit the key and add the missing scopes
- Common missing scope: `functions.write`
