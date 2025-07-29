class EventModel {
  final int id;
  final String title;
  final String logo;
  final DateTime? start;
  final DateTime? finish;
  final String format;
  final String location;
  final bool onsite;
  final int participants;
  final String restrictions;
  final String prizes;
  final String description;
  final bool publicVotable;

  EventModel({
    required this.id,
    required this.title,
    this.logo = '',
    this.start,
    this.finish,
    this.format = '',
    this.location = '',
    this.onsite = false,
    this.participants = 0,
    this.restrictions = '',
    this.prizes = '',
    this.description = '',
    this.publicVotable = false,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      logo: json['logo'] ?? '',
      start: json['start'] != null ? DateTime.parse(json['start']) : null,
      finish: json['finish'] != null ? DateTime.parse(json['finish']) : null,
      format: json['format'] ?? '',
      location: json['location'] ?? '',
      onsite: json['onsite'] ?? false,
      participants: json['participants'] ?? 0,
      restrictions: json['restrictions'] ?? '',
      prizes: json['prizes'] ?? '',
      description: json['description'] ?? '',
      publicVotable: json['public_votable'] ?? false,
    );
  }
}
