class Schedule {
  final String patientId;
  final String day;
  final String time;
  final String notes;

  Schedule({
    required this.patientId,
    required this.day,
    required this.time,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'day': day,
      'time': time,
      'notes': notes,
    };
  }

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      patientId: json['patientId'],
      day: json['day'],
      time: json['time'],
      notes: json['notes'],
    );
  }
}
