import 'package:flutter/material.dart';

class SkillGapScreen extends StatefulWidget {
  final String? userId;

  const SkillGapScreen({super.key, this.userId});

  @override
  State<SkillGapScreen> createState() => _SkillGapScreenState();
}

class _SkillGapScreenState extends State<SkillGapScreen> {
  bool _showReport = false;
  String _selectedRole = "Flutter Developer";

  final List<String> _roles = const [
    "Flutter Developer",
    "Frontend Developer",
    "Mobile App Engineer",
    "Full Stack Developer"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: _showReport
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
                onPressed: () {
                  setState(() {
                    _showReport = false;
                  });
                },
              )
            : null,
        title: Text(
          _showReport ? "Your Skill Gap" : "Skill Pathway",
          style: const TextStyle(
            color: Color(0xFF1D2939),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _showReport ? _buildGapReportView() : _buildSelectionView(),
          ),
        ),
      ),
    );
  }

  // --- VIEW 1: SELECTION & CURRENT SKILLS SCREEN ---
  Widget _buildSelectionView() {
    return SingleChildScrollView(
      key: const ValueKey('SelectionView'),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Skill Gap Analyzer",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Discover the gap between your current skills and your dream role.",
            style: TextStyle(fontSize: 14, color: Color(0xFF64748B), height: 1.4),
          ),
          const SizedBox(height: 24),

          // Target Role Input Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "TARGET ROLE",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF94A3B8),
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedRole,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B)),
                      items: [
                        for (final role in _roles)
                          DropdownMenuItem<String>(
                            value: role,
                            child: Text(
                              role,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E293B),
                                fontSize: 15,
                              ),
                            ),
                          ),
                      ],
                      onChanged: (newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedRole = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Current Skills Card
          Container(
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
                    const Text(
                      "YOUR CURRENT SKILLS",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF94A3B8),
                        letterSpacing: 0.8,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.edit_outlined, size: 14, color: Color(0xFF3822D6)),
                      label: const Text(
                        "Edit Skills",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3822D6),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _SkillChip(label: "Dart", checked: true),
                    _SkillChip(label: "Flutter", checked: true),
                    _SkillChip(label: "Git", checked: true),
                    _SkillChip(label: "HTML", checked: true),
                    _SkillChip(label: "CSS", checked: true),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(color: Color(0xFFF1F5F9)),
                const SizedBox(height: 12),
                const Text(
                  "Suggested additions for this role:",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 12),
                const Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _AddChip(label: "Firebase"),
                    _AddChip(label: "REST APIs"),
                    _AddChip(label: "State Management"),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Analyze Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3822D6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              onPressed: () {
                setState(() {
                  _showReport = true;
                });
              },
              icon: const Icon(Icons.bar_chart_rounded, color: Colors.white, size: 20),
              label: const Text(
                "Analyze My Skills",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // --- VIEW 2: ANALYSIS RESULT SCREEN ---
  Widget _buildGapReportView() {
    return SingleChildScrollView(
      key: const ValueKey('GapReportView'),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Target Role",
            style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 4),
          Text(
            _selectedRole,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2513A8),
            ),
          ),
          const SizedBox(height: 28),

          // Circular Score Chart
          const Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 170,
                  height: 170,
                  child: CircularProgressIndicator(
                    value: 0.65,
                    strokeWidth: 14,
                    backgroundColor: Color(0xFFEEF2FF),
                    color: Color(0xFF3822D6),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "65%",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Match Score",
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 36),

          // YOU HAVE - STRENGTHS
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "YOU HAVE — STRENGTHS",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF64748B),
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Column(
              children: [
                _StrengthRow(label: "Dart"),
                Divider(height: 1, color: Color(0xFFF1F5F9)),
                _StrengthRow(label: "Flutter"),
                Divider(height: 1, color: Color(0xFFF1F5F9)),
                _StrengthRow(label: "Git"),
                Divider(height: 1, color: Color(0xFFF1F5F9)),
                _StrengthRow(label: "HTML / CSS"),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // YOU NEED - SKILL GAPS
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "YOU NEED — SKILL GAPS",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF64748B),
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5F5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFECDD3)),
            ),
            child: const Column(
              children: [
                _GapRow(label: "Firebase Integration"),
                Divider(height: 1, color: Color(0xFFFFE4E6)),
                _GapRow(label: "REST APIs"),
                Divider(height: 1, color: Color(0xFFFFE4E6)),
                _GapRow(label: "State Management (Provider/Riverpod)"),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // RECOMMENDED NEXT STEP CARD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F4FF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFD0D7FF)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_rounded, color: Color(0xFF3822D6), size: 22),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Recommended Next Step",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Focus on these missing skills to improve your match score and become job-ready.",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF475569),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ACTION BUTTON 1: Find Learning Resources
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4B39EF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              onPressed: () {},
              icon: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 18),
              label: const Text(
                "Find Learning Resources",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ACTION BUTTON 2: Re-analyze Profile
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF4B39EF)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                setState(() {
                  _showReport = false;
                });
              },
              icon: const Icon(Icons.refresh_rounded, color: Color(0xFF4B39EF), size: 18),
              label: const Text(
                "Re-analyze Profile",
                style: TextStyle(
                  color: Color(0xFF4B39EF),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),

          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

// --- HELPER WIDGETS ---

class _SkillChip extends StatelessWidget {
  final String label;
  final bool checked;

  const _SkillChip({required this.label, required this.checked});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          checked ? Icons.check_circle_outline_rounded : Icons.circle_outlined,
          size: 18,
          color: const Color(0xFF10B981),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _AddChip extends StatelessWidget {
  final String label;

  const _AddChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.add, size: 14, color: Color(0xFF64748B)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF334155),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _StrengthRow extends StatelessWidget {
  final String label;

  const _StrengthRow({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Color(0xFFEEF2FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Color(0xFF3822D6), size: 16),
          ),
          const SizedBox(width: 14),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}

class _GapRow extends StatelessWidget {
  final String label;

  const _GapRow({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Color(0xFFFFE4E6),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close, color: Color(0xFFE11D48), size: 16),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF881337),
              ),
            ),
          ),
        ],
      ),
    );
  }
}