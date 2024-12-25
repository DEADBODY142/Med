import 'package:flutter/material.dart';
import 'package:medicine_reminder/view/homepage.dart';
import 'package:medicine_reminder/view/profile.dart';

class OverlayExamplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content (if required, replace with your main widget)
          // HealthDashboard(),

          // Overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5), // Semi-transparent background
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image in the overlay
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/cetamol.jpg', // Replace with your image asset path
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Instruction Text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'एउटा लिनुहोस्', // "Take one" in Nepali
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 5,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: 20),

                  // Approve button
                  ElevatedButton(
                   
                    style: ElevatedButton.styleFrom(
                      
                      backgroundColor: Colors.green, // Button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    ),
                    onPressed: () {
                      // Navigate to HealthDashboard on button press
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MedicineLogsPage()),
                      );
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
