import 'package:flutter/material.dart';
import 'package:medicine_reminder/model/user_model.dart';
import 'package:medicine_reminder/view/UrgentCarePage.dart';
import 'package:medicine_reminder/view/medicineschedule.dart'; // Import the schedule page
import 'package:medicine_reminder/view/addmedicine.dart'; // Import the Add Medicine page
import 'package:medicine_reminder/view/profile.dart';

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
      ProfilePage(), // Profile page
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
        leading: Icon(Icons.medical_services),
        title: Text(
          ['Health Dashboard', 'Add Medicine', 'Customer Profile'][_selectedIndex],
        ),

        backgroundColor: Colors.blue,
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
                    backgroundImage: NetworkImage(
                        'https://via.placeholder.com/150'), // Replace with user's profile image
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
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Row(
                        children: [
                          Icon(Icons.warning, color: Colors.orange, size: 30),
                          SizedBox(width: 12),
                          Text('Urgent Care', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Icon(Icons.arrow_forward, color: Colors.orange),
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
                  ServiceItem(icon: Icons.local_hospital, label: 'Ambulance'),
                ],
              ),
              const SizedBox(height: 20),

              // Appointment Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Appointment',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'See All',
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              AppointmentCard(), // Assuming AppointmentCard is defined elsewhere

              // Added Medicines Section
              const SizedBox(height: 20),
              const Text(
                'Your Medicines',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              medicines.isEmpty
                  ? const Text('No medicines added yet.')
                  : ListView.builder(
                shrinkWrap: true,
                itemCount: medicines.length,
                itemBuilder: (context, index) {
                  final medicine = medicines[index];
                  return ListTile(
                    title: Text(medicine.name),
                    subtitle: Text('${medicine.type}, ${medicine.amount}'),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      // Navigate to a detail page or perform an action on the selected medicine
                    },
                  );
                },
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
            color: Colors.blue[50],
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
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
              radius: 25,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dr. Prem Tiwari',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Orthopedic',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                    SizedBox(width: 4),
                    Text(
                      'Wed Nov 20 - 8:00 AM',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                )
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
      appBar: AppBar(title: Text('$doctorName - Appointment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Doctor: $doctorName', style: TextStyle(fontSize: 20)),
            Text('Specialty: $specialty', style: TextStyle(fontSize: 16)),
            Text('Appointment Time: $appointmentTime', style: TextStyle(fontSize: 16)),
            Text('Appointment Date: $appointmentDate', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Edit Button
          FloatingActionButton(
            onPressed: () {
              // Handle Edit action, navigate to edit page or show a dialog
              print('Edit appointment');
            },
            child: Icon(Icons.edit),
            heroTag: null, // This is used for tag to avoid conflicts if there are multiple FABs
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
    );
  }
}


class CustomerDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: const Text(
        'Customer Profile Page',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
