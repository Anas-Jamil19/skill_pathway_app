import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_screen.dart';
import 'opportunities_screen.dart';
import 'skill_gap_screen.dart';
import 'tracker_screen.dart';
import 'learning_resources_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String userId;

  const DashboardScreen({
    super.key,
    required this.userId,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  bool isLoadingProfile = true;

  String userDisplayName = "Anas Jamil";
  String targetRole = "Flutter Developer";
  Uint8List? fetchedAvatarBytes;
  String? avatarUrl;

  final Color primaryNavy = const Color(0xFF1E1B4B);
  final Color accentPurple = const Color(0xFF4F46E5);
  final Color bgLight = const Color(0xFFFAFAFC);
  final Color textDark = const Color(0xFF0F172A);
  final Color textMuted = const Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    _fetchUserProfileData();
  }

  // --- FETCH USER DETAILS & SAVED ONBOARDING AVATAR FROM SUPABASE ---
  Future<void> _fetchUserProfileData() async {
    try {
      final supabase = Supabase.instance.client;
      final authUser = supabase.auth.currentUser;

      final response = await supabase
          .from('profiles')
          .select()
          .eq('id', widget.userId)
          .maybeSingle();

      if (response != null) {
        setState(() {
          userDisplayName = response['full_name'] ?? authUser?.userMetadata?['full_name'] ?? "Anas Jamil";
          targetRole = response['career_goal'] ?? "Flutter Developer";
          
          if (response['avatar_url'] != null && response['avatar_url'].toString().isNotEmpty) {
            final String rawAvatar = response['avatar_url'].toString();
            if (rawAvatar.startsWith('http')) {
              avatarUrl = rawAvatar;
            } else {
              try {
                fetchedAvatarBytes = base64Decode(rawAvatar);
              } catch (_) {
                avatarUrl = rawAvatar;
              }
            }
          }
        });
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
    } finally {
      if (mounted) setState(() => isLoadingProfile = false);
    }
  }

  // --- LOGOUT DIALOG FUNCTION ---
  Future<void> _handleLogout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Logout", style: TextStyle(fontWeight: FontWeight.bold, color: textDark)),
        content: Text("Are you sure you want to sign out of Skill Pathway?", style: TextStyle(color: textMuted)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: textMuted, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            onPressed: () async {
              Navigator.pop(context);
              await Supabase.instance.client.auth.signOut();
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text("Logout", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _navigateToOpportunities() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OpportunitiesScreen(userId: widget.userId),
      ),
    );
  }

  void _navigateToLearningResources() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LearningResourcesScreen(userId: widget.userId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      body: SafeArea(
        child: Column(
          children: [
            // --- TOP APP BAR WITH BRANDING & CLICKABLE LOGOUT AVATAR ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
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
                  
                  // Clickable Avatar to Trigger Logout Dialog
                  GestureDetector(
                    onTap: _handleLogout,
                    child: Tooltip(
                      message: "Tap to Logout",
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: const Color(0xFFE2E8F0),
                            backgroundImage: fetchedAvatarBytes != null
                                ? MemoryImage(fetchedAvatarBytes!)
                                : (avatarUrl != null
                                    ? NetworkImage(avatarUrl!)
                                    : const NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150')) as ImageProvider,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Color(0xFFEF4444),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.power_settings_new, size: 9, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- DASHBOARD BODY ---
            Expanded(
              child: isLoadingProfile
                  ? Center(child: CircularProgressIndicator(color: accentPurple))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                      child: Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 440),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hi $userDisplayName! 👋",
                                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textDark, letterSpacing: -0.5),
                              ),
                              const SizedBox(height: 4),
                              Text("Welcome to Skill Pathway", style: TextStyle(color: textMuted, fontSize: 15)),
                              const SizedBox(height: 20),

                              // Career Readiness Card
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Career Readiness", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textDark)),
                                          const SizedBox(height: 6),
                                          Text("You are on track! Complete 2 more modules to reach 90%.", style: TextStyle(color: textMuted, fontSize: 13, height: 1.4)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    SizedBox(
                                      width: 64,
                                      height: 64,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            value: 0.82,
                                            strokeWidth: 7,
                                            backgroundColor: const Color(0xFFEEF2FF),
                                            color: accentPurple,
                                          ),
                                          const Text("82%", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Quick Features Grid
                              GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.55,
                                children: [
                                  _buildFeatureCard(
                                    title: "Opportunities",
                                    icon: Icons.work_outline_rounded,
                                    bgColor: const Color(0xFFEEF2FF),
                                    iconBgColor: Colors.white,
                                    iconColor: accentPurple,
                                    onTap: _navigateToOpportunities,
                                  ),
                                  _buildFeatureCard(
                                    title: "Skill Gap",
                                    icon: Icons.track_changes_rounded,
                                    bgColor: const Color(0xFFF3E8FF),
                                    iconBgColor: Colors.white,
                                    iconColor: const Color(0xFF9333EA),
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => SkillGapScreen(userId: widget.userId)));
                                    },
                                  ),
                                  _buildFeatureCard(
                                    title: "Learning\nResources",
                                    icon: Icons.menu_book_rounded,
                                    bgColor: const Color(0xFFF1F5F9),
                                    iconBgColor: Colors.white,
                                    iconColor: textDark,
                                    onTap: _navigateToLearningResources,
                                  ),
                                  _buildFeatureCard(
                                    title: "Application\nTracker",
                                    icon: Icons.show_chart_rounded,
                                    bgColor: const Color(0xFFF1F5F9),
                                    iconBgColor: Colors.white,
                                    iconColor: textDark,
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => TrackerScreen(userId: widget.userId)));
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 28),

                              // Recommended Opportunities
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Recommended Opportunities", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textDark)),
                                  TextButton(
                                    onPressed: _navigateToOpportunities,
                                    child: Text("See All", style: TextStyle(color: accentPurple, fontWeight: FontWeight.w600, fontSize: 13)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              _buildOpportunityCard(
                                title: "Junior Flutter Developer",
                                company: "TechWave Solutions Inc.",
                                deadline: "Oct 15",
                                matchText: "92% Match",
                                onTap: _navigateToOpportunities,
                              ),
                              const SizedBox(height: 12),
                              _buildOpportunityCard(
                                title: "Mobile App Intern",
                                company: "InnoDev Studios",
                                deadline: "Oct 22",
                                matchText: "88% Match",
                                onTap: _navigateToOpportunities,
                              ),
                              const SizedBox(height: 28),

                              // Skill Gap Snapshot
                              Text("Skill Gap Snapshot", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textDark)),
                              const SizedBox(height: 12),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E293B),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("TARGET ROLE", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.bold)),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                                          child: const Text("65% Match", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      targetRole,
                                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 16),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: 0.65,
                                        backgroundColor: Colors.white.withOpacity(0.2),
                                        color: accentPurple,
                                        minHeight: 6,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      height: 42,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => SkillGapScreen(userId: widget.userId)));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: textDark,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text("Analyze Skills", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                            SizedBox(width: 6),
                                            Icon(Icons.arrow_forward_rounded, size: 16),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 28),

                              // Upcoming Deadline
                              Text("Upcoming Deadline", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textDark)),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF2F2),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFFFCA5A5).withOpacity(0.5)),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                      child: const Icon(Icons.error_outline_rounded, color: Color(0xFFEF4444), size: 22),
                                    ),
                                    const SizedBox(width: 14),
                                    const Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Capstone Project Proposal", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A))),
                                          SizedBox(height: 2),
                                          Text("Due in 2 Days", style: TextStyle(color: Color(0xFFDC2626), fontSize: 13, fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),

            // --- BOTTOM NAVIGATION BAR ---
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, Icons.home_rounded, "Home"),
                  _buildNavItem(1, Icons.explore_outlined, "Explore", onTap: _navigateToOpportunities),
                  _buildNavItem(2, Icons.menu_book_outlined, "Learn", onTap: _navigateToLearningResources),
                  _buildNavItem(3, Icons.show_chart_rounded, "Tracker", onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TrackerScreen(userId: widget.userId)));
                  }),
                  _buildNavItem(4, Icons.person_outline_rounded, "Profile", onTap: _handleLogout),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required IconData icon,
    required Color bgColor,
    required Color iconBgColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textDark, height: 1.2)),
          ],
        ),
      ),
    );
  }

  Widget _buildOpportunityCard({
    required String title,
    required String company,
    required String deadline,
    required String matchText,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textDark)),
                  const SizedBox(height: 2),
                  Text(company, style: TextStyle(color: textMuted, fontSize: 13)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: textMuted),
                      const SizedBox(width: 4),
                      Text("Deadline: $deadline", style: TextStyle(color: textMuted, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(20)),
              child: Text(matchText, style: TextStyle(color: accentPurple, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, {VoidCallback? onTap}) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedIndex = index);
        if (onTap != null) onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isSelected ? BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(20)) : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? accentPurple : const Color(0xFF64748B), size: 22),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? accentPurple : const Color(0xFF64748B))),
          ],
        ),
      ),
    );
  }
}