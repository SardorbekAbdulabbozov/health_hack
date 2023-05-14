class TrainerModel {
  final String ssn;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? specialization;

  TrainerModel({
    required this.ssn,
    required this.email,
    this.firstName,
    this.lastName,
    this.specialization,
  });
}
