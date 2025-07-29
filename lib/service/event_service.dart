import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event_model.dart';

// Build API URL for listing events
String buildEventApiUrl({
  int limit = 20,
  Duration duration = const Duration(days: 7),
}) {
  final now = DateTime.now().toUtc();
  final startTimestamp = now.millisecondsSinceEpoch ~/ 1000;
  final endTimestamp = now.add(duration).millisecondsSinceEpoch ~/ 1000;

  return "https://ctftime.org/api/v1/events/?limit=$limit&start=$startTimestamp&finish=$endTimestamp";
}

// Fetch list of events with duplicate filtering
Future<List<EventModel>> fetchEvents({
  Duration duration = const Duration(days: 7),
}) async {
  final url = Uri.parse(buildEventApiUrl(duration: duration));
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);

    final seenIds = <int>{};
    final events = <EventModel>[];

    for (final item in jsonData) {
      final event = EventModel.fromJson(item);
      if (!seenIds.contains(event.id)) {
        seenIds.add(event.id);
        events.add(event);
      }
    }

    return events;
  } else {
    throw Exception('Failed to load events');
  }
}

// Build API URL for event details by event ID
String buildEventDetailsApiUrl(int eventId) {
  return "https://ctftime.org/api/v1/events/$eventId/";
}

// Fetch event details by event ID
Future<EventModel> fetchEventDetails(int eventId) async {
  final url = Uri.parse(buildEventDetailsApiUrl(eventId));
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = jsonDecode(response.body);
    return EventModel.fromJson(jsonData);
  } else {
    throw Exception('Failed to load event details for ID $eventId');
  }
}
