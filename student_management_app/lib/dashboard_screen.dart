import 'package:flutter/material.dart';
import 'registration_screen.dart';
import 'student_list_screen.dart';
import 'api_integration_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome, Administrator',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Statistics Section
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.blue.shade50,
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text('Total Students', style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 5),
                          Text('245', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Card(
                    color: Colors.green.shade50,
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text('Active Courses', style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 5),
                          Text('12', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Action 1: Navigate to Registration Form
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.person_add, color: Colors.blue),
                title: const Text('Register New Student'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),

            // Action 2: Navigate to Stored Database Records List
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.view_list, color: Colors.green),
                title: const Text('View Registered Students'),
                subtitle: const Text('Manage and read saved database logs'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const StudentListScreen()),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),

            // Action 3: Navigate to Remote Cloud Server API Feed
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.cloud_sync, color: Colors.purple),
                title: const Text('API Remote Sync Feed'),
                subtitle: const Text('Consume external REST server profiles'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ApiIntegrationScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}