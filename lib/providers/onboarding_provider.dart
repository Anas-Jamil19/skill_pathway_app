import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OnboardingProvider extends ChangeNotifier {
  bool isLoading = false;

  String selectedDegree = 'B.S. Computer Science';
  String selectedSemester = '4th Year / 7th-8th Semester';
  final TextEditingController universityController = TextEditingController(text: 'Dawood UET');
  final TextEditingController careerGoalController = TextEditingController(text: 'Flutter Developer');

  List<dynamic> skills = [];
  List<String> selectedSkillIds = [];
  List<String> selectedInterests = [];

  static const List<String> degreesList = [
    'B.S. Computer Science',
    'B.S. Software Engineering',
    'B.S. Information Technology',
    'B.S. Data Science',
    'B.S. Artificial Intelligence',
  ];

  static const List<String> semestersList = [
    '1st Year / 1st-2nd Semester',
    '2nd Year / 3rd-4th Semester',
    '3rd Year / 5th-6th Semester',
    '4th Year / 7th-8th Semester',
  ];

  OnboardingProvider() {
    _fetchSkills();
  }

  Future<void> init() async {
    await _fetchSkills();
  }

  Future<void> _fetchSkills() async {
    try {
      isLoading = true;
      notifyListeners();

      final supabase = Supabase.instance.client;
      final response = await supabase.from('skills').select();
      skills = response as List<dynamic>;
    } catch (e) {
      debugPrint("Error fetching skills: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateDegree(String value) {
    selectedDegree = value;
    notifyListeners();
  }

  void updateSemester(String value) {
    selectedSemester = value;
    notifyListeners();
  }

  void toggleSkill(String skillId) {
    if (selectedSkillIds.contains(skillId)) {
      selectedSkillIds.remove(skillId);
    } else {
      selectedSkillIds.add(skillId);
    }
    notifyListeners();
  }

  void toggleInterest(String interest) {
    if (selectedInterests.contains(interest)) {
      selectedInterests.remove(interest);
    } else {
      selectedInterests.add(interest);
    }
    notifyListeners();
  }

  Future<bool> submitProfile(String userId, {Uint8List? imageBytes}) async {
    try {
      final supabase = Supabase.instance.client;
      final authUser = supabase.auth.currentUser;
      final String effectiveUserId = authUser?.id ?? userId;

      String? avatarBase64;
      if (imageBytes != null) {
        avatarBase64 = base64Encode(imageBytes);
      }

      final Map<String, dynamic> updateData = {
        'id': effectiveUserId,
        'degree': selectedDegree,
        'university': universityController.text.trim().isEmpty ? 'Dawood UET' : universityController.text.trim(),
        'semester': selectedSemester,
        'career_goal': careerGoalController.text.trim().isEmpty ? 'Flutter Developer' : careerGoalController.text.trim(),
        'interests': selectedInterests,
        'is_onboarded': true,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (avatarBase64 != null) {
        updateData['avatar_url'] = avatarBase64;
      }

      await supabase.from('profiles').upsert(updateData);
      debugPrint("Profile submitted successfully!");
      return true;
    } catch (e) {
      debugPrint("Error saving profile: $e");
      return false;
    }
  }
}