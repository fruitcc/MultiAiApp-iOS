# Backend Configuration Guide

## Quick Setup

### Configure Backend URL in the App

1. Open the MultiAiApp on your iOS device or simulator
2. Go to the **Settings** tab
3. Enter your backend URL in the **Backend URL** field
4. Toggle **Use Custom URL** to enable it
5. Tap **Test Connection** to verify
6. Tap **Save Settings**

## Configuration Examples

### 1. For iOS Simulator (Local Development)
- **Backend URL**: `http://localhost:48395`
- This is the default - just make sure your backend is running locally with `npm run dev`

### 2. For Physical iPhone/iPad (Local Backend)
1. Find your Mac's IP address:
   ```bash
   # Option 1: Terminal
   ifconfig | grep "inet " | grep -v 127.0.0.1
   
   # Option 2: System Preferences
   System Preferences > Network > Wi-Fi > IP Address
   ```
2. In the app Settings tab, enter: `http://YOUR_MAC_IP:48395`
   - Example: `http://192.168.1.100:48395`
3. Ensure your device and Mac are on the same Wi-Fi network

### 3. For Production (Linode/Cloud Server)
- **Backend URL**: `http://YOUR_LINODE_IP`
- Or with domain: `https://api.yourdomain.com`
- Make sure your backend is deployed and running on the server

## Features

### Backend URL Management
- ✅ Configure backend URL directly from the app
- ✅ Test connection before saving
- ✅ Automatic connection status monitoring
- ✅ Service availability display
- ✅ Quick setup guide in-app

### API Key Management
- API keys are now managed entirely by the backend
- No need to enter API keys in the iOS app
- Backend handles all authentication with AI services

## Troubleshooting

### "Disconnected" Status in Settings

1. **Check backend is running**:
   - Local: `npm run dev` in backend directory
   - Production: `pm2 status` on server

2. **Verify URL is correct**:
   - Simulator: `http://localhost:48395`
   - Device: `http://YOUR_MAC_IP:48395`
   - Production: `http://YOUR_SERVER_IP`

3. **Test backend directly**:
   ```bash
   curl http://YOUR_BACKEND_URL/health
   ```

4. **Network issues**:
   - Ensure device and backend are on same network (for local testing)
   - Check firewall settings allow port 48395
   - Verify CORS is configured in backend

### Connection Test Failed

If the "Test Connection" button shows failure:
1. Double-check the URL format (must include http:// or https://)
2. Ensure no trailing slashes in the URL
3. Verify the backend is accessible from your device
4. Check backend logs for any errors

## Default URLs

The app uses these defaults based on build configuration:
- **Debug builds** (Xcode Run): `http://localhost:48395`
- **Release builds** (TestFlight/App Store): User must configure in Settings

## Security Notes

- For production, always use HTTPS with SSL certificates
- The app stores the backend URL in UserDefaults
- API keys are never stored on the device
- All API authentication is handled server-side

## Backend Requirements

Your backend must implement these endpoints:
- `GET /health` - Health check endpoint
- `GET /api/ai/services` - List available AI services
- `POST /api/ai/chat/{service}` - AI chat endpoints

## Need Help?

1. Check backend status in the Settings tab
2. Use "Test Connection" to verify connectivity
3. Review backend logs: `npm run dev` or `pm2 logs`
4. Ensure all environment variables are set in backend `.env` file