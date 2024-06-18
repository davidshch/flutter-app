import 'package:flutter/foundation.dart'; // Flutter primitives library to do basic code

// Define a class that holds the name variable
class UserData with ChangeNotifier {
  String name = '';
  int age = 0;

  // Setter method to update the name variable
  void setName(String n) {
    name = n;
    notifyListeners(); // Notifies to any clients about the change
  }

  // Getter method to return the name variable
  String get getName => name;

  // Age setter
  void setAge(int a) {
    age = a;
    notifyListeners();
  }

  // Age getter
  int get getAge => age;
}
