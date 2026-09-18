import 'package:dio/dio.dart';

class ApiService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://127.0.0.1:8000',
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  ));

  static Future<List<dynamic>> fetchSkills() async {
    try {
      final response = await _dio.get('/skills');
      return response.data['skills'];
    } catch (e) {
      throw Exception('Failed to load skills: $e');
    }
  }

  static Future<bool> submitOnboarding(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/onboarding', data: data);
      return response.data['status'] ?? false;
    } catch (e) {
      throw Exception('Failed to submit onboarding: $e');
    }
  }

  static Future<List<dynamic>> fetchOpportunities(String userId, {String? typeFilter}) async {
    try {
      String url = '/opportunities-wall/$userId';
      if (typeFilter != null && typeFilter != 'All') {
        url += '?type_filter=$typeFilter';
      }
      final response = await _dio.get(url);
      return response.data['opportunities'];
    } catch (e) {
      throw Exception('Failed to load opportunities: $e');
    }
  }

  static Future<List<dynamic>> fetchCareerRoles() async {
    try {
      final response = await _dio.get('/career-roles');
      return response.data['roles'];
    } catch (e) {
      throw Exception('Failed to load career roles: $e');
    }
  }

  static Future<Map<String, dynamic>> analyzeSkillGap(String userId, String roleId) async {
    try {
      final response = await _dio.get('/skill-gap/$userId/$roleId');
      return response.data;
    } catch (e) {
      throw Exception('Failed to analyze skill gap: $e');
    }
  }

  static Future<List<dynamic>> fetchLearningResources(String skillName) async {
    try {
      final response = await _dio.get('/learning-resources/$skillName');
      return response.data['resources'];
    } catch (e) {
      throw Exception('Failed to load resources: $e');
    }
  }

  // --- Feature 5: Tracker APIs ---
  static Future<List<dynamic>> fetchUserApplications(String userId) async {
    try {
      final response = await _dio.get('/applications/$userId');
      return response.data['applications'];
    } catch (e) {
      throw Exception('Failed to load applications: $e');
    }
  }

  static Future<bool> updateApplicationStatus(String applicationId, String status) async {
    try {
      final response = await _dio.post('/applications/update-status', data: {
        'application_id': applicationId,
        'status': status,
      });
      return response.data['status'] ?? false;
    } catch (e) {
      throw Exception('Failed to update status: $e');
    }
  }
}