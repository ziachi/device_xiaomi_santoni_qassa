# keepQASSA Sisu (Android 10) — Xiaomi Redmi 4X (santoni)

> ✅ **Build SUCCESS** — keepQASSA Sisu v2.4_0.s for santoni.
>
> - **ZIP:** `qassa_Sisu-v2.4_0.s-UNOFFICIAL-santoni-20260614-1254-Vanilla-signed.zip` (753MB)
> - **MD5:** `372396bc63a7ee186acecf615938303d`
> - **Build time:** 19 min 36 sec
> - **Signed:** releasekey (`vendor/ziachi-keys`)

Unofficial keepQASSA Sisu v2.4_0.s for Xiaomi Redmi 4X (santoni).
Vanilla build, custom signed, with XiaomiAddon & GCam preinstalled.

## Device Specs

| Spec | Detail |
|------|--------|
| SoC | Qualcomm MSM8937 (Snapdragon 435) |
| CPU | Octa-core 1.4 GHz Cortex-A53 |
| GPU | Adreno 505 |
| RAM | 2–4 GB |
| Storage | 16–64 GB |
| Display | 5.0" 720×1280 IPS |
| Camera | 13MP rear, 5MP front |
| Battery | 4100 mAh |
| Kernel | 4.9.x (ARM64) |

## Repositories

| Repo | Branch | Description |
|------|--------|-------------|
| [device_xiaomi_santoni_qassa](https://github.com/ziachi/device_xiaomi_santoni_qassa/tree/qassa-dev) | `qassa-dev` | Device tree (this repo) |
| [android-override-a10](https://github.com/ziachi/android-override-a10/tree/main) | `main` | Override framework patches (Android 10) |
| [android-override](https://github.com/ziachi/android-override/tree/main) | `main` | Override framework (Android 13+) |

> **Note:** `android-override-a10` contains framework-level patches for
> device identity management. See its
> [docs/](https://github.com/ziachi/android-override-a10/tree/main/docs)
> for integration guides and troubleshooting.

## Features

- **XiaomiAddon** — Device-specific settings app (KCal, USB Fast Charge, QS tiles)
- **GCam** — Google Camera preinstalled
- **Custom Releasetools** — Build credit injection into ZIP
- **ADB enabled by default** — for screenless/automation access
- **Custom signed** — releasekey from `vendor/ziachi-keys`
- **Maintainer info** — embedded in `build.prop`

## Build Instructions

### Prerequisites

- Ubuntu 22.04+ (or WSL2), 16GB+ RAM, 200GB+ disk
- OpenJDK 8, Python 3, `repo`, `git`, `git-lfs`, `ccache`

```bash
# Install repo tool
mkdir -p ~/bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
export PATH=~/bin:$PATH

# Setup ccache (recommended)
ccache -M 40G
```

### Build

```bash
# 1. Init source
repo init -u https://github.com/nicholaschum/qassa_manifest.git -b s
repo sync -j8

# 2. Setup device tree
git clone https://github.com/ziachi/device_xiaomi_santoni_qassa.git \
    device/xiaomi/santoni -b qassa-dev

# 3. Build
source build/envsetup.sh
lunch qassa_santoni-userdebug
mka qassa -j10
```

## Known Issues & Fixes

See [android-override-a10/docs/bug-analysis/](https://github.com/ziachi/android-override-a10/tree/main/docs/bug-analysis) for detailed root cause analysis:

| Issue | Status | Doc |
|-------|--------|-----|
| ActivityThread.java stray character (javac error) | ✅ Fixed | [activitythread-stray-char.md](https://github.com/ziachi/android-override-a10/tree/main/docs/bug-analysis/activitythread-stray-char.md) |
| Webview LFS pointers not pulled after repo sync | ✅ Fixed | [webview-lfs.md](https://github.com/ziachi/android-override-a10/tree/main/docs/bug-analysis/webview-lfs.md) |
| dex2oat duplicate compiler filter crash (CRITICAL) | ✅ Fixed | [dex2oat-compiler-filter.md](https://github.com/ziachi/android-override-a10/tree/main/docs/bug-analysis/dex2oat-compiler-filter.md) |
| Soong bootstrap cache stale after device.mk fix | ✅ Fixed | [soong-cache.md](https://github.com/ziachi/android-override-a10/tree/main/docs/bug-analysis/soong-cache.md) |

## Troubleshooting

| Problem | Fix |
|---------|-----|
| webview.apk build error (tiny file) | `cd external/chromium-webview && git lfs pull` |
| dex2oat crash with "duplicate filter" | See [dex2oat-compiler-filter.md](https://github.com/ziachi/android-override-a10/tree/main/docs/bug-analysis/dex2oat-compiler-filter.md) |
| Soong build error after device.mk change | Clean Soong cache: `rm -rf out/soong/.bootstrap` |

## Documentation

| Doc | Description |
|-----|-------------|
| [CHANGELOG.md](CHANGELOG.md) | Commit history |
| [android-override-a10 docs](https://github.com/ziachi/android-override-a10/tree/main/docs) | Build fixes, integration guide, troubleshooting |

## Maintainer

**[@kalomakan](https://t.me/kalomakan) / [ziachi](https://github.com/ziachi)**

## License

```
Copyright 2025 Android Override Project

Licensed under the Apache License, Version 2.0
```
