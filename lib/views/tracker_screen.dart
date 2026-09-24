import 'package:flutter/material.dart';

class TrackerScreen extends StatefulWidget {
  final String? userId;

  const TrackerScreen({super.key, this.userId});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  String _selectedFilter = "All";
  final List<String> _filters = const ["All", "In Progress", "Submitted", "Rejected"];

  // --- DYNAMIC APPLICATION DATA LIST ---
  final List<Map<String, dynamic>> _applications = [
    {
      "id": "1",
      "company": "Google",
      "logoText": "G",
      "logoColor": const Color(0xFF4285F4),
      "title": "Google STEP Internship 2025",
      "status": "In Progress",
      "appliedDate": "15 May 2026",
      "nextStep": "Online Assessment",
      "completedSteps": "2/4 Completed",
      "progress": 0.5,
      "note": "Note: Update resume with latest Flutter project before assessment.",
      "timeline": [
        {"title": "Applied", "subtitle": "Application submitted successfully.", "isCompleted": true, "isCurrent": false},
        {"title": "Online Assessment", "subtitle": "Pending invitation email.", "isCompleted": false, "isCurrent": true},
        {"title": "Interview", "subtitle": "", "isCompleted": false, "isCurrent": false},
      ]
    },
    {
      "id": "2",
      "company": "DAAD",
      "logoText": "D",
      "logoColor": const Color(0xFF0284C7),
      "title": "DAAD Scholarship 2026",
      "status": "Submitted",
      "appliedDate": "10 May 2026",
      "nextStep": "Under Review",
      "completedSteps": "1/3 Completed",
      "progress": 0.33,
      "note": "Note: Document verification in progress.",
      "timeline": [
        {"title": "Applied", "subtitle": "Submitted via portal.", "isCompleted": true, "isCurrent": false},
        {"title": "Under Review", "subtitle": "Reviewing by committee.", "isCompleted": false, "isCurrent": true},
      ]
    },
    {
      "id": "3",
      "company": "Microsoft",
      "logoText": "M",
      "logoColor": const Color(0xFF00A4EF),
      "title": "Microsoft Student Ambassador",
      "status": "Rejected",
      "appliedDate": "01 Apr 2026",
      "nextStep": "Application Closed",
      "completedSteps": "3/3 Completed",
      "progress": 1.0,
      "note": "Note: Re-apply in the next cohort next year.",
      "timeline": [
        {"title": "Applied", "subtitle": "Submitted video task.", "isCompleted": true, "isCurrent": false},
        {"title": "Final Decision", "subtitle": "Not selected this cycle.", "isCompleted": true, "isCurrent": true},
      ]
    },
  ];

  // --- FILTERED LIST LOGIC ---
  List<Map<String, dynamic>> get _filteredApplications {
    if (_selectedFilter == "All") {
      return _applications;
    }
    return _applications.where((app) => app["status"] == _selectedFilter).toList();
  }

  // --- UPDATE STATUS DIALOG ---
  void _showUpdateStatusBottomSheet(BuildContext context, Map<String, dynamic> appItem) {
    String selectedStatus = appItem["status"];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Update Status: ${appItem["title"]}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Select the current stage for this opportunity:",
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                  ),
                  const SizedBox(height: 16),

