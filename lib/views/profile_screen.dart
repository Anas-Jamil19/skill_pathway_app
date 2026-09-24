import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = true;
  bool isSaving = false;

  String fullName = "Anas Jamil";
  String careerGoal = "Flutter Developer";
  String email = "";
  String phone = "+92 300 1234567";
  String university = "Dawood University of Engineering and Technology";
  Uint8List? avatarBytes;
  String? avatarUrl;

  final Color primaryNavy = const Color(0xFF1E1B4B);
  final Color accentPurple = const Color(0xFF4F46E5);
  final Color textDark = const Color(0xFF0F172A);
  final Color textMuted = const Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    try {
      final supabase = Supabase.instance.client;
      final authUser = supabase.auth.currentUser;
      email = authUser?.email ?? "anasjamil2k25@gmail.com";

      final response = await supabase
          .from('profiles')
          .select()
          .eq('id', widget.userId)
          .maybeSingle();

      if (response != null) {
        setState(() {
          fullName = response['full_name'] ?? authUser?.userMetadata?['full_name'] ?? "Anas Jamil";
          careerGoal = response['career_goal'] ?? "Flutter Developer";
          phone = response['phone'] ?? "+92 300 1234567";
          university = response['university'] ?? "Dawood University of Engineering and Technology";

          if (response['avatar_url'] != null && response['avatar_url'].toString().isNotEmpty) {
            final String rawAvatar = response['avatar_url'].toString();
            if (rawAvatar.startsWith('http')) {
              avatarUrl = rawAvatar;
            } else {
              try {
                avatarBytes = base64Decode(rawAvatar);
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
      if (mounted) setState(() => isLoading = false);
    }
  }

  // --- LOGOUT DIALOG ---
  void _handleLogout() {
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

  // --- EDIT PROFILE / PERSONAL INFO MODAL ---
  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: fullName);
    final goalController = TextEditingController(text: careerGoal);
    final phoneController = TextEditingController(text: phone);
    final universityController = TextEditingController(text: university);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      backgroundColor: Colors.white,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 16),
                Text("Edit Personal Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textDark)),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: goalController,
                  decoration: InputDecoration(
                    labelText: "Target Career Goal",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: universityController,
                  decoration: InputDecoration(
                    labelText: "University / Institution",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryNavy,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: isSaving
                        ? null
                        : () async {
                            setModalState(() => isSaving = true);
                            final newName = nameController.text.trim();
                            final newGoal = goalController.text.trim();
                            final newPhone = phoneController.text.trim();
                            final newUni = universityController.text.trim();

                            try {
                              await Supabase.instance.client
                                  .from('profiles')
                                  .update({
                                    'full_name': newName,
                                    'career_goal': newGoal,
                                    'phone': newPhone,
                                    'university': newUni,
                                  })
                                  .eq('id', widget.userId);

                              setState(() {
                                fullName = newName;
                                careerGoal = newGoal;
                                phone = newPhone;
                                university = newUni;
                              });

                              if (mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Profile updated successfully!")),
                                );
                              }
                            } catch (e) {
                              debugPrint("Error updating profile: $e");
                            } finally {
                              if (mounted) setModalState(() => isSaving = false);
                            }
                          },
                    child: isSaving
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text("Save Changes", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- RESUME / CV DIALOG ---
  void _showResumeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.description_outlined, color: accentPurple),
            const SizedBox(width: 8),
            const Text("My Resume / CV"),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Status: ATS Optimized & Updated"),
            SizedBox(height: 8),
            Text("Primary Stack: Flutter, Dart, Supabase, Git", style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryNavy, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Resume download / view feature triggered")),
              );
            },
            child: const Text("View Full CV"),
          ),
        ],
      ),
    );
  }

  // --- SAVED OPPORTUNITIES BOTTOM SHEET ---
  void _showSavedOpportunitiesDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      backgroundColor: Colors.white,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Saved Opportunities", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textDark)),
            const SizedBox(height: 12),
            _buildSavedItem("Junior Flutter Developer", "TechWave Solutions Inc. • 92% Match"),
            const SizedBox(height: 8),
            _buildSavedItem("Mobile App Intern", "InnoDev Studios • 88% Match"),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedItem(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: textDark, fontSize: 14)),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(color: textMuted, fontSize: 12)),
            ],
          ),
          const Icon(Icons.bookmark, color: Color(0xFF4338CA), size: 20),
        ],
      ),
    );
  }

  // --- SETTINGS DIALOG ---
  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Settings & Preferences"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text("Push Notifications"),
              value: true,
              activeThumbColor: accentPurple,
              onChanged: (val) {},
            ),
            SwitchListTile(
              title: const Text("Dark Theme (Auto)"),
              value: false,
              activeThumbColor: accentPurple,
              onChanged: (val) {},
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryNavy, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context),
            child: const Text("Done"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("My Profile", style: TextStyle(color: primaryNavy, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: accentPurple))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    children: [
                      // --- PROFILE HEADER CARD ---
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 42,
                              backgroundColor: const Color(0xFFEEF2FF),
                              backgroundImage: avatarBytes != null
                                  ? MemoryImage(avatarBytes!)
                                  : (avatarUrl != null
                                      ? NetworkImage(avatarUrl!)
                                      : const NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150')) as ImageProvider,
                            ),
                            const SizedBox(height: 12),
                            Text(fullName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textDark)),
                            const SizedBox(height: 2),
                            Text(careerGoal, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: accentPurple)),
                            const SizedBox(height: 2),
                            Text(email, style: TextStyle(fontSize: 13, color: textMuted)),
                            const SizedBox(height: 16),
                            OutlinedButton.icon(
                              onPressed: _showEditProfileDialog,
                              icon: const Icon(Icons.edit_outlined, size: 16),
                              label: const Text("Edit Profile"),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: primaryNavy,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                side: const BorderSide(color: Color(0xFFCBD5E1)),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // --- STATS OVERVIEW ---
                      Row(
                        children: [
                          _buildStatCard("3", "Applications", Icons.assignment_outlined),
                          const SizedBox(width: 12),
                          _buildStatCard("82%", "Skill Match", Icons.track_changes_outlined),
                          const SizedBox(width: 12),
                          _buildStatCard("5", "Courses", Icons.school_outlined),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // --- MENU OPTIONS ---
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          children: [
                            _buildMenuItem(Icons.person_outline_rounded, "Personal Information", _showEditProfileDialog),
                            const Divider(height: 1, color: Color(0xFFF1F5F9)),
                            _buildMenuItem(Icons.description_outlined, "My Resume / CV", _showResumeDialog),
                            const Divider(height: 1, color: Color(0xFFF1F5F9)),
                            _buildMenuItem(Icons.bookmark_outline_rounded, "Saved Opportunities", _showSavedOpportunitiesDialog),
                            const Divider(height: 1, color: Color(0xFFF1F5F9)),
                            _buildMenuItem(Icons.settings_outlined, "Settings & Preferences", _showSettingsDialog),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // --- SIGN OUT BUTTON ---
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: _handleLogout,
                          icon: const Icon(Icons.logout_rounded, size: 18),
                          label: const Text("Sign Out", style: TextStyle(fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFEF2F2),
                            foregroundColor: const Color(0xFFEF4444),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            side: const BorderSide(color: Color(0xFFFCA5A5)),
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

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            Icon(icon, color: accentPurple, size: 22),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textDark)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 11, color: textMuted, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(color: Color(0xFFF1F5F9), shape: BoxShape.circle),
        child: Icon(icon, color: primaryNavy, size: 20),
      ),
      title: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textDark)),
      trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
      onTap: onTap,
    );
  }
}