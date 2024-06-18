// Name: David Shcherbatykh
// Teacher: Ms. Hideg ICS3U
// Due: Wed, Jan. 16, 2024
// Description: A workout tracker app that allows you to input your exercises, the name of the workout, and the amount of reps
// and weight you did with each reps and weight input adding another set to the exercise you added it to. The first page is a simple login/welcome
// page that allows the user to input their name and age. After finishing their workout by pressing the 'Finish' button, the user
// will be congratulated and see a summary of their workout with the name, number of exercises, and total volume of the workout.
// The user can also rate how they felt during the workout. The user can start a new workout by pressing the according button, and
// if the user wants to restart their current workout, they can do so by pressing the according button.
//

import 'package:flutter/material.dart'; // Nesscary to use material design widgets
import 'package:provider/provider.dart'; // Provider package to use providers for user data
// Import other files to call their main widgets
import 'userdata.dart';
import 'screens/loginpage.dart';

void main() {
  // Run the app with the MyApp widget
  runApp(const MyApp());
}

// Define the MyApp class as a custom widget
class MyApp extends StatelessWidget {
  // Use a constant constructor for stateless widgets
  const MyApp({super.key});

  // Override the build method to return the app widget
  @override
  Widget build(BuildContext context) {
    // Use the Provider package to provide the UserData object from userdata.dart to the app
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserData(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily:
              'Kanit', // Sets default font family to Kanit which was imported in pubspec.yaml and downloaded from Google Fonts to fonts folder

          primaryColor: Colors.purple,
        ),
        // Set the home to the LoginPage widget (loginpage.dart)
        home: const LoginPage(),
      ),
    );
  }
}
