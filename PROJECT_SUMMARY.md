# GunplaZone Flutter Project - Summary

## 📱 Ringkasan Project

Project **GunplaZone** adalah aplikasi mobile e-commerce lengkap untuk toko Gundam, dibangun dengan **Flutter (Dart)** dengan fitur-fitur enterprise-grade.

## ✨ Fitur Utama

### 1. **Autentikasi & User Management**

- Login dengan Google dan Apple

- User privilege system (Admin & User biasa)

- Session management dengan JWT

- User profile dengan statistik

### 2. **E-Commerce Store**

- Browse produk dengan grid layout

- Search produk real-time

- Filter kategori (HG, RG, MG, PG, RE/100)

- Product detail screen dengan spesifikasi lengkap

- Favorites/Wishlist functionality

- Rating dan review produk

### 3. **Shopping Cart & Checkout**

- Add/remove/update quantity items

- Real-time cart total calculation

- Shipping address input

- Delivery options (Standard, Express)

- Payment method selection

- Order summary dengan breakdown harga

- Harga dalam format Rupiah (Rp)

### 4. **Order Management**

- Order history dengan status tracking

- Order detail view

- Order status: Pending, Shipped, Delivered

- Order items breakdown

### 5. **Chat Support**

- Real-time chat dengan customer support

- Message history

- Emoji & attachment support

- Auto-scroll ke message terbaru

- Support response simulation

### 6. **Admin Panel**

- CRUD produk (Create, Read, Update, Delete)

- Product form dengan validasi

- Delete confirmation dialog

- Stock management

- Price management dalam Rupiah

### 7. **Theme Management**

- Light mode & Dark mode toggle

- Persistent theme preference

- Consistent color scheme

- Material Design 3 compliance

### 8. **Navigation**

- Bottom tab bar (Home, Cart, Chat, Profile)

- Go Router untuk deep linking

- Protected routes untuk authenticated users

- Smooth transitions antar screen

## 📁 Struktur Project

```
gunplazone_flutter/
├── lib/
│   ├── main.dart                          # Entry point
│   ├── config/
│   │   └── theme.dart                     # Theme configuration
│   ├── models/
│   │   ├── models.dart                    # Data models
│   │   └── models.g.dart                  # Generated JSON serialization
│   ├── services/
│   │   └── api_service.dart               # API client (Dio)
│   ├── providers/
│   │   ├── theme_provider.dart            # Theme state
│   │   ├── auth_provider.dart             # Auth state
│   │   ├── product_provider.dart          # Product management
│   │   ├── cart_provider.dart             # Shopping cart
│   │   └── chat_provider.dart             # Chat messages
│   ├── routes/
│   │   └── app_routes.dart                # Go Router configuration
│   ├── screens/
│   │   ├── splash_screen.dart             # Splash/Loading screen
│   │   ├── auth/
│   │   │   └── sign_in_screen.dart        # Login screen
│   │   ├── home/
│   │   │   ├── home_screen.dart           # Product listing
│   │   │   └── product_detail_screen.dart # Product detail
│   │   ├── cart/
│   │   │   └── cart_screen.dart           # Shopping cart
│   │   ├── checkout/
│   │   │   └── checkout_screen.dart       # Checkout flow
│   │   ├── chat/
│   │   │   └── chat_screen.dart           # Chat support
│   │   ├── profile/
│   │   │   ├── profile_screen.dart        # User profile
│   │   │   └── orders_screen.dart         # Order history
│   │   └── admin/
│   │       └── admin_panel_screen.dart    # Admin CRUD
│   └── widgets/
│       ├── bottom_nav_bar.dart            # Bottom navigation
│       └── product_card.dart              # Product card widget
├── pubspec.yaml                           # Dependencies
├── analysis_options.yaml                  # Linting rules
├── .gitignore                             # Git ignore
├── README.md                              # Project documentation
├── BACKEND_SETUP.md                       # Backend setup guide
├── PROJECT_SUMMARY.md                     # This file
└── assets/
    ├── images/                            # App images
    ├── icons/                             # App icons
    └── fonts/                             # Custom fonts
```

## 🛠️ Tech Stack

| Kategori | Technology |
| --- | --- |
| **Framework** | Flutter 3.3.0+ |
| **Language** | Dart 3.0+ |
| **State Management** | Provider 6.4.0 |
| **Navigation** | Go Router 13.2.0 |
| **HTTP Client** | Dio 5.4.0 |
| **Authentication** | Google Sign-In 6.2.0, Firebase Auth 4.17.0 |
| **Local Storage** | SharedPreferences 2.2.2, SQLite 2.3.0 |
| **JSON Serialization** | json_serializable 6.7.1 |
| **UI Framework** | Material Design 3 |

## 📊 Data Models

### User

```
class User {
  int id;
  String email;
  String? name;
  String role; // 'user' or 'admin'
  DateTime createdAt;
}
```

### Product

```
class Product {
  int id;
  String name;
  String description;
  String category;
  int price; // Rupiah
  String imageUrl;
  int stock;
  double rating;
  DateTime createdAt;
}
```

### CartItem

```
class CartItem {
  int id;
  Product product;
  int quantity;
  int get subtotal => product.price * quantity;
}
```

### Order

```
class Order {
  int id;
  int userId;
  List<CartItem> items;
  int totalAmount;
  String status; // 'pending', 'shipped', 'delivered'
  String shippingAddress;
  String deliveryOption;
  String paymentMethod;
  DateTime createdAt;
}
```

### ChatMessage

```
class ChatMessage {
  int id;
  int userId;
  String message;
  bool isUserMessage;
  DateTime timestamp;
}
```

### Favorite

```
class Favorite {
  int id;
  int userId;
  int productId;
  Product product;
  DateTime createdAt;
}
```

## 🎨 Color Scheme

### Light Mode

- **Background**: #FFFFFF

- **Surface**: #F5F5F5

- **Foreground**: #11181C

- **Primary**: #0A7EA4 (Teal)

- **Border**: #E5E7EB

### Dark Mode

- **Background**: #151718

- **Surface**: #1E2022

- **Foreground**: #ECEDEE

- **Primary**: #0A7EA4 (Teal)

- **Border**: #334155

## 🚀 Getting Started

### Prerequisites

```bash
# Install Flutter
flutter --version  # Should be 3.3.0+

# Install Dart
dart --version     # Should be 3.0+
```

### Installation

1. **Extract project**

```bash
tar -xzf gunplazone_flutter.tar.gz
cd gunplazone_flutter
```

1. **Install dependencies**

```bash
flutter pub get
```

1. **Generate JSON serialization**

```bash
flutter pub run build_runner build
```

1. **Run aplikasi**

```bash
# iOS
flutter run -d ios

# Android
flutter run -d android

# Web
flutter run -d web
```

## 📡 API Integration

Aplikasi terhubung ke backend API di `http://localhost:3000/api`

### Endpoints

| Method | Endpoint | Auth | Description |
| --- | --- | --- | --- |
| POST | `/auth/google` | ❌ | Login dengan Google |
| POST | `/auth/logout` | ✅ | Logout |
| GET | `/products` | ❌ | List produk |
| GET | `/products/:id` | ❌ | Detail produk |
| POST | `/products` | ✅ | Buat produk (admin ) |
| PUT | `/products/:id` | ✅ | Update produk (admin) |
| DELETE | `/products/:id` | ✅ | Hapus produk (admin) |
| POST | `/orders` | ✅ | Buat order |
| GET | `/orders` | ✅ | List orders user |
| GET | `/chat/messages` | ✅ | Chat messages |
| POST | `/chat/messages` | ✅ | Send message |
| GET | `/favorites` | ✅ | List favorites |
| POST | `/favorites` | ✅ | Add favorite |
| DELETE | `/favorites/:id` | ✅ | Remove favorite |

## 💾 Database Schema

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

## 📦 Dummy Data

Aplikasi dilengkapi dengan 8 produk Gundam dummy:

1. **HG 1/144 Kamgfer** - Rp 109.900

1. **HGCE 1/144 Mighty Strike Freedom** - Rp 219.800

1. **PG 1/60 RX-78-2 Gundam** - Rp 899.000

1. **RG 1/144 Sazabi** - Rp 159.900

1. **MG 1/100 Unicorn Gundam** - Rp 349.900

1. **HG 1/144 Barbatos** - Rp 129.900

1. **RE/100 Jagd Doga** - Rp 179.900

1. **HG 1/144 Exia** - Rp 119.900

## 🔐 Security Features

- JWT token-based authentication

- Protected API endpoints

- Secure token storage (SecureStore untuk native, Cookie untuk web)

- CORS enabled

- Input validation dengan Zod

- SQL injection prevention dengan parameterized queries

## 📱 UI/UX Features

- **Responsive Design**: Optimal untuk semua ukuran layar

- **Dark Mode Support**: Automatic theme switching

- **Loading States**: Skeleton screens dan spinners

- **Error Handling**: User-friendly error messages

- **Haptic Feedback**: Vibration on interactions

- **Smooth Animations**: Subtle transitions antar screen

- **Accessibility**: Proper contrast ratios dan font sizes

## 🧪 Testing

### Unit Tests

```bash
flutter test
```

### Integration Tests

```bash
flutter test integration_test/
```

### Manual Testing Checklist

- [x] Login flow dengan Google

- [ ] Browse dan search produk

- [ ] Add/remove dari cart

- [ ] Checkout flow lengkap

- [ ] Chat functionality

- [ ] Admin CRUD operations

- [ ] Dark mode toggle

- [ ] Order history view

- [ ] Favorites management

- [ ] Logout functionality

## 📚 Documentation Files

1. **README.md** - Project overview dan setup guide

1. **BACKEND_SETUP.md** - Backend API setup dengan Node.js + Express + MySQL

1. **PROJECT_SUMMARY.md** - This file

## 🚢 Deployment

### Build APK (Android)

```bash
flutter build apk --release
```

### Build iOS

```bash
flutter build ios --release
```

### Build Web

```bash
flutter build web --release
```

## 🐛 Known Limitations

- Chat support adalah mock (auto-reply setelah 2 detik)

- Product images menggunakan placeholder

- Payment gateway belum terintegrasi

- Real-time sync belum implemented

- Offline mode belum tersedia

## 🔄 Next Steps

1. **Setup Backend**: Ikuti BACKEND_SETUP.md untuk setup Node.js API

1. **Database Setup**: Create MySQL database dan run migrations

1. **Google OAuth**: Setup Google Sign-In credentials

1. **Run App**: `flutter run` untuk development

1. **Testing**: Test semua user flows end-to-end

1. **Deployment**: Build dan deploy ke App Store/Play Store

## 📞 Support

Untuk pertanyaan atau issues:

1. Check README.md untuk common issues

1. Check BACKEND_SETUP.md untuk backend problems

1. Review Flutter documentation: [https://flutter.dev](https://flutter.dev)

1. Check Dart documentation: [https://dart.dev](https://dart.dev)

## 📄 License

MIT License - Gratis untuk penggunaan komersial dan personal

---

**Happy Coding! 🚀 GunplaZone siap diluncurkan!**

