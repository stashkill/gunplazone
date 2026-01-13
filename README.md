# GunplaZone - Flutter Mobile App

Aplikasi mobile e-commerce untuk toko Gundam dengan fitur lengkap termasuk CRUD produk, autentikasi Google, chat support, checkout, dan light/dark mode.

## Fitur Utama

- **Autentikasi**: Login dengan Google dan Apple
- **E-Commerce**: Browse produk, search, filter kategori, favorites
- **Shopping Cart**: Tambah/kurangi/hapus item dari keranjang
- **Checkout**: Pengiriman, metode pembayaran, ringkasan pesanan
- **Chat Support**: Chat real-time dengan customer support
- **Order History**: Riwayat pesanan dengan status tracking
- **Admin Panel**: CRUD produk untuk admin (Create, Read, Update, Delete)
- **Dark Mode**: Toggle antara light dan dark theme
- **Harga Rupiah**: Semua harga menggunakan format Rupiah (Rp)

## Tech Stack

- **Framework**: Flutter (Dart)
- **State Management**: Provider
- **Navigation**: Go Router
- **HTTP Client**: Dio
- **Local Storage**: SharedPreferences, SQLite
- **Authentication**: Google Sign-In, Firebase Auth
- **UI**: Material Design 3

## Struktur Project

```
lib/
├── main.dart                 # Entry point aplikasi
├── config/
│   └── theme.dart           # Konfigurasi tema light/dark
├── models/
│   └── models.dart          # Data models (User, Product, Order, dll)
├── services/
│   └── api_service.dart     # API client untuk backend
├── providers/
│   ├── theme_provider.dart  # Theme state management
│   ├── auth_provider.dart   # Authentication state
│   ├── product_provider.dart # Product management
│   ├── cart_provider.dart   # Shopping cart state
│   └── chat_provider.dart   # Chat messages state
├── routes/
│   └── app_routes.dart      # Navigation routes
├── screens/
│   ├── splash_screen.dart
│   ├── auth/
│   │   └── sign_in_screen.dart
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── product_detail_screen.dart
│   ├── cart/
│   │   └── cart_screen.dart
│   ├── checkout/
│   │   └── checkout_screen.dart
│   ├── chat/
│   │   └── chat_screen.dart
│   ├── profile/
│   │   ├── profile_screen.dart
│   │   └── orders_screen.dart
│   └── admin/
│       └── admin_panel_screen.dart
└── widgets/
    ├── bottom_nav_bar.dart
    └── product_card.dart
```

## Setup & Installation

### Prerequisites
- Flutter SDK 3.3.0 atau lebih tinggi
- Dart SDK
- Android Studio / Xcode (untuk development)

### Instalasi

1. **Clone repository**
```bash
git clone <repository-url>
cd gunplazone_flutter
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Generate models (JSON serialization)**
```bash
flutter pub run build_runner build
```

4. **Run aplikasi**
```bash
# iOS
flutter run -d ios

# Android
flutter run -d android

# Web
flutter run -d web
```

## Backend API

Aplikasi ini terhubung ke backend API di `http://localhost:3000/api`. Pastikan backend server sudah berjalan sebelum menjalankan aplikasi.

### API Endpoints

**Authentication**
- `POST /auth/google` - Login dengan Google
- `POST /auth/logout` - Logout

**Products**
- `GET /products` - List semua produk
- `GET /products?category=HG` - Filter produk by kategori
- `GET /products/:id` - Detail produk
- `POST /products` - Buat produk (admin only)
- `PUT /products/:id` - Update produk (admin only)
- `DELETE /products/:id` - Hapus produk (admin only)

**Orders**
- `POST /orders` - Buat order
- `GET /orders` - List orders user
- `GET /orders/:id` - Detail order

**Chat**
- `GET /chat/messages` - List chat messages
- `POST /chat/messages` - Send chat message

**Favorites**
- `GET /favorites` - List favorites
- `POST /favorites` - Add to favorites
- `DELETE /favorites/:productId` - Remove from favorites

## Database Schema

