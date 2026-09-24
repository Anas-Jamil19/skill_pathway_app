import 'package:flutter/material.dart';
import 'opportunity_detail_screen.dart';

class OpportunitiesScreen extends StatefulWidget {
  final String userId;

  const OpportunitiesScreen({super.key, required this.userId});

  @override
  State<OpportunitiesScreen> createState() => _OpportunitiesScreenState();
}

class _OpportunitiesScreenState extends State<OpportunitiesScreen> {
  String selectedFilter = 'All';
  String searchQuery = '';

  final Color primaryNavy = const Color(0xFF1E1B4B);
  final Color accentPurple = const Color(0xFF4F46E5);
  final Color bgLight = const Color(0xFFFAFAFC);
  final Color textDark = const Color(0xFF0F172A);
  final Color textMuted = const Color(0xFF64748B);

  final List<Map<String, dynamic>> opportunitiesList = [
    {
      'id': '1',
      'title': 'Software Engineering Internship',
      'company': 'ABC Technologies',
      'type': 'INTERNSHIP',
      'deadline': '20 Aug 2026',
      'match': '92%',
      'matchColor': const Color(0xFF4F46E5),
      'isSaved': false,
      'location': 'Lahore, Pakistan',
    },
    {
      'id': '2',
      'title': 'Global Leaders Grant',
      'company': 'EduCorp Foundation',
      'type': 'SCHOLARSHIP',
      'deadline': '15 Sep 2026',
      'match': '85%',
      'matchColor': const Color(0xFF64748B),
      'isSaved': true,
      'location': 'Islamabad, Pakistan',
    },
    {
      'id': '3',
      'title': 'Junior Product Designer',
      'company': 'Creative Studio X',
      'type': 'JOB',
      'deadline': 'Rolling',
      'match': '78%',
      'matchColor': const Color(0xFF64748B),
      'isSaved': false,
      'location': 'Karachi, Pakistan',
    },
    {
      'id': '4',
      'title': 'Flutter App Developer Intern',
      'company': 'TechWave Solutions',
      'type': 'INTERNSHIP',
      'deadline': '30 Aug 2026',
      'match': '95%',
      'matchColor': const Color(0xFF4F46E5),
      'isSaved': false,
      'location': 'Remote / Karachi',
    },
    {
      'id': '5',
      'title': 'Merit-Based STEM Scholarship',
      'company': 'Higher Education Commission',
      'type': 'SCHOLARSHIP',
      'deadline': '10 Oct 2026',
      'match': '90%',
      'matchColor': const Color(0xFF4F46E5),
      'isSaved': false,
      'location': 'Pakistan',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredOpportunities = opportunitiesList.where((item) {
      final matchesFilter = selectedFilter == 'All' ||
          (selectedFilter == 'Internships' && item['type'] == 'INTERNSHIP') ||
          (selectedFilter == 'Scholarships' && item['type'] == 'SCHOLARSHIP') ||
          (selectedFilter == 'Jobs' && item['type'] == 'JOB');

      final matchesSearch = item['title']
              .toString()
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          item['company']
              .toString()
              .toLowerCase()
              .contains(searchQuery.toLowerCase());

      return matchesFilter && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: bgLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header Bar (Avatar Removed for Clean Look)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.school_outlined, color: primaryNavy, size: 28),
                  const SizedBox(width: 8),
                  Text(
                    "Skill Pathway",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryNavy,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          "Opportunities",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: textDark,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Discover paths tailored to your profile.",
                          style: TextStyle(color: textMuted, fontSize: 15),
                        ),
                        const SizedBox(height: 20),

                        // Search Input
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: const Color(0xFFCBD5E1)),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            onChanged: (val) =>
                                setState(() => searchQuery = val),
                            decoration: InputDecoration(
                              hintText: "Search opportunities...",
                              hintStyle: TextStyle(
                                  color: textMuted.withOpacity(0.7),
                                  fontSize: 15),
                              prefixIcon: Icon(Icons.search_rounded,
                                  color: textMuted),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Filter Chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildFilterChip('All'),
                              const SizedBox(width: 8),
                              _buildFilterChip('Internships'),
                              const SizedBox(width: 8),
                              _buildFilterChip('Scholarships'),
                              const SizedBox(width: 8),
                              _buildFilterChip('Jobs'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Opportunity Cards List
                        ...filteredOpportunities
                            .map((item) => _buildOpportunityCard(item)),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final bool isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? primaryNavy : const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : textDark,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildOpportunityCard(Map<String, dynamic> item) {
    final String type = item['type'];
    Color tagBgColor;
    Color tagTextColor;

    if (type == 'INTERNSHIP') {
      tagBgColor = const Color(0xFFEEF2FF);
      tagTextColor = accentPurple;
    } else if (type == 'SCHOLARSHIP') {
      tagBgColor = const Color(0xFFE0E7FF);
      tagTextColor = const Color(0xFF3730A3);
    } else {
      tagBgColor = const Color(0xFFF1F5F9);
      tagTextColor = textDark;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OpportunityDetailScreen(opportunity: item),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: tagBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    type,
                    style: TextStyle(
                      color: tagTextColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      item['isSaved'] = !(item['isSaved'] as bool);
                    });
                  },
                  child: Icon(
                    item['isSaved']
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color: item['isSaved'] ? accentPurple : textMuted,
                    size: 22,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item['title'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.business_rounded, size: 16, color: textMuted),
                const SizedBox(width: 6),
                Text(
                  item['company'],
                  style: TextStyle(color: textMuted, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "DEADLINE",
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded,
                            size: 14, color: Color(0xFFEF4444)),
                        const SizedBox(width: 6),
                        Text(
                          item['deadline'],
                          style: TextStyle(
                            color: textDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: item['matchColor'],
                    shape: BoxShape.circle,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item['match'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const Text(
                        "MATCH",
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 7,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}