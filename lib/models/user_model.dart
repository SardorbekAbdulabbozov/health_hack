class UserModel {
  final String ssn;
  final String email;
  final String? firstName;
  final String? lastName;
  final DateTime? dateOfBirth;
  final String? workoutId;
  final int? age;
  final double? weight;
  final double? height;

  UserModel({
    required this.ssn,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.dateOfBirth,
    this.workoutId,
    this.age,
    this.weight,
    this.height,
  });
}
