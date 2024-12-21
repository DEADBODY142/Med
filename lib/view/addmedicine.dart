import 'package:flutter/material.dart';
import 'package:medicine_reminder/view/medicineschedule.dart';
import 'package:file_picker/file_picker.dart';

class AddMedicinePage extends StatefulWidget {
  @override
  _AddMedicinePageState createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  DateTime? startDate;
  DateTime? finishDate;
  List<bool> selectedDays = List.generate(7, (_) => false); // Track selected days
  String? selectedTime; // Track selected time (Morning/Afternoon/Evening)
  String? selectedType; // Track selected type (Tablet/Capsule/Liquid)
  String? selectedAmount; // Track selected amount (1 Tablet, 2 Capsules, etc.)
  TextEditingController medicineNameController = TextEditingController();
  TextEditingController strengthController = TextEditingController();
  TextEditingController frequencyController = TextEditingController();
  TimeOfDay? selectedMedicineTime;
  String? imagePath;

  @override
  void dispose() {
    super.dispose();
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
                // Add Photo Section
                Center(
                  child: InkWell(
                    onTap: () async {
                      // Open file picker to select an image
                      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

                      if (result != null) {
                        String? filePath = result.files.single.path;
                        if (filePath != null) {
                          setState(() {
                            imagePath = filePath; // Store the image path
                          });
                        }
                      }
                    },
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[200],
                      child: imagePath == null ? Icon(Icons.add_a_photo, size: 30, color: Colors.grey) : null,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Medicine Name Field
                buildLabel('Medicine Name'),
                buildTextField(controller: medicineNameController, hint: 'Enter Medicine Name'),

                // Strength Field
                buildLabel('Strength'),
                buildTextField(controller: strengthController, hint: 'Enter The Strength'),

                // When To Take Field
                buildLabel('When To Take'),
                buildDropdown(['Morning', 'Afternoon', 'Evening'], 'Select When To Take', (value) {
                  setState(() {
                    selectedTime = value;
                  });
                }),

                // Type Field
                buildLabel('Type'),
                buildDropdown(['Tablet', 'Capsule', 'Liquid'], 'Select Medicine Type', (value) {
                  setState(() {
                    selectedType = value;
                  });
                }),

                // Amount Field
                buildLabel('Amount'),
                buildDropdown(['1 Tablet', '2 Capsules', '5 mL'], 'Select Amount', (value) {
                  setState(() {
                    selectedAmount = value;
                  });
                }),

                // Frequency Field
                buildLabel('Frequency'),
                buildTextField(controller: frequencyController, hint: 'Enter Frequency'),

                // Start Date Field
                buildLabel('Start Date'),
                buildDateField(context, 'Select Start Date', (pickedDate) {
                  setState(() {
                    startDate = pickedDate;
                  });
                }, startDate),

                // Finish Date Field
                buildLabel('Finish Date'),
                buildDateField(context, 'Select Finish Date', (pickedDate) {
                  setState(() {
                    finishDate = pickedDate;
                  });
                }, finishDate),

                // Days of Week Selection
                buildLabel('Days'),
                Wrap(
                  spacing: 8,
                  children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                      .asMap()
                      .map((index, day) {
                    return MapEntry(
                      index,
                      ChoiceChip(
                        label: Text(day),
                        selected: selectedDays[index],
                        onSelected: (selected) {
                          setState(() {
                            selectedDays[index] = selected;
                          });
                        },
                      ),
                    );
                  })
                      .values
                      .toList(),
                ),

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

                // Make Schedule Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (medicineNameController.text.isNotEmpty && strengthController.text.isNotEmpty) {
                          // Redirect to the schedule page with selected details
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SchedulePage(
                                startDate: startDate,
                                finishDate: finishDate,
                                selectedDays: selectedDays,
                                // selectedTime: selectedTime,
                                // selectedType: selectedType,
                                // selectedAmount: selectedAmount,
                              ),
                            ),
                          );
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
                      child: Text('Make Schedule'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                    ),
                    SizedBox(width: 16),
                    IconButton(
                      icon: Icon(
                        Icons.mic, // Placeholder icon for voice speech
                        size: 28,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        // Placeholder: Do nothing for now
                      },
                    ),
                  ],
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

  Widget buildDropdown(List<String> items, String hint, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: items.isNotEmpty ? items[0] : null,
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget buildDateField(BuildContext context, String hint, Function(DateTime?) onDateSelected, DateTime? selectedDate) {
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
            Text(selectedDate != null ? '${selectedDate.toLocal()}'.split(' ')[0] : hint, style: TextStyle(color: Colors.grey)),
            Icon(Icons.calendar_today, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
