# Bug: Graphics Allocator @3.0 Bootloop

## Summary
Device bootloops because SurfaceFlinger cannot find `allocator@3.0` HAL.

## Root Cause
- `manifest.xml` declared BOTH `allocator@2.0` AND `@3.0`
- `device.mk` included `allocator@3.0-service` (non-existent binary for MSM8937)
- SurfaceFlinger tried to load `@3.0`, waited forever → Watchdog kill → bootloop

## Evidence (logcat)
```
hwservicemanager: Cannot find entry android.hardware.graphics.allocator@3.0::IAllocator/default
  in either framework or device manifest.
Gralloc3: allocator 3.x is not supported
```

## Fix
1. Remove `<version>3.0</version>` from allocator HAL in `manifest.xml`
2. Remove `android.hardware.graphics.allocator@3.0-service` from `device.mk` PRODUCT_PACKAGES

## Commit
`03332ae` — santoni: Fix allocator@3.0 bootloop + update docs (#6)

## Lesson
MSM8937 (Snapdragon 435) only supports `allocator@2.0`. Always verify HAL versions against actual vendor binaries.
