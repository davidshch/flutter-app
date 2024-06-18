import 'package:flutter/material.dart';
import 'package:zyvexapp/screens/finishscreen.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  int totalVolume = 0; // Variable to store the total volume of the workout
  int numExercises =
      0; // Variable to store the number of exercises in the workout

  final TextEditingController workoutController =
      TextEditingController(); // A controller to get the value of the text field

  String workoutName = ''; // Variable to store the workout name

  bool isNotEmpty =
      false; // Used in for loop to check if there are no sets inputted

  bool isButtonActive =
      false; // Updates when exercise is added or there are no exercises for finish button

  // Similar to the one on loginpage it will listen for whenever workoutName is changed and check if there are no sets as well to activate button or not
  @override
  void initState() {
    super.initState();

    workoutController.addListener(() {
      // For loop to check if there are no sets inputted
      for (int i = 0; i < exercises.length; i++) {
        isNotEmpty = exercises[i].sets.isNotEmpty;
        if (isNotEmpty) {
          // If sets found, break out
          break;
        }
      }
      // Button is activated if there are sets and the name isn't empty
      final isButtonActive = workoutController.text.isNotEmpty && isNotEmpty;

      // Updates the new state to the bool
      setState(() => this.isButtonActive = isButtonActive);
    });
  }

  List<Exercise> exercises =
      []; // A list to store the exercises added by the user

  // Next 4 methods are to send dialog and deal with buttons on each dialog
  void _showAddExerciseDialog() {
    showDialog(
      // Dialog builder
      context: context,
      builder: (BuildContext context) {
        TextEditingController exerciseController = TextEditingController();
        return AlertDialog(
            title: const Text('Add Exercise'),
            content: TextField(controller: exerciseController),
            actions: [
              // Actions of dialog
              TextButton(
                  onPressed: () =>
                      Navigator.of(context).pop(), // Disposes pop up
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    // Save the exercise name in the list if it is not empty
                    if (exerciseController.text.isNotEmpty) {
                      setState(() {
                        exercises.add(
                            Exercise(name: exerciseController.text, sets: []));
                      });
                    }
                    Navigator.of(context).pop(); // Dispose
                  },
                  child: const Text('OK'))
            ]);
      },
    );
  }

  void _showRestartWorkoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text('Restart Workout?'),
            content: const Text(
              'Are you sure you want to restart your workout?',
              style: TextStyle(fontSize: 20),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    setState(() {
                      exercises
                          .clear(); // CLears exercise list and brings set count back to 1
                      Set.count = 1;
                    });
                    isButtonActive =
                        false; // Sets bool back to false when there's no exercises
                    Navigator.of(context).pop();
                  },
                  child: const Text('Restart'))
            ]);
      },
    );
  }

  void _showFinishWorkoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text('Finish Workout?',
                style: TextStyle(color: Colors.green)),
            content: const Text(
                'Are you sure you are ready to finish your workout?',
                style: TextStyle(fontSize: 20)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    setState(() {
                      workoutName = workoutController
                          .text; // Retrieves value of workoutName using controller
                      numExercises = 0; // Brings both variables back to 0
                      totalVolume = 0;
                    });

                    // Loops through exercises and calculates volume
                    for (int i = 0; i < exercises.length; i++) {
                      // Finds number of exercises
                      numExercises++;
                      // Loop through the sets of each exercise
                      for (int j = 0; j < exercises[i].sets.length; j++) {
                        // Update the total volume by multiplying the weight and the reps of each set
                        totalVolume += exercises[i].sets[j].weight *
                            exercises[i].sets[j].reps;
                      }
                    }

                    Navigator.of(context).pop();

                    // Pushes to finish screen with workoutName, totalVolume, numExercises, exercises, workoutController, and isButtonActive as required parameters
                    // to be used and modified in the next screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return FinishScreen(
                            workoutName: workoutName,
                            numExercises: numExercises,
                            totalVolume: totalVolume,
                            exercises: exercises,
                            workoutController: workoutController,
                            isButtonActive: isButtonActive);
                      }),
                    );
                  },
                  child: const Text('Finish',
                      style: TextStyle(color: Colors.green)))
            ]);
      },
    );
  }

  void _showAddSetDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController weightController = TextEditingController();
        TextEditingController repController = TextEditingController();
        return AlertDialog(
            title: const Text('Add Set'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                    controller: weightController,
                    keyboardType: TextInputType
                        .number, // Sets keyboard to number version to only allow numbers
                    decoration:
                        const InputDecoration(labelText: 'Weight (lbs)')),
                TextField(
                    controller: repController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Reps')),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    // Save the set in the exercise and parses the numbers from the controllers' values casted to Strings and if it's null they're set to 0 (to fix errors)
                    setState(() {
                      int weight = int.tryParse(weightController.text) ?? 0;
                      int reps = int.tryParse(repController.text) ?? 0;
                      // Validate the input and adds the set with the reps and weight data and won't add the set otherwise
                      if (weight > 0 &&
                          weight <= 1000 &&
                          reps > 0 &&
                          reps <= 20) {
                        exercises[index]
                            .sets
                            .add(Set(weight: weight, reps: reps));
                      }
                    });
                    Navigator.of(context).pop();
                    isButtonActive = workoutController.text.isNotEmpty &&
                        isNotEmpty; // Update isButtonActive
                  },
                  child: const Text('OK'))
            ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false, // Disables back button to go back to login page
        child: Scaffold(
          appBar: AppBar(
            // Use a text field as the title of the app bar
            title: TextField(
              controller: workoutController,
              style: TextStyle(
                  color: Colors.purple[900],
                  fontSize: 27,
                  fontWeight: FontWeight.bold),
              // Set the decoration of the text field
              decoration: const InputDecoration(
                // Set the hint text and style
                hintText: 'Enter Workout Name...',
                hintStyle: TextStyle(color: Colors.grey),
                // Remove the border and the background color
                border: InputBorder.none,
                fillColor: Colors.transparent,
                filled: true,
              ),
            ),
          ),
          body: Column(children: [
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: _showAddExerciseDialog, // Calls method when pressed
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(250.0, 50.0)),
                child: const Text('Add Exercises',
                    style: TextStyle(fontSize: 20))),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _showRestartWorkoutDialog,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[50],
                  minimumSize: const Size(250.0, 50.0)),
              child: const Text('Restart Workout',
                  style: TextStyle(color: Color(0xFFEF5350), fontSize: 20)),
            ),
            const SizedBox(height: 10),
            // Display the exercises in a list view by building one
            Expanded(
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        exercises[index]
                            .name, // Takes the name of the exercise and sets it to the item text
                        style: const TextStyle(fontSize: 20)),
                    trailing: IconButton(
                      icon: Icon(Icons.add_circle, color: Colors.purple[900]),
                      onPressed: () {
                        // Show the add set dialog when the icon is pressed
                        _showAddSetDialog(index);
                      },
                    ),
                    onTap: () {
                      // Expand or collapse the table when the tile is tapped
                      setState(() {
                        exercises[index].expanded = !exercises[index].expanded;
                      });
                    },
                    // Displays the created set table if it's expanded and not empty
                    subtitle: exercises[index].expanded &&
                            exercises[index].sets.isNotEmpty
                        ? Table(
                            border: TableBorder.all(), // Uniform border
                            children: [
                              const TableRow(children: [
                                Text('Set',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 18)),
                                Text('Weight (lbs)',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 17)),
                                Text('Reps',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 18)),
                              ]),
                              // Generate a table row for each set
                              ...exercises[index].sets.map((set) {
                                return TableRow(children: [
                                  Text(set.number.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 18)),
                                  Text(set.weight.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 18)),
                                  Text(set.reps.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 18)),
                                ]);
                              }),
                            ],
                          )
                        : null, // Do not show the table if the exercise is not expanded or has no sets
                  );
                },
              ),
            ),
            ElevatedButton(
                // Ternary operator to set to null (disable) if bool is false (no exercises)
                onPressed: isButtonActive
                    ? () {
                        // Runs finish dialog method
                        _showFinishWorkoutDialog();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(150.0, 50.0)),
                child: const Text('Finish',
                    style: TextStyle(color: Colors.white, fontSize: 25))),
            const SizedBox(
              height: 10,
            )
          ]),
        ));
  }
}

// Class/object to represent an exercise
class Exercise {
  String name;
  List<Set> sets;
  bool expanded; // Flag to indicate if the exercise is expanded or collapsed
  Exercise({required this.name, required this.sets, this.expanded = false});
}

// Class/object to represent a set
class Set {
  int number;
  int weight;
  int reps;
  Set({required this.weight, required this.reps}) : number = count++;
  static int count = 1; // Static variable to keep track of the set number
}
