# Qassa ROM — Xiaomi Redmi 4X (santoni)

> **keepQASSA Sisu v2.4_0.s** (Android 10) — Unofficial build for santoni.
> Vanilla, custom signed, with XiaomiAddon & GCam preinstalled.

---

## Quick Reference

| Key | Value |
|-----|-------|
| **ROM** | keepQASSA Sisu v2.4_0.s (Android 10) |
| **Device** | Xiaomi Redmi 4X (santoni) |
| **SoC** | Qualcomm MSM8937 (Snapdragon 435) |
| **Lunch** | `qassa_santoni-userdebug` |
| **Build command** | `mka qassa -j$(nproc)` |
| **Build type** | UNOFFICIAL |
| **Signed with** | `vendor/ziachi-keys/releasekey` |
| **SELinux** | Enforcing (always) |
| **Manifest** | `https://github.com/keepQASSA/manifest.git` branch `Q` |
| **Maintainer** | [@kalomakan](https://t.me/kalomakan) / [ziachi](https://github.com/ziachi) |

---

## Repository Map

All custom repos for this ROM. Clone each into the matching path inside the Qassa source tree.

```
~/qassa/                                    <- ROM source root
|-- .repo/                                  <- repo tool metadata
|-- device/xiaomi/santoni/                  <- THIS REPO (device tree)
|-- vendor/xiaomi/santoni/                  <- Vendor blobs
|-- kernel/xiaomi/msm8937/                  <- Kernel source
|-- frameworks/base/                        <- Framework patches (custom)
|-- vendor/qassa/                           <- ROM vendor config (from repo sync)
|-- vendor/ziachi-keys/                     <- Signing keys (NOT on GitHub)
|-- build/                                  <- Build system (from repo sync)
|-- external/chromium-webview/              <- Webview (needs git-lfs pull!)
`-- out/                                    <- Build output (~200GB)
```

| Repo | GitHub URL | Branch | Clone Path |
|------|-----------|--------|------------|
| **Device tree** | [device_xiaomi_santoni_qassa](https://github.com/ziachi/device_xiaomi_santoni_qassa) | `qassa-dev` | `device/xiaomi/santoni` |
| **Vendor blobs** | [vendor_xiaomi_santoni_qassa](https://github.com/ziachi/vendor_xiaomi_santoni_qassa) | `10.0` | `vendor/xiaomi/santoni` |
| **Kernel** | [kernel_xiaomi_msm8937_qassa](https://github.com/ziachi/kernel_xiaomi_msm8937_qassa) | `13` | `kernel/xiaomi/msm8937` |
| **Framework** | [frameworks_base_qassa](https://github.com/ziachi/frameworks_base_qassa) | `qassa-10` | `frameworks/base` |

> **Signing keys** (`vendor/ziachi-keys`) are NOT on GitHub. Generate your own or ask the maintainer.

---

## Full Setup Guide (from scratch on a new VPS)

### Prerequisites

- **OS:** Ubuntu 22.04+ (or WSL2 on Windows)
- **CPU:** 6+ cores recommended (Ryzen 5 7600 or similar)
- **RAM:** 16GB+ (22GB+ recommended for -j10)
- **Disk:** 250GB+ free space
- **Packages:** OpenJDK 8, Python 3, git, git-lfs, ccache, repo

```bash
# Install build dependencies (Ubuntu 22.04)
sudo apt update && sudo apt install -y \
    bc bison build-essential ccache curl flex g++-multilib gcc-multilib \
    git git-lfs gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev \
    lib32z1-dev liblz4-tool libncurses5 libncurses5-dev libsdl1.2-dev \
    libssl-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool \
    squashfs-tools xsltproc zip zlib1g-dev openjdk-8-jdk python3

# Install repo tool
mkdir -p ~/bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
echo 'export PATH=~/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

# Setup ccache (optional but recommended)
echo 'export USE_CCACHE=1' >> ~/.bashrc
echo 'export CCACHE_DIR=~/.ccache' >> ~/.bashrc
source ~/.bashrc
ccache -M 40G
```

### Step 1: Initialize ROM Source

```bash
mkdir -p ~/qassa && cd ~/qassa
repo init -u https://github.com/keepQASSA/manifest.git -b Q --depth=1
repo sync -j8 --force-sync --no-tags --no-clone-bundle
```

> Initial sync takes 1-3 hours depending on internet speed. ~70GB download.

### Step 2: Clone Custom Repos

```bash
cd ~/qassa

# Device tree
rm -rf device/xiaomi/santoni
git clone https://github.com/ziachi/device_xiaomi_santoni_qassa.git \
    device/xiaomi/santoni -b qassa-dev

# Vendor blobs
rm -rf vendor/xiaomi/santoni
git clone https://github.com/ziachi/vendor_xiaomi_santoni_qassa.git \
    vendor/xiaomi/santoni -b 10.0

# Kernel
rm -rf kernel/xiaomi/msm8937
git clone https://github.com/ziachi/kernel_xiaomi_msm8937_qassa.git \
    kernel/xiaomi/msm8937 -b 13

# Framework patches (on top of synced frameworks/base)
cd frameworks/base
git remote add ziachi https://github.com/ziachi/frameworks_base_qassa.git
git fetch ziachi
git checkout ziachi/qassa-10
cd ~/qassa
```

### Step 3: Fix Webview (IMPORTANT - build will fail without this)

```bash
cd ~/qassa/external/chromium-webview
git lfs pull
# Verify webview.apk is ~40MB+, NOT a tiny LFS pointer file:
ls -lh prebuilt/x86_64/webview.apk
cd ~/qassa
```

### Step 4: Setup Signing Keys

Generate your own keys if you don't have the maintainer's keys:

```bash
mkdir -p ~/qassa/vendor/ziachi-keys
cd ~/qassa/vendor/ziachi-keys
for key in releasekey platform shared media networkstack testkey; do
    subject="/C=ID/ST=Java/L=Jakarta/O=Qassa/OU=Android/CN=${key}"
    openssl genrsa 2048 2>/dev/null | \
        openssl pkcs8 -topk8 -inform PEM -outform DER -nocrypt -out ${key}.pk8
    openssl req -new -x509 -sha256 -key <(openssl rsa -inform DER -in ${key}.pk8 2>/dev/null) \
        -out ${key}.x509.pem -days 10000 -subj "${subject}" 2>/dev/null
done
cd ~/qassa
```

### Step 5: Build

```bash
cd ~/qassa
source build/envsetup.sh
lunch qassa_santoni-userdebug
mka qassa -j$(nproc)
```

> First build: ~4-8 hours (6-core). Subsequent builds with ccache: ~1-3 hours.
>
> Output: `out/target/product/santoni/qassa_Sisu-*.zip`

### Step 6: Flash

```bash
# Boot into TWRP recovery, then sideload:
adb sideload out/target/product/santoni/qassa_Sisu-*.zip

# OR copy ZIP to device and flash from TWRP file manager
```

---

## Build Commands Cheat Sheet

| Command | Purpose | Time |
|---------|---------|------|
| `source build/envsetup.sh` | Load build environment | instant |
| `lunch qassa_santoni-userdebug` | Select device/variant | instant |
| `mka qassa -j10` | Full build (10 threads) | 1-8 hr |
| `mka installclean` | Clean product output, keep cache | instant |
| `mka clean` | Full clean (delete entire out/) | instant |
| `rm -rf out/soong/.bootstrap` | Fix Soong cache errors | instant |

### Background build with logging:
```bash
nohup mka qassa -j10 > /tmp/build.log 2>&1 &
tail -f /tmp/build.log          # monitor
grep -i "error\|fail" /tmp/build.log  # check errors
```

---

## What's Included

### Prebuilt Apps
| App | Path | Description |
|-----|------|-------------|
| GCam | `GCam/Camera.apk` | Google Camera |
| XiaomiAddon | `XiaomiAddon/` | KCal display, USB Fast Charge, QS tiles |

### Device Features
- ADB enabled by default (headless/automation access)
- Custom signed with releasekey
- SELinux enforcing (always)
- Maintainer info embedded in build.prop

---

## Known Issues & Fixes

| # | Issue | Status | Fix |
|---|-------|--------|-----|
| 6 | allocator@3.0 bootloop (MSM8937) | Fixed | Remove `<version>3.0</version>` from manifest.xml |
| 8 | Privapp-permissions bootloop | Fixed | Added whitelist XML for all privapps |
| 10 | Calendar crash (startService from bg) | Fixed | Debloated via Android.bp overlay |
| 11 | GameSpace crash | Fixed | Debloated via Android.bp overlay |
| 15 | SELinux memtrack/libutils denials | Fixed | dontaudit + allow rules |
| 15 | Vibrator haptic type 2 error | Fixed | Overlay `config_enableHapticTextHandle=false` |
| 17 | Dolby remnants in device tree | Fixed | Removed all Dolby refs |
| 22 | Android Override integrated | Fixed | Removed all Override hooks + app |

### Common Build Errors

| Problem | Fix |
|---------|-----|
| webview.apk build error (tiny file) | `cd external/chromium-webview && git lfs pull` |
| Soong build error after .mk change | `rm -rf out/soong/.bootstrap` |
| Disk full during build | `mka installclean` or `mka clean` |
| Jack server OOM | `export JACK_SERVER_VM_ARGUMENTS="-Xmx4g"` |

---

## Hard Rules

> **These rules MUST be followed by any human or AI agent working on this project.**

| # | Rule |
|---|------|
| 1 | **NEVER `git push --force`** — History is sacred, no exceptions |
| 2 | **SELinux MUST stay Enforcing** — No permissive, ever |
| 3 | **1 fix = 1 commit** — Format: `[vN] santoni: description (#N)` |
| 4 | **Commit body must include:** Problem / Fix / Files / Impact |
| 5 | **Don't mix Matrixx patterns with Qassa** — Different ROM, different codebase |
| 6 | **Don't auto-build** — Wait for explicit "gas build" from maintainer |
| 7 | **README + CHANGELOG must update** with every commit+push |
| 8 | **Monitor builds** with 5-minute poll intervals |
| 9 | **GPG sign all commits** — Ask maintainer for key setup |

---

## For AI Agents

If you are an AI agent (Viktor, Cursor, Copilot, etc.) continuing work on this project, read this section carefully.

### Project Context
- This is **keepQASSA** (Android 10 / Q), NOT LineageOS, NOT Matrixx
- Build system: standard AOSP Make (`mka`)
- ROM manifest: `https://github.com/keepQASSA/manifest.git` branch `Q`
- Source tree synced with `repo sync --depth=1` (shallow clones)
- Device codename: `santoni` (Xiaomi Redmi 4X)

### Build Environment Setup
```bash
cd ~/qassa
source build/envsetup.sh
lunch qassa_santoni-userdebug
mka qassa -j$(nproc)
```

### Common Tasks

| Task | How |
|------|-----|
| Add prebuilt app | Put APK + Android.mk in `device/xiaomi/santoni/<AppName>/`, add to device.mk PRODUCT_PACKAGES |
| Change build prop | Edit `system.prop` or `qassa_santoni.mk` PRODUCT_PROPERTY_OVERRIDES |
| Fix SELinux denial | Add rules to `sepolicy/vendor/`, NEVER set permissive |
| Debloat system app | Add entry to `debloat/Android.bp` |
| Add overlay | Put XML in `overlay/` or `overlay-lineage/` |
| Update kernel config | Edit defconfig in `kernel/xiaomi/msm8937` |

### Disk Management
The `out/` directory grows to 200GB+. Always check `df -h` before building.
- `mka installclean` — frees ~10-15GB, keeps compiled objects, rebuild ~1-3hr
- `mka clean` — frees everything, full rebuild ~4-8hr

### GPG Signing
All commits must be GPG signed. Ask the maintainer for the signing key ID, then:
```bash
git config --global user.signingkey <KEY_ID>
git config --global commit.gpgsign true
```

### Commit Workflow
1. Make changes
2. Test build compiles (or get maintainer approval to skip)
3. Commit with format: `[vN] santoni: description (#N)`
4. Include in commit body: Problem / Fix / Files / Impact
5. Update README.md and CHANGELOG.md
6. Push (never force push)

---

## Commit History

See [CHANGELOG.md](CHANGELOG.md) for full history.

| # | Version | Hash | Change |
|---|---------|------|--------|
| 23 | v20 | 2e0ceda | Add Spectrum kernel profile to XiaomiAddon |
| 22 | v19 | 727c886 | Fix PinnerService path for flattened APEX |
| 21 | v18 | c687798 | Fix PinnerService APEX path for Android 10 |
| 20 | v17 | cfbf6ba | Complete Dolby removal from device tree |
| 19 | v16 | 3f69e6d | Update README — comprehensive setup guide |
| 18 | v16 | 32160a3 | Remove Android Override integration |
| 17 | v15 | df886c1 | Fix README — separate device tree vs override bugs |
| 16 | v15 | fc1ceaa | Update README + CHANGELOG |
| 15 | v15 | ae7f47a | Build deps fix + device info overlay |
| 14 | v15 | ac19f79 | Add Spectrum kernel manager + OverrideSettings SEPolicy |
| 13 | v15 | aa0fc5d | Remove Dolby from device tree |
| 12 | v15 | 60526f3 | SEPolicy cleanup — remove non-existent types |
| 11 | - | 0a1ca39 | Fix 6 bugs from V14 logcat analysis |
| 9 | - | d3098f2 | Add bug analysis docs + update README |
| 8 | - | 4032e6f | Fix privapp-permissions bootloop |
| 6 | - | 03332ae | Fix allocator@3.0 bootloop + update docs |

---

## Credits

- [omansh-krishn](https://github.com/omansh-krishn) — original keepQASSA device tree for santoni
- [nicholaschum](https://github.com/nicholaschum) — keepQASSA ROM
- [ziachi](https://github.com/ziachi) — santoni port, customizations, bug fixes
