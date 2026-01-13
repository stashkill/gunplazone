# 🚀 Panduan Lengkap: Running GunplaZone di Android Studio

Panduan step-by-step untuk menjalankan aplikasi Flutter GunplaZone di Android Studio.

## 📋 Prasyarat

Sebelum memulai, pastikan Anda sudah memiliki:

1. **Android Studio** (versi terbaru)
   - Download: https://developer.android.com/studio
   - Minimum: Android Studio Flamingo atau lebih tinggi

2. **Flutter SDK** (versi 3.3.0 atau lebih tinggi)
   - Download: https://flutter.dev/docs/get-started/install
   - Verifikasi: Buka terminal, jalankan `flutter --version`

3. **Java Development Kit (JDK)** (versi 11 atau lebih tinggi)
   - Biasanya sudah included dengan Android Studio
   - Verifikasi: `java -version`

4. **Android SDK** (API Level 21 atau lebih tinggi)
   - Biasanya sudah included dengan Android Studio

5. **Git** (untuk version control)
   - Download: https://git-scm.com/

## ✅ Step 1: Install & Setup Flutter

### 1.1 Download Flutter SDK

```bash
# Buka terminal/command prompt
# Windows: Gunakan PowerShell atau Command Prompt
# Mac/Linux: Gunakan Terminal

# Pilih folder untuk Flutter (misal: C:\src atau ~/development)
cd C:\src  # Windows
# atau
cd ~/development  # Mac/Linux

# Clone Flutter repository
git clone https://github.com/flutter/flutter.git -b stable
```

### 1.2 Setup PATH Environment Variable

**Windows:**
1. Tekan `Win + X` → pilih "System"
2. Klik "Advanced system settings"
3. Klik "Environment Variables"
4. Di "User variables", klik "New"
5. Variable name: `PATH`
6. Variable value: `C:\src\flutter\bin` (sesuaikan dengan folder Flutter Anda)
7. Klik OK

**Mac/Linux:**
```bash
# Edit file ~/.bashrc atau ~/.zshrc
nano ~/.bashrc

# Tambahkan baris ini di akhir file:
export PATH="$PATH:$HOME/development/flutter/bin"

# Simpan: Ctrl+O → Enter → Ctrl+X
# Reload: source ~/.bashrc
```

### 1.3 Verifikasi Flutter Installation

```bash
# Buka terminal/command prompt baru
flutter --version

# Output yang diharapkan:
# Flutter 3.x.x • channel stable
# Framework • revision xxxxx
# Engine • revision xxxxx
# Dart • SDK version x.x.x
```

## ✅ Step 2: Setup Android Studio & Android SDK

### 2.1 Install Android Studio

1. Download dari: https://developer.android.com/studio
2. Jalankan installer dan ikuti wizard
3. Pilih "Standard" installation
4. Tunggu hingga selesai

### 2.2 Setup Android SDK

1. Buka Android Studio
2. Klik "More Options" → "SDK Manager"
3. Pastikan installed:
   - **Android SDK Platform** (API Level 33 atau lebih tinggi)
   - **Android SDK Build-Tools** (versi terbaru)
   - **Android Emulator**
   - **Android SDK Platform-Tools**
4. Klik "Apply" dan tunggu download selesai

### 2.3 Setup Android Emulator

1. Buka Android Studio
2. Klik "More Options" → "Virtual Device Manager"
3. Klik "Create Device"
4. Pilih device (misal: Pixel 6 Pro)
5. Pilih API Level (misal: API 33)
6. Klik "Next" → "Finish"
7. Device akan muncul di list

## ✅ Step 3: Setup Flutter Plugin di Android Studio

### 3.1 Install Flutter Plugin

1. Buka Android Studio
2. Klik "Plugins" (di sidebar kiri)
3. Cari "Flutter"
4. Klik "Install"
5. Klik "Restart IDE"

### 3.2 Install Dart Plugin

1. Plugins akan otomatis install Dart plugin juga
2. Verifikasi: Plugins → cari "Dart" → pastikan terinstall

## ✅ Step 4: Extract & Setup Project GunplaZone

### 4.1 Extract File RAR

1. Download file `gunplazone_flutter.rar`
2. Extract menggunakan:
   - **Windows**: WinRAR atau 7-Zip
   - **Mac/Linux**: `unrar x gunplazone_flutter.rar`

```bash
# Mac/Linux
unrar x gunplazone_flutter.rar
# Folder gunplazone_flutter/ akan terbuat
```

### 4.2 Buka Project di Android Studio

1. Buka Android Studio
2. Klik "Open"
3. Navigasi ke folder `gunplazone_flutter/`
4. Klik "Open"
5. Android Studio akan mulai indexing (tunggu hingga selesai)

### 4.3 Install Dependencies

1. Buka Terminal di Android Studio (View → Tool Windows → Terminal)
2. Jalankan:

