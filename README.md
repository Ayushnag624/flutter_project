# om_ornament

A complete Flutter-based Jewelry Inventory System with:

- Client App (View items + real-time gold/silver rates)
- Admin App (Upload jewelry, manage stock, update real-time rates)
- Firebase real-time sync & Cloudinary image upload

This project contains two separate Flutter applications that work together as one system.

---

## Getting Started

This project is built using:
- Flutter  
- Firebase Realtime Database  
- Firebase Authentication  
- Cloudinary (Image Upload)  

To run the project, configure Firebase and Cloudinary in both apps.

---

## Project Structure

```
om_ornament/
 ├─ client_app/
 │   ├─ lib/
 │   ├─ android/
 │   └─ main.dart
 ├─ admin_app/
 │   ├─ lib/
 │   ├─ android/
 │   └─ main.dart
 └─ README.md
```

---

## Features

### Client App
- View jewelry items
- View real-time Gold & Silver rates
- Firebase Realtime Database sync
- Smooth UI and fast loading
- Multi-device support

### Admin App
- Upload jewelry with Cloudinary
- Add/Edit/Delete items
- Manage stock and categories
- Update real-time Gold & Silver rates
- Secure login using Firebase Authentication
- Changes reflect instantly in client app

---

## Tech Stack

- Flutter (Dart)
- Firebase Realtime Database
- Firebase Authentication
- Cloudinary CDN
- HTTP, Image Picker
- Optional: GetX / Riverpod

---

## Running the Apps

### Run Client App
```
cd client_app
flutter pub get
flutter run
```

### Run Admin App
```
cd admin_app
flutter pub get
flutter run
```

---

## Firebase Setup

1. Create Firebase project  
2. Enable:
   - Realtime Database  
   - Authentication → Email/Password  
3. Download `google-services.json` and place it in:
   ```
   android/app/
   ```
4. Add Firebase rules (ask me if you need secure ones)

---

## Cloudinary Setup

1. Create a Cloudinary account  
2. Create an **unsigned upload preset**  
3. Add these into admin_app `main.dart`:
   ```
   final String cloudName = "your_cloud_name";
   final String uploadPreset = "your_upload_preset";
   ```

---

## Database Structure Example

```
rates/
  gold: 6300
  silver: 85
  updatedAt: timestamp

items/
  itemId/
    title: "Necklace"
    price: 55000
    stock: 3
    imageUrl: "https://..."
    createdAt: timestamp
```

---

## Screenshots

Add your screenshots under:
```
client_app/screenshots/
admin_app/screenshots/
```

---

## Learn More About Flutter

- https://docs.flutter.dev/get-started/codelab
- https://docs.flutter.dev/cookbook
- https://docs.flutter.dev/
