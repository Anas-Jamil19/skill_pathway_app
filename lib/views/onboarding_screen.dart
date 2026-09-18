import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/onboarding_provider.dart';
import 'dashboard_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool isSubmitting = false;

  // Image Upload Variables
  Uint8List? _selectedImageBytes;
  final ImagePicker _picker = ImagePicker();

  final Color primaryNavy = const Color(0xFF1B1464);
  final Color accentPurple = const Color(0xFF4F46E5);
  final Color bgLight = const Color(0xFFFAFAFC);
  final Color textDark = const Color(0xFF0F172A);
  final Color textMuted = const Color(0xFF64748B);

  static const List<Map<String, dynamic>> interestCategories = [
    {'title': 'Web', 'icon': Icons.web_rounded},
    {'title': 'Mobile', 'icon': Icons.smartphone_rounded},
    {'title': 'AI/ML', 'icon': Icons.smart_toy_outlined},
    {'title': 'UI/UX', 'icon': Icons.space_dashboard_outlined},
    {'title': 'Data Science', 'icon': Icons.storage_rounded},
    {'title': 'Cloud', 'icon': Icons.cloud_queue_rounded},
  ];

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  void _jumpToStep(int step) {
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OnboardingProvider>(context);
    final user = Supabase.instance.client.auth.currentUser;
    final userId = user?.id ?? "11111111-1111-1111-1111-111111111111";

    return Scaffold(
      backgroundColor: bgLight,
      body: SafeArea(
        child: Column(
          children: [
            // --- TOP HEADER WITH CIRCULAR BACK & SEGMENTED BARS ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: textDark, size: 20),
                      onPressed: () {
                        if (_currentStep > 0) {
                          _jumpToStep(_currentStep - 1);
                        } else {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: _buildSegmentedProgress(_currentStep)),
                ],
              ),
            ),

            // --- WIZARD BODY ---
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // ================= STEP 1: ACADEMICS =================
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tell us about your academics",
                              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: textDark, letterSpacing: -0.5),
                            ),
                            const SizedBox(height: 8),
                            Text("This helps us personalize opportunities for you.", style: TextStyle(color: textMuted, fontSize: 15)),
                            const SizedBox(height: 32),
                            Text("Degree", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: textDark)),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              initialValue: provider.selectedDegree,
                              icon: Icon(Icons.unfold_more, color: textMuted, size: 20),
                              decoration: _buildInputDecoration(),
                              items: OnboardingProvider.degreesList.map((deg) {
                                return DropdownMenuItem<String>(
                                  value: deg,
                                  child: Text(deg, style: TextStyle(fontSize: 15, color: textDark)),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) provider.updateDegree(val);
                              },
                            ),
                            const SizedBox(height: 24),
                            Text("University", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: textDark)),
                            const SizedBox(height: 8),
                            TextField(
                              controller: provider.universityController,
                              style: TextStyle(fontSize: 15, color: textDark),
                              decoration: _buildInputDecoration(
                                prefixIcon: Icon(Icons.search_rounded, color: textMuted, size: 22),
                                suffixIcon: provider.universityController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.cancel, color: Color(0xFFCBD5E1), size: 20),
                                        onPressed: () {
                                          provider.universityController.clear();
                                          setState(() {});
                                        },
                                      )
                                    : null,
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 24),
                            Text("Current Year / Semester", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: textDark)),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              initialValue: provider.selectedSemester,
                              icon: Icon(Icons.unfold_more, color: textMuted, size: 20),
                              decoration: _buildInputDecoration(),
                              items: OnboardingProvider.semestersList.map((sem) {
                                return DropdownMenuItem<String>(
                                  value: sem,
                                  child: Text(sem, style: TextStyle(fontSize: 15, color: textDark)),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) provider.updateSemester(val);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ================= STEP 2: SKILLS =================
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("What skills do you have?", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: textDark, letterSpacing: -0.5)),
                            const SizedBox(height: 8),
                            Text("Select all that apply to tailor your pathway.", style: TextStyle(color: textMuted, fontSize: 15)),
                            const SizedBox(height: 28),
                            provider.isLoading
                                ? Center(child: CircularProgressIndicator(color: accentPurple))
                                : provider.skills.isEmpty
                                    ? const Center(child: Text("No skills loaded from backend."))
                                    : Wrap(
                                        spacing: 12,
                                        runSpacing: 14,
                                        children: provider.skills.map((skill) {
                                          final String skillId = skill['id'].toString();
                                          final String skillName = skill['skill_name'].toString();
                                          final isSelected = provider.selectedSkillIds.contains(skillId);

                                          return GestureDetector(
                                            onTap: () => provider.toggleSkill(skillId),
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                              decoration: BoxDecoration(
                                                color: isSelected ? accentPurple : Colors.white,
                                                borderRadius: BorderRadius.circular(28),
                                                border: Border.all(
                                                  color: isSelected ? accentPurple : const Color(0xFFE2E8F0),
                                                  width: 1.2,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(skillName, style: TextStyle(color: isSelected ? Colors.white : textDark, fontSize: 15, fontWeight: FontWeight.w500)),
                                                  if (isSelected) ...[
                                                    const SizedBox(width: 8),
                                                    const Icon(Icons.check, color: Colors.white, size: 18),
                                                  ],
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ================= STEP 3: INTERESTS & GOALS =================
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Almost there!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textDark, letterSpacing: -0.5)),
                            const SizedBox(height: 6),
                            Text("Tell us what you want to learn to build your custom syllabus.", style: TextStyle(color: textMuted, fontSize: 15)),
                            const SizedBox(height: 28),
                            Text("What are your interests?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textDark)),
                            const SizedBox(height: 16),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 14,
                                mainAxisSpacing: 14,
                                childAspectRatio: 1.45,
                              ),
                              itemCount: interestCategories.length,
                              itemBuilder: (context, index) {
                                final item = interestCategories[index];
                                final String title = item['title'] as String;
                                final IconData icon = item['icon'] as IconData;
                                final isSelected = provider.selectedInterests.contains(title);

                                return GestureDetector(
                                  onTap: () => provider.toggleInterest(title),
                                  child: Container(
                                    padding: const EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                      color: isSelected ? const Color(0xFFF1F4FF) : const Color(0xFFF8FAFC),
                                      borderRadius: BorderRadius.circular(32),
                                      border: Border.all(
                                        color: isSelected ? accentPurple : const Color(0xFFCBD5E1),
                                        width: isSelected ? 2.0 : 1.2,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(icon, size: 28, color: textDark),
                                        const SizedBox(height: 12),
                                        Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textDark)),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 32),
                            Text("What is your career goal?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textDark)),
                            const SizedBox(height: 14),
                            TextField(
                              controller: provider.careerGoalController,
                              style: TextStyle(fontSize: 15, color: textDark),
                              decoration: _buildInputDecoration(
                                prefixIcon: Icon(Icons.search_rounded, color: textMuted, size: 22),
                                hintText: "Flutter Developer",
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 28),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ================= STEP 4: REVIEW PROFILE =================
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Review your profile", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textDark, letterSpacing: -0.5)),
                                    const SizedBox(height: 4),
                                    Text("Make sure everything looks right.", style: TextStyle(color: textMuted, fontSize: 15)),
                                  ],
                                ),
                                // Avatar with Camera Badge
                                GestureDetector(
                                  onTap: _pickImage,
                                  child: Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 32,
                                        backgroundColor: const Color(0xFFE2E8F0),
                                        backgroundImage: _selectedImageBytes != null
                                            ? MemoryImage(_selectedImageBytes!)
                                            : const NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150') as ImageProvider,
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: accentPurple,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.white, width: 2),
                                          ),
                                          child: const Icon(Icons.camera_alt, size: 12, color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 28),

                            _buildReviewCard(
                              icon: Icons.school_outlined,
                              title: "Academic",
                              onEdit: () => _jumpToStep(0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(provider.selectedDegree, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textDark)),
                                  const SizedBox(height: 2),
                                  Text(
                                    provider.universityController.text.trim().isEmpty ? "Dawood UET" : provider.universityController.text.trim(),
                                    style: TextStyle(fontSize: 14, color: textMuted),
                                  ),
                                  const SizedBox(height: 2),
                                  Text("Year / Semester: ${provider.selectedSemester}", style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            _buildReviewCard(
                              icon: Icons.extension_outlined,
                              title: "Skills",
                              onEdit: () => _jumpToStep(1),
                              child: provider.selectedSkillIds.isEmpty
                                  ? Text("No skills selected yet.", style: TextStyle(color: textMuted, fontSize: 14))
                                  : Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: provider.selectedSkillIds.map((id) {
                                        final skillObj = provider.skills.firstWhere((s) => s['id'].toString() == id, orElse: () => {'skill_name': id});
                                        return Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF1F5F9),
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: Text(skillObj['skill_name'].toString(), style: TextStyle(fontSize: 13, color: textDark, fontWeight: FontWeight.w500)),
                                        );
                                      }).toList(),
                                    ),
                            ),
                            const SizedBox(height: 16),

                            _buildReviewCard(
                              icon: Icons.favorite_border_rounded,
                              title: "Interests",
                              onEdit: () => _jumpToStep(2),
                              child: provider.selectedInterests.isEmpty
                                  ? Text("No interests selected.", style: TextStyle(color: textMuted, fontSize: 14))
                                  : Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: provider.selectedInterests.map((interest) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFEEF2FF),
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: Text(interest, style: TextStyle(fontSize: 13, color: accentPurple, fontWeight: FontWeight.w600)),
                                        );
                                      }).toList(),
                                    ),
                            ),
                            const SizedBox(height: 16),

                            _buildReviewCard(
                              icon: Icons.flag_outlined,
                              title: "Career Goal",
                              onEdit: () => _jumpToStep(2),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  provider.careerGoalController.text.trim().isEmpty ? "Flutter Developer" : provider.careerGoalController.text.trim(),
                                  style: TextStyle(fontSize: 14, color: textDark, height: 1.4),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- BOTTOM FIXED NAVIGATION BAR ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
              ),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: isSubmitting
                              ? null
                              : () async {
                                  if (_currentStep < 3) {
                                    _jumpToStep(_currentStep + 1);
                                  } else {
                                    setState(() => isSubmitting = true);
                                    // Save profile details to database
                                    bool ok = await provider.submitProfile(userId, imageBytes: _selectedImageBytes);
                                    setState(() => isSubmitting = false);
                                    if (ok && mounted) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DashboardScreen(
                                            userId: userId,
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentPurple,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isSubmitting
                                    ? "Saving Profile..."
                                    : _currentStep == 3
                                        ? "Complete Profile"
                                        : "Continue",
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                _currentStep == 3 ? Icons.check_circle_outline_rounded : Icons.arrow_forward_rounded,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_currentStep == 3) ...[
                        const SizedBox(height: 8),
                        Text(
                          "You can always update this information later.",
                          style: TextStyle(fontSize: 12, color: textMuted),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard({
    required IconData icon,
    required String title,
    required VoidCallback onEdit,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
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
              Row(
                children: [
                  Icon(icon, color: primaryNavy, size: 20),
                  const SizedBox(width: 8),
                  Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textDark)),
                ],
              ),
              GestureDetector(
                onTap: onEdit,
                child: Text(
                  "Edit",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: accentPurple),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildSegmentedProgress(int stepIndex) {
    return Row(
      children: List.generate(4, (i) {
        final isActive = i <= stepIndex;
        return Expanded(
          child: Container(
            height: 5,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: isActive ? accentPurple : const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }

  InputDecoration _buildInputDecoration({Widget? prefixIcon, Widget? suffixIcon, String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide(color: accentPurple, width: 1.5),
      ),
    );
  }
}