                  // Options
                  ...["In Progress", "Submitted", "Rejected"].map((status) {
                    final isSelected = selectedStatus == status;
                    return InkWell(
                      onTap: () {
                        setModalState(() {
                          selectedStatus = status;
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFEEF2FF) : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF4338CA) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              status,
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? const Color(0xFF4338CA) : const Color(0xFF334155),
                              ),
                            ),
                            if (isSelected)
                              const Icon(Icons.check_circle_rounded, color: Color(0xFF4338CA), size: 20),
                          ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E1B4B),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        setState(() {
                          appItem["status"] = selectedStatus;
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Status updated to '$selectedStatus'"),
                            backgroundColor: const Color(0xFF1E1B4B),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: const Text("Save Status", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayedList = _filteredApplications;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.school_outlined, color: Color(0xFF1E1B4B), size: 24),
            SizedBox(width: 8),
            Text(
              "Skill Pathway",
              style: TextStyle(
                color: Color(0xFF1E1B4B),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Application Tracker",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Monitor your academic and career opportunities.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // --- FUNCTIONAL HORIZONTAL FILTER PILLS ---
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (final filter in _filters)
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: ChoiceChip(
                                label: Text(filter),
                                selected: _selectedFilter == filter,
                                selectedColor: const Color(0xFF1E1B4B),
                                backgroundColor: Colors.white,
                                labelStyle: TextStyle(
                                  color: _selectedFilter == filter ? Colors.white : const Color(0xFF475569),
                                  fontWeight: _selectedFilter == filter ? FontWeight.bold : FontWeight.w500,
                                  fontSize: 13,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  side: BorderSide(
                                    color: _selectedFilter == filter ? const Color(0xFF1E1B4B) : const Color(0xFFE2E8F0),
                                  ),
                                ),
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      _selectedFilter = filter;
                                    });
                                  }
                                },
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // --- APPLICATION CARDS LIST ---
                    if (displayedList.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(32),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            const Icon(Icons.folder_open_rounded, size: 48, color: Color(0xFF94A3B8)),
                            const SizedBox(height: 12),
                            Text(
                              "No applications in '$_selectedFilter'",
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      )
                    else
                      for (final item in displayedList) ...[
                        _buildApplicationCard(item),
                        const SizedBox(height: 16),
                      ],

                    const SizedBox(height: 80),
                  ],
                ),
              ),

              Positioned(
                bottom: 24,
                right: 20,
                child: FloatingActionButton(
                  backgroundColor: const Color(0xFF1E1B4B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Add new application modal triggered")),
                    );
                  },
                  child: const Icon(Icons.add, color: Colors.white, size: 28),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildApplicationCard(Map<String, dynamic> item) {
    Color statusBg = const Color(0xFFEEF2FF);
    Color statusText = const Color(0xFF4338CA);

    if (item["status"] == "Rejected") {
      statusBg = const Color(0xFFFEF2F2);
      statusText = const Color(0xFFEF4444);
    } else if (item["status"] == "Submitted") {
      statusBg = const Color(0xFFF1F5F9);
      statusText = const Color(0xFF334155);
    }

    final List timelineList = item["timeline"] ?? [];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    item["logoText"],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: item["logoColor"],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item["title"],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            (item["status"] as String).toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: statusText,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        Text(
                          "• Applied: ${item["appliedDate"]}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Next: ${item["nextStep"]}",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF334155),
                      ),
                    ),
                    Text(
                      item["completedSteps"],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1B4B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: item["progress"],
                    backgroundColor: const Color(0xFFE2E8F0),
                    color: const Color(0xFF1E1B4B),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Timeline steps
          for (int i = 0; i < timelineList.length; i++)
            _buildTimelineStep(
              title: timelineList[i]["title"],
              subtitle: timelineList[i]["subtitle"],
              isCompleted: timelineList[i]["isCompleted"],
              isCurrent: timelineList[i]["isCurrent"],
              isLast: i == timelineList.length - 1,
            ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.edit_note_rounded, color: Color(0xFF64748B), size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item["note"],
                    style: const TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF334155),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFFF1F5F9),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onPressed: () => _showUpdateStatusBottomSheet(context, item),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Update Status",
                    style: TextStyle(
                      color: Color(0xFF334155),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_drop_down, color: Color(0xFF334155)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep({
    required String title,
    required String subtitle,
    required bool isCompleted,
    required bool isCurrent,
    bool isLast = false,
  }) {
    Color dotColor = const Color(0xFFCBD5E1);
    if (isCompleted || isCurrent) {
      dotColor = const Color(0xFF1E1B4B);
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20,
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isCurrent ? Colors.white : dotColor,
                    shape: BoxShape.circle,
                    border: isCurrent ? Border.all(color: const Color(0xFF1E1B4B), width: 3) : null,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: const Color(0xFFE2E8F0),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isCurrent || isCompleted ? FontWeight.bold : FontWeight.normal,
                      color: isCurrent || isCompleted ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}