```bash
# Install Flutter dependencies
flutter pub get

# Generate JSON serialization code
flutter pub run build_runner build

# Output yang diharapkan:
# Building package executable...
# Building with sound null safety
# [info] Building for platform: android
# [info] Generating build script...
# [info] Generating build script completed, took 1s
```

Tunggu hingga selesai (bisa memakan waktu 1-2 menit).

## ✅ Step 5: Setup Backend API

### 5.1 Install Node.js

1. Download dari: https://nodejs.org/
2. Pilih "LTS" version
3. Jalankan installer dan ikuti wizard
4. Verifikasi:

```bash
node --version
npm --version
```

### 5.2 Setup Backend Server

1. Buat folder baru: `gunplazone-backend`

```bash
mkdir gunplazone-backend
cd gunplazone-backend
```

2. Inisialisasi Node.js project:

```bash
npm init -y
```

3. Install dependencies:

```bash
npm install express mysql2 dotenv cors bcryptjs jsonwebtoken
npm install --save-dev nodemon
```

4. Buat file `.env`:

```env
PORT=3000
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=password
DB_NAME=gunplazone
JWT_SECRET=your_jwt_secret_key_here_change_this
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret
```

5. Buat file `server.js` (copy dari BACKEND_SETUP.md)

6. Update `package.json` scripts:

```json
{
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js"
  }
}
```

### 5.3 Setup MySQL Database

1. Install MySQL dari: https://dev.mysql.com/downloads/mysql/

2. Buka MySQL Command Line atau MySQL Workbench

3. Jalankan SQL commands (dari BACKEND_SETUP.md):

```sql
CREATE DATABASE gunplazone;
USE gunplazone;

-- Copy semua CREATE TABLE statements dari BACKEND_SETUP.md
-- Copy semua INSERT statements untuk dummy data
```

4. Verifikasi database:

```bash
mysql -u root -p
# Masukkan password
# mysql> SHOW DATABASES;
# mysql> USE gunplazone;
# mysql> SHOW TABLES;
```

### 5.4 Jalankan Backend Server

```bash
cd gunplazone-backend
npm run dev

# Output yang diharapkan:
# Server running on http://localhost:3000
```

**PENTING**: Biarkan terminal ini terbuka! Backend harus running saat menjalankan app Flutter.

## ✅ Step 6: Jalankan Android Emulator

### 6.1 Buka Android Emulator

**Option 1: Dari Android Studio**
1. Klik "Device Manager" (di toolbar)
2. Cari device yang sudah dibuat
3. Klik tombol "Play" (▶)
4. Tunggu emulator boot (bisa 1-2 menit)

**Option 2: Dari Terminal**
```bash
# List available emulators
emulator -list-avds

# Jalankan emulator
emulator -avd Pixel_6_Pro_API_33
# (sesuaikan dengan nama device Anda)
```

### 6.2 Verifikasi Emulator Connected

```bash
# Di terminal baru, jalankan:
flutter devices

# Output yang diharapkan:
# 1 connected device:
# emulator-5554 • Android SDK built for x86_64 • android-x86_64 • Android 13 (API 33)
```

## ✅ Step 7: Run Flutter App

### 7.1 Jalankan App di Android Studio

**Option 1: Dari Android Studio UI**
1. Pastikan emulator sudah running
2. Klik tombol "Run" (▶) di toolbar
3. Pilih emulator jika diminta
4. Tunggu build selesai (3-5 menit untuk first run)

**Option 2: Dari Terminal**
```bash
# Pastikan sudah di folder gunplazone_flutter/
cd gunplazone_flutter

# Jalankan app
flutter run

# Output yang diharapkan:
# Launching lib/main.dart on emulator-5554 in debug mode...
# Building flutter app in debug mode...
# ✓ Built build/app/outputs/flutter-apk/app-debug.apk
# Installing and launching...
# ✓ Installed build/app/outputs/flutter-apk/app-debug.apk
# Waiting for emulator to report its views...
# flutter: Observatory listening on http://127.0.0.1:xxxxx
```

### 7.2 Troubleshooting Build Issues

**Jika ada error "Gradle build failed":**

```bash
# Clean build
flutter clean

# Get dependencies lagi
flutter pub get

# Run lagi
flutter run
```

**Jika ada error "SDK not found":**

```bash
# Jalankan flutter doctor
flutter doctor

# Ikuti instruksi yang diberikan
```

## ✅ Step 8: Test Aplikasi

### 8.1 Splash Screen
- Aplikasi akan menampilkan splash screen dengan logo GunplaZone
- Tunggu 2-3 detik

### 8.2 Sign In Screen
- Klik "Continue with Google" atau "Continue with Apple"
- Aplikasi akan membuka login dialog
- Gunakan akun Google/Apple Anda

### 8.3 Home Screen
- Setelah login, akan melihat grid produk Gundam
- Scroll untuk melihat lebih banyak produk
- Gunakan search bar untuk cari produk

### 8.4 Test Features

