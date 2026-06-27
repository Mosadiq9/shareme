# Milestone 9 (M9): Dogfooding, Real-Device Validation & Production Handover — Implementation Plan

**Current Status:** Milestone 8 (Security, Encryption & Final Polish) is **100% complete, analyzed (0 lints), built, and committed to git** (`commit a7fac48`). Cryptographic session PIN verification, quarantine SHA-256 validation, and tactile haptic feedback are fully integrated.

Per your verification protocol, here is the exact technical plan for **Milestone 9** (our final milestone!) for you and your developer to review before we execute.

---

## 🎯 Goal Description
Perform final real-device dogfooding verification across Android and iOS platforms, optimize release build configurations (ProGuard/R8 rules, split APKs), and produce the comprehensive Production Handover documentation package.

---

## ⚠️ User & Developer Review Required

1. **Production Build Scripting (TRD §9.2)**: We will create a standardized build helper script (`build_release.ps1` / `build_release.sh`) that executes strict release compilation with code shrinking and obfuscation enabled (`--split-per-abi --obfuscate --split-debug-info`).
2. **ProGuard & Network Rules**: Ensure that ProGuard rules do not strip reflective serialization classes used by Riverpod or SQLite native bindings (`sqlite3_flutter_libs`).
3. **Final Dogfooding Checklist**: Ensure real physical devices test multi-file batch transfers exceeding 1GB to confirm zero RAM leaks (<50MB continuous consumption).

---

## 🏗️ Proposed Architecture & Changes

### 1. Production Build & ProGuard Rules (`android/app/`)
- **`proguard-rules.pro`**: Add defensive keep rules for SQLite drift models and Riverpod state generators.

### 2. Handover & Verification Documentation (`docs/`)
- **`PRODUCTION_HANDOVER.md`**: Complete architectural reference detailing clean layers, wire protocol specs, database schema, and troubleshooting guides for ongoing maintenance.

---

## 🧪 Verification Plan

### Automated Verification
1. Run `flutter analyze` ensuring zero interface or deprecation errors.
2. Execute dry-run release build verification command: `flutter build apk --release`.

### Manual / Physical Verification
1. Test physical transfer between two devices using the release APK to verify performance stability under real OS resource constraints.

---

## 🚦 Next Steps
**Please have your developer review this final milestone document.** If approved, reply with **"continue"** or **"approved"** to execute Milestone 9 and complete the Phase 1 engineering roadmap!
