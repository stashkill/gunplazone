# GunplaZone Backend Setup Guide

Panduan lengkap untuk setup backend API GunplaZone menggunakan Node.js + Express + MySQL.

## Prerequisites

- Node.js 16+ dan npm/yarn
- MySQL 8.0+
- Postman (untuk testing API)

## Setup Backend

### 1. Inisialisasi Project

```bash
mkdir gunplazone-backend
cd gunplazone-backend
npm init -y
```

### 2. Install Dependencies

```bash
npm install express mysql2 dotenv cors bcryptjs jsonwebtoken axios
npm install --save-dev nodemon
```

### 3. Setup Environment Variables

Buat file `.env`:

```env
PORT=3000
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=password
DB_NAME=gunplazone
JWT_SECRET=your_jwt_secret_key_here
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret
```

### 4. Database Setup

Buat database dan tables:

```sql
CREATE DATABASE gunplazone;
USE gunplazone;

-- Users Table
CREATE TABLE users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  openId VARCHAR(64) UNIQUE NOT NULL,
  name VARCHAR(255),
  email VARCHAR(320),
  loginMethod VARCHAR(64),
  role ENUM('user', 'admin') DEFAULT 'user',
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  lastSignedIn TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Products Table
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

-- Orders Table
CREATE TABLE orders (
  id INT PRIMARY KEY AUTO_INCREMENT,
  userId INT NOT NULL,
  totalAmount INT NOT NULL,
  status ENUM('pending', 'shipped', 'delivered') DEFAULT 'pending',
  shippingAddress TEXT,
  deliveryOption VARCHAR(100),
  paymentMethod VARCHAR(100),
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
);

-- Order Items Table
CREATE TABLE order_items (
  id INT PRIMARY KEY AUTO_INCREMENT,
  orderId INT NOT NULL,
  productId INT NOT NULL,
  quantity INT NOT NULL,
  price INT NOT NULL,
  FOREIGN KEY (orderId) REFERENCES orders(id) ON DELETE CASCADE,
  FOREIGN KEY (productId) REFERENCES products(id)
);

-- Chat Messages Table
CREATE TABLE chat_messages (
  id INT PRIMARY KEY AUTO_INCREMENT,
  userId INT NOT NULL,
  message TEXT NOT NULL,
  isUserMessage BOOLEAN DEFAULT TRUE,
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
);

-- Favorites Table
CREATE TABLE favorites (
  id INT PRIMARY KEY AUTO_INCREMENT,
  userId INT NOT NULL,
  productId INT NOT NULL,
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY unique_favorite (userId, productId),
  FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (productId) REFERENCES products(id) ON DELETE CASCADE
);

-- Insert Dummy Products
INSERT INTO products (name, description, category, price, imageUrl, stock, rating) VALUES
('HG 1/144 Kamgfer', 'High Grade Gundam model kit dengan detail menakjubkan. Cocok untuk pemula dan kolektor.', 'HG', 109900, 'https://via.placeholder.com/400x400?text=HG+Kamgfer', 15, 4.5),
('HGCE 1/144 Mighty Strike Freedom', 'High Grade Cosmic Era Strike Freedom dengan senjata lengkap', 'HGCE', 219800, 'https://via.placeholder.com/400x400?text=Strike+Freedom', 8, 4.7),
('PG 1/60 RX-78-2 Gundam', 'Perfect Grade original Gundam dengan detail tertinggi', 'PG', 899000, 'https://via.placeholder.com/400x400?text=PG+Gundam', 3, 4.9),
('RG 1/144 Sazabi', 'Real Grade Sazabi dengan detail tinggi dan poseable', 'RG', 159900, 'https://via.placeholder.com/400x400?text=RG+Sazabi', 12, 4.6),
('MG 1/100 Unicorn Gundam', 'Master Grade Unicorn Gundam dengan transformation', 'MG', 349900, 'https://via.placeholder.com/400x400?text=MG+Unicorn', 6, 4.8),
('HG 1/144 Barbatos', 'High Grade Gundam Barbatos dari Iron-Blooded Orphans', 'HG', 129900, 'https://via.placeholder.com/400x400?text=HG+Barbatos', 10, 4.4),
('RE/100 Jagd Doga', 'Real Entry Grade Jagd Doga dengan harga terjangkau', 'RE/100', 179900, 'https://via.placeholder.com/400x400?text=Jagd+Doga', 7, 4.5),
('HG 1/144 Exia', 'High Grade Gundam Exia dari Gundam 00', 'HG', 119900, 'https://via.placeholder.com/400x400?text=HG+Exia', 14, 4.3);
```

### 5. Buat Server File

Buat `server.js`:

```javascript
const express = require('express');
const mysql = require('mysql2/promise');
const cors = require('cors');
const dotenv = require('dotenv');
const jwt = require('jsonwebtoken');

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

// Database Connection Pool
const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
});

// Middleware untuk verifikasi JWT
const verifyToken = (req, res, next) => {
  const token = req.headers.authorization?.split(' ')[1];
  if (!token) return res.status(401).json({ error: 'No token provided' });

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.userId = decoded.id;
    next();
  } catch (err) {
    res.status(401).json({ error: 'Invalid token' });
  }
};

// ============ AUTH ROUTES ============

app.post('/api/auth/google', async (req, res) => {
  try {
    const { idToken } = req.body;
    // Verify token dengan Google (simplified)
    
    const connection = await pool.getConnection();
    
    // Find or create user
    const [users] = await connection.query(
      'SELECT * FROM users WHERE openId = ?',
      [idToken]
    );

    let user;
    if (users.length === 0) {
      // Create new user
      const result = await connection.query(
        'INSERT INTO users (openId, email, loginMethod) VALUES (?, ?, ?)',
        [idToken, `user_${Date.now()}@gunplazone.com`, 'google']
      );
      user = { id: result[0].insertId, openId: idToken, role: 'user' };
    } else {
      user = users[0];
    }

    const token = jwt.sign(
      { id: user.id, role: user.role },
      process.env.JWT_SECRET,
      { expiresIn: '7d' }
    );

    connection.release();
    res.json({ token, user });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/auth/logout', (req, res) => {
  res.json({ message: 'Logged out' });
});

// ============ PRODUCT ROUTES ============

app.get('/api/products', async (req, res) => {
  try {
    const { category } = req.query;
    const connection = await pool.getConnection();

    let query = 'SELECT * FROM products';
    const params = [];

    if (category && category !== 'All') {
      query += ' WHERE category = ?';
      params.push(category);
    }

    const [products] = await connection.query(query, params);
    connection.release();

    res.json({ data: products });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.get('/api/products/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const connection = await pool.getConnection();

    const [products] = await connection.query(
      'SELECT * FROM products WHERE id = ?',
      [id]
    );
    connection.release();

    if (products.length === 0) {
      return res.status(404).json({ error: 'Product not found' });
    }

    res.json({ data: products[0] });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/products', verifyToken, async (req, res) => {
  try {
    const { name, description, category, price, imageUrl, stock } = req.body;
    const connection = await pool.getConnection();

    const result = await connection.query(
      'INSERT INTO products (name, description, category, price, imageUrl, stock) VALUES (?, ?, ?, ?, ?, ?)',
      [name, description, category, price, imageUrl, stock]
    );

    connection.release();
    res.json({ data: { id: result[0].insertId, ...req.body } });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.put('/api/products/:id', verifyToken, async (req, res) => {
  try {
    const { id } = req.params;
    const { name, description, category, price, imageUrl, stock } = req.body;
    const connection = await pool.getConnection();

    await connection.query(
      'UPDATE products SET name=?, description=?, category=?, price=?, imageUrl=?, stock=? WHERE id=?',
      [name, description, category, price, imageUrl, stock, id]
    );

    connection.release();
    res.json({ data: { id, ...req.body } });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.delete('/api/products/:id', verifyToken, async (req, res) => {
  try {
    const { id } = req.params;
    const connection = await pool.getConnection();

    await connection.query('DELETE FROM products WHERE id = ?', [id]);
    connection.release();

    res.json({ message: 'Product deleted' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ============ ORDER ROUTES ============

app.post('/api/orders', verifyToken, async (req, res) => {
  try {
    const { items, totalAmount, shippingAddress, deliveryOption, paymentMethod } = req.body;
    const connection = await pool.getConnection();

    const result = await connection.query(
      'INSERT INTO orders (userId, totalAmount, shippingAddress, deliveryOption, paymentMethod) VALUES (?, ?, ?, ?, ?)',
      [req.userId, totalAmount, shippingAddress, deliveryOption, paymentMethod]
    );

    const orderId = result[0].insertId;

    // Insert order items
    for (const item of items) {
      await connection.query(
        'INSERT INTO order_items (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)',
        [orderId, item.product.id, item.quantity, item.product.price]
      );
    }

    connection.release();
    res.json({ data: { id: orderId, ...req.body } });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.get('/api/orders', verifyToken, async (req, res) => {
  try {
    const connection = await pool.getConnection();

    const [orders] = await connection.query(
      'SELECT * FROM orders WHERE userId = ? ORDER BY createdAt DESC',
      [req.userId]
    );

    connection.release();
    res.json({ data: orders });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ============ CHAT ROUTES ============

app.get('/api/chat/messages', verifyToken, async (req, res) => {
  try {
    const connection = await pool.getConnection();

    const [messages] = await connection.query(
      'SELECT * FROM chat_messages WHERE userId = ? ORDER BY timestamp ASC',
      [req.userId]
    );

    connection.release();
    res.json({ data: messages });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/chat/messages', verifyToken, async (req, res) => {
  try {
    const { message } = req.body;
    const connection = await pool.getConnection();

    const result = await connection.query(
      'INSERT INTO chat_messages (userId, message, isUserMessage) VALUES (?, ?, ?)',
      [req.userId, message, true]
    );

    connection.release();
    res.json({ data: { id: result[0].insertId, message, isUserMessage: true } });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ============ FAVORITES ROUTES ============

app.get('/api/favorites', verifyToken, async (req, res) => {
  try {
    const connection = await pool.getConnection();

    const [favorites] = await connection.query(
      `SELECT f.*, p.* FROM favorites f 
       JOIN products p ON f.productId = p.id 
       WHERE f.userId = ?`,
      [req.userId]
    );

    connection.release();
    res.json({ data: favorites });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/favorites', verifyToken, async (req, res) => {
  try {
    const { productId } = req.body;
    const connection = await pool.getConnection();

    const result = await connection.query(
      'INSERT INTO favorites (userId, productId) VALUES (?, ?)',
      [req.userId, productId]
    );

    connection.release();
    res.json({ data: { id: result[0].insertId, productId } });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.delete('/api/favorites/:productId', verifyToken, async (req, res) => {
  try {
    const { productId } = req.params;
    const connection = await pool.getConnection();

    await connection.query(
      'DELETE FROM favorites WHERE userId = ? AND productId = ?',
      [req.userId, productId]
    );

    connection.release();
    res.json({ message: 'Removed from favorites' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ============ HEALTH CHECK ============

app.get('/api/health', (req, res) => {
  res.json({ status: 'OK' });
});

// Start Server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
```

