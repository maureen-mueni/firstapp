import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'models/remote_user.dart';

class ApiIntegrationScreen extends StatefulWidget {
  const ApiIntegrationScreen({super.key});

  @override
  State<ApiIntegrationScreen> createState() => _ApiIntegrationScreenState();
}

class _ApiIntegrationScreenState extends State<ApiIntegrationScreen> {
  late Future<List<RemoteUser>> _remoteUsersFuture;

  @override
  void initState() {
    super.initState();
    _remoteUsersFuture = ApiService.fetchRemoteUsers(); // Fires request on startup
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Remote Sync Feed'),
        backgroundColor: Colors.purple,
      ),
      body: FutureBuilder<List<RemoteUser>>(
        future: _remoteUsersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.purple));
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('${snapshot.error}', style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
              ),
            );
          } else if (snapshot.hasData) {
            final users = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.purple.shade100,
                      child: Text(user.name[0].toUpperCase(), style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
                    ),
                    title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Email: ${user.email}'),
                    trailing: const Icon(Icons.cloud_done, color: Colors.purple, size: 20),
                  ),
                );
              },
            );
          }
          return const Center(child: Text('No external profiles found.'));
        },
      ),
    );
  }
}