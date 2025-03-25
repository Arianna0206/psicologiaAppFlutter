
class PushMessage {
  final String messageId;
  final String title;
  final String body;
  final DateTime sentDate;
   final String? frequency; 
  final List<int>? selectedDays;
  final Map<String, dynamic>? data;
  final String? imageUrl;

  PushMessage({
    required this.messageId,
    required this.title,
    required this.body,
    required this.sentDate,
    this.frequency,
    this.selectedDays,
    this.data,
    this.imageUrl,
  });

  factory PushMessage.fromMap(Map<String, dynamic> map, String id) {
    return PushMessage(
      messageId: id,
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      // sentDate: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(), 
      data: map['data'] as Map<String, dynamic>?,
      imageUrl: map['imageUrl'] as String?,
      sentDate: DateTime.parse(map['sentDate']),
      frequency: map['frequency'], 
      selectedDays: map['selectedDays'] != null ? List<int>.from(map['selectedDays']) : null, 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'sentDate': sentDate.toIso8601String(),
      'data': data,
      'imageUrl': imageUrl,
      'frequency': frequency, 
      'selectedDays': selectedDays, 
    };
  }

  @override
  String toString() {
    return '''
    PushMessage - 
      id:    $messageId
      title: $title
      body:  $body
      data:  $data
      imageUrl: $imageUrl
      sentDate: $sentDate
    ''';
  }
}