### 6. Update package.json

```json
{
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js"
  }
}
```

### 7. Run Backend

```bash
# Development
npm run dev

# Production
npm start
```

## Testing API

Gunakan Postman atau curl untuk test endpoints:

```bash
# Get all products
curl http://localhost:3000/api/products

# Get products by category
curl http://localhost:3000/api/products?category=HG

# Login
curl -X POST http://localhost:3000/api/auth/google \
  -H "Content-Type: application/json" \
  -d '{"idToken":"test_token"}'
```

## Deployment

### Deploy ke Heroku

```bash
heroku create gunplazone-api
heroku config:set DB_HOST=your_db_host
heroku config:set DB_USER=your_db_user
heroku config:set DB_PASSWORD=your_db_password
heroku config:set DB_NAME=gunplazone
heroku config:set JWT_SECRET=your_jwt_secret
git push heroku main
```

### Deploy ke AWS/GCP

Gunakan Docker untuk containerization:

```dockerfile
FROM node:16-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

## Troubleshooting

### Database Connection Error
- Pastikan MySQL server sudah running
- Check credentials di `.env`
- Verify database sudah created

### JWT Token Error
- Pastikan JWT_SECRET sudah di-set di `.env`
- Check token format di Authorization header

### CORS Error
- Verify CORS middleware sudah di-setup
- Check allowed origins

---

**Backend setup selesai! Aplikasi Flutter siap terhubung ke API.** 🚀
