# Velora 🛍️

A modern and responsive e-commerce mobile application built with **Flutter and Dart**, focused on a clean shopping experience, smooth navigation, and a polished user interface.

## ✨ Features

* 🏠 Modern Home Screen
* 🔎 Product Search
* 🗂️ Product Categories
* 🎨 Animated Promotional Banners
* ⭐ Featured Products
* 🛍️ Product Details
* ❤️ Favorites / Wishlist
* 🛒 Shopping Cart
* 🔃 Product Sorting
* 📦 Order Management
* 📋 Order Details
* 👤 User Profile
* 🎨 Consistent Custom Theme
* 📱 Responsive Flutter UI

## 🛠️ Tech Stack

* **Flutter**
* **Dart**
* **Provider** — State Management
* **Material 3**

## 📁 Project Structure

```text
lib/
├── data/
│   ├── categories.dart
│   └── products.dart
│
├── models/
│   ├── cart_item.dart
│   ├── category.dart
│   ├── order.dart
│   └── product.dart
│
├── providers/
│   ├── address_provider.dart
│   ├── cart_provider.dart
│   ├── favorites_provider.dart
│   └── order_provider.dart
│
├── screens/
│   ├── cart_screen.dart
│   ├── checkout_screen.dart
│   ├── favorites_screen.dart
│   ├── home.dart
│   ├── order_details_screen.dart
│   ├── order_success_screen.dart
│   ├── orders_screen.dart
│   ├── product_details_screen.dart
│   ├── products_screen.dart
│   ├── profile_screen.dart
│   ├── search_results_screen.dart
│   └── splash_screen.dart
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
└── main.dart

assets/
└── images/
    └── banners/
        ├── headphones.png
        ├── shoes.png
        └── smartwatch.png
```

## 🚀 Getting Started

### Prerequisites

Make sure you have the following installed:

* Flutter SDK
* Dart SDK
* Android Studio or VS Code
* Android Emulator or a physical Android device

### Installation

Clone the repository:

```bash
git clone https://github.com/iqrarashid19/velora-ecommerce-app.git
```

Navigate to the project directory:

```bash
cd velora-ecommerce-app
```

Install the required dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

## 📱 Application Screens

The application includes:

* Splash Screen
* Home Screen
* Product Listing
* Product Details
* Search Results
* Favorites / Wishlist
* Shopping Cart
* Checkout
* Order Success
* Orders
* Order Details
* User Profile

## 📸 Screenshots

Screenshots of the application will be added here.

> More screenshots will be added as the project continues to evolve.

## 🎯 Project Purpose

Velora was developed as a Flutter e-commerce application to practice and demonstrate modern mobile application development concepts, including:

* Flutter UI development
* Responsive layouts
* Reusable widgets
* Provider-based state management
* Navigation between screens
* Product categorization
* Product filtering and sorting
* Shopping cart management
* Favorites / wishlist functionality
* Order management
* Checkout flow
* Asset management
* Custom application theming
* Material 3 design

## 🧩 State Management

The application uses **Provider** for managing application state.

Current providers include:

* `CartProvider`
* `FavoritesProvider`
* `OrderProvider`
* `AddressProvider`

These providers handle application functionality such as cart items, favorite products, orders, and delivery address information.

## 🎨 UI & Design

Velora follows a clean and modern e-commerce design approach with:

* Custom application theme
* Material 3 components
* Consistent typography
* Reusable UI components
* Product cards
* Promotional banners
* Category cards
* Responsive layouts
* Smooth navigation between screens

## 🔄 Application Flow

```text
Splash Screen
      ↓
Home Screen
      ↓
Product Categories / Featured Products
      ↓
Product Listing
      ↓
Product Details
      ↓
Add to Cart
      ↓
Shopping Cart
      ↓
Checkout
      ↓
Order Success
      ↓
Orders
      ↓
Order Details
```

Users can also:

```text
Home
 ├── Search Products
 ├── Browse Categories
 ├── View Featured Products
 ├── Add Products to Favorites
 └── View Product Details
```

## 📦 Current Project Status

**Status:** 🚧 In Development

The core e-commerce interface and shopping flow have been implemented. Additional functionality, refinements, and production-level integrations may be added as development continues.

## 🔮 Future Improvements

Possible future improvements include:

* 🔐 User Authentication
* ☁️ Firebase Backend Integration
* 🗄️ Cloud Database
* 💳 Online Payment Integration
* 📍 Real-time Address / Location Services
* 🔔 Push Notifications
* 🧾 Advanced Order Tracking
* 👨‍💼 Admin Dashboard
* 📊 Product & Sales Analytics
* 🌐 Backend API Integration

## 👨‍💻 Author

**Iqra Rashid**

Flutter & Dart Developer

Built with ❤️ using **Flutter & Dart**.

## 📄 License

This project is created for learning, development, and portfolio purposes.
