import 'package:flutter/material.dart';
import 'services/database_helper.dart';
import 'models/student.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _courseController = TextEditingController();

  List<Student> _studentList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshStudentList(); // Load local data when screen opens
  }

  @override
  void dispose() {
    _nameController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  // Fetch all students from the SQLite database
  void _refreshStudentList() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper.instance.readAllStudents();
    setState(() {
      _studentList = data;
      _isLoading = false;
    });
  }

  // Handle the form submission and save data locally (CREATE)
  void _saveStudent() async {
    if (_formKey.currentState!.validate()) {
      final newStudent = Student(
        name: _nameController.text.trim(),
        course: _courseController.text.trim(),
      );

      await DatabaseHelper.instance.insertStudent(newStudent);

      // Clear the text fields after successful save
      _nameController.clear();
      _courseController.clear();

      // Show confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student Record Saved Locally!')),
      );

      _refreshStudentList(); // Refresh list to display the new entry
    }
  }

  // Handle deleting a student record (DELETE)
  void _deleteStudent(int id) async {
    await DatabaseHelper.instance.deleteStudent(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Record Removed')),
    );
    _refreshStudentList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Registration'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. INPUT FORM SECTION
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Student Full Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the student name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _courseController,
                    decoration: const InputDecoration(
                      labelText: 'Course (e.g., BIT, CS)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.book),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the course name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _saveStudent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text('Save Record', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Divider(thickness: 2),
            const SizedBox(height: 10),

            // 2. DISPLAY DATA SECTION (DYNAMIC LIST)
            const Text(
              'Registered Students (Local Database)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _studentList.isEmpty
                  ? const Center(child: Text('No records found. Add students above!'))
                  : ListView.builder(
                itemCount: _studentList.length,
                itemBuilder: (context, index) {
                  final student = _studentList[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal.shade100,
                        child: Text(student.name[0].toUpperCase()),
                      ),
                      title: Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Course: ${student.course}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => _deleteStudent(student.id!),
                      ),
                    ),
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