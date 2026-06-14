# Device Tree for Xiaomi Redmi 4X (santoni) — keepQASSA

## Spec Sheet

| Feature | Specification |
|---------|--------------|
| Chipset | Qualcomm MSM8937 Snapdragon 435 |
| CPU | Octa-core 1.4 GHz Cortex-A53 |
| GPU | Adreno 505 |
| RAM | 2-4 GB |
| Storage | 16-64 GB |
| Display | 5.0" 720x1280 IPS |
| Camera | 13MP rear, 5MP front |
| Battery | 4100 mAh |
| Kernel | 4.9.x (ARM64) |

## Repos

| Repo | Branch | Description |
|------|--------|-------------|
| [device_xiaomi_santoni_qassa](https://github.com/ziachi/device_xiaomi_santoni_qassa/tree/qassa-dev) | `qassa-dev` | Device tree (this repo) |
| [android-override-a10](https://github.com/ziachi/android-override-a10/tree/main) | `main` | Override framework patches |
| [android-override](https://github.com/ziachi/android-override/tree/main) | `main` | Override framework (Android 13+) |

## Build Status

### keepQASSA Sisu v2.4_0.s — Build SUCCESS
- **ROM:** keepQASSA Sisu v2.4_0.s (Android 10)
- **Type:** UNOFFICIAL (Vanilla)
- **ZIP:** `qassa_Sisu-v2.4_0.s-UNOFFICIAL-santoni-20260614-1254-Vanilla-signed.zip` (753MB)
- **MD5:** `372396bc63a7ee186acecf615938303d`
- **Build time:** 19:36
- **Signed:** releasekey (vendor/ziachi-keys)
- **Build cmd:** `mka qassa -j10` after `lunch qassa_santoni-userdebug`

## Features

- Custom releasetools with build credit injection
- ADB enabled by default
- Maintainer info in build.prop
- Signed with custom releasekey

## Known Issues

See [android-override-a10/docs/bug-analysis/](https://github.com/ziachi/android-override-a10/tree/main/docs/bug-analysis) for resolved build issues:
- ActivityThread.java stray character (javac error)
- Webview LFS pointers not pulled after repo sync
- dex2oat duplicate compiler filter crash (CRITICAL)
- Soong bootstrap cache stale after device.mk fix

## Building

```bash
# Init repo
repo init -u https://github.com/nicholaschum/qassa_manifest.git -b s
repo sync -j8

# Setup device
git clone https://github.com/ziachi/device_xiaomi_santoni_qassa.git \
    device/xiaomi/santoni -b qassa-dev

# Build
source build/envsetup.sh
lunch qassa_santoni-userdebug
mka qassa -j10
```

## Maintainer

- **GitHub:** [ziachi](https://github.com/ziachi)
- **Telegram:** [@kalomakan](https://t.me/kalomakan)

## License

```
Copyright 2025 Android Override Project

Licensed under the Apache License, Version 2.0
```

See [LICENSE](LICENSE) for full text.
