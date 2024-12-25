import 'package:flutter/material.dart';

class AddAppointmentPage extends StatefulWidget {
  @override
  _AddAppointmentPageState createState() => _AddAppointmentPageState();
}

class _AddAppointmentPageState extends State<AddAppointmentPage> {
  final TextEditingController doctorNameController = TextEditingController();
  final TextEditingController specialtyController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Name Field
              buildLabel('Doctor Name'),
              buildTextField(controller: doctorNameController, hint: 'Enter Doctor\'s Name'),

              // Specialty Field
              buildLabel('Specialty'),
              buildTextField(controller: specialtyController, hint: 'Enter Specialty'),

              // Appointment Date Field
              buildLabel('Appointment Date'),
              buildDateField(context),

              // Appointment Time Field
              buildLabel('Appointment Time'),
              buildTimeField(context),

              // Submit Button
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (doctorNameController.text.isNotEmpty && specialtyController.text.isNotEmpty && selectedDate != null && selectedTime != null) {
                    // Submit the appointment data
                    print('Appointment added: ${doctorNameController.text}, ${specialtyController.text}, $selectedDate, ${selectedTime!.format(context)}');
                    Navigator.pop(context); // Go back to the previous page
                  } else {
                    // Show an alert if essential fields are empty
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Error'),
                        content: Text('Please fill in all required fields'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Text('Add Appointment'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildTextField({required TextEditingController controller, required String hint}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget buildDateField(BuildContext context) {
    return InkWell(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          setState(() {
            selectedDate = pickedDate;
          });
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(selectedDate != null ? '${selectedDate!.toLocal()}'.split(' ')[0] : 'Select Appointment Date', style: TextStyle(color: Colors.grey)),
            Icon(Icons.calendar_today, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget buildTimeField(BuildContext context) {
    return InkWell(
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: selectedTime ?? TimeOfDay.now(),
        );
        if (pickedTime != null) {
          setState(() {
            selectedTime = pickedTime;
          });
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedTime != null ? selectedTime!.format(context) : 'Select Appointment Time',
              style: TextStyle(color: Colors.grey),
            ),
            Icon(Icons.access_time, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
