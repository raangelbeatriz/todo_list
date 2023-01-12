# To-Do List
 
## ✨ About
To-Do List is an app where the user can create, manage and delete tasks. This project was made using a modular architecture, Provider as a state manager, and Firebase Auth. My goal was to learn more about modular architecture and topics such as Dependency Injection and the use of Service Layers.

## ⚡ Demo
![Screen_Recording_20230112_120647_AdobeExpress (1)](https://user-images.githubusercontent.com/50742224/212125591-d1ba3cdf-a6a0-4d83-9444-69b4c7d5993e.gif)


## Features
- [x] Register with Firebase
- [x] Login with password and Google Sign In
- [x] Logout
- [x] Create a task
- [x] Mark a task as finished
- [x] Delete with a swipe
- [x] Filter finished/unfinished tasks

## Main technologies
- Flutter
- Provider as a State Manager
- SQLite Database
- Firebase Auth

## 🚀 How to Use

- Clone this project
```sh
git clone https://github.com/raangelbeatriz/todo_list.git
```
- Open your project, and then get the packages
```sh
flutter pub get
```
- Make sure you have a Firebase account and then create a project, you can name it todo-list

- Make sure you have Firebase CLI installed in your machine, <a href="https://firebase.google.com/docs/cli">documentation</a>

- Use firebase CLI to add firebase to your app, <a href="https://firebase.google.com/docs/flutter/setup?platform=android">documentation</a>

- After this you'll notice the firebase_options file on your project in this root ```app -> lib -> firebase_options.dart```

- If you want to use the Google Sign-In, generate an SHA-1 key, with the following command or generate through android studio
```sh
keytool -list -v -alias androiddebugkey -keystore  %USERPROFILE%\.android\debug.keystore
```

- Go to Firebase, project settings, and copy the key there

- On Firebase Page go to Authentication, and choose the Email/Password and Google Sign-In methods

- On your terminal, run your flutter project
```sh
flutter run
```
   
   >This project was developed ❤️ by **[@Beatriz Rangel](https://www.linkedin.com/in/beatrizorangel/)**, following the classes of [@Academia do Flutter](https://instituto.academiadoflutter.com.br/)
   ---



