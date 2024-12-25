import 'package:flutter/material.dart';
import 'package:medicine_reminder/model/user_model.dart';
import 'package:medicine_reminder/view/UrgentCarePage.dart';
import 'package:medicine_reminder/view/medicineschedule.dart'; // Import the schedule page
import 'package:medicine_reminder/view/addmedicine.dart'; // Import the Add Medicine page
import 'package:medicine_reminder/view/profile.dart';
import 'package:medicine_reminder/view/addappointment.dart';



class HealthDashboard extends StatefulWidget {
  @override
  _HealthDashboardState createState() => _HealthDashboardState();
}

class _HealthDashboardState extends State<HealthDashboard> {
  int _selectedIndex = 0;
  List<Medicine> medicines = [];

  // List of pages to navigate between
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(medicines: medicines), // Home page content
      AddMedicinePage(), // Add Medicine page
      MedicineLogsPage(), // Profile page
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _addMedicine() async {
    final newMedicine = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddMedicinePage()),
    );
    if (newMedicine != null) {
      setState(() {
        medicines.add(newMedicine);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex], // Display the page based on selected index
      appBar: AppBar(
        title: Text(['Dasboard', 'Add Medicine', 'Customer Profile'][_selectedIndex],
        ),
        backgroundColor: Colors.blue,
        leading: Icon(Icons.medical_services), // Left side icon
        flexibleSpace: Row(
          mainAxisAlignment: MainAxisAlignment.end, // Align icons to the right
          children: [
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.white, size: 40),
              onPressed: () {
                // Navigate to Notifications Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationsPage()),
                );
              },
            ),
            SizedBox(height: 10), // Add spacing between the icon and text
            Text(
              '',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color(0xFFF5F5F5),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add Medicine',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Customer Profile',
          ),
        ],
        type: BottomNavigationBarType.fixed, // Ensure items don't overflow
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final List<Medicine> medicines; // This will hold the added medicines

  HomePage({required this.medicines});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/pilll.jpg'),// Replace with user's profile image
                    radius: 25,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome!',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'User',
                        style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Urgent Care Button
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UrgentCarePage()));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Row(
                        children: [
                          Icon(Icons.warning, color: Colors.red, size: 30),
                          SizedBox(width: 12),
                          Text('Urgent Care', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Icon(Icons.arrow_forward, color: Colors.red),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Services Section
              const Text(
                'Our Services',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  ServiceItem(icon: Icons.medical_services, label: 'Medicines'),
                  ServiceItem(icon: Icons.calendar_today, label: 'Appointment'),
                  ServiceItem(icon: Icons.local_hospital, label: 'Emergency'),
                ],
              ),
              const SizedBox(height: 20),

              // Appointment Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Text widget for Appointment title
                  Text(
                    'Appointment',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  // IconButton to add an appointment
                  IconButton(
                    icon: Icon(Icons.add_circle, color: Colors.blue),
                    onPressed: () {
                      // Navigate to AddAppointmentPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddAppointmentPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 12),
              AppointmentCard(), // Assuming AppointmentCard is defined elsewhere

              // Added Medicines Section
              const SizedBox(height: 20),
              Material(
                elevation: 4.0, // Add elevation for shadow effect
                borderRadius: BorderRadius.circular(12.0), // Rounded corners
                child: Container(
                  padding: EdgeInsets.all(16.0), // Padding inside the container
                  decoration: BoxDecoration(
                    color: Colors.blue, // Background color for the container
                    borderRadius: BorderRadius.circular(12.0), // Same as Material for consistency
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Medicines',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12, width: double.infinity),
                      medicines.isEmpty
                          ? const Text('No medicines added yet.')
                          : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(), // Prevent inner scrolling
                        itemCount: medicines.length,
                        itemBuilder: (context, index) {
                          final medicine = medicines[index];
                          return ListTile(
                            title: Text("cetamol"),
                            subtitle: Text('Tablet, 1 Tablet'),
                            trailing: Icon(Icons.arrow_forward),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SchedulePage(selectedDays: []),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class ServiceItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const ServiceItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Icon(icon, size: 30, color: Colors.blue),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

class AppointmentCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the AppointmentDetailPage when tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppointmentDetailPage(
              doctorName: 'Dr. Prem Tiwari',
              specialty: 'Orthopedic',
              appointmentTime: '8:00 AM',
              appointmentDate: 'Wed Nov 20',
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('stethoscope.jpg'),
              radius: 25,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dr. Prem Tiwari',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, ),
                ),
                Text(
                  'Orthopedic',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                    SizedBox(width: 4),
                    Text(
                      'Wed Nov 20 - 8:00 AM',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AppointmentDetailPage extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String appointmentTime;
  final String appointmentDate;

  AppointmentDetailPage({
    required this.doctorName,
    required this.specialty,
    required this.appointmentTime,
    required this.appointmentDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$doctorName - Appointment'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(Icons.account_circle, 'Doctor', doctorName),
              const SizedBox(height: 16),
              _buildInfoCard(Icons.medical_services, 'Specialty', specialty),
              const SizedBox(height: 16),
              _buildInfoCard(Icons.access_time, 'Appointment Time', appointmentTime),
              const SizedBox(height: 16),
              _buildInfoCard(Icons.calendar_today, 'Appointment Date', appointmentDate),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Edit Button
            FloatingActionButton(
              onPressed: () {
                // Handle Edit action, navigate to edit page or show a dialog
                print('Edit appointment');
              },
              child: Icon(Icons.edit),
              backgroundColor: Colors.blueAccent,
              heroTag: null, // Avoid conflicts if there are multiple FABs
            ),
            const SizedBox(width: 16),
            // Delete Button
            FloatingActionButton(
              onPressed: () {
                // Handle Delete action, confirm and delete the appointment
                print('Delete appointment');
              },
              child: Icon(Icons.delete),
              backgroundColor: Colors.red,
              heroTag: null, // Similar to the Edit button to avoid conflict
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to create info cards with icons and text
  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 32,
              color: Colors.blueAccent, // Icon color for visual appeal
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UrgentCarePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Guardian Details'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Guardian Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Contact Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Add save logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Details Saved!')),
                );
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UrgentCarePage()),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.warning, color: Colors.red, size: 30),
                    SizedBox(width: 12),
                    Text('Urgent Care',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Icon(Icons.arrow_forward, color: Colors.red),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0, // Removes shadow for a clean look
        title: Center(
          child: Text(
            'Notifications',
            style: TextStyle(color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20), // Black text for better contrast
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child:Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ensures minimal height for the column
          children: [
            SizedBox(height: 20), // Spacing below the line
            Icon(
              Icons.notifications_off,
              color: Colors.grey,
              size: 80,
            ),
            SizedBox(height: 5), // Spacing between icon and text
            Text(
              'No notifications yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
      ),
    );
  }
}



