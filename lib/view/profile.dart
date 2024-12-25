import 'package:flutter/material.dart';
import 'package:medicine_reminder/view/register.dart';

class MedicineLogsPage extends StatelessWidget {
  final List<Map<String, dynamic>> medicineLogs = [
    {
      'name': 'Paracetamol/प्यारासिटामोल',
      'logs': ['Taken', 'Taken', 'Skipped', 'Taken', '-', '-', '-']
    },
    {
      'name': 'Ibuprofen/आइबुप्रोफेन',
      'logs': ['Pending', 'Taken', 'Taken', 'Pending', '-', '-', '-']
    },
    {
      'name': 'Vitamin C/भिटामिन C',
      'logs': ['Taken', 'Taken', 'Taken', 'Taken', '-', '-', '-']
    },
  ];

  final List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Weekly Medicine Logs',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [IconButton(onPressed: (){Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );}, icon: Icon(Icons.logout))],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: medicineLogs.length,
          itemBuilder: (context, index) {
            final medicine = medicineLogs[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicine['name'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 10),
                    Table(
                      border: TableBorder.all(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(1),
                        3: FlexColumnWidth(1),
                        4: FlexColumnWidth(1),
                        5: FlexColumnWidth(1),
                        6: FlexColumnWidth(1),
                      },
                      children: [
                        TableRow(
                          children: weekDays.map((day) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                day,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        TableRow(
                          children: List.generate(weekDays.length, (dayIndex) {
                            String status = medicine['logs'][dayIndex];
                            Color statusColor;
                            switch (status) {
                              case 'Taken':
                                statusColor = Colors.green;
                                break;
                              case 'Skipped':
                                statusColor = Colors.red;
                                break;
                              case 'Pending':
                              default:
                                statusColor = Colors.orange;
                                break;
                            }
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}

