class Event {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final String eventTimestampUTC;
  final String createdAtTimestampUTC;

  DateTime? getUtcDate() {
    try {
      return DateTime.parse(eventTimestampUTC);
    } on FormatException {
      return null;
    }
  }

//<editor-fold desc="Data Methods">
  const Event({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.eventTimestampUTC,
    required this.createdAtTimestampUTC,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Event &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          title == other.title &&
          description == other.description &&
          eventTimestampUTC == other.eventTimestampUTC &&
          createdAtTimestampUTC == other.createdAtTimestampUTC);

  @override
  int get hashCode => id.hashCode ^ userId.hashCode ^ title.hashCode ^ description.hashCode ^ eventTimestampUTC.hashCode ^ createdAtTimestampUTC.hashCode;

  @override
  String toString() {
    return 'Event{ id: $id, userId: $userId, title: $title, description: $description, eventTimestampUTC: $eventTimestampUTC, createdAtTimestampUTC: $createdAtTimestampUTC,}';
  }

  Event copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? eventTimestampUTC,
    String? createdAtTimestampUTC,
  }) {
    return Event(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      eventTimestampUTC: eventTimestampUTC ?? this.eventTimestampUTC,
      createdAtTimestampUTC: createdAtTimestampUTC ?? this.createdAtTimestampUTC,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'event_timestamp': eventTimestampUTC,
      'created_at': createdAtTimestampUTC,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      eventTimestampUTC: map['event_timestamp'] as String,
      createdAtTimestampUTC: map['created_at'] as String,
    );
  }

//</editor-fold>
}
