import 'package:shared_preferences/shared_preferences.dart';
import 'package:medicine_reminder/model/user_model.dart';

class AuthController {
  Future<bool> loginUser(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(email)) {
      String storedUser = prefs.getString(email) ?? '';
      Map<String, dynamic> userData = _decodeUserData(storedUser);

      return userData['password'] == password;
    }
    return false;
  }

  // Register a new user
  Future<bool> registerUser(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(user.email)) {
      return false; // Email already exists
    }

    // Save user details as a JSON string in SharedPreferences
    Map<String, dynamic> userData = {
      'email': user.email,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'password': user.password,
    };

    await prefs.setString(user.email, _encodeUserData(userData));
    return true; // Registration successful
  }

  // Check if the user is logged in
  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  // Set login status
  Future<void> setLoginStatus(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', status);
  }

  // Log out the user
  Future<void> logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
  }

  // Encode user data to a JSON string
  String _encodeUserData(Map<String, dynamic> userData) {
    return userData.toString();  // In a real app, you'd want to use jsonEncode
  }

  // Decode user data from a JSON string
  Map<String, dynamic> _decodeUserData(String userData) {
    final parts = userData.substring(1, userData.length - 1).split(', ');
    return Map.fromEntries(
      parts.map((part) {
        final kv = part.split(': ');
        return MapEntry(kv[0], kv[1]);
      }),
    );
  }
}
class MedicineController {
  // List to store medicines
  List<Medicine> medicines = [];

  // Function to add a new medicine
  void addMedicine(Medicine medicine) {
    medicines.add(medicine);
  }

  // Function to get all medicines
  List<Medicine> getMedicines() {
    return medicines;
  }

  // Validation for adding a medicine
  bool validateMedicineFields({
    required String name,
    required String strength,
    required String frequency,
  }) {
    if (name.isEmpty || strength.isEmpty || frequency.isEmpty) {
      return false;  // Validation failed
    }
    return true;  // Validation passed
  }
}
void _handleAddAppointment(Appointment appointment) {
  // Handle the logic when an appointment is added, e.g., add it to a list.
  print("Appointment added: ${appointment.doctorName}");
}

