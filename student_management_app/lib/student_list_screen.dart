import 'package:flutter/material.dart';
import 'services/database_helper.dart';
import 'models/student.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  List<Student> _students = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDatabaseRecords(); // Triggers the read operation on startup
  }

  // READ Operation: Pull data dynamically from SQLite
  Future<void> _fetchDatabaseRecords() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper.instance.readAllStudents();
    setState(() {
      _students = data;
      _isLoading = false;
    });
  }

  // DELETE Operation: Remove data record permanently
  void _removeStudentRecord(int id) async {
    await DatabaseHelper.instance.deleteStudent(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Student record removed successfully.')),
    );
    _fetchDatabaseRecords(); // Refresh data layout locally
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registered Students List'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchDatabaseRecords, // Force layout sync
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _students.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No local records found.',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _students.length,
        itemBuilder: (context, index) {
          final targetStudent = _students[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  targetStudent.name.isNotEmpty
                      ? targetStudent.name[0].toUpperCase()
                      : '?',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
              title: Text(
                targetStudent.name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'Course/Program: ${targetStudent.course}',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
                onPressed: () => _removeStudentRecord(targetStudent.id!),
              ),
            ),
          );
        },
      ),
    );
  }
}