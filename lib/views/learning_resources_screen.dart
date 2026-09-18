import 'package:flutter/material.dart';
import 'resource_detail_screen.dart';

class LearningResourcesScreen extends StatefulWidget {
  final String? userId;

  const LearningResourcesScreen({super.key, this.userId});

  @override
  State<LearningResourcesScreen> createState() => _LearningResourcesScreenState();
}

class _LearningResourcesScreenState extends State<LearningResourcesScreen> {
  String _selectedCategory = "All";
  String _selectedFocusArea = "Mobile Development";

  final List<String> _categories = const ["All", "Courses", "Tutorials", "Books", "Videos"];
  final List<String> _focusAreas = const ["Web Development", "Mobile Development", "Data Science"];

  final List<Map<String, dynamic>> _resources = const [
    {
      "title": "Mastering REST APIs with Flutter",
      "platform": "Udemy",
      "type": "Course",
      "rating": "4.6",
      "level": "Beginner to Int.",
      "duration": "6.5 h",
      "language": "English",
      "icon": Icons.api_rounded,
      "color": Color(0xFF6366F1),
      "category": "Courses",
    },
    {
      "title": "Firebase for Flutter",
      "platform": "Coursera",
      "type": "Course",
      "rating": "4.7",
      "level": "Intermediate",
      "duration": "8.0 h",
      "language": "English",
      "icon": Icons.storage_rounded,
      "color": Color(0xFFEF4444),
      "category": "Courses",
    },
    {
      "title": "State Management in Flutter",
      "platform": "YouTube",
      "type": "Video",
      "rating": "4.8",
      "level": "All Levels",
      "duration": "2.5 h",
      "language": "English",
      "icon": Icons.play_circle_fill_rounded,
      "color": Color(0xFF10B981),
      "category": "Videos",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredResources = _selectedCategory == "All"
        ? _resources
        : _resources.where((r) => r["category"] == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Skill Pathway",
          style: TextStyle(
            color: Color(0xFF3822D6),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined, color: Color(0xFF1E293B)),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Greeting
                const Row(
                  children: [
                    Text(
                      "Hello Anas!",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(width: 6),
                    Text("👋", style: TextStyle(fontSize: 20)),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  "Ready to level up your skills today?",
                  style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                ),

                const SizedBox(height: 20),

                // YOUR SKILL GAPS
                const Text(
                  "YOUR SKILL GAPS",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF94A3B8),
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 10),
                const Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _GapBadge(label: "REST APIs"),
                    _GapBadge(label: "Firebase"),
                    _GapBadge(label: "State Management"),
                  ],
                ),

                const SizedBox(height: 24),

                // FOCUS AREA
                const Text(
                  "FOCUS AREA",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF94A3B8),
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _focusAreas.map((area) {
                      final isSelected = _selectedFocusArea == area;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(area),
                          selected: isSelected,
                          selectedColor: const Color(0xFF1E1B4B),
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : const Color(0xFF475569),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected ? const Color(0xFF1E1B4B) : const Color(0xFFE2E8F0),
                            ),
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedFocusArea = area;
                              });
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 28),

                // Recommended for You
                const Text(
                  "Recommended for You",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 12),

                // Category Tabs
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((cat) {
                      final isSelected = _selectedCategory == cat;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = cat;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 16),
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: isSelected ? const Color(0xFF3822D6) : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Text(
                            cat,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? const Color(0xFF3822D6) : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 16),

                // Resource Cards List
                ...filteredResources.map((res) => _ResourceCard(data: res)),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- HELPER WIDGETS ---

class _GapBadge extends StatelessWidget {
  final String label;

  const _GapBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFECDD3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.warning_amber_rounded, size: 14, color: Color(0xFFE11D48)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF9F1239),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const _ResourceCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResourceDetailScreen(resource: data),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: (data["color"] as Color).withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                data["icon"] as IconData,
                color: data["color"] as Color,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      data["type"] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4338CA),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    data["title"] as String,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data["platform"] as String,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        data["rating"] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.bookmark_outline_rounded, color: Color(0xFF64748B)),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}