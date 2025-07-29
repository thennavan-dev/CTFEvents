import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event_model.dart';

String buildEventApiUrl({
  int limit = 20,
  Duration duration = const Duration(days: 7),
}) {
  final now = DateTime.now().toUtc();
  final startTimestamp = now.millisecondsSinceEpoch ~/ 1000;
  final endTimestamp = now.add(duration).millisecondsSinceEpoch ~/ 1000;

  return "https://ctftime.org/api/v1/events/?limit=$limit&start=$startTimestamp&finish=$endTimestamp";
}

Future<List<EventModel>> fetchEvents({
  Duration duration = const Duration(days: 7),
}) async {
  final url = Uri.parse(buildEventApiUrl(duration: duration));
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);
    return jsonData.map((json) => EventModel.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load events');
  }
}

Future<EventModel> fetchEventDetailsById(int id) async {
  final url = Uri.parse("https://ctftime.org/api/v1/events/$id/");
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = jsonDecode(response.body);
    return EventModel.fromJson(jsonData);
  } else {
    throw Exception('Failed to load event detail');
  }
}
