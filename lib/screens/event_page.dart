import 'package:flutter/material.dart';
import '../models/event_model.dart';       // Use your EventModel here
import '../service/api_service.dart';      // Your service file

class EventPage extends StatefulWidget {
  final int eventId;

  const EventPage({super.key, required this.eventId});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late Future<EventModel> _futureEventDetail;

  @override
  void initState() {
    super.initState();
    _futureEventDetail = fetchEventDetailsById(widget.eventId);  // Directly assign the Future<EventModel>
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Event Details"),
        backgroundColor: const Color(0xFF1F1F1F),
        elevation: 2,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      body: FutureBuilder<EventModel>(
        future: _futureEventDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.tealAccent));
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Error loading event details:\n${snapshot.error}",
                  style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text(
                "Event details not found.",
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
            );
          }

          final event = snapshot.data!;

          String formatDate(DateTime? dt) => dt == null
              ? 'N/A'
              : "${dt.toLocal().day.toString().padLeft(2, '0')}/"
              "${dt.toLocal().month.toString().padLeft(2, '0')}/"
              "${dt.toLocal().year}";

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: event.logo.isNotEmpty
                        ? Image.network(
                      event.logo,
                      height: 140,
                      width: 140,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                      const Icon(Icons.shield, size: 140, color: Colors.white24),
                    )
                        : const Icon(Icons.shield, size: 140, color: Colors.white24),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  event.title,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 20),
                _infoCard(
                  child: Column(
                    children: [
                      _buildInfoRow("Start Date", formatDate(event.start)),
                      _buildInfoRow("End Date", formatDate(event.finish)),
                      _buildInfoRow("Format", event.format.isNotEmpty ? event.format : "N/A"),
                      _buildInfoRow("Location", event.location.isNotEmpty ? event.location : "Online"),
                      _buildInfoRow("Onsite", event.onsite ? "Yes" : "No"),
                      _buildInfoRow("Participants", event.participants > 0 ? event.participants.toString() : "N/A"),
                      _buildInfoRow("Restrictions", event.restrictions.isNotEmpty ? event.restrictions : "None"),
                      _buildInfoRow("Prizes", event.prizes.isNotEmpty ? event.prizes : "None"),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  "Description",
                  style: textTheme.titleLarge?.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  event.description.isNotEmpty ? event.description : "No description available.",
                  style: const TextStyle(
                    color: Colors.white70,
                    height: 1.6,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              "$label:",
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(153),  // use withAlpha instead of deprecated withOpacity
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: child,
    );
  }
}
