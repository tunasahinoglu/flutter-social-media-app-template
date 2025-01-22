# Flutter Social Media Application Template - BLoC - Firebase

A Flutter-based social media app template that includes features like user registration, login, password reset, email verification, local data storage, multi-language support, and theme switching. This template was developed using BLoC state management.

## Features

- ✅ Email verification via Firebase Authentication
- ✅ Password reset functionality
- ✅ Local user data storage with Hive
- ✅ Firebase Firestore database integration
- ✅ Media management with Firebase Storage
- ✅ Page navigation using Go Router
- ✅ Multi-language support (TR-EN)
- ✅ Theme switching (Dark/Light Mode)
- ✅ Google Navigation Bar integration
- ✅ Network connectivity check


<img src="https://github.com/user-attachments/assets/a135324e-ddc4-4f7b-886f-cc4da90833c7" width="200" />

<img src="https://github.com/user-attachments/assets/c1e92812-d284-412a-869b-d526098f02f5" width="200" />

<img src="https://github.com/user-attachments/assets/3eaa3c75-0c11-4255-8c03-76371e69ad3b" width="200" />
  
<img src="https://github.com/user-attachments/assets/10cce733-8bb3-4778-89ec-b431473ada50" width="200" />

<img src="https://github.com/user-attachments/assets/e8ed0752-d72c-4b52-84fc-a2457c3ae79a" width="200" />

<img src="https://github.com/user-attachments/assets/09d7eae9-04b3-43a0-9de5-9ac9c96912bb" width="200" />






## Dependencies
| **Category**         | **Package**                  | **Version**  |
|----------------------|-----------------------------|-------------|
| **State Management** | flutter_bloc                | ^8.1.6      |
|                      | equatable                   | ^2.0.5      |
| **Cache Data**       | hive                         | ^2.2.3      |
|                      | hive_flutter                | ^1.1.0      |
|                      | path_provider               | ^2.1.4      |
| **Firebase**         | firebase_core               | ^3.2.0      |
| **Authentication**   | firebase_auth               | ^5.1.2      |
| **Database**         | cloud_firestore             | ^5.2.1      |
|                      | firebase_storage            | ^12.1.1     |
| **Router**          | go_router                    | ^14.2.1     |
| **Navigation Bar**  | google_nav_bar               | ^5.0.6      |
| **Localization**    | easy_localization            | ^3.0.7      |
| **Network**        | connectivity_plus            | ^6.0.4      |
| **Other**           | uuid                         | ^4.4.2      |
|                      | image_picker                | ^1.1.2      |
|                      | flutter_image_compress      | ^1.1.0      |
|                      | image                        | ^4.0.15     |




## Installation

Clone the repository:
```
git clone https://github.com/tunasahinoglu/flutter-social-media-app-template.git
```
Install dependencies:
```
cd flutter-social-media-app-template
flutter pub get
```
Set up Firebase:

Create a Firebase project.

Add google-services.json (Android), GoogleService-Info.plist (iOS) and firebase_option.dart files to the appropriate directories.

Run the app:
```
flutter run
```