### Users Table
```sql
CREATE TABLE users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  openId VARCHAR(64) UNIQUE NOT NULL,
  name TEXT,
  email VARCHAR(320),
  loginMethod VARCHAR(64),
  role ENUM('user', 'admin') DEFAULT 'user',
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  lastSignedIn TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Products Table
```sql
CREATE TABLE products (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  category VARCHAR(100),
  price INT NOT NULL,
  imageUrl VARCHAR(500),
  stock INT DEFAULT 0,
  rating FLOAT DEFAULT 0,
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Orders Table
```sql
CREATE TABLE orders (
  id INT PRIMARY KEY AUTO_INCREMENT,
  userId INT NOT NULL,
  totalAmount INT NOT NULL,
  status ENUM('pending', 'shipped', 'delivered') DEFAULT 'pending',
  shippingAddress TEXT,
  deliveryOption VARCHAR(100),
  paymentMethod VARCHAR(100),
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (userId) REFERENCES users(id)
);
```

### Order Items Table
```sql
CREATE TABLE order_items (
  id INT PRIMARY KEY AUTO_INCREMENT,
  orderId INT NOT NULL,
  productId INT NOT NULL,
  quantity INT NOT NULL,
  price INT NOT NULL,
  FOREIGN KEY (orderId) REFERENCES orders(id),
  FOREIGN KEY (productId) REFERENCES products(id)
);
```

### Chat Messages Table
```sql
CREATE TABLE chat_messages (
  id INT PRIMARY KEY AUTO_INCREMENT,
  userId INT NOT NULL,
  message TEXT NOT NULL,
  isUserMessage BOOLEAN DEFAULT TRUE,
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (userId) REFERENCES users(id)
);
```

### Favorites Table
```sql
CREATE TABLE favorites (
  id INT PRIMARY KEY AUTO_INCREMENT,
  userId INT NOT NULL,
  productId INT NOT NULL,
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY unique_favorite (userId, productId),
  FOREIGN KEY (userId) REFERENCES users(id),
  FOREIGN KEY (productId) REFERENCES products(id)
);
```

## Dummy Data

Berikut adalah contoh dummy data untuk produk Gundam:

```sql
INSERT INTO products (name, description, category, price, stock, rating) VALUES
('HG 1/144 Kamgfer', 'High Grade Gundam model kit dengan detail menakjubkan', 'HG', 109900, 15, 4.5),
('HGCE 1/144 Mighty Strike Freedom', 'High Grade Cosmic Era Strike Freedom', 'HGCE', 219800, 8, 4.7),
('PG 1/60 RX-78-2 Gundam', 'Perfect Grade original Gundam', 'PG', 899000, 3, 4.9),
('RG 1/144 Sazabi', 'Real Grade Sazabi dengan detail tinggi', 'RG', 159900, 12, 4.6),
('MG 1/100 Unicorn Gundam', 'Master Grade Unicorn Gundam', 'MG', 349900, 6, 4.8),
('HG 1/144 Barbatos', 'High Grade Gundam Barbatos dari Iron-Blooded Orphans', 'HG', 129900, 10, 4.4),
('RE/100 Jagd Doga', 'Real Entry Grade Jagd Doga', 'RE/100', 179900, 7, 4.5),
('HG 1/144 Exia', 'High Grade Gundam Exia dari Gundam 00', 'HG', 119900, 14, 4.3);
```

## Pengembangan Lebih Lanjut

### TODO
- [ ] Integrasi payment gateway (Stripe, GCash, dll)
- [ ] Push notifications
- [ ] Real-time chat dengan WebSocket
- [ ] Product reviews dan ratings
- [ ] Wishlist sharing
- [ ] Referral program
- [ ] Analytics dan tracking
- [ ] Offline mode dengan sync

## Troubleshooting

### Build Error
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### API Connection Error
- Pastikan backend server sudah running di `http://localhost:3000`
- Check firewall settings
- Verify API endpoint di `lib/services/api_service.dart`

### State Management Issues
- Pastikan semua providers sudah di-wrap di `main.dart`
- Use `Consumer` atau `Provider.of` untuk access state
- Avoid rebuilding entire widget tree

## License

MIT License - Lihat LICENSE file untuk detail

## Support

Untuk pertanyaan atau issues, silakan buat GitHub issue atau hubungi tim development.

---

**Happy Coding! 🚀**
