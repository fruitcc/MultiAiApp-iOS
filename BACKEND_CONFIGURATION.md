# Backend Configuration Guide

## Quick Setup

Edit `/MultiAiApp/Config/BackendConfig.swift` and change the URL based on your needs:

### 1. For iOS Simulator (Local Development)
```swift
static let baseURL = "http://localhost:48395"
```
✅ This is the default - no changes needed if running backend locally

### 2. For Physical iPhone/iPad (Local Backend)
```swift
// Find your Mac's IP: System Preferences > Network > Wi-Fi
static let baseURL = "http://192.168.1.100:48395"  // Replace with your Mac's IP
```

### 3. For Production (Linode/Cloud Server)
```swift
static let baseURL = "http://YOUR_LINODE_IP"  // Replace with your server IP
// Or with domain:
static let baseURL = "https://api.yourdomain.com"
```

## Finding Your IP Addresses

### Mac's Local IP (for device testing):
```bash
# Option 1: Terminal
ifconfig | grep "inet " | grep -v 127.0.0.1

# Option 2: System Preferences
System Preferences > Network > Wi-Fi > IP Address
```

### Linode Server IP:
- Check your Linode dashboard
- Or SSH into server and run: `curl ifconfig.me`

## Troubleshooting

### "Could not connect to server" on iPhone:
1. Ensure iPhone and Mac are on same Wi-Fi network
2. Check Mac's firewall settings allow connections
3. Verify backend is running: `npm run dev`
4. Use correct Mac IP address (not localhost)

### "Network error" with Linode:
1. Verify server is running: `pm2 status`
2. Check firewall allows port 80/443
3. Test with: `curl http://YOUR_LINODE_IP/health`
4. Ensure CORS is configured for your app

### HTTP vs HTTPS:
- Local development: HTTP is fine
- Production: Use HTTPS with SSL certificate
- Info.plist already configured for localhost HTTP
- Add your domain to Info.plist for production HTTP (not recommended)

## Build Configurations

The app automatically uses different URLs based on build configuration:
- **Debug** (Xcode Run): Uses local URL
- **Release** (Archive/TestFlight): Uses production URL

You can override this by directly editing `BackendConfig.swift`.

## Example Configurations

### Development Setup:
```swift
#if DEBUG
static let baseURL = "http://localhost:48395"  // Simulator
// static let baseURL = "http://192.168.1.5:48395"  // Device testing
#else
static let baseURL = "http://123.456.789.0"  // Production
#endif
```

### Simple Production Setup:
```swift
// Just change this one line:
static let baseURL = "http://YOUR_LINODE_IP"
```

## Testing Your Configuration

1. Open the app
2. Go to Settings tab
3. Check "Backend Status"
   - ✅ Green = Connected
   - ❌ Red = Check your configuration

## Need Help?

1. Check backend is running: `npm run dev` or `pm2 status`
2. Test backend directly: `curl YOUR_BACKEND_URL/health`
3. Verify URL in `BackendConfig.swift`
4. Check network/firewall settings