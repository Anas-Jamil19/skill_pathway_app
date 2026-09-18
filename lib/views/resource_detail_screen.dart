import 'package:flutter/material.dart';

class ResourceDetailScreen extends StatelessWidget {
  final Map<String, dynamic> resource;

  const ResourceDetailScreen({super.key, required this.resource});

  @override
  Widget build(BuildContext context) {
    final title = resource['title'] ?? 'Mastering REST APIs with Flutter';
    final platform = resource['platform'] ?? 'Udemy';
    final type = (resource['type'] ?? 'COURSE').toString().toUpperCase();
    final rating = resource['rating'] ?? '4.6';
    final level = resource['level'] ?? 'Beginner to Int.';
    final duration = resource['duration'] ?? '6.5 h';
    final language = resource['language'] ?? 'English';

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Resource Details",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Image Hero Card with Pill Badge
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        "https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?auto=format&fit=crop&w=800&q=80",
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Text(
                          type,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Title & Provider
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Provider: $platform",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 16),

                // 2x2 Stats Grid (Rating, Level, Duration, Language)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildGridStat(
                              icon: Icons.star_border_rounded,
                              value: rating,
                              label: "Rating",
                            ),
                          ),
                          Container(width: 1, height: 65, color: Colors.grey.shade300),
                          Expanded(
                            child: _buildGridStat(
                              icon: Icons.stacked_line_chart,
                              value: level,
                              label: "Level",
                            ),
                          ),
                        ],
                      ),
                      Divider(height: 1, color: Colors.grey.shade300),
                      Row(
                        children: [
                          Expanded(
                            child: _buildGridStat(
                              icon: Icons.access_time,
                              value: duration,
                              label: "Duration",
                            ),
                          ),
                          Container(width: 1, height: 65, color: Colors.grey.shade300),
                          Expanded(
                            child: _buildGridStat(
                              icon: Icons.language,
                              value: language,
                              label: "Language",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ABOUT SECTION
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.info_outline, size: 20, color: Colors.black87),
                          SizedBox(width: 8),
                          Text(
                            "ABOUT",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Dive deep into backend integration by mastering REST APIs within the Flutter framework. This comprehensive course guides you through building robust, data-driven mobile applications. You will learn best practices for handling asynchronous operations, managing state with external data, and ensuring your app remains responsive and resilient in real-world network conditions.",
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // WHAT YOU'LL LEARN
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(14.0),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle_outline, size: 20, color: Colors.black87),
                            SizedBox(width: 8),
                            Text(
                              "WHAT YOU'LL LEARN",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, color: Colors.grey.shade300),
                      const _LearnCheckRow(text: "Understand REST API concepts"),
                      Divider(height: 1, color: Colors.grey.shade300),
                      const _LearnCheckRow(text: "Make HTTP requests in Flutter"),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // ADD TO MY LEARNING BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      elevation: 2,
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Added to My Learning!"),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.add, color: Colors.black87, size: 22),
                    label: const Text(
                      "ADD TO MY LEARNING",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridStat({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.black87),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class _LearnCheckRow extends StatelessWidget {
  final String text;

  const _LearnCheckRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, size: 20, color: Colors.black87),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}