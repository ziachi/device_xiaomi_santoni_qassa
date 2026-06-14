# Bug: Privapp-Permissions Whitelist Bootloop

## Summary
System server crashes on boot due to missing privapp-permissions whitelist entries for two privileged apps.

## Root Cause
Two apps installed to `/system/priv-app/` request signature|privileged permissions not in any whitelist XML:
1. **GCam** (`com.google.android.GoogleCameraEng`) — needs `BIND_WALLPAPER`
   - Whitelist existed for `com.google.android.GoogleCamera` but APK actual package name is `GoogleCameraEng`
2. **OverrideSettings** (`com.android.override.settings`) — needs `WRITE_SECURE_SETTINGS`
   - `privapp-permissions-override.xml` existed in source but was NOT copied to system via `PRODUCT_COPY_FILES`

## Evidence (logcat)
```
FATAL EXCEPTION IN SYSTEM PROCESS: main
java.lang.IllegalStateException: Signature|privileged permissions not in privapp-permissions whitelist:
  {com.google.android.GoogleCameraEng: android.permission.BIND_WALLPAPER,
   com.android.override.settings: android.permission.WRITE_SECURE_SETTINGS}
  at com.android.server.pm.permission.PermissionManagerService.systemReady
```
This repeated 3x (PID 1778 → 2766 → 3161) causing bootloop.

## Fix
1. Add `GoogleCameraEng` entry to `permissions/privapp-permissions-qti.xml`
2. Add `OverrideSettings/privapp-permissions-override.xml` to `PRODUCT_COPY_FILES` in `device.mk`

## Commit
`4032e6f` — santoni: Fix privapp-permissions bootloop (#8)

## Lesson
- Priv-app package names must EXACTLY match whitelist XML entries
- Having the XML in source is not enough — it must be in `PRODUCT_COPY_FILES` to be copied to system image
