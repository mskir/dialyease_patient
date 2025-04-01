import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _patientData = {
    'firstName': '',
    'lastName': '',
    'email': '',
    'phone': '',
    'address': '',
    'password': '',
  };

  final TextEditingController _passwordController = TextEditingController(); 

  Future<void> _submit() async {
  if (!_formKey.currentState!.validate()) return;
  _formKey.currentState!.save();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => const Center(child: CircularProgressIndicator()),
  );

  try {
    await Provider.of<AuthProvider>(context, listen: false)
        .register(_patientData);
    Navigator.of(context).pop(); 
    Navigator.pushReplacementNamed(context, '/home');
  } catch (err) {
    Navigator.of(context).pop(); 
    
    String message = err.toString();
    if (message.contains('Invalid server response format')) {
      message = 'Server responded with unexpected format. Please contact support.';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 5),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patient Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextField(
                label: 'First Name',
                onSaved: (value) => _patientData['firstName'] = value!,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              CustomTextField(
                label: 'Last Name',
                onSaved: (value) => _patientData['lastName'] = value!,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              CustomTextField(
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => _patientData['email'] = value!,
                validator: (value) {
                  if (value!.isEmpty) return 'Required';
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              CustomTextField(
                label: 'Phone',
                keyboardType: TextInputType.phone,
                onSaved: (value) => _patientData['phone'] = value!,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              CustomTextField(
                label: 'Address',
                onSaved: (value) => _patientData['address'] = value!,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              CustomTextField(
                label: 'Password',
                obscureText: true,
                controller: _passwordController, 
                onSaved: (value) => _patientData['password'] = value!,
                validator: (value) {
                  if (value!.isEmpty) return 'Required';
                  if (value.length < 6) return 'Minimum 6 characters';
                  return null;
                },
              ),
              CustomTextField(
  label: 'Confirm Password',
  obscureText: true,
  onSaved: (value) {}, 
  validator: (value) {
    if (value!.isEmpty) return 'Required';
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  },
),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Register'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pushReplacementNamed('/login'),
                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
