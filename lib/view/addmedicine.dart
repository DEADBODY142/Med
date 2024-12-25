import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:medicine_reminder/view/medicineschedule.dart';
import 'dart:convert';

import 'package:medicine_reminder/model/user_model.dart';

class AddMedicinePage extends StatefulWidget {
  @override
  _AddMedicinePageState createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  DateTime? startDate;
  DateTime? finishDate;
  String? selectedType;
  String? selectedAmount;
  TextEditingController medicineNameController = TextEditingController();
  TextEditingController frequencyController = TextEditingController();
  TimeOfDay? selectedMedicineTime;
  String? imagePath;

  Future<void> submitData() async {
    try {
      // Prepare JSON data
      Map<String, dynamic> data = {
        'medicine_name': medicineNameController.text,
        'frequency': frequencyController.text,
        'start_date': startDate?.toIso8601String(),
        'finish_date': finishDate?.toIso8601String(),
        'selected_type': selectedType,
        'selected_amount': selectedAmount,
        'reminder_time': selectedMedicineTime != null
            ? '${selectedMedicineTime!.hour}:${selectedMedicineTime!.minute}'
            : null,
      };
      
      // Print data to debug
      print("Data to be sent: ${json.encode(data)}");

      // Create a MultipartRequest
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://127.0.0.1:5000/add_medicine'),
      );

      // Add JSON data as 'data' field
      request.fields['data'] = json.encode(data);

      // Add image file if selected
      if (imagePath != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', imagePath!));
      }

      // Send request
      var response = await request.send();

      // Handle response
      if (response.statusCode == 200) {
        print("Data submitted successfully");
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Success'),
            content: Text('Medicine schedule added successfully!'),
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
      } else {
        print("Failed to submit data. Status code: ${response.statusCode}");
        print("Response body: ${await response.stream.bytesToString()}");
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to add medicine schedule. Please try again.'),
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
    } catch (e) {
      print("Error submitting data: $e");
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('An unexpected error occurred: $e'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: InkWell(
                    onTap: () async {
                      print("Tapped on");
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(type: FileType.image);
                      if (result != null) {
                        String? filePath = result.files.single.path;
                        print('Selected file: $filePath');
                         // Debugging print
                        if (filePath != null) {
                          setState(() {
                            imagePath = filePath;
                          });
                        }
                      }else {
                        print('No file picked');
                    }
                    },
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[200],
                      child: imagePath == null
                          ? Icon(Icons.add_a_photo,
                              size: 30, color: Colors.grey)
                          : null,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                buildLabel('Medicine Name'),
                buildTextField(
                    controller: medicineNameController,
                    hint: 'Enter Medicine Name'),
                buildLabel('Type'),
                buildDropdown(
                    ['Tablet', 'Capsule', 'Liquid'], 'Select Medicine Type',
                    (value) {
                  setState(() {
                    selectedType = value;
                  });
                }),
                buildLabel('Amount'),
                buildDropdown(
                    ['1 Tablet', '2 Capsules', '5 mL'], 'Select Amount',
                    (value) {
                  setState(() {
                    selectedAmount = value;
                  });
                }),
                buildLabel('Frequency'),
                buildTextField(
                    controller: frequencyController, hint: 'Enter Frequency'),
                buildLabel('Start Date'),
                buildDateField(context, 'Select Start Date', (pickedDate) {
                  setState(() {
                    startDate = pickedDate;
                  });
                }, startDate),
                buildLabel('Finish Date'),
                buildDateField(context, 'Select Finish Date', (pickedDate) {
                  setState(() {
                    finishDate = pickedDate;
                  });
                }, finishDate),
                buildLabel('Set Reminder Time'),
                InkWell(
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: selectedMedicineTime ?? TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        selectedMedicineTime = pickedTime;
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
                          selectedMedicineTime != null
                              ? '${selectedMedicineTime!.format(context)}'
                              : 'Select Reminder Time',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Icon(Icons.access_time, size: 18, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: submitData,
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                ),
              ],
            ),
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

  Widget buildTextField(
      {required TextEditingController controller, required String hint}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget buildDropdown(
      List<String> items, String hint, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: items.isNotEmpty ? items[0] : null,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget buildDateField(BuildContext context, String hint,
      Function(DateTime?) onDateSelected, DateTime? selectedDate) {
    return InkWell(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        onDateSelected(pickedDate);
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
                selectedDate != null
                    ? '${selectedDate.toLocal()}'.split(' ')[0]
                    : hint,
                style: TextStyle(color: Colors.grey)),
            Icon(Icons.calendar_today, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
