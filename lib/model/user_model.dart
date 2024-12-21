class UserModel {
  final String email;
  final String firstName;
  final String lastName;
  final String password;

  UserModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
  });
}

class Medicine {
  final String medicineName;
  final String strength;
  final String? selectedTime;
  final String? selectedType;
  final String? selectedAmount;
  final DateTime? startDate;
  final DateTime? finishDate;
  final List<bool> selectedDays;
  final String frequency;

  Medicine({
    required this.medicineName,
    required this.strength,
    this.selectedTime,
    this.selectedType,
    this.selectedAmount,
    this.startDate,
    this.finishDate,
    required this.selectedDays,
    required this.frequency,
  });
}
