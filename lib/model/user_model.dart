class UserModel {
  final String email;
  final String firstName;
  final String lastName;
  final String password;

  // Constructor with non-optional parameters, no default values
  UserModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
  });
}
class Appointment {
  final String doctorName;
  final String specialty;
  final String appointmentTime;
  final String appointmentDate;

  Appointment({
    required this.doctorName,
    required this.specialty,
    required this.appointmentTime,
    required this.appointmentDate,
  });
}


class Medicine {
  final String name;
  final String strength;
  final String time;
  final String type;
  final String amount;
  final DateTime startDate;
  final DateTime finishDate;
  final List<bool> days;

  Medicine({
    required this.name,
    required this.strength,
    required this.time,
    required this.type,
    required this.amount,
    required this.startDate,
    required this.finishDate,
    required this.days,
  });
}


