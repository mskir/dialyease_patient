import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart'; // Adjust path if needed

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final patient = authProvider.patient;

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: patient == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(Icons.person, size: 100, color: Colors.grey),
                  const SizedBox(height: 20),
                  ProfileInfoRow(
                    label: 'Full Name',
                    value: '${patient.firstName} ${patient.lastName}',
                  ),
                  ProfileInfoRow(label: 'Email', value: patient.email),
                  ProfileInfoRow(label: 'Phone', value: patient.phone),
                  ProfileInfoRow(label: 'Address', value: patient.address),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<AuthProvider>(context, listen: false).logout();
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ),
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
