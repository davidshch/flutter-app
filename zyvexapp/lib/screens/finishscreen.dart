import 'package:confetti/confetti.dart'; // Library for confetti animation
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zyvexapp/screens/workoutscreen.dart';
import 'package:zyvexapp/userdata.dart';

// ignore: must_be_immutable
class FinishScreen extends StatefulWidget {
  final String workoutName; // Declare passed variables
  int numExercises;
  int totalVolume;
  final List<Exercise> exercises;
  final TextEditingController workoutController;
  bool isButtonActive;

  FinishScreen(
      {super.key,
      required this.workoutName,
      required this.numExercises,
      required this.totalVolume,
      required this.exercises,
      required this.workoutController,
      required this.isButtonActive}); // Required arguments that were passed

  @override
  _FinishScreenState createState() => _FinishScreenState();
}

class _FinishScreenState extends State<FinishScreen> {
  final confetti = ConfettiController();

  int rating = 0; // 0: none, 1: happy, 2: neutral, 3: sad

  // Method to set the rating inputted
  void setRating(int value) {
    setState(() {
      rating = value;
    });
  }

  // Function to clear the workout data and navigate back to workout screen when the 'New Workout' button is pressed
  void clearDataAndNavigateBack(BuildContext context) {
    setState(() {
      // Clears exercise list
      widget.exercises.clear();
      // Set count back to 1
      Set.count = 1;
      // Disables button because workout is restarted and there is no data
      widget.isButtonActive = false;
      // Resets stats back to 0
      widget.totalVolume = 0;
      widget.numExercises = 0;
    });
    // Clear workoutName textfield controller
    widget.workoutController.clear();
    // Navigate back to the previous screen, passing some data
    Navigator.pop(context);
  }

// Dispose method is always good to have to clear and clean up controllers
  @override
  void dispose() {
    confetti.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    confetti.play(); // Starts confetti animation
    return Scaffold(
        appBar: AppBar(
          title: const Text('Workout Finished!'),
          backgroundColor: Colors.transparent,
        ),
        body: Column(children: <Widget>[
          // Column widget used to have multiple children
          Align(
            alignment: Alignment.topCenter, // Confeti start position
            child: ConfettiWidget(
              confettiController: confetti, // Defines controller used
              blastDirectionality:
                  BlastDirectionality.explosive, // Direction of blast
              emissionFrequency:
                  0.02, // Change of confetti being emitted on a single frame
              numberOfParticles: 12, // Number of confetti
              minBlastForce: 1,
              maxBlastForce: 10, // Itensity of emission
              gravity: 0.1, // How fast it falls
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment
                .start, // Places children widgets starting from the top or start of main axis
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Centered
                children: [
                  const Icon(Icons.star,
                      color: Colors.yellow, size: 40), // Star icon
                  SizedBox(
                    height: 150,
                    width: 150,
                    child:
                        Image.asset('assets/images/trophy.png'), // Trophy image
                  ),
                  const Icon(Icons.star, color: Colors.yellow, size: 40),
                ],
              ),
              Text(
                'Great job, ${context.watch<UserData>().getName}!', // Calls .getName using userdata provider
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text(
                'You completed a workout!',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(
                    16), // Adds padding/spacing all around container
                decoration: BoxDecoration(
                  border: Border.all(
                      // Gives it a border
                      color: const Color.fromRGBO(158, 158, 158, 1),
                      width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      widget
                          .workoutName, // Needs widget. before variable to use it
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '# of Exercises: ${widget.numExercises}', // numExercises and totalVolume get displayed in Text widget using ${}
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Total Volume: ${widget.totalVolume}lb',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Rate your Workout',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.sentiment_very_satisfied,
                      color: rating == 1
                          ? Colors.green
                          : Colors
                              .grey, // When user presses icon it sets the rating to the according number otherwise it's gray
                      size: 60,
                    ),
                    onPressed: () => setRating(1),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.sentiment_neutral,
                      color: rating == 2 ? Colors.orange : Colors.grey,
                      size: 60,
                    ),
                    onPressed: () => setRating(2),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.sentiment_very_dissatisfied,
                      color: rating == 3 ? Colors.red : Colors.grey,
                      size: 60,
                    ),
                    onPressed: () => setRating(3),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(150.0, 42.0)),
                onPressed: () {
                  clearDataAndNavigateBack(
                      context); // Calls function to reset everything and go back to previous screen when pressed
                },
                child: const Text(
                  'New Workout',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          )
        ]));
  }
}
