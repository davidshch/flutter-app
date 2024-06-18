// Nesscary imports to be refrenced in file
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zyvexapp/userdata.dart';
import 'workoutscreen.dart';

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  // Constructs state of the widget because it is stateful and will change during runtime
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? name;
  int? age;

  bool isButtonActive = false;

  // Initialized later in initState() method
  late TextEditingController nameController;

  // A helper function (when state is updated) to check if the name text field and age dropdown are empty or not to then disable button accordingly
  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(); // Controllers are used to get the state of text fields

    nameController.addListener(() {
      // Whenever text field is edited
      final isButtonActive = nameController.text.isNotEmpty && age != null;

      // Updates the new state to the bool
      setState(() => this.isButtonActive = isButtonActive);
    });
  }

  // Clean up the controllers when the widget is disposed.
  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Builds the UI of screen/widget tree
    return Scaffold(
        // Layout
        // Disables resizing of layout when keyboard is opened
        resizeToAvoidBottomInset: false,
        body: Column(
          // Column layout widget
          children: [
            SizedBox(
              width: double.infinity,
              child: Image.asset(
                  'assets/images/login_image.png', // Login image sized to width of box
                  fit: BoxFit.fitWidth),
            ),
            const SizedBox(
                height:
                    10), // Empty sized boxes are used for spacing of widgets on screen
            SizedBox(
              height: 100,
              width: 250,
              child: Image.asset('assets/images/logo.png',
                  fit: BoxFit.fill), // Logo fills sized box
            ),
            const SizedBox(height: 10),
            const Text(
              'Empower Your Fitness',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),
            Row(children: <Widget>[
              // Row layout widget
              const SizedBox(width: 50),
              SizedBox(
                width: 150,
                child: TextField(
                  controller:
                      nameController, // Set nameController to track the state of this text field
                  decoration: const InputDecoration(
                      hintText:
                          'Enter your name'), // When there is nothing inputted shows this text
                ),
              ),
              const SizedBox(width: 100),
              SizedBox(
                width: 55,
                child: DropdownButton<int>(
                  hint: const Text('Age'),
                  // Shows 5 options at a time
                  menuMaxHeight: 5 * 48.0,
                  // Sets inputted value of dropdown to age variable
                  value: age,
                  // Generates a list of values starting from 12 to 90 which is set to the menu items
                  items: List.generate(88, (index) => index + 12)
                      .map((e) =>
                          DropdownMenuItem(value: e, child: Text(e.toString())))
                      .toList(),
                  // When value is changed it sets the inputted value to age
                  onChanged: (value) {
                    // Checks if name field has text when age value is changed to know to disable button or not
                    if (nameController.text.isNotEmpty) {
                      isButtonActive = true;
                    }
                    // Use setState inside the state class to set the age variable
                    setState(() {
                      age = value;
                    });
                  },
                ),
              ),
            ]),
            const SizedBox(height: 250),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150.0, 50.0)),
                onPressed:
                    isButtonActive // If isButtonActive is false then button will be disabled (null)
                        ? () {
                            // Uses Provider file (userdata.dart) which stores data and calls its constructor to set and store the new values
                            context
                                .read<UserData>()
                                .setName(nameController.text);
                            context.read<UserData>().setAge(age!);

                            // Use the Navigator widget to navigate to the next workout screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return const WorkoutScreen();
                              }),
                            );
                          }
                        : null,
                child: const Text('Start', style: TextStyle(fontSize: 25)))
          ],
        ));
  }
}
