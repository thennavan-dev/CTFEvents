import 'package:flutter/material.dart';
import '../models/event_model.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback? onTap;

  const EventCard({
    super.key,
    required this.event,
    this.onTap,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final Color dateBackgroundColor = Colors.deepPurple.shade800;
    final Color iconColor = Colors.deepPurpleAccent.shade100;
    final Color dateTextColor = Colors.deepPurple.shade100;

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
      shadowColor: Colors.black54,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey.shade900, Colors.black87],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: event.logo.isNotEmpty
                    ? Image.network(
                  event.logo,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _placeholderImage(),
                )
                    : _placeholderImage(),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with teal color
                    Text(
                      event.title,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade400,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 16,
                      runSpacing: 6,
                      children: [
                        _dateChip(
                          icon: Icons.calendar_today,
                          label: _formatDate(event.start),
                          backgroundColor: dateBackgroundColor,
                          iconColor: iconColor,
                          textColor: dateTextColor,
                        ),
                        _dateChip(
                          icon: Icons.schedule,
                          label: _formatDate(event.finish),
                          backgroundColor: dateBackgroundColor,
                          iconColor: iconColor,
                          textColor: dateTextColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildChip(
                          label:
                          event.publicVotable ? "Open to Public" : "Private",
                          icon: event.publicVotable
                              ? Icons.lock_open
                              : Icons.lock,
                          background: event.publicVotable
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                          labelColor: Colors.white,
                        ),
                        const SizedBox(width: 12),
                        _buildChip(
                          label: event.onsite ? "Onsite" : "Online",
                          icon: event.onsite
                              ? Icons.location_on_outlined
                              : Icons.cloud_outlined,
                          background: event.onsite
                              ? Colors.orange.shade700
                              : Colors.blue.shade700,
                          labelColor: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 80,
      height: 80,
      color: Colors.grey.shade800,
      child: const Icon(
        Icons.shield,
        color: Colors.white30,
        size: 40,
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required IconData icon,
    required Color background,
    required Color labelColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: labelColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
                color: labelColor, fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _dateChip({
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color iconColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
