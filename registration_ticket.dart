class RegistrationTicket {
  final String id;
  final String eventTitle;
  final String name;
  final String nim;
  final String email;
  final String whatsapp;
  final String participantType;
  final String attendanceDate;
  final String seminarKit;
  final double donation;
  final DateTime registeredAt;

  RegistrationTicket({
    required this.id,
    required this.eventTitle,
    required this.name,
    required this.nim,
    required this.email,
    required this.whatsapp,
    required this.participantType,
    required this.attendanceDate,
    required this.seminarKit,
    required this.donation,
    required this.registeredAt,
  });
}