**Shopping Cart:**
1. Klik produk → klik "Add to Cart"
2. Klik tab "Cart" di bottom
3. Lihat items di cart

**Checkout:**
1. Di cart screen, klik "Checkout"
2. Isi shipping address
3. Pilih delivery option
4. Pilih payment method
5. Klik "Place Order"

**Chat:**
1. Klik tab "Chat" di bottom
2. Ketik pesan
3. Klik send button

**Profile:**
1. Klik tab "Profile" di bottom
2. Lihat user info
3. Toggle dark mode
4. Klik "My Orders" untuk lihat order history

**Admin Panel (jika admin user):**
1. Di profile screen, klik "Admin Panel"
2. Lihat list produk
3. Klik edit/delete untuk manage produk

## ✅ Step 9: Hot Reload & Hot Restart

### 9.1 Hot Reload
- Tekan `R` di terminal (atau Ctrl+\ di Android Studio)
- App akan reload tanpa kehilangan state
- Gunakan saat edit UI/styling

### 9.2 Hot Restart
- Tekan `Shift+R` di terminal
- App akan restart dan kehilangan state
- Gunakan saat ada perubahan dependencies atau state management

### 9.3 Full Rebuild
- Tekan `Ctrl+C` untuk stop app
- Jalankan `flutter run` lagi
- Gunakan saat ada error atau perubahan besar

## 🔧 Debugging Tips

### 9.1 View Logs
```bash
# Di terminal yang menjalankan flutter run
# Logs akan muncul otomatis

# Atau gunakan:
flutter logs
```

### 9.2 Debug Mode
- Tekan `D` di terminal untuk membuka debugger
- Gunakan breakpoints di Android Studio
- Inspect variables dan state

### 9.3 Performance Profiling
```bash
# Jalankan dengan profiling
flutter run --profile

# Atau gunakan DevTools:
flutter pub global activate devtools
devtools
```

## 🎯 Common Issues & Solutions

### Issue 1: "No connected devices"
**Solution:**
```bash
# Pastikan emulator running
emulator -avd Pixel_6_Pro_API_33

# Atau check devices
flutter devices

# Jika masih tidak terdeteksi:
adb kill-server
adb start-server
```

### Issue 2: "Gradle build failed"
**Solution:**
```bash
flutter clean
flutter pub get
flutter run
```

### Issue 3: "API connection error"
**Solution:**
1. Pastikan backend server running di `http://localhost:3000`
2. Check `.env` file di backend
3. Verifikasi database connection
4. Check firewall settings

### Issue 4: "Google Sign-In not working"
**Solution:**
1. Setup Google OAuth credentials
2. Add SHA-1 fingerprint ke Google Console
3. Update `google-services.json` di `android/app/`

## 📱 Device Testing

### Test di Physical Device

1. **Enable USB Debugging**
   - Settings → Developer Options → USB Debugging (ON)

2. **Connect via USB**
   - Hubungkan Android phone ke komputer
   - Allow USB debugging di phone

3. **Verify Connection**
   ```bash
   flutter devices
   # Device Anda akan muncul di list
   ```

4. **Run App**
   ```bash
   flutter run
   # Pilih device jika ada multiple devices
   ```

## 🚀 Build APK untuk Distribution

### Build Release APK

```bash
# Generate release APK
flutter build apk --release

# Output file:
# build/app/outputs/flutter-apk/app-release.apk

# File ini bisa di-upload ke Google Play Store
```

### Build App Bundle (untuk Play Store)

```bash
# Generate app bundle
flutter build appbundle --release

# Output file:
# build/app/outputs/bundle/release/app-release.aab
```

## 📚 Useful Resources

- Flutter Documentation: https://flutter.dev/docs
- Android Studio Help: https://developer.android.com/studio/intro
- Dart Language: https://dart.dev/guides
- Firebase Setup: https://firebase.google.com/docs/flutter/setup
- Google Sign-In: https://pub.dev/packages/google_sign_in

## ✅ Checklist

Sebelum submit/deploy, pastikan:

- [ ] App berjalan di emulator tanpa error
- [ ] Semua screens accessible
- [ ] Login/Logout berfungsi
- [ ] Shopping cart berfungsi
- [ ] Checkout flow complete
- [ ] Chat messages terkirim
- [ ] Dark mode toggle berfungsi
- [ ] Admin panel accessible (jika admin)
- [ ] Harga menampilkan Rupiah
- [ ] No console errors

## 🎉 Done!

Selamat! Aplikasi GunplaZone sudah running di Android Studio. Sekarang Anda bisa:

1. **Develop**: Edit code dan gunakan hot reload
2. **Debug**: Gunakan breakpoints dan inspect variables
3. **Test**: Test semua features di emulator
4. **Build**: Generate APK untuk distribution

---

**Happy Coding! 🚀**

Jika ada pertanyaan atau issues, check troubleshooting section atau lihat dokumentasi resmi.
