# 🌿 Farmsetu

**Farmsetu** is a full-stack agricultural marketplace platform that connects farmers directly with customers — cutting out middlemen and giving farmers a digital storefront. Built as a real-world portfolio project, it combines a Flutter mobile app (with role-based farmer/customer experiences) with a web-based admin panel for farmer verification, all backed by Firebase in real time.

> 🎓 Built as a placement portfolio project to demonstrate full-stack mobile development, real-time data architecture, and multi-role application design — developed with assistance from [Claude](https://www.anthropic.com/claude) (Anthropic).

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Repository Structure](#repository-structure)
- [Getting Started](#getting-started)
- [Firebase Setup](#firebase-setup)
- [Admin Panel](#admin-panel)
- [Screenshots](#screenshots)
- [Roadmap](#roadmap)
- [Future Improvements](#future-improvements)
- [License](#license)

---

## Overview

Farmsetu solves a simple problem: farmers struggle to reach customers directly, and customers struggle to find verified, fresh produce sources. The platform has three connected pieces:

1. **Farmer App** — Farmers register, submit documents for verification, and once approved, list and manage their products and incoming orders.
2. **Customer App** — Customers browse approved farms and products, add items to cart, and place orders — all updating in real time as farmers manage their stock.
3. **Admin Panel** — A lightweight web dashboard where Farmsetu staff review and approve/reject farmer registrations.

Both the farmer and customer experiences live in a **single Flutter codebase**, routed by role and approval status at startup.

### Core Workflow

```
Farmer registers  →  Admin reviews & approves  →  Farmer listed publicly
                                                   →  Products visible to customers in real time
```

---

## Features

### 👨‍🌾 Farmer App
- Multi-step registration with Aadhaar & farm passbook verification fields
- Real-time approval status tracking (Submitted → Govt. Review → Admin Review → Approved)
- Product management (add/edit/delete, stock tracking, organic tagging, image upload via Cloudinary)
- Incoming order management with status updates (Accepted → Processing → Dispatched → Delivered)
- Earnings dashboard with weekly performance chart
- Profile photo upload

### 🛒 Customer App
- Browse products by category with live search
- Real-time farm/vendor directory (only shows admin-approved farmers)
- Product detail pages with quantity selector and cart integration
- Cart management with live subtotal/delivery fee calculation
- Multi-address delivery management (up to 5 saved addresses)
- Order placement and order history tracking
- Saved/favorited products
- In-app notifications
- **Multi-language support** — English, Hindi, Tamil, Telugu, Kannada, Marathi (custom localization system)
- Light/dark theme toggle

### 🛠️ Admin Panel
- Review pending farmer registrations
- Approve or reject farmer applications
- View farmer documents and details

---

## Tech Stack

| Layer | Technology |
|---|---|
| **Mobile App** | Flutter (Dart) |
| **State Management** | Provider |
| **Backend / Database** | Firebase Firestore (`asia-south1`) |
| **Authentication** | Firebase Auth |
| **Image Hosting** | Cloudinary |
| **Admin Panel** | HTML / CSS / JavaScript + Firebase Web SDK |
| **Notifications (planned)** | Twilio WhatsApp API |

---

## Architecture

Firebase Firestore is the **single source of truth** across all three interfaces:

- Farmer registrations are written to the `farmers` collection with a `status` field (`0`–`3`, where `3` = approved).
- The admin panel reads pending farmers and updates their `status` on approval/rejection.
- The customer app streams only `status == 3` farmers and their `isAvailable == true` products in real time — so an admin approval instantly makes a farmer's storefront and products visible to customers, with no app restart required.
- Orders are written with the customer's Firebase Auth `uid` (not email) as the key identifier, and stream back to both the customer's order history and the relevant farmer's incoming orders screen.

```
┌─────────────────┐        ┌──────────────────────┐        ┌──────────────────┐
│   Farmer App     │──────▶│   Firebase Firestore   │◀──────│  Customer App     │
│ (registration,    │        │  (farmers, products,   │        │ (browse, cart,    │
│  product mgmt,    │        │   orders collections)  │        │  checkout, orders) │
│  order mgmt)       │        └──────────────────────┘        └──────────────────┘
└─────────────────┘                    ▲
                                         │
                                ┌─────────────────┐
                                │   Admin Panel     │
                                │ (approve/reject    │
                                │  farmers)          │
                                └─────────────────┘
```

---

## Repository Structure

```
farmsetu/
├── README.md
├── LICENSE
├── farmsetu_app/          # Flutter application (farmer + customer)
│   ├── lib/
│   │   ├── models/        # Data models (Product, Farmer, Order, Vendor, Address...)
│   │   ├── providers/     # State management (Provider/ChangeNotifier)
│   │   ├── screens/       # UI screens, organized by feature
│   │   ├── widgets/       # Reusable UI components
│   │   ├── theme/         # App theming & color tokens
│   │   ├── data/          # Mock/fallback data
│   │   ├── l10n/          # Custom localization (6 languages)
│   │   ├── firebase_options.dart.example  # Template — copy & fill via `flutterfire configure`
│   │   └── main.dart      # App entry point & root router
│   └── pubspec.yaml
│
├── farmsetu-admin/         # Web-based admin approval panel
│   └── index.html          # Firebase config is placeholder-only — see Admin Panel section
│
└── README.md
```

---

## Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (≥ 3.38)
- Dart ≥ 3.10
- A Firebase project (Firestore + Authentication enabled)
- A code editor (VS Code / Android Studio)

### Installation

```bash
# Clone the repo
git clone https://github.com/<your-username>/farmsetu.git
cd farmsetu/farmsetu_app

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Configure Firebase

This repo does **not** include `lib/firebase_options.dart` — it's excluded via `.gitignore` because it contains project-specific Firebase keys. Instead, a template is provided at `lib/firebase_options.dart.example`.

To run the app, you need to generate your own:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This creates a fresh `lib/firebase_options.dart` wired to **your own** Firebase project, with the same structure as the `.example` file. After running it:

```bash
flutter pub get
flutter run
```

> 💡 **Why hide this file?** Firebase web config values aren't secret keys in the traditional sense — they're meant to ship inside client apps, and the real security boundary is Firestore Security Rules. But they do identify one specific live project. Keeping a project's own config out of a public portfolio repo is good hygiene: it stops strangers from finding and hammering your free-tier quota, and it mirrors the pattern real engineering teams use for any environment-specific config. See [Firebase Setup](#firebase-setup) below for the Firestore structure and rules this project expects.

---

## Firebase Setup

### Firestore Collections

| Collection | Purpose |
|---|---|
| `farmers` | Farmer profiles + approval `status` (0 = submitted → 3 = approved) |
| `products` | Products listed by approved farmers, keyed by `farmerId` |
| `orders` | Customer orders, keyed by `customerId` (Firebase Auth `uid`) |
| `users/{uid}/saved_products` | Per-customer saved/favorited products |

### Deployed Security Rules

These are the rules actually live on this project's Firebase backend (verified working — admin approve/reject and farmer registration tested end-to-end):

```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /farmers/{farmerId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null
          && (request.auth.uid == farmerId
              || request.auth.token.email == 'admin@farmsetu.com');
    }
    match /products/{productId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null
          && request.auth.uid == request.resource.data.farmerId;
      allow update, delete: if request.auth != null
          && request.auth.uid == resource.data.farmerId;
    }
    match /orders/{orderId} {
      allow read, write: if request.auth != null;
    }
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null
          && request.auth.uid == userId;
    }
  }
}
```

**What this protects, concretely:**
- All reads/writes require Firebase Authentication — no anonymous/public access anywhere.
- Products can only be created or modified by the farmer who owns them (`farmerId` must match the writer's `uid`).
- Saved products are fully isolated per customer.
- Farmer approval/rejection is restricted to the admin panel's Firebase Auth account (`admin@farmsetu.com`), which signs in via Firebase Auth rather than a client-side-only check.

**Known gaps (intentionally deferred, not overlooked):**
- **Farmer self-approval is not yet blocked.** The current `farmers` write rule checks *who* is writing (`uid == farmerId`), not *which fields* they're changing — so a signed-in farmer could technically set their own `status` to `3` (approved) without going through admin review. The fix is straightforward (split into separate `create`/`update` rules and require `status` to stay unchanged on farmer-initiated updates) but hasn't been applied yet.
- **Orders are readable/writable by any authenticated user, not just the people involved.** This is required for now because `farmer_orders_screen.dart` reads the entire `orders` collection client-side and filters in Dart for matching `vendorId`. Properly restricting this needs a `vendorIds: [list of farmer uids]` array field added at order-creation time (or moving farmer order reads behind a Cloud Function) — tracked under [Future Improvements](#future-improvements).
- The admin check is hardcoded to a single email address rather than a scalable role system (e.g. Firebase custom claims). Fine for one admin account; would need revisiting for multiple admins.

---

## Admin Panel

The admin panel (`farmsetu-admin/index.html`) is a standalone HTML page using the Firebase Web SDK to:
- List farmers with pending approval status (real-time via Firestore listeners)
- Approve or reject applications (updates the `status` field in Firestore)
- View farmer documents, details, and all listed products

**Authentication:** Login is handled entirely by Firebase Authentication — the page does not store or check any password of its own. Access is granted only to accounts created in **Firebase Console → Authentication → Users**, and Firestore Security Rules (see [Firebase Setup](#firebase-setup)) restrict farmer-approval writes to that specific admin account.

### Running it locally

1. Open `farmsetu-admin/index.html` and paste your own Firebase Web SDK config into the `firebaseConfig` object (placeholders are provided in the file). Get these values from **Firebase Console → Project Settings → General → Your apps → Web app**.
2. Create an admin user in **Firebase Console → Authentication → Users → Add user**.
3. Open the file in a browser and sign in with that account's email/password.

> 🔒 This repo's version of `index.html` has no hardcoded credentials or live project keys — both were placeholders from the start of public hosting, specifically so the admin password and Firebase project identity are never exposed to anyone browsing the repository.

---

## Screenshots

> _Add screenshots/GIFs of the Farmer App, Customer App, and Admin Panel here once available — e.g. `docs/screenshots/`._

| Customer Home | Farmer Dashboard | Admin Panel |
|---|---|---|
| _coming soon_ | _coming soon_ | _coming soon_ |

---

## Roadmap

- [ ] Twilio WhatsApp integration for farmer approval notifications
- [ ] Customer-side order tracking notifications
- [ ] Ratings & reviews for farms and products
- [ ] Payment gateway integration (currently demo-only checkout)

---

## Future Improvements

Beyond the immediate roadmap, here's the longer-term direction for Farmsetu:

### 🚚 Logistics & Delivery
- **Farmer-assigned delivery agents** — allow farmers to add their own delivery personnel, assign orders to them, and let agents update delivery status (Picked Up → In Transit → Delivered) from a dedicated lightweight view.
- **Live order tracking** for customers, similar to mainstream delivery apps, using real-time location updates from the assigned agent.
- **Delivery zone & radius management** — let farmers define which pincodes/areas they can realistically deliver to.

### 🤖 AI Integration
- **AI-powered crop/produce quality detection** — farmers upload a product photo and an AI model flags quality issues or estimates freshness/grade before listing.
- **Smart pricing suggestions** — recommend fair market prices to farmers based on category, season, and regional listings.
- **AI customer assistant** — a chat-based assistant to help customers find products ("show me organic vegetables under ₹100") using natural language instead of manual filtering.
- **Demand forecasting for farmers** — surface simple trends (e.g. "tomatoes sell out fastest on weekends") so farmers can plan stock.
- **Automated farmer document verification** — use OCR/AI to pre-validate Aadhaar and passbook documents before they reach manual admin review, speeding up approvals.

### 🔐 Platform & Security
- Block farmers from self-approving — split the `farmers` write rule into `create`/`update` so a farmer can edit their own profile but never change their own `status` field; only the admin account should be able to flip approval state.
- Restrict order reads to the customer who placed the order and the farmer(s) whose products are in it (currently any authenticated user can read the full `orders` collection) — requires adding a `vendorIds` array field at order-creation time.
- Move the admin check from a single hardcoded email to a scalable role system (Firebase custom claims) to support multiple admin accounts.
- Add Cloud Functions for sensitive operations (farmer approval, order status transitions) instead of relying solely on client-side Firestore writes.
- Rate limiting and abuse protection on registration endpoints.

### 💳 Commerce
- Real payment gateway integration (Razorpay/Stripe) replacing the current demo checkout.
- Subscription/recurring orders for staple goods (milk, grains).
- Bulk ordering and wholesale pricing tiers for restaurants/businesses.

### 🌍 Reach
- Expand multi-language support to more regional Indian languages.
- Offline-first support for farmers in low-connectivity rural areas, with sync-on-reconnect.

---

## License

This project is licensed under the [MIT License](LICENSE) — free to use, modify, and learn from, with attribution appreciated.

It was built for educational and portfolio purposes; feel free to fork and adapt it for your own learning.

---

<p align="center">Built with 🌱 by Sriram</p>
