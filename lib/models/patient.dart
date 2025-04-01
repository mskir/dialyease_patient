class Patient {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String schedule; 

  Patient({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.schedule, 
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'schedule': schedule, 
    };
  }

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      schedule: json['schedule'] ?? 'No schedule',  
    );
  }
}
