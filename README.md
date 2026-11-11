# Firebase Todo App (SwiftUI)

A simple todo list iOS app built with SwiftUI. Users sign up with email and password, and their tasks are stored in Cloud Firestore.

## Features

- Email and password authentication (sign up, login, logout) using Firebase Authentication
- Create, read, update and delete tasks (CRUD)
- Each task has a title and a description
- Mark tasks as done or undo
- Real-time updates from Firestore
- Each user sees only their own tasks, enforced by Firestore security rules

## Tech Stack

- Swift and SwiftUI
- MVVM architecture
- Firebase Authentication
- Cloud Firestore
- Firebase iOS SDK added with Swift Package Manager

## Project Structure

```
firebase-todo-swiftui/
  FirebaseTodo/
    FirebaseTodo.xcodeproj
    FirebaseTodo/
      Models/
        TodoItem.swift
      ViewModels/
        AuthViewModel.swift
        TaskViewModel.swift
      Views/
        AuthView.swift
        TaskListView.swift
        TaskFormView.swift
      FirebaseTodoApp.swift
      ContentView.swift
      GoogleService-Info.plist
```

## Data Model

Tasks are stored in the `tasks` collection. Each document has:

| Field | Type | Description |
|---|---|---|
| title | String | Task title |
| description | String | Task description |
| completed | Bool | Done or not |
| uid | String | ID of the user who owns the task |
| createdAt | Timestamp | Server timestamp when created |

## Setup

### Requirements
- macOS with Xcode 14 or later
- iOS 15.0 or later (simulator or device)
- A Google account for the Firebase console

### 1. Clone the repository
```
git clone https://github.com/AnweshaDS/firebase-todo-swiftui.git
cd firebase-todo-swiftui
```

### 2. Create a Firebase project
1. Go to the Firebase console and create a new project.
2. Authentication: Sign-in method > enable **Email/Password**.
3. Firestore Database: create a database in **production mode**.
4. Project settings > Add app > iOS. Use the bundle identifier shown in Xcode (target > General).
5. Download `GoogleService-Info.plist` and place it in `FirebaseTodo/FirebaseTodo/` (next to `ContentView.swift`). Make sure the `FirebaseTodo` target is ticked.

### 3. Firestore security rules
In Firestore > Rules, paste and publish:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /tasks/{taskId} {
      allow read, delete: if request.auth != null
                          && resource.data.uid == request.auth.uid;
      allow create: if request.auth != null
                    && request.resource.data.uid == request.auth.uid;
      allow update: if request.auth != null
                    && resource.data.uid == request.auth.uid
                    && request.resource.data.uid == request.auth.uid;
    }
  }
}
```

### 4. Open and run
1. Open `FirebaseTodo/FirebaseTodo.xcodeproj` in Xcode.
2. Wait for Swift Package Manager to resolve the Firebase package.
3. Check that `FirebaseAuth` and `FirebaseFirestore` are listed under target > General > Frameworks, Libraries, and Embedded Content.
4. Choose an iPhone simulator and press Run.

## How to Use

1. Tap **No account? Sign up**, enter an email and a password of at least 6 characters, and tap **Create account**.
2. Tap **+** to add a task with a title and description.
3. Tap a task to edit it.
4. Tap the circle on the left to mark a task as done.
5. Swipe a task to the left to delete it.
6. Tap **Logout** to sign out.

