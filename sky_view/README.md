sky_view
A Flutter project that displays the position of astrological signs in the night sky based on the current month.

Setup Instructions
Install Flutter
Follow the official guide to install Flutter:
https://flutter.dev/docs/get-started/install

Install Android Studio
Download and install Android Studio from:
https://developer.android.com/studio

Set up Android Emulator

Open Android Studio

Navigate to Tools > AVD Manager

Create and start a new Android Virtual Device (emulator)

Install Visual Studio Code
Download and install VS Code here:
https://code.visualstudio.com/

Install Flutter and Dart plugins in VS Code

Open VS Code

Go to Extensions (Ctrl+Shift+X)

Search for "Flutter" and "Dart" and install both

Running the Project
Open this project folder in Visual Studio Code.

Connect an Android device via USB OR start the Android emulator you created.

In VS Code, press F5 or go to the Run menu and select Run Without Debugging.

The app will build and launch on the connected Android device or emulator.

⚠️ This project currently only supports running on Android devices or emulators.

How to Run This Application on Web
Because Flutter web apps are blocked from sending API requests directly due to CORS policies, I created a backend API using Node.js and Express to handle the requests.

Instructions:
Install Node.js

If you haven’t already, download and install Node.js from:
https://nodejs.org/

Run the Node.js Backend Server

Open a terminal or command prompt.

Navigate to the directory where your Node.js server code is located.

Run the command:
node index.js
This will start the backend server.

Run the Flutter Web Project

Open your Flutter project in VSCode.

Select Chrome as the device target.

Run the Flutter app (flutter run or use VSCode’s Run button).

Your Flutter web app will now communicate with the Node.js backend to bypass CORS issues.

