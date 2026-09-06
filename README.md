# 🛍️ Velora — Modern Flutter E-Commerce App

Velora is a modern **Flutter e-commerce application** built to demonstrate a complete shopping experience with **Firebase Authentication, Cloud Firestore, Provider state management, and a dedicated Admin Dashboard**.

The app includes both **customer-facing shopping features** and **admin-side store management**, making it a complete portfolio-level Flutter project.

---

## ✨ Features

### 👤 Customer Features

* 🔐 Firebase Email & Password Authentication
* 🏠 Modern Home Screen
* 🔎 Product Search
* 🗂️ Product Categories
* 🛍️ Product Listing & Filtering
* 📦 Product Details
* ❤️ Favorites / Wishlist
* 🛒 Shopping Cart
* ➕➖ Cart Quantity Management
* 💳 Checkout & Payment Method Selection
* 📍 Delivery Address Management
* 📦 Order Placement
* ✅ Order Confirmation
* 🧾 My Orders
* 🚚 Order Tracking
* ⭐ Product Reviews & Ratings
* 👤 User Profile
* 🔄 Order Status Updates
* ⚡ Loading, Error & Empty States

### 👨‍💼 Admin Features

* 📊 Admin Dashboard
* 📈 Product Overview
* 🛍️ Product Management
* ➕ Add Products
* ✏️ Edit Products
* 🗑️ Delete Products
* 📦 Order Management
* 🔎 Order Details
* 🔄 Update Order Status
* 👥 Admin-only access control

---

## 🔥 Firebase Integration

Velora uses Firebase as its backend infrastructure.

### Firebase Services

* **Firebase Authentication**

  * User registration
  * User login
  * Authentication state

* **Cloud Firestore**

  * Products
  * Users
  * Orders
  * Favorites
  * Reviews
  * Admin data

* **Firestore Security Rules**

  * User-specific data protection
  * Admin-only product management
  * Protected order status updates
  * Review ownership protection
  * Authenticated access control

---

## 🛠️ Tech Stack

| Technology              | Purpose                                |
| ----------------------- | -------------------------------------- |
| Flutter                 | Cross-platform application development |
| Dart                    | Application programming language       |
| Provider                | State management                       |
| Firebase Authentication | User authentication                    |
| Cloud Firestore         | Backend database                       |
| Material 3              | UI design system                       |
| Google Fonts            | Typography                             |

---

## 📸 Screenshots

### 🚀 Authentication & Home

| Splash Screen                            | Login Screen                           |
| ---------------------------------------- | -------------------------------------- |
| ![Splash Screen](screenshots/splash.png) | ![Login Screen](screenshots/login.png) |

| Signup Screen                            | Home Screen                          |
| ---------------------------------------- | ------------------------------------ |
| ![Signup Screen](screenshots/signup.png) | ![Home Screen](screenshots/home.png) |

---

### 🛍️ Shopping Experience

| Product Details                                     | Cart / Checkout                                   |
| --------------------------------------------------- | ------------------------------------------------- |
| ![Product Details](screenshots/product_details.png) | ![Cart / Checkout](screenshots/cart_checkout.png) |

| Place Order                                 | Order Confirmation                                   |
| ------------------------------------------- | ---------------------------------------------------- |
| ![Place Order](screenshots/place_order.png) | ![Order Confirmation](screenshots/order_confirm.png) |

| My Orders                               | Order Tracking                                    |
| --------------------------------------- | ------------------------------------------------- |
| ![My Orders](screenshots/my_orders.png) | ![Order Tracking](screenshots/order_tracking.png) |

| Favorites                               | Profile                             |
| --------------------------------------- | ----------------------------------- |
| ![Favorites](screenshots/favorites.png) | ![Profile](screenshots/profile.png) |

---

### 👨‍💼 Admin Panel

| Admin Dashboard                                     | Manage Products                                     |
| --------------------------------------------------- | --------------------------------------------------- |
| ![Admin Dashboard](screenshots/admin_dashboard.png) | ![Manage Products](screenshots/manage_products.png) |

| Add Product                                  | Admin Orders                                  |
| -------------------------------------------- | --------------------------------------------- |
| ![Add Product](screenshots/add_products.png) | ![Admin Orders](screenshots/admin_orders.png) |

| Admin Order Detail                                        |   |
| --------------------------------------------------------- | - |
| ![Admin Order Detail](screenshots/admin_order_detail.png) |   |

---

## 🏗️ Project Structure

```text
lib/
├── data/
│   ├── categories.dart
│   └── products.dart
│
├── models/
│   ├── product.dart
│   ├── order.dart
│   ├── cart_item.dart
│   ├── category.dart
│   └── review.dart
│
├── providers/
│   ├── address_provider.dart
│   ├── cart_provider.dart
│   ├── favorites_provider.dart
│   └── order_provider.dart
│
├── screens/
│   ├── home.dart
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   ├── splash_screen.dart
│   ├── products_screen.dart
│   ├── product_details_screen.dart
│   ├── search_results_screen.dart
│   ├── favorites_screen.dart
│   ├── cart_screen.dart
│   ├── checkout_screen.dart
│   ├── order_success_screen.dart
│   ├── orders_screen.dart
│   ├── order_details_screen.dart
│   ├── profile_screen.dart
│   ├── admin_dashboard_screen.dart
│   ├── admin_products_screen.dart
│   ├── admin_product_form_screen.dart
│   └── admin_orders_screen.dart
│
├── services/
│   └── firestore_service.dart
│
├── theme/
│   └── app_theme.dart
│
├── widgets/
│   ├── add_to_cart_button.dart
│   ├── address_form.dart
│   ├── category_item.dart
│   ├── favorite_button.dart
│   ├── greeting_header.dart
│   ├── order_card.dart
│   ├── payment_method_selector.dart
│   ├── payment_option.dart
│   ├── product_card.dart
│   ├── promo_banner.dart
│   ├── search_bar.dart
│   └── section_title.dart
│
├── firebase_options.dart
└── main.dart
```

---

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/iqrarashid19/velora-ecommerce-app.git
```

### 2. Navigate to the Project

```bash
cd velora-ecommerce-app
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Configure Firebase

Connect the project to your own Firebase project and generate the required configuration using FlutterFire CLI.

```bash
flutterfire configure
```

### 5. Run the Application

```bash
flutter run
```

---

## 🔐 Security

The project uses **Firestore Security Rules** to protect user-specific data and restrict admin functionality.

Sensitive Firebase files such as:

```text
android/app/google-services.json
```

are excluded from version control.

Before production deployment, review Firebase configuration, security rules, authentication settings, and environment-specific credentials.

---

## 🎯 What This Project Demonstrates

Velora demonstrates practical Flutter development skills including:

* Clean Flutter project organization
* Reusable widgets
* Provider-based state management
* Firebase Authentication
* Cloud Firestore integration
* CRUD operations
* Role-based admin functionality
* Shopping cart implementation
* Checkout flow
* Order management
* Order tracking
* Reviews & ratings
* Form validation
* Loading, error and empty states
* Protected Firestore data

---

## 📌 Future Improvements

Possible future improvements include:

* 💳 Online payment gateway integration
* 🔔 Push notifications
* 📊 Advanced analytics
* 🖼️ Cloud image management
* 📱 Play Store deployment
* 🎨 Further UI/UX enhancements

---

## 👨‍💻 Developer

**Iqra Rashid**

Flutter & Dart Developer

Built as a portfolio project to demonstrate modern mobile application development with Flutter and Firebase.

---

## ⭐ Support

If you find this project useful or interesting, consider giving the repository a ⭐ on GitHub.
