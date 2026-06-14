# keepQASSA Sisu (Android 10) — Xiaomi Redmi 4X (santoni)

> ✅ **Build SUCCESS** — keepQASSA Sisu v2.4_0.s for santoni.
>
> - **ZIP:** `qassa_Sisu-v2.4_0.s-UNOFFICIAL-santoni-20260614-1642-Vanilla-signed.zip` (752MB)
> - **MD5:** `9306143979d0bea70d8367ceb48904da`
> - **Build time:** 03:32
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

| Issue | Status | Doc |
|-------|--------|-----|
| Graphics allocator@3.0 bootloop (MSM8937) | ✅ Fixed | [allocator-bootloop.md](docs/bug-analysis/allocator-bootloop.md) |
| Privapp-permissions whitelist bootloop (GCam + OverrideSettings) | ✅ Fixed | [privapp-permissions-bootloop.md](docs/bug-analysis/privapp-permissions-bootloop.md) |
| Calendar crash — startService from background | ✅ Fixed (v15) | Debloat via Android.bp override |
| GameSpace crash — Settings ActivityNotFoundException | ✅ Fixed (v15) | Debloat via Android.bp override |
| SELinux memtrack/libutils denials | ✅ Fixed (v15) | dontaudit + allow rules |
| Vibrator unsupported haptic effect type 2 | ✅ Fixed (v15) | Overlay config_enableHapticTextHandle=false |

> **Framework-level fixes** (android-override-a10 repo): see [android-override-a10/docs/](https://github.com/ziachi/android-override-a10/tree/main/docs)

## Troubleshooting

| Problem | Fix |
|---------|-----|
| webview.apk build error (tiny file) | `cd external/chromium-webview && git lfs pull` |
| dex2oat crash with "duplicate filter" | See [dex2oat-compiler-filter.md](https://github.com/ziachi/android-override-a10/tree/main/docs/bug-analysis/dex2oat-compiler-filter.md) |
| Soong build error after device.mk change | Clean Soong cache: `rm -rf out/soong/.bootstrap` |
| Bootloop after first boot (allocator@3.0) | Remove `<version>3.0</version>` from manifest.xml allocator HAL |
| Bootloop with privapp-permissions crash | Add missing packages to privapp whitelist XML + ensure XML is in `PRODUCT_COPY_FILES` |

## Documentation

| Doc | Description |
|-----|-------------|
| [CHANGELOG.md](CHANGELOG.md) | Commit history |
| [android-override-a10 docs](https://github.com/ziachi/android-override-a10/tree/main/docs) | Build fixes, integration guide, troubleshooting |

## Maintainer

**[@kalomakan](https://t.me/kalomakan) / [ziachi](https://github.com/ziachi)**

## Credits

- [omansh-krishn](https://github.com/omansh-krishn) — keepQASSA device